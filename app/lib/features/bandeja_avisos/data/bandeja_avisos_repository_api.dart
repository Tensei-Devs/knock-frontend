import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/bandeja_avisos/domain/aviso_en_bandeja.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/avisos` y `/api/v1/me/preferencias-avisos` (backend 044).
/// Va por el transporte con sesión (spec 026). No registra títulos ni textos.
class BandejaAvisosRepositoryApi implements BandejaAvisosRepository {
  const BandejaAvisosRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  static const _preferencias = 'me/preferencias-avisos';

  @override
  Future<PaginaAvisos> listar({String? cursor}) async {
    final r = await enviarJson(
      transporte,
      url,
      'GET',
      'avisos',
      consulta: {'cursor': ?cursor},
    );
    final m = objetoDelContrato(r.json);
    return PaginaAvisos(
      listaDelContrato(m['items']).map(_aviso).toList(growable: false),
      textoOpcional(m['siguienteCursor']),
    );
  }

  @override
  Future<AvisosSinLeer> sinLeer() async {
    final r = await enviarJson(
      transporte,
      url,
      'GET',
      'avisos/no-leidos/contador',
    );
    final m = objetoDelContrato(r.json);
    return AvisosSinLeer(
      enteroObligatorio(m['cantidad']),
      masDe99: booleanoObligatorio(m['masDe99']),
    );
  }

  @override
  Future<void> marcarLeido(String id) => enviarJsonONoEncontrado(
    transporte,
    url,
    'POST',
    'avisos/${Uri.encodeComponent(id)}/leido',
  );

  @override
  Future<void> marcarTodos() =>
      enviarJson(transporte, url, 'POST', 'avisos/leidos');

  @override
  Future<List<PreferenciaDeAviso>> preferencias() async => _leerPreferencias(
    await enviarJson(transporte, url, 'GET', _preferencias),
  );

  @override
  Future<List<PreferenciaDeAviso>> cambiar(
    String tipo, {
    required bool activo,
  }) async => _leerPreferencias(
    await enviarJson(
      transporte,
      url,
      'PUT',
      _preferencias,
      cuerpo: {
        'tipos': [
          {'tipo': tipo, 'activo': activo},
        ],
      },
    ),
  );

  static List<PreferenciaDeAviso> _leerPreferencias(RespuestaJson r) => [
    for (final valor in listaDelContrato(objetoDelContrato(r.json)['tipos']))
      _preferencia(valor),
  ];

  static PreferenciaDeAviso _preferencia(Object? json) => switch (json) {
    {
      'tipo': final String tipo,
      'activo': final bool activo,
      'apagable': final bool apagable,
    }
        when tipo.isNotEmpty =>
      PreferenciaDeAviso(tipo: tipo, activo: activo, apagable: apagable),
    _ => throw const DatosInvalidosFailure(),
  };

  static AvisoEnBandeja _aviso(Object? json) {
    final m = objetoDelContrato(json);
    return AvisoEnBandeja(
      id: textoObligatorio(m['id']),
      tipo: textoObligatorio(m['tipo']),
      titulo: textoObligatorio(m['titulo']),
      texto: textoObligatorio(m['texto']),
      leido: booleanoObligatorio(m['leido']),
      creadoEn: fechaHoraObligatoria(m['creadoEn']),
    );
  }
}
