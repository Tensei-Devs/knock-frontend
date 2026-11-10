import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;
import 'package:knock_api/api.dart';

/// Convierte un error del cliente generado en un [Failure] tipado.
///
/// Se lee solo `code` del ProblemDetails (403 y 409, spec 015 del backend);
/// el resto del cuerpo, que puede traer detalles técnicos, se descarta.
Failure mapearErrorApi(Object error) {
  if (error is Failure) return error;
  if (error is! ApiException) return const ServicioNoDisponibleFailure();
  // El cliente generado envuelve los fallos de red (sin conexión, TLS) con un
  // `innerException`: no hubo respuesta de la API.
  // Salvo que el transporte lanzó a propósito un Failure (p. ej. la espera
  // por 429): ese se conserva.
  final interno = error.innerException;
  if (interno is Failure) return interno;
  if (interno != null) return const ServicioNoDisponibleFailure();
  return switch (error.code) {
    401 => const NoAutorizadoFailure(),
    403 when _codigo(error.message) == 'account_suspended' =>
      const CuentaSuspendidaFailure(),
    403 => const AccesoDenegadoFailure(),
    409 => const ConflictoFailure(),
    400 || 413 || 422 => const DatosRechazadosFailure(),
    429 => const DemasiadosIntentosFailure(),
    _ => const ServicioNoDisponibleFailure(),
  };
}

String? _codigo(String? cuerpo) {
  if (cuerpo == null || cuerpo.isEmpty) return null;
  try {
    final json = jsonDecode(cuerpo);
    if (json is Map<String, Object?>) {
      final codigo = json['code'];
      return codigo is String ? codigo : null;
    }
  } on FormatException {
    return null;
  }
  return null;
}

/// Ejecuta una llamada del cliente generado y traduce sus errores.
///
/// Nunca deja salir un `ApiException` (que lleva el cuerpo de la respuesta)
/// hacia las capas de arriba.
Future<T> llamarApi<T>(Future<T> Function() llamada) async {
  try {
    return await llamada();
  } on Failure {
    rethrow;
  } on ApiException catch (error) {
    throw mapearErrorApi(error);
  } on ProviderException catch (error) {
    // Riverpod envuelve el error de un provider que falló al crearse (por
    // ejemplo, `clienteApiProvider` sin URL base), una vez por cada provider
    // que dependía de él.
    Object causa = error;
    while (causa is ProviderException) {
      causa = causa.exception;
    }
    throw mapearErrorApi(causa);
  }
}
