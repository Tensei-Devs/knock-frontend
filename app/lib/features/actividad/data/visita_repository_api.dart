import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/actividad/data/contrato_json.dart';
import 'package:app/features/actividad/data/visita_contrato_mapper.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/visitas/{id}` (backend 022). Pide sesión (Bearer, por el
/// transporte con sesión de la spec 026). El código de cuatro dígitos llega en
/// la respuesta y no se registra ni se guarda aquí (spec 016).
class VisitaRepositoryApi implements VisitaRepository {
  const VisitaRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<Visita> obtenerVisita(String id) async {
    return VisitaContratoMapper.visita(
      await obtenerJsonONoEncontrado(
        transporte,
        url,
        'visitas/${Uri.encodeComponent(id)}',
      ),
    );
  }
}

/// REAL: `POST /api/v1/visitas/{id}/aviso` (backend 022). Prepara el texto
/// para compartir con alguien de confianza: no guarda contactos ni envía nada.
/// Una escritura nunca se reintenta aquí (spec 026, R-13).
class AvisoRepositoryApi implements AvisoRepository {
  const AvisoRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<MensajeAviso> pedirAviso(String visitaId) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'visitas/${Uri.encodeComponent(visitaId)}/aviso',
      aceptar: const {404, 409},
    );
    if (r.estado == 404) throw const NoEncontradoFailure();
    if (r.estado == 409) {
      final json = r.json;
      final codigo = json is Map<Object?, Object?> ? json['code'] : null;
      // Solo `visit_not_notifiable` bloquea el aviso; otro conflicto deja
      // enviar el texto de respaldo (spec 022, CA-16).
      throw codigo == 'visit_not_notifiable'
          ? const AvisoNoPermitidoFailure()
          : const ConflictoFailure();
    }
    return VisitaContratoMapper.aviso(r.json);
  }
}
