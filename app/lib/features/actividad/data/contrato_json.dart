import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:http/http.dart' as http;

/// Piezas comunes de los repositorios de `/solicitudes` y `/visitas` (backend
/// 020, 021 y 022).

/// `GET` a [ruta] que trata un 404 como [NoEncontradoFailure] (ajena,
/// inexistente o mal formada: el servidor responde igual y no revela cuál).
/// Devuelve el JSON decodificado.
Future<Object?> obtenerJsonONoEncontrado(
  http.Client transporte,
  String url,
  String ruta, {
  Map<String, String>? consulta,
}) async {
  final r = await enviarJson(
    transporte,
    url,
    'GET',
    ruta,
    consulta: consulta,
    aceptar: const {404},
  );
  if (r.estado == 404) throw const NoEncontradoFailure();
  return r.json;
}

/// `AAAA-MM-DD` del contrato, como día local sin hora; lanza
/// [DatosInvalidosFailure] si no es una fecha.
DateTime diaLocalDelContrato(Object? valor) {
  final f = valor is String ? DateTime.tryParse(valor) : null;
  if (f == null) throw const DatosInvalidosFailure();
  return DateTime(f.year, f.month, f.day);
}
