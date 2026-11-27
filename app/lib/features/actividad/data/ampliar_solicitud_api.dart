import 'package:app/core/red/contrato_json.dart';
import 'package:http/http.dart' as http;

/// REAL: `POST /api/v1/solicitudes/{id}/ampliar` (spec 038; backend 048).
/// Adelanta la siguiente oleada. Un 404 es `NoEncontradoFailure` y un 409
/// (`request_not_extendable`), `ConflictoFailure`. No se reintenta solo.
class AmpliarSolicitudApi {
  const AmpliarSolicitudApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  Future<void> ampliar(String solicitudId) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      'solicitudes/${Uri.encodeComponent(solicitudId)}/ampliar',
    );
    textoObligatorio(objetoDelContrato(r.json)['estado']);
  }
}
