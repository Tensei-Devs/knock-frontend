import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/suspension/domain/apelacion_suspension.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET` y `POST /api/v1/suspension/apelacion`. El transporte es el
/// público: nunca el de la sesión de Knock (CA-E01 de la spec 033).
class ApelacionSuspensionRepositoryApi
    implements ApelacionSuspensionRepository {
  const ApelacionSuspensionRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  Future<ApelacionDeSuspension> _pedir(
    String metodo,
    String idToken, [
    Map<String, Object?>? cuerpo,
  ]) async {
    final r = await enviarJson(
      transporte,
      url,
      metodo,
      'suspension/apelacion',
      cuerpo: cuerpo,
      cabeceras: {'Authorization': 'Bearer $idToken'},
      aceptar: const {404, 409},
    );
    if (r.estado == 404) throw const NoEncontradoFailure();
    if (r.estado == 409) throw const ApelacionNoPermitidaFailure();
    final m = objetoDelContrato(r.json);
    final resuelta = m['resueltaEn'];
    return ApelacionDeSuspension(
      estado: textoObligatorio(m['estado']),
      presentadaEn: fechaHoraObligatoria(m['presentadaEn']),
      resueltaEn: resuelta == null ? null : fechaHoraObligatoria(resuelta),
    );
  }

  @override
  Future<ApelacionDeSuspension> consultar(String idToken) =>
      _pedir('GET', idToken);

  @override
  Future<ApelacionDeSuspension> presentar(String idToken, String texto) =>
      _pedir('POST', idToken, {'texto': texto});
}
