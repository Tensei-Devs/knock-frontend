import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/cuenta/domain/eliminacion.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/me/pendientes` y `/api/v1/me/eliminacion` (backend 039). Va
/// por el transporte con sesión (spec 026). No registra el motivo ni el token.
class EliminacionRepositoryApi implements EliminacionRepository {
  const EliminacionRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  static const _eliminacion = 'me/eliminacion';

  @override
  Future<PendientesDeCuenta> pendientes() async {
    final r = await enviarJson(transporte, url, 'GET', 'me/pendientes');
    final m = objetoDelContrato(r.json);
    return PendientesDeCuenta(
      citas: _total(m['citas']),
      cotizaciones: _total(m['cotizaciones']),
    );
  }

  @override
  Future<ResultadoDeEliminacion> programar({
    String? firebaseIdToken,
    String? motivo,
  }) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      _eliminacion,
      cuerpo: {
        'confirmacion': EliminacionRepository.confirmacion,
        'firebaseIdToken': ?firebaseIdToken,
        'motivo': ?motivo,
      },
      aceptar: const {422},
    );
    if (r.estado != 422) {
      return EliminacionProgramada(
        fechaHoraObligatoria(objetoDelContrato(r.json)['eliminarEn']),
      );
    }
    if (r.json case {'errors': {'firebaseIdToken': _}}) {
      return PideVerificacion(rechazada: firebaseIdToken != null);
    }
    throw const DatosRechazadosFailure();
  }

  @override
  Future<void> cancelar() =>
      enviarJson(transporte, url, 'POST', '$_eliminacion/cancelar');

  /// El contrato admite el total como número o como texto con dígitos.
  static int _total(Object? grupo) {
    final valor = objetoDelContrato(grupo)['total'];
    final total = valor is String ? int.tryParse(valor) : valor;
    if (total is! int || total < 0) throw const DatosInvalidosFailure();
    return total;
  }
}
