import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/verificacion/domain/verificacion.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/me/verificacion`. No se registra ni se guarda nada.
class VerificacionRepositoryApi implements VerificacionRepository {
  const VerificacionRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  static const _estados = {
    'sin_verificar': EstadoDeVerificacion.sinVerificar,
    'en_captura': EstadoDeVerificacion.enCaptura,
    'en_revision': EstadoDeVerificacion.enRevision,
    'verificada': EstadoDeVerificacion.verificada,
    'no_verificada': EstadoDeVerificacion.noVerificada,
  };

  @override
  Future<Verificacion> miEstado() async {
    final r = await enviarJson(transporte, url, 'GET', 'me/verificacion');
    final m = objetoDelContrato(r.json);
    final estado = _estados[m['estado']];
    if (estado == null) throw const DatosInvalidosFailure();
    final enviado = m['enviadoEn'];
    return Verificacion(
      estado: estado,
      motivo: textoOpcional(m['motivo']),
      consejos: [
        for (final c in listaDelContrato(m['consejos'])) textoObligatorio(c),
      ],
      nivelOtorgado: textoOpcional(m['nivelOtorgado']),
      enviadoEn: enviado == null ? null : fechaHoraObligatoria(enviado),
    );
  }
}
