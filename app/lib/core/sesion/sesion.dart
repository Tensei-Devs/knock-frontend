import 'dart:async';

import 'package:app/core/red/cache_respuestas.dart';
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

/// Dónde se guardan los tokens.
///
/// Hoy solo existe la versión en memoria. El almacenamiento seguro del sistema
/// (Keystore) es de la spec 009: se implementa esta interfaz allí.
abstract interface class AlmacenTokens {
  TokensSesion? leer();

  Future<void> guardar(TokensSesion tokens);

  Future<void> borrar();
}

class AlmacenTokensEnMemoria implements AlmacenTokens {
  TokensSesion? _tokens;

  @override
  TokensSesion? leer() => _tokens;

  @override
  Future<void> guardar(TokensSesion tokens) async => _tokens = tokens;

  @override
  Future<void> borrar() async => _tokens = null;
}

/// Pide al servidor un par de tokens nuevo. Devuelve `null` si la credencial
/// de renovación ya no es válida.
///
/// El contrato OpenAPI aún no publica el endpoint de renovación: mientras
/// tanto [renovadorSesionProvider] usa [RenovadorNoDisponible] y las pruebas
/// usan un servidor simulado.
abstract interface class RenovadorSesion {
  Future<TokensSesion?> renovar(String refreshToken);
}

/// Sin endpoint de renovación: toda renovación falla y la sesión se cierra.
class RenovadorNoDisponible implements RenovadorSesion {
  const RenovadorNoDisponible();

  @override
  Future<TokensSesion?> renovar(String refreshToken) async => null;
}

final almacenTokensProvider = Provider<AlmacenTokens>(
  (ref) => AlmacenTokensEnMemoria(),
);

final renovadorSesionProvider = Provider<RenovadorSesion>(
  (ref) => const RenovadorNoDisponible(),
);

/// Estado de la sesión (spec 002, R-02): `null` si no hay sesión.
class SesionNotifier extends Notifier<TokensSesion?> {
  Future<TokensSesion?>? _renovando;

  @override
  TokensSesion? build() => ref.read(almacenTokensProvider).leer();

  /// Guarda la sesión nueva. Vacía la caché por si quedaba algo de otra cuenta.
  Future<void> iniciar(TokensSesion tokens) async {
    ref.read(cacheRespuestasProvider).borrarTodo();
    await ref.read(almacenTokensProvider).guardar(tokens);
    state = tokens;
  }

  /// Borra tokens y caché (R-06, CA-04).
  Future<void> cerrar() async {
    ref.read(cacheRespuestasProvider).borrarTodo();
    state = null;
    await ref.read(almacenTokensProvider).borrar();
  }

  /// Renueva el token que la API rechazó ([vencido]). Peticiones simultáneas
  /// comparten una sola renovación. Devuelve `null` si no se pudo renovar;
  /// en ese caso la sesión ya quedó cerrada.
  Future<TokensSesion?> renovar(String vencido) {
    final actual = state;
    if (actual == null) return Future.value();
    if (actual.accessToken != vencido) return Future.value(actual);
    return _renovando ??= _renovar(actual)
        .whenComplete(() => _renovando = null);
  }

  Future<TokensSesion?> _renovar(TokensSesion actual) async {
    TokensSesion? nuevos;
    try {
      nuevos = await ref
          .read(renovadorSesionProvider)
          .renovar(actual.refreshToken);
    } on Object {
      nuevos = null;
    }
    if (nuevos == null) {
      await cerrar();
      return null;
    }
    await ref.read(almacenTokensProvider).guardar(nuevos);
    state = nuevos;
    return nuevos;
  }
}

final sesionProvider = NotifierProvider<SesionNotifier, TokensSesion?>(
  SesionNotifier.new,
);
