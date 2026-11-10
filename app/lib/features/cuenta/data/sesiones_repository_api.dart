import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/cuenta/domain/sesion_dispositivo.dart';
import 'package:app/features/cuenta/domain/sesiones_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/me/sesiones` y `DELETE /api/v1/me/sesiones/{id}`
/// (spec 018 del backend). Sin pantalla todavía (spec 026, R-09).
class SesionesRepositoryApi implements SesionesRepository {
  const SesionesRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<List<SesionDispositivo>> listar() async {
    final respuesta = await enviarJson(transporte, url, 'GET', 'me/sesiones');
    final json = respuesta.json;
    if (json is! List<Object?>) throw const DatosInvalidosFailure();
    return json.map(_aSesion).toList(growable: false);
  }

  @override
  Future<void> cerrar(String id) async {
    if (id.trim().isEmpty) throw const DatosRechazadosFailure();
    // 404 también es una sesión ajena o ya cerrada: no revela nada (D-07).
    await enviarJson(
      transporte,
      url,
      'DELETE',
      'me/sesiones/${Uri.encodeComponent(id)}',
      aceptar: const {404},
    );
  }
}

SesionDispositivo _aSesion(Object? json) {
  if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
  final id = json['id'];
  final dispositivo = json['dispositivo'];
  final actividad = json['ultimaActividad'];
  final actual = json['actual'];
  final fecha = actividad is String ? DateTime.tryParse(actividad) : null;
  if (id is! String ||
      id.isEmpty ||
      dispositivo is! String ||
      fecha == null ||
      actual is! bool) {
    throw const DatosInvalidosFailure();
  }
  return SesionDispositivo(
    id: id,
    dispositivo: dispositivo,
    ultimaActividad: fecha,
    actual: actual,
  );
}
