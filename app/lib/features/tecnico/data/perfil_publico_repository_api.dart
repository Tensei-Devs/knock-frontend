import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/tecnico/domain/perfil_publico.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/tecnicos/{id}` y sus subrutas (backend 046 y 047).
class PerfilPublicoRepositoryApi implements PerfilPublicoRepository {
  const PerfilPublicoRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  Future<Map<Object?, Object?>> _leer(
    String id, [
    String subruta = '',
    Map<String, String>? consulta,
  ]) async {
    if (id.trim().isEmpty) throw const DatosRechazadosFailure();
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'tecnicos/${Uri.encodeComponent(id)}$subruta',
      consulta: consulta,
    );
    return objetoDelContrato(r.json);
  }

  @override
  Future<PerfilPublico> perfil(String id) async {
    final m = await _leer(id);
    final detalle = m['detalle'];
    return PerfilPublico(
      id: textoObligatorio(m['id']),
      nombre: textoObligatorio(m['nombre']),
      verificacion: textoObligatorio(m['verificacion']),
      oficios: [
        for (final o in listaDelContrato(m['oficios'])) textoObligatorio(o),
      ],
      nombreNegocio: textoOpcional(m['nombreNegocio']),
      fotoUrl: textoOpcional(m['fotoUrl']),
      calificacion: _numeroOpcional(m['calificacion'])?.toDouble(),
      anios: _numeroOpcional(m['anios'])?.toInt(),
      descripcionCorta: textoOpcional(m['descripcionCorta']),
      detalle: detalle == null ? null : _aDetalle(detalle),
    );
  }

  @override
  Future<List<ServicioPublico>> servicios(String id) async {
    final m = await _leer(id, '/servicios');
    return [for (final s in listaDelContrato(m['items'])) _aServicio(s)];
  }

  @override
  Future<PaginaFotos> fotos(String id, {String? cursor}) async {
    final m = await _leer(id, '/fotos-trabajos', {'cursor': ?cursor});
    return PaginaFotos([
      for (final f in listaDelContrato(m['fotos'])) _aFoto(f),
    ], textoOpcional(m['nextCursor']));
  }

  @override
  Future<bool> llegaAColonia(String id, String coloniaId) async {
    final m = await _leer(id, '/llega-a-mi-colonia', {'colonia': coloniaId});
    return booleanoObligatorio(m['atiende']);
  }
}

num? _numeroOpcional(Object? valor) {
  if (valor is! num?) throw const DatosInvalidosFailure();
  return valor;
}

DetallePerfil _aDetalle(Object json) {
  final m = objetoDelContrato(json);
  return DetallePerfil(
    disponibleHoy: booleanoObligatorio(m['disponibleHoy']),
    descripcion: textoOpcional(m['descripcion']),
    atencion: textoOpcional(m['atencion']),
    radioKm: _numeroOpcional(m['radioKm'])?.toInt(),
    coloniaId: textoOpcional(m['coloniaId']),
  );
}

ServicioPublico _aServicio(Object? json) {
  final m = objetoDelContrato(json);
  String texto(String campo) => textoObligatorio(m[campo]);
  return ServicioPublico(
    id: texto('id'),
    nombre: texto('nombre'),
    oficio: texto('oficio'),
    precioReferencia: enteroObligatorio(m['precioReferencia']),
    detalle: textoOpcional(m['detalle']),
  );
}

FotoDeTrabajo _aFoto(Object? json) {
  final m = objetoDelContrato(json);
  return FotoDeTrabajo(
    id: textoObligatorio(m['id']),
    url: textoObligatorio(m['url']),
  );
}
