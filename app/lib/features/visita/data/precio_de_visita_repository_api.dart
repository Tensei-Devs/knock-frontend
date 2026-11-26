import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/visita/domain/precio_de_visita.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET` y decisión de `/visitas/{id}/cotizacion-final`,
/// `GET /visitas/{id}/ajustes-pendientes` y `POST /ajustes/{id}/decision`.
/// La descripción y el motivo del técnico no se registran (CA-21).
class PrecioDeVisitaRepositoryApi implements PrecioDeVisitaRepository {
  const PrecioDeVisitaRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  Future<Map<Object?, Object?>> _pedir(
    String metodo,
    String ruta, {
    Map<String, Object?>? cuerpo,
  }) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      metodo,
      ruta,
      cuerpo: cuerpo,
    );
    return objetoDelContrato(r.json);
  }

  String _visita(String id, String resto) =>
      'visitas/${Uri.encodeComponent(id)}/$resto';

  @override
  Future<CotizacionFinal?> cotizacionFinal(String visitaId) async {
    final Map<Object?, Object?> m;
    try {
      m = await _pedir('GET', _visita(visitaId, 'cotizacion-final'));
    } on NoEncontradoFailure {
      return null;
    }
    return CotizacionFinal(
      precio: _monto(m['precio']),
      descripcion: textoObligatorio(m['descripcion']),
      estado: textoObligatorio(m['estado']),
      venceEn: fechaHoraObligatoria(m['venceEn']),
    );
  }

  @override
  Future<List<AjusteDePrecio>> ajustesPendientes(String visitaId) async {
    final m = await _pedir('GET', _visita(visitaId, 'ajustes-pendientes'));
    return [
      for (final e in listaDelContrato(m['items']))
        _ajuste(objetoDelContrato(e)),
    ];
  }

  AjusteDePrecio _ajuste(Map<Object?, Object?> a) => AjusteDePrecio(
    id: textoObligatorio(a['id']),
    montoNuevo: _monto(a['montoNuevo']),
    motivo: textoObligatorio(a['motivo']),
    venceEn: fechaHoraObligatoria(a['venceEn']),
  );

  @override
  Future<void> decidirCotizacionFinal(
    String visitaId, {
    required bool aprueba,
  }) => _decidir(_visita(visitaId, 'cotizacion-final/decision'), aprueba);

  @override
  Future<void> decidirAjuste(String ajusteId, {required bool aprueba}) =>
      _decidir('ajustes/${Uri.encodeComponent(ajusteId)}/decision', aprueba);

  Future<void> _decidir(String ruta, bool aprueba) async {
    final m = await _pedir(
      'POST',
      ruta,
      cuerpo: {'decision': aprueba ? 'aprueba' : 'rechaza'},
    );
    textoObligatorio(m['estado']);
  }

  /// El contrato declara los montos como número o texto.
  num _monto(Object? valor) {
    final n = valor is num ? valor : num.tryParse(valor is String ? valor : '');
    if (n == null) throw const DatosInvalidosFailure();
    return n;
  }
}
