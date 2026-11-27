import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/tecnicos_confianza/domain/tecnico_confianza.dart';
import 'package:app/features/tecnicos_confianza/domain/tecnicos_confianza_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/me/tecnicos-confianza` (backend 042). Una escritura nunca se
/// reintenta aquí (spec 026, R-13).
class TecnicosConfianzaRepositoryApi implements TecnicosConfianzaRepository {
  const TecnicosConfianzaRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  static String _ruta(String id) =>
      'me/tecnicos-confianza/${Uri.encodeComponent(id)}';

  @override
  Future<PaginaTecnicosConfianza> listar({String? cursor, int? limite}) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'me/tecnicos-confianza',
      consulta: {'cursor': ?cursor, 'limite': ?limite?.toString()},
    );
    final m = objetoDelContrato(r.json);
    return PaginaTecnicosConfianza(
      listaDelContrato(m['items']).map(_aTecnico).toList(growable: false),
      textoOpcional(m['nextCursor']),
    );
  }

  @override
  Future<ResultadoGuardado> guardar(String tecnicoId) async {
    if (tecnicoId.trim().isEmpty) throw const DatosRechazadosFailure();
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'PUT',
      _ruta(tecnicoId),
    );
    return ResultadoGuardado(_aTecnico(r.json), yaEstaba: r.estado == 200);
  }

  @override
  Future<void> quitar(String tecnicoId) async {
    if (tecnicoId.trim().isEmpty) throw const DatosRechazadosFailure();
    await enviarJsonONoEncontrado(transporte, url, 'DELETE', _ruta(tecnicoId));
  }
}

TecnicoDeConfianza _aTecnico(Object? json) {
  final m = objetoDelContrato(json);
  return TecnicoDeConfianza(
    tecnicoId: textoObligatorio(m['tecnicoId']),
    nombre: textoObligatorio(m['nombre']),
    fotoUrl: textoOpcional(m['fotoUrl']),
    nivelVerificacion: textoObligatorio(m['nivelVerificacion']),
    guardadoEn: fechaHoraObligatoria(m['guardadoEn']),
  );
}
