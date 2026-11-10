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
  ///
  /// Nunca lanza: si el almacenamiento seguro falla al borrar, la sesión en
  /// memoria y la interfaz ya quedaron cerradas y la persona vuelve al login.
  Future<void> cerrar() async {
    ref.read(cacheRespuestasProvider).borrarTodo();
    state = null;
    ref.read(sesionIniciadaProvider.notifier).cerrar();
    try {
      await ref.read(almacenSesionProvider).cerrarSesion();
    } on Object {
      // Sin registro (R-11): el error del almacén podría llevar datos.
    }
  }

  /// Renueva el token que la API rechazó ([vencido]). Peticiones simultáneas
  /// comparten una sola renovación (single-flight). Devuelve `null` si la API
  /// rechazó la renovación o si los tokens nuevos no se pudieron guardar (la
  /// sesión ya quedó cerrada), o si no hay sesión; si el fallo es transitorio
  /// lanza un [Failure] y la sesión sigue abierta.
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
    // renovación anterior ya no sirve (CA-026-13). Si no se pueden guardar, el
    // almacén seguiría con el token de renovación que la API ya rotó y, al
    // reiniciar, su reuso cerraría todas las sesiones de la cuenta (spec 016,
    // backend): se cierra la sesión local y la petición no se repite (R-05, R-07).
    if (!await _guardarConReintento(nuevos)) {
      await cerrar();
      return null;
    }
    state = nuevos;
    return nuevos;
  }

  /// Guarda [tokens] y, si falla, lo intenta una sola vez más. `true` si quedó
  /// guardado. No registra el fallo: el error del almacén podría llevar datos.
  Future<bool> _guardarConReintento(TokensSesion tokens) async {
    final almacen = ref.read(almacenSesionProvider);
    for (var intento = 0; intento < 2; intento++) {
      try {
        await almacen.guardar(
          acceso: tokens.accessToken,
          refresco: tokens.refreshToken,
        );
        return true;
      } on Exception {
        // Las fallas del almacén seguro llegan como excepciones; un `Error` de
        // programación no se traga. Se reintenta una vez; el segundo fallo lo
        // resuelve quien llama.
      }
    }
    return false;
  }
}

final sesionProvider = NotifierProvider<SesionNotifier, TokensSesion?>(
  SesionNotifier.new,
);
