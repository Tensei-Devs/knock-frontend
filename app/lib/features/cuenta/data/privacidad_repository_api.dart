import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/cuenta/domain/privacidad.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/me/consentimientos` y `/api/v1/me/exportaciones` (backend
/// 039). Va por el transporte con sesión (spec 026). No registra nada.
class PrivacidadRepositoryApi implements PrivacidadRepository {
  const PrivacidadRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  static const _consentimientos = 'me/consentimientos';

  @override
  Future<List<Consentimiento>> consentimientos() async {
    final r = await enviarJson(transporte, url, 'GET', _consentimientos);
    return listaDelContrato(r.json).map(_consentimiento).toList();
  }

  @override
  Future<Consentimiento> cambiarConsentimiento(
    String tipo, {
    required bool vigente,
  }) async {
    final r = await enviarJson(
      transporte,
      url,
      'PUT',
      _consentimientos,
      cuerpo: {'tipo': tipo, 'vigente': vigente},
    );
    return _consentimiento(r.json);
  }

  @override
  Future<void> pedirExportacion() =>
      enviarJson(transporte, url, 'POST', 'me/exportaciones');

  @override
  Future<Exportacion?> ultimaExportacion() async {
    final r = await enviarJson(
      transporte,
      url,
      'GET',
      'me/exportaciones/ultima',
      aceptar: const {404},
    );
    if (r.estado == 404) return null;
    final m = objetoDelContrato(r.json);
    return switch (textoObligatorio(m['estado'])) {
      'en_preparacion' => const Exportacion(EstadoExportacion.enPreparacion),
      'vencida' => const Exportacion(EstadoExportacion.vencida),
      'lista' => Exportacion(
        EstadoExportacion.lista,
        enlace: _enlace(m['enlace']),
        venceEn: fechaHoraObligatoria(m['venceEn']),
      ),
      _ => throw const DatosInvalidosFailure(),
    };
  }

  /// Solo se abre un enlace `https`.
  static Uri _enlace(Object? valor) {
    final uri = Uri.tryParse(textoObligatorio(valor));
    if (uri == null || !uri.isScheme('https') || uri.host.isEmpty) {
      throw const DatosInvalidosFailure();
    }
    return uri;
  }

  static Consentimiento _consentimiento(Object? json) {
    final m = objetoDelContrato(json);
    final fecha = m['fecha'];
    return Consentimiento(
      tipo: textoObligatorio(m['tipo']),
      vigente: booleanoObligatorio(m['vigente']),
      obligatorio: booleanoObligatorio(m['obligatorio']),
      version: textoOpcional(m['version']),
      fecha: fecha == null ? null : fechaHoraObligatoria(fecha),
    );
  }
}
