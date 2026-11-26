import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/opiniones/domain/opinion.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /tecnicos/{id}/opiniones`, `POST /visitas/{id}/opinion` y
/// `POST /opiniones/{id}/respuesta` (backend 051). Va por el transporte con
/// sesión (spec 026): un 401 cierra la sesión. No registra textos y una
/// escritura no se reintenta sola.
class OpinionesRepositoryApi implements OpinionesRepository {
  const OpinionesRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<PaginaOpiniones> listar(String tecnicoId, {String? cursor}) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'tecnicos/${Uri.encodeComponent(tecnicoId)}/opiniones',
      consulta: {'cursor': ?cursor},
    );
    final m = objetoDelContrato(r.json);
    return PaginaOpiniones(
      listaDelContrato(m['items']).map(_opinion).toList(growable: false),
      _resumen(m['resumen']),
      textoOpcional(m['nextCursor']),
    );
  }

  @override
  Future<OpinionCreada> calificar(String visitaId, NuevaOpinion opinion) async {
    final comentario = opinion.comentario.trim();
    final partes = opinion.partes;
    final r = await _escribir(
      'visitas/${Uri.encodeComponent(visitaId)}/opinion',
      {
        'calificacion': opinion.calificacion,
        'partes': partes.vacia
            ? null
            : {
                'puntualidad': partes.puntualidad,
                'calidad': partes.calidad,
                'precioJusto': partes.precioJusto,
                'trato': partes.trato,
              },
        'comentario': comentario.isEmpty ? null : comentario,
        // Sin fotos mientras no exista su entrega (spec 041, §10).
        'fotos': <String>[],
        'guardarTecnicoConfianza': opinion.guardarTecnicoConfianza,
      },
      conflicto: 'review_not_allowed',
      fallaDelConflicto: const OpinionNoPermitidaFailure(),
    );
    final m = objetoDelContrato(r.json);
    return OpinionCreada(
      id: textoObligatorio(m['id']),
      calificacion: _entero(m['calificacion']),
      moderacion: textoObligatorio(m['moderacion']),
      creadoEn: fechaHoraObligatoria(m['creadoEn']),
    );
  }

  @override
  Future<void> responder(String opinionId, String texto) => _escribir(
    'opiniones/${Uri.encodeComponent(opinionId)}/respuesta',
    {'texto': texto.trim()},
    conflicto: 'review_already_answered',
    fallaDelConflicto: const OpinionYaRespondidaFailure(),
  );

  /// Un `POST` cuyo 409 con el código [conflicto] es [fallaDelConflicto]; otro
  /// 409 queda como conflicto genérico.
  Future<RespuestaJson> _escribir(
    String ruta,
    Map<String, Object?> cuerpo, {
    required String conflicto,
    required Failure fallaDelConflicto,
  }) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      ruta,
      cuerpo: cuerpo,
      aceptar: const {409},
    );
    if (r.estado != 409) return r;
    final json = r.json;
    throw json is Map<Object?, Object?> && json['code'] == conflicto
        ? fallaDelConflicto
        : const ConflictoFailure();
  }

  /// Los enteros del contrato llegan como número o como texto numérico.
  static int _entero(Object? valor) =>
      _enteroOpcional(valor) ?? (throw const DatosInvalidosFailure());

  static int? _enteroOpcional(Object? valor) {
    if (valor == null) return null;
    final n = valor is int ? valor : int.tryParse('$valor');
    if (n == null) throw const DatosInvalidosFailure();
    return n;
  }

  static ResumenDeOpiniones _resumen(Object? json) {
    final m = objetoDelContrato(json);
    final promedio = m['promedio'];
    final valor = promedio == null ? null : double.tryParse('$promedio');
    if (promedio != null && valor == null) throw const DatosInvalidosFailure();
    return ResumenDeOpiniones(
      promedio: valor,
      total: _entero(m['total']),
      distribucion: {
        for (final e in objetoDelContrato(m['distribucion']).entries)
          _entero(e.key): _entero(e.value),
      },
    );
  }

  static Opinion _opinion(Object? json) {
    final m = objetoDelContrato(json);
    final partes = m['partes'];
    final respuesta = m['respuesta'];
    return Opinion(
      id: textoObligatorio(m['id']),
      calificacion: _entero(m['calificacion']),
      partes: partes == null ? null : _partes(partes),
      comentario: textoOpcional(m['comentario']),
      totalFotos: listaDelContrato(m['fotos']).length,
      respuesta: respuesta == null ? null : _respuesta(respuesta),
      anonimizada: booleanoObligatorio(m['anonimizada']),
      servicioVerificado: booleanoObligatorio(m['servicioVerificado']),
      creadoEn: fechaHoraObligatoria(m['creadoEn']),
    );
  }

  static PartesDeOpinion _partes(Object json) {
    final m = objetoDelContrato(json);
    return PartesDeOpinion(
      puntualidad: _enteroOpcional(m['puntualidad']),
      calidad: _enteroOpcional(m['calidad']),
      precioJusto: _enteroOpcional(m['precioJusto']),
      trato: _enteroOpcional(m['trato']),
    );
  }

  static RespuestaDeOpinion _respuesta(Object json) {
    final m = objetoDelContrato(json);
    return RespuestaDeOpinion(
      textoObligatorio(m['texto']),
      fechaHoraObligatoria(m['fecha']),
    );
  }
}
