import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:http/http.dart' as http;

/// Escrituras del técnico; no se reintentan automáticamente.
class PrecioTecnicoRepositoryApi {
  const PrecioTecnicoRepositoryApi({
    required this.transporte,
    required this.url,
  });
  final http.Client transporte;
  final String url;

  Future<void> enviarFinal(
    String visitaId, {
    required int precio,
    required String descripcion,
  }) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      'visitas/${Uri.encodeComponent(visitaId)}/cotizacion-final',
      cuerpo: {'precio': precio, 'descripcion': descripcion},
    );
    final m = objetoDelContrato(r.json);
    if (textoObligatorio(m['visitaId']) != visitaId) {
      throw const DatosInvalidosFailure();
    }
    _entero(m['precio']);
    textoObligatorio(m['estado']);
    fechaHoraObligatoria(m['venceEn']);
  }

  Future<void> proponerAjuste(
    String cotizacionId, {
    required int montoNuevo,
    required String motivo,
  }) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      'cotizaciones/${Uri.encodeComponent(cotizacionId)}/ajuste-precio',
      cuerpo: {'montoNuevo': montoNuevo, 'motivo': motivo},
    );
    final m = objetoDelContrato(r.json);
    if (textoObligatorio(m['cotizacionId']) != cotizacionId) {
      throw const DatosInvalidosFailure();
    }
    textoObligatorio(m['id']);
    textoObligatorio(m['visitaId']);
    _entero(m['montoNuevo']);
    textoObligatorio(m['estado']);
    fechaHoraObligatoria(m['venceEn']);
  }

  static int _entero(Object? valor) {
    final n = valor is int ? valor : int.tryParse('$valor');
    if (n == null) throw const DatosInvalidosFailure();
    return n;
  }
}
