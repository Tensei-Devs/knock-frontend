import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/tecnico/domain/servicios.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/tecnicos/{id}/servicios` y
/// `/api/v1/tecnicos/me/servicios` (backend 047, SRV-01 a SRV-04). Va por el
/// transporte con sesión (spec 026). No registra nombres ni textos y las
/// escrituras no se reintentan aquí.
class ServiciosRepositoryApi implements ServiciosRepository {
  const ServiciosRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  static const _mios = 'tecnicos/me/servicios';

  static String _uno(String id) => '$_mios/${Uri.encodeComponent(id)}';

  @override
  Future<List<ServicioTecnico>> deTecnico(String tecnicoId) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'tecnicos/${Uri.encodeComponent(tecnicoId)}/servicios',
    );
    return [
      for (final s in listaDelContrato(objetoDelContrato(r.json)['items']))
        _servicio(s),
    ];
  }

  @override
  Future<ServicioGuardado> agregar(DatosDeServicio datos) =>
      _guardar('POST', _mios, datos);

  @override
  Future<ServicioGuardado> editar(String id, DatosDeServicio datos) =>
      _guardar('PUT', _uno(id), datos);

  @override
  Future<RechazoDeServicio?> quitar(String id) async {
    final r = await enviarJson(
      transporte,
      url,
      'DELETE',
      _uno(id),
      aceptar: const {404},
    );
    return r.estado == 404 ? _rechazo404(r.json) : null;
  }

  Future<ServicioGuardado> _guardar(
    String metodo,
    String ruta,
    DatosDeServicio datos,
  ) async {
    final r = await enviarJson(
      transporte,
      url,
      metodo,
      ruta,
      cuerpo: {
        'nombre': datos.nombre.trim(),
        'detalle': datos.detalle.trim(),
        'precioReferencia': datos.precioReferencia,
        'oficio': datos.oficio,
      },
      aceptar: const {404, 409, 422},
    );
    final rechazo = switch (r.estado) {
      404 => _rechazo404(r.json),
      409 when _trae(r.json, 'service_limit_reached') =>
        RechazoDeServicio.limite,
      409 => throw const ConflictoFailure(),
      422 when _trae(r.json, 'trade_invalid') =>
        RechazoDeServicio.oficioNoValido,
      422 => throw const DatosRechazadosFailure(),
      _ => null,
    };
    return (
      servicio: rechazo == null ? _servicio(r.json) : null,
      rechazo: rechazo,
    );
  }

  /// Los dos 404 del contrato se distinguen por su código; cualquier otro es
  /// «no encontrado».
  static RechazoDeServicio _rechazo404(Object? json) {
    if (_trae(json, 'not_a_technician')) {
      return RechazoDeServicio.sinPerfilDeTecnico;
    }
    if (_trae(json, 'service_not_found')) return RechazoDeServicio.noExiste;
    throw const NoEncontradoFailure();
  }

  /// Si el ProblemDetails nombra [codigo] en `code` o en `errors`.
  static bool _trae(Object? json, String codigo) {
    if (json is! Map<Object?, Object?>) return false;
    if (json['code'] == codigo) return true;
    final errores = json['errors'];
    return errores is Map<Object?, Object?> &&
        errores.values.any(
          (v) => v == codigo || (v is List<Object?> && v.contains(codigo)),
        );
  }

  static ServicioTecnico _servicio(Object? json) {
    final m = objetoDelContrato(json);
    // El contrato admite el entero también como texto.
    final precio = switch (m['precioReferencia']) {
      final int n => n,
      final String s => int.tryParse(s),
      _ => null,
    };
    if (precio == null) throw const DatosInvalidosFailure();
    return ServicioTecnico(
      id: textoObligatorio(m['id']),
      nombre: textoObligatorio(m['nombre']),
      detalle: textoOpcional(m['detalle']),
      precioReferencia: precio,
      oficio: textoObligatorio(m['oficio']),
    );
  }
}
