import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/red/errores_api.dart';
import 'package:http/http.dart' as http;
import 'package:knock_api/api.dart' show ApiException;

/// Respuesta de una llamada que terminó como se esperaba: sin cuerpo en los
/// errores y sin cabeceras de autorización.
final class RespuestaJson {
  const RespuestaJson({
    required this.estado,
    this.json,
    this.cabeceras = const {},
  });

  final int estado;

  /// Cuerpo ya decodificado; `null` si no hubo cuerpo (204).
  final Object? json;
  final Map<String, String> cabeceras;
}

/// Llamada JSON (`GET`, `POST`, `PUT` o `DELETE`) a un endpoint del contrato
/// que aún no está en el cliente generado (spec 026, D-01). Mismo mapeo de
/// errores que [mapearErrorApi]; los errores nunca llevan el cuerpo, la URL ni
/// el token. Se retira cuando el contrato vendorizado incluya el endpoint.
///
/// Los estados de [aceptar] (por ejemplo 404 o 400 en `refresh`) se entregan
/// como respuesta para que quien llama decida; el resto de los no 2xx lanza un
/// [Failure]. Un 304 que llegue sin que se haya pedido es un dato inválido.
/// Una escritura jamás se reintenta aquí (spec 026, R-13).
Future<RespuestaJson> enviarJson(
  http.Client transporte,
  String urlBase,
  String metodo,
  String ruta, {
  Map<String, String>? consulta,
  Object? cuerpo,
  Set<int> aceptar = const {},
}) async {
  final base = normalizarUrlApi(urlBase);
  if (base == null) throw const ApiNoConfiguradaFailure();
  final uri = Uri.parse('$base/api/v$versionApi/$ruta')
      .replace(queryParameters: consulta);
  final peticion = http.Request(metodo, uri)
    ..headers['Accept'] = 'application/json';
  if (cuerpo != null) {
    peticion
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode(cuerpo);
  }
  final http.Response respuesta;
  try {
    respuesta = await http.Response.fromStream(await transporte.send(peticion));
  } on Failure {
    rethrow;
  } on Exception {
    throw const ServicioNoDisponibleFailure();
  }
  final estado = respuesta.statusCode;
  if (aceptar.contains(estado)) return RespuestaJson(estado: estado);
  if (estado == 304) throw const DatosInvalidosFailure();
  if (estado < 200 || estado > 299) {
    throw mapearErrorApi(ApiException(estado, respuesta.body));
  }
  return RespuestaJson(
    estado: estado,
    json: _decodificar(respuesta),
    cabeceras: respuesta.headers,
  );
}

Object? _decodificar(http.Response respuesta) {
  if (respuesta.bodyBytes.isEmpty) return null;
  try {
    return jsonDecode(utf8.decode(respuesta.bodyBytes));
  } on FormatException {
    throw const DatosInvalidosFailure();
  }
}
