import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/visita/domain/permiso_fotos.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/visitas/{id}` y `PUT .../permiso-fotos` (backend 050).
/// Escrito a mano por ADR-007. No se guarda nada en el teléfono.
class PermisoFotosRepositoryApi implements PermisoFotosRepository {
  const PermisoFotosRepositoryApi({
    required this.transporte,
    required this.url,
  });

  final http.Client transporte;
  final String url;

  Future<Map<Object?, Object?>> _pedir(
    String metodo,
    String ruta, [
    Map<String, Object?>? cuerpo,
  ]) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      metodo,
      ruta,
      cuerpo: cuerpo,
    );
    return objetoDelContrato(r.json);
  }

  @override
  Future<PermisoDeFotos> consultar(String visitaId) async {
    final m = await _pedir('GET', 'visitas/${Uri.encodeComponent(visitaId)}');
    if (textoObligatorio(m['id']) != visitaId) {
      throw const DatosInvalidosFailure();
    }
    final permiso = m['permisoFotos'];
    return PermisoDeFotos(
      terminada:
          textoObligatorio(m['rol']) == 'cliente' &&
          textoObligatorio(m['estado']) == 'terminada',
      permiso: permiso != null && booleanoObligatorio(permiso),
    );
  }

  @override
  Future<bool> guardar(String visitaId, {required bool permiso}) async {
    final m = await _pedir(
      'PUT',
      'visitas/${Uri.encodeComponent(visitaId)}/permiso-fotos',
      {'permiso': permiso},
    );
    if (textoObligatorio(m['visitaId']) != visitaId) {
      throw const DatosInvalidosFailure();
    }
    return booleanoObligatorio(m['permiso']);
  }
}
