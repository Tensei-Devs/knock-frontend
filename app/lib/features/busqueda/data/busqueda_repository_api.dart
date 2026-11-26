import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/busqueda/domain/busqueda.dart';
import 'package:app/features/busqueda/domain/busqueda_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/busqueda` (backend 027). El texto viaja solo en la
/// consulta de esta petición y no se guarda: `transporteApiProvider` no
/// cachea esta ruta.
class BusquedaRepositoryApi implements BusquedaRepository {
  const BusquedaRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<PaginaBusqueda> buscar({
    required String consulta,
    required String coloniaId,
    String? oficio,
    bool soloVerificados = false,
    String? cursor,
    int limite = 20,
  }) async {
    if (normalizarConsulta(consulta) != consulta ||
        coloniaId.trim().isEmpty ||
        limite < 1 ||
        limite > 20) {
      throw const DatosRechazadosFailure();
    }
    final r = await enviarJson(
      transporte,
      url,
      'GET',
      'busqueda',
      consulta: {
        'q': consulta,
        'coloniaId': coloniaId,
        'oficio': ?oficio,
        if (soloVerificados) 'soloVerificados': 'true',
        'cursor': ?cursor,
        'limit': '$limite',
      },
      aceptar: const {400, 422, 500, 502, 503, 504},
    );
    if (r.estado >= 500) throw const BusquedaNoDisponible();
    if (r.estado == 400 || r.estado == 422) {
      throw _falloDeBusqueda(r);
    }
    final m = objetoDelContrato(r.json);
    return PaginaBusqueda(
      interpretacion: _aInterpretacion(m['interpretacion']),
      items: listaDelContrato(m['items'])
          .map(_aExperto)
          .toList(growable: false),
      siguiente: textoOpcional(m['nextCursor']),
    );
  }

  @override
  Future<List<SugerenciaBusqueda>> sugerencias(String consulta) async {
    if (normalizarConsulta(consulta) != consulta) {
      throw const DatosRechazadosFailure();
    }
    final r = await enviarJson(
      transporte,
      url,
      'GET',
      'tecnicos/autocompletar',
      consulta: {'q': consulta},
    );
    final filas = listaDelContrato(objetoDelContrato(r.json)['sugerencias']);
    return [for (final fila in filas) _aSugerencia(fila)];
  }
}

SugerenciaBusqueda _aSugerencia(Object? json) {
  final m = objetoDelContrato(json);
  String? opcional(String campo) => textoOpcional(m[campo]);
  return SugerenciaBusqueda(
    tipo: textoObligatorio(m['tipo']),
    texto: textoObligatorio(m['texto']),
    clave: opcional('clave'),
    id: opcional('id'),
  );
}

Failure _falloDeBusqueda(RespuestaJson r) {
  final cuerpo = r.json;
  final codigo = cuerpo is Map<Object?, Object?> ? cuerpo['code'] : null;
  if (r.estado == 422 && codigo == 'colonia_not_found') {
    return const OpcionNoDisponibleFailure();
  }
  // 400 `invalid_cursor` también llega como DatosRechazados: quien pidió con
  // cursor reinicia desde la primera página.
  return const DatosRechazadosFailure();
}

InterpretacionBusqueda _aInterpretacion(Object? json) {
  final m = objetoDelContrato(json);
  final estado = EstadoInterpretacion.desde(textoObligatorio(m['estado']));
  if (estado == null) throw const DatosInvalidosFailure();
  final detectado = m['oficioDetectado'];
  final sugeridos = m['oficiosSugeridos'];
  return InterpretacionBusqueda(
    estado: estado,
    oficioDetectado: detectado == null ? null : _aOficio(detectado),
    oficiosSugeridos: sugeridos == null
        ? const []
        : listaDelContrato(sugeridos).map(_aOficio).toList(growable: false),
  );
}

OficioBuscado _aOficio(Object? json) {
  final m = objetoDelContrato(json);
  return OficioBuscado(
    clave: textoObligatorio(m['clave']),
    nombre: textoObligatorio(m['nombre']),
  );
}

ExpertoBuscado _aExperto(Object? json) {
  final m = objetoDelContrato(json);
  final calificacion = m['calificacion'];
  final distancia = m['distanciaKm'];
  if (calificacion is! num || (distancia != null && distancia is! int)) {
    throw const DatosInvalidosFailure();
  }
  return ExpertoBuscado(
    id: textoObligatorio(m['id']),
    nombre: textoObligatorio(m['nombre']),
    oficios: listaDelContrato(m['oficios'])
        .map(_aOficio)
        .toList(growable: false),
    calificacion: calificacion.toDouble(),
    totalResenas: enteroObligatorio(m['totalResenas']),
    verificado: booleanoObligatorio(m['verificado']),
    nivelVerificacion: textoObligatorio(m['nivelVerificacion']),
    coloniaBase: textoOpcional(m['coloniaBase']),
    distanciaKm: distancia as int?,
    atiendeTuColonia: booleanoObligatorio(m['atiendeTuColonia']),
    fotoUrl: textoOpcional(m['fotoUrl']),
  );
}
