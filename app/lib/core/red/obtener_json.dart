import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:http/http.dart' as http;

/// GET a un endpoint del contrato que aún no está en el cliente generado
/// (`oficios`, `colonias/en-punto`, `me`). Mismo transporte y mismo mapeo de
/// errores que el cliente generado; se retira cuando el contrato vendorizado
/// los incluya (spec 006). La URL base sale de `KNOCK_API_URL`, nunca fija.
///
/// Devuelve el JSON decodificado o lanza un [Failure].
Future<Object?> obtenerJson(
  http.Client transporte,
  String urlBase,
  String ruta, {
  Map<String, String>? consulta,
}) async {
  final respuesta = await enviarJson(
    transporte,
    urlBase,
    'GET',
    ruta,
    consulta: consulta,
  );
  return respuesta.json;
}
