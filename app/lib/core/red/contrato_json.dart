import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:http/http.dart' as http;

/// Piezas comunes para leer el JSON del contrato en los repositorios de la
/// capa de datos (spec 026, D-01). Todo lo que no cumple el contrato lanza
/// [DatosInvalidosFailure]; ningún mensaje copia el cuerpo recibido.

/// Un objeto JSON del contrato.
Map<Object?, Object?> objetoDelContrato(Object? valor) {
  if (valor is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
  return valor;
}

/// Una lista JSON del contrato.
List<Object?> listaDelContrato(Object? valor) {
  if (valor is! List<Object?>) throw const DatosInvalidosFailure();
  return valor;
}

/// Un texto obligatorio y no vacío.
String textoObligatorio(Object? valor) {
  if (valor is! String || valor.trim().isEmpty) {
    throw const DatosInvalidosFailure();
  }
  return valor;
}

/// Un texto que puede faltar o ser `null`; si viene, debe ser texto.
String? textoOpcional(Object? valor) {
  if (valor == null) return null;
  if (valor is! String) throw const DatosInvalidosFailure();
  return valor;
}

/// Un booleano obligatorio.
bool booleanoObligatorio(Object? valor) {
  if (valor is! bool) throw const DatosInvalidosFailure();
  return valor;
}

/// Un entero obligatorio.
int enteroObligatorio(Object? valor) {
  if (valor is! int) throw const DatosInvalidosFailure();
  return valor;
}

/// Una fecha y hora ISO 8601 obligatoria.
DateTime fechaHoraObligatoria(Object? valor) {
  final f = valor is String ? DateTime.tryParse(valor) : null;
  if (f == null) throw const DatosInvalidosFailure();
  return f;
}

/// Como `enviarJson`, pero un 404 es [NoEncontradoFailure] (recurso ajeno,
/// inexistente o mal formado: el servidor responde igual y no revela cuál).
/// [aceptar] suma estados que quien llama quiere examinar.
Future<RespuestaJson> enviarJsonONoEncontrado(
  http.Client transporte,
  String url,
  String metodo,
  String ruta, {
  Map<String, String>? consulta,
  Object? cuerpo,
  Set<int> aceptar = const {},
}) async {
  final r = await enviarJson(
    transporte,
    url,
    metodo,
    ruta,
    consulta: consulta,
    cuerpo: cuerpo,
    aceptar: {404, ...aceptar},
  );
  if (r.estado == 404) throw const NoEncontradoFailure();
  return r;
}
