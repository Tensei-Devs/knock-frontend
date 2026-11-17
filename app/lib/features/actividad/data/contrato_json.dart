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

/// Un objeto JSON del contrato; lanza [DatosInvalidosFailure] si no lo es.
Map<Object?, Object?> mapaDelContrato(Object? valor) {
  if (valor is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
  return valor;
}

/// Un texto obligatorio y no vacío del contrato.
String textoDelContrato(Object? valor) {
  if (valor is! String || valor.trim().isEmpty) {
    throw const DatosInvalidosFailure();
  }
  return valor;
}

/// Un texto opcional: `null` si falta o está vacío.
String? textoOpcionalDelContrato(Object? valor) =>
    valor is String && valor.trim().isNotEmpty ? valor : null;

/// Un booleano obligatorio del contrato.
bool booleanoDelContrato(Object? valor) {
  if (valor is! bool) throw const DatosInvalidosFailure();
  return valor;
}
