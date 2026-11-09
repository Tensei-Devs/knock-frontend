import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/red/errores_api.dart';
import 'package:http/http.dart' as http;
import 'package:knock_api/api.dart' show ApiException;

/// GET a un endpoint del contrato que aún no está en el cliente generado
/// (`oficios`, `colonias/en-punto`). Mismo transporte y mismo mapeo de errores
/// que el cliente generado; se retira cuando el contrato vendorizado los
/// incluya (spec 006). La URL base sale de `KNOCK_API_URL`, nunca fija.
///
/// Devuelve el JSON decodificado o lanza un [Failure].
Future<Object?> obtenerJson(
  http.Client transporte,
  String urlBase,
  String ruta, {
  Map<String, String>? consulta,
}) async {
  final base = normalizarUrlApi(urlBase);
  if (base == null) throw const ApiNoConfiguradaFailure();
  final uri = Uri.parse('$base/api/v$versionApi/$ruta')
      .replace(queryParameters: consulta);
  final http.Response respuesta;
  try {
    respuesta = await transporte.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );
  } on Exception {
    throw const ServicioNoDisponibleFailure();
  }
  if (respuesta.statusCode < 200 || respuesta.statusCode > 299) {
    throw mapearErrorApi(ApiException(respuesta.statusCode, respuesta.body));
  }
  try {
    return jsonDecode(utf8.decode(respuesta.bodyBytes));
  } on FormatException {
    throw const DatosInvalidosFailure();
  }
}
