import 'dart:convert';

import 'package:app/core/cache/revalidador_etag.dart';
import 'package:app/core/errores/failure.dart';
import 'package:app/features/oficios/data/oficio_mapper.dart';
import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/domain/resultado_oficios.dart';

/// Oficios reales de `GET /api/v1/oficios`, con caché y revalidación `ETag`
/// (spec 010). El catálogo es público y no personal, por eso se puede guardar.
class OficiosRepositoryApi implements OficiosRepositoryConCache {
  OficiosRepositoryApi({
    required this._revalidador,
    required this._url,
    this.vigencia = const Duration(minutes: 10),
  });

  static const clave = 'catalogo/oficios';

  final RevalidadorEtag _revalidador;
  final Uri _url;
  final Duration vigencia;

  @override
  Future<List<Oficio>> listar() async => (await _consultar()).oficios;

  @override
  Stream<ResultadoOficios> observar() async* {
    final guardado = await _revalidador.leerGuardado(clave);
    String? mostrado;
    if (guardado != null) {
      try {
        yield ResultadoOficios(_mapear(guardado.cuerpo));
        mostrado = guardado.cuerpo;
      } on DatosInvalidosFailure {
        // Lo guardado no sirve: se ignora y se pide de nuevo.
      }
    }
    final ResultadoOficios resultado;
    final String cuerpo;
    try {
      final r = await _revalidador.obtener(
        _url,
        clave: clave,
        vigencia: vigencia,
        validar: _mapear,
      );
      cuerpo = r.cuerpo;
      resultado = ResultadoOficios(
        _mapear(r.cuerpo),
        sinConexion: r.sinConexion,
      );
    } on Failure {
      // Sin conexión y sin nada guardado: error. Con algo ya mostrado, se
      // avisa que puede estar desactualizado.
      if (mostrado == null) rethrow;
      yield ResultadoOficios(_mapear(mostrado), sinConexion: true);
      return;
    }
    if (cuerpo != mostrado || resultado.sinConexion) yield resultado;
  }

  Future<ResultadoOficios> _consultar() async {
    final r = await _revalidador.obtener(
      _url,
      clave: clave,
      vigencia: vigencia,
      validar: _mapear,
    );
    return ResultadoOficios(_mapear(r.cuerpo), sinConexion: r.sinConexion);
  }

  static List<Oficio> _mapear(String cuerpo) {
    try {
      return OficioMapper.listaDesdeContrato(jsonDecode(cuerpo));
    } on FormatException {
      throw const DatosInvalidosFailure();
    }
  }
}
