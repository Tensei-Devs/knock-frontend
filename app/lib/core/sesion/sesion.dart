import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cache_respuestas.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:app/core/sesion/renovador_sesion_api.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Credenciales de la sesión. No se imprimen: `toString` no las muestra.
@immutable
class TokensSesion {
  const TokensSesion({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  @override
  bool operator ==(Object other) =>
      other is TokensSesion &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken;

  @override
  int get hashCode => Object.hash(accessToken, refreshToken);

  @override
  String toString() => 'TokensSesion(***)';
}

/// Pide al servidor un par de tokens nuevo (`POST /auth/refresh`).
///
/// Devuelve `null` solo si la API **rechazó** la credencial de renovación
/// (400 o 401): la sesión ya no sirve. Un fallo transitorio (sin red, 429,
/// 5xx) lanza un `Failure` y la sesión se conserva (spec 026, D-03).
abstract interface class RenovadorSesion {
  Future<TokensSesion?> renovar(String refreshToken);
}

/// Doble de pruebas: toda renovación es rechazada.
class RenovadorNoDisponible implements RenovadorSesion {
  const RenovadorNoDisponible();

  @override
  Future<TokensSesion?> renovar(String refreshToken) async => null;
}

/// Tokens que había en el almacenamiento seguro al arrancar. `main()` los
/// fija (spec 026, R-05); por defecto, sin sesión.
final tokensInicialesProvider = Provider<TokensSesion?>((ref) => null);

/// Estado de la sesión (spec 002, R-02; spec 026): `null` si no hay sesión.
///
/// Los tokens viven en memoria mientras dura la sesión y en el
/// almacenamiento seguro ([AlmacenSesion]); no hay ningún otro almacén.
class SesionNotifier extends Notifier<TokensSesion?> {
  Future<TokensSesion?>? _renovando;

  @override
  TokensSesion? build() => ref.read(tokensInicialesProvider);

  /// Guarda la sesión nueva. Vacía la caché por si quedaba algo de otra cuenta.
  Future<void> iniciar(TokensSesion tokens) async {
    ref.read(cacheRespuestasProvider).borrarTodo();
    await ref
        .read(almacenSesionProvider)
        .guardar(acceso: tokens.accessToken, refresco: tokens.refreshToken);
    state = tokens;
  }

  /// Cierra la sesión en el teléfono: borra tokens y caché y deja la bandera
  /// de interfaz en falso para que el router lleve a `/entrar` (R-03, R-07).
  Future<void> cerrar() async {
    ref.read(cacheRespuestasProvider).borrarTodo();
    state = null;
    ref.read(sesionIniciadaProvider.notifier).cerrar();
    await ref.read(almacenSesionProvider).cerrarSesion();
  }

  /// Renueva el token que la API rechazó ([vencido]). Peticiones simultáneas
  /// comparten una sola renovación (single-flight). Devuelve `null` si la API
  /// rechazó la renovación (la sesión ya quedó cerrada) o si no hay sesión; si
  /// el fallo es transitorio lanza un [Failure] y la sesión sigue abierta.
  Future<TokensSesion?> renovar(String vencido) {
    final actual = state;
    if (actual == null) return Future.value();
    if (actual.accessToken != vencido) return Future.value(actual);
    return _renovando ??= _renovar(actual)
        .whenComplete(() => _renovando = null);
  }

  Future<TokensSesion?> _renovar(TokensSesion actual) async {
    final TokensSesion? nuevos;
    try {
      nuevos = await ref
          .read(renovadorSesionProvider)
          .renovar(actual.refreshToken);
    } on Failure {
      rethrow;
    } on Object {
      throw const ServicioNoDisponibleFailure();
    }
    // Se cerró la sesión mientras se renovaba: no se reabre (spec 026 §10).
    if (state != actual) return state;
    if (nuevos == null) {
      await cerrar();
      return null;
    }
    // Los tokens nuevos se guardan antes de repetir cualquier petición: el de
    // renovación anterior ya no sirve (CA-026-13).
    try {
      await ref
          .read(almacenSesionProvider)
          .guardar(acceso: nuevos.accessToken, refresco: nuevos.refreshToken);
    } on Exception {
      // Sin registro: la sesión sigue en memoria y el error podría llevar datos.
    }
    state = nuevos;
    return nuevos;
  }
}

final sesionProvider = NotifierProvider<SesionNotifier, TokensSesion?>(
  SesionNotifier.new,
);
