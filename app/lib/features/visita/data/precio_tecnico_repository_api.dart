import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/visita/domain/precio_tecnico.dart';
import 'package:http/http.dart' as http;

/// Escrituras del técnico; no se reintentan automáticamente.
class PrecioTecnicoRepositoryApi implements PrecioTecnicoRepository {
  const PrecioTecnicoRepositoryApi({
    required this.transporte,
    required this.url,
  });
  final http.Client transporte;
  final String url;

  @override
  Future<CotizacionAceptada?> cotizacionAceptada(String visitaId) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'tecnicos/me/trabajo',
    );
    final m = objetoDelContrato(r.json);
    Object? solicitud;
    for (final item in listaDelContrato(m['proximasVisitas'])) {
      final visita = objetoDelContrato(item);
      if (visita['visitaId'] == visitaId) solicitud = visita['solicitudId'];
    }
    if (solicitud == null) return null;
    for (final item in listaDelContrato(m['cotizacionesEnviadas'])) {
      final c = objetoDelContrato(item);
      if (c['solicitudId'] == solicitud && c['estado'] == 'aceptada') {
        return CotizacionAceptada(
          id: textoObligatorio(c['cotizacionId']),
          tope: _entero(c['tope']),
        );
      }
    }
    return null;
  }

  @override
  Future<void> enviarFinal(
    String visitaId, {
    required int precio,
    required String descripcion,
  }) async {
    final m = await _escribir(
      'visitas/${Uri.encodeComponent(visitaId)}/cotizacion-final',
      {'precio': precio, 'descripcion': descripcion},
    );
    if (textoObligatorio(m['visitaId']) != visitaId) {
      throw const DatosInvalidosFailure();
    }
    _entero(m['precio']);
    textoObligatorio(m['estado']);
    fechaHoraObligatoria(m['venceEn']);
  }

  @override
  Future<void> proponerAjuste(
    String cotizacionId, {
    required int montoNuevo,
    required String motivo,
  }) async {
    final m = await _escribir(
      'cotizaciones/${Uri.encodeComponent(cotizacionId)}/ajuste-precio',
      {'montoNuevo': montoNuevo, 'motivo': motivo},
    );
    if (textoObligatorio(m['cotizacionId']) != cotizacionId) {
      throw const DatosInvalidosFailure();
    }
    textoObligatorio(m['id']);
    textoObligatorio(m['visitaId']);
    _entero(m['montoNuevo']);
    textoObligatorio(m['estado']);
    fechaHoraObligatoria(m['venceEn']);
  }

  /// El 422 y el 503 de moderación traen su `code`; el resto de los 422 y 503
  /// son datos rechazados y servicio no disponible.
  Future<Map<Object?, Object?>> _escribir(
    String ruta,
    Map<String, Object?> cuerpo,
  ) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      ruta,
      cuerpo: cuerpo,
      aceptar: const {422, 503},
    );
    if (r.estado != 422 && r.estado != 503) return objetoDelContrato(r.json);
    final json = r.json;
    final codigo = json is Map<Object?, Object?> ? json['code'] : null;
    throw switch (r.estado) {
      422 when codigo == 'content_rejected' =>
        const ContenidoRechazadoFailure(),
      422 => const DatosRechazadosFailure(),
      503 when codigo == 'moderation_unavailable' =>
        const ModeracionNoDisponibleFailure(),
      _ => const ServicioNoDisponibleFailure(),
    };
  }

  static int _entero(Object? valor) {
    final n = valor is int ? valor : int.tryParse('$valor');
    if (n == null) throw const DatosInvalidosFailure();
    return n;
  }
}
