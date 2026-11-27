// Spec 016: respuestas ficticias de la vista del técnico y de la llegada.
import 'package:http/http.dart' as http;

import 'api_falsa.dart';

const visitaDeLlegadaId = 'c1c1c1c1c1c1c1c1c1c1c1c1';

Map<String, Object?> visitaTecnicoJson({
  String estado = 'confirmada',
  String modalidad = 'domicilio',
  bool puedeLlegar = true,
  String? llegadaEn,
}) => {
  'id': visitaDeLlegadaId,
  'rol': 'tecnico',
  'estado': estado,
  'modalidad': modalidad,
  'dia': '2026-11-27',
  'hora': '16:00',
  'precio': 400,
  'tope': 500,
  'tecnico': null,
  'cliente': {'colonia': 'Centro'},
  'lugar': {'tipo': modalidad, 'direccion': 'Calle de prueba 1'},
  'codigo': null,
  'puedeLlegar': puedeLlegar,
  'llegadaEn': llegadaEn,
};

http.Response problemaJson(
  int estado,
  String codigo, [
  Map<String, Object?> extra = const {},
]) => jsonOk({'code': codigo, ...extra}, estado: estado);
