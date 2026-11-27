import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/visita/domain/acciones_visita.dart';
import 'package:http/http.dart' as http;

/// REAL: `POST /api/v1/visitas/{id}/cancelar`, `/reprogramar`,
/// `/cliente-ausente`, `/terminar` y `/no-terminado` (backend 050), y
/// `/tecnico-ausente` (backend 064). Con sesión, por el transporte de la spec 026.
/// El motivo y el texto de la persona no se registran (CA-37).
class AccionesVisitaRepositoryApi implements AccionesVisitaRepository {
  const AccionesVisitaRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  Future<Map<Object?, Object?>> _enviar(
    String visitaId,
    String accion,
    Map<String, Object?>? cuerpo,
  ) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      'visitas/${Uri.encodeComponent(visitaId)}/$accion',
      cuerpo: cuerpo,
    );
    return objetoDelContrato(r.json);
  }

  @override
  Future<VisitaCancelada> cancelar(String visitaId, String motivo) async {
    final m = await _enviar(visitaId, 'cancelar', {'motivo': motivo});
    return VisitaCancelada(
      estado: textoObligatorio(m['estado']),
      tardia: booleanoObligatorio(m['tardia']),
    );
  }

  @override
  Future<PropuestaDeFecha> reprogramar(
    String visitaId,
    DateTime fechaHora,
  ) async {
    final m = await _enviar(visitaId, 'reprogramar', {
      'fechaHora': fechaHora.toUtc().toIso8601String(),
    });
    return PropuestaDeFecha(
      fechaHora: fechaHoraObligatoria(m['fechaHora']),
      propuestaPor: textoObligatorio(m['propuestaPor']),
      venceEn: fechaHoraObligatoria(m['venceEn']),
    );
  }

  @override
  Future<void> reportarNoTerminado(String visitaId, String texto) async {
    final m = await _enviar(visitaId, 'no-terminado', {'texto': texto});
    textoObligatorio(m['estado']);
  }

  @override
  Future<String> clienteAusente(String visitaId) =>
      _ausencia(visitaId, 'cliente-ausente');

  @override
  Future<String> tecnicoAusente(String visitaId) =>
      _ausencia(visitaId, 'tecnico-ausente');

  Future<String> _ausencia(String visitaId, String accion) async {
    final m = await _enviar(visitaId, accion, null);
    _verificarVisita(m, visitaId);
    textoObligatorio(m['quienFalto']);
    return textoObligatorio(m['estado']);
  }

  @override
  Future<String> terminar(
    String visitaId, {
    required String descripcion,
    required List<String> fotos,
    String? recomendacion,
  }) async {
    final m = await _enviar(visitaId, 'terminar', {
      'descripcion': descripcion,
      'recomendacion': recomendacion,
      'fotos': fotos,
    });
    _verificarVisita(m, visitaId);
    fechaHoraObligatoria(m['terminadaEn']);
    return textoObligatorio(m['estado']);
  }

  static void _verificarVisita(Map<Object?, Object?> m, String visitaId) {
    if (textoObligatorio(m['visitaId']) != visitaId) {
      throw const DatosInvalidosFailure();
    }
  }
}
