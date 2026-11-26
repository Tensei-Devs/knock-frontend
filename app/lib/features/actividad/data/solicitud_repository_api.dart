import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/actividad/data/contrato_json.dart';
import 'package:app/features/actividad/data/solicitud_contrato_mapper.dart';
import 'package:app/features/actividad/data/solicitud_mapper.dart';
import 'package:app/features/actividad/data/subida_de_fotos_api.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: las rutas de `/api/v1/solicitudes` (backend 020 y 021). Todas piden
/// sesión (Bearer, por el transporte con sesión de la spec 026).
///
/// Las fotos suben con [fotos] (backend 062). Sin ella, [subirFoto] falla con
/// [ServicioNoDisponibleFailure]. Una escritura nunca se reintenta aquí (spec
/// 026, R-13).
class SolicitudRepositoryApi implements SolicitudRepository {
  const SolicitudRepositoryApi({
    required this.transporte,
    required this.url,
    this.fotos,
  });

  final http.Client transporte;
  final String url;
  final SubidaDeFotosApi? fotos;

  /// Páginas que se piden como máximo al listar (50 solicitudes por página).
  static const _maxPaginas = 4;

  @override
  Future<String> subirFoto(String rutaLocal) async {
    final subida = fotos;
    if (subida == null) throw const ServicioNoDisponibleFailure();
    return subida.subir(rutaLocal);
  }

  @override
  Future<Solicitud> crear(NuevaSolicitud solicitud) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'solicitudes',
      cuerpo: cuerpoDeSolicitud(solicitud),
      aceptar: const {422, 503},
    );
    if (r.estado == 503) {
      throw _codigo(r) == 'moderation_unavailable'
          ? const ModeracionNoDisponibleFailure()
          : const ServicioNoDisponibleFailure();
    }
    if (r.estado == 422) {
      throw switch (_codigo(r)) {
        'content_rejected' => const ContenidoRechazadoFailure(),
        'trade_invalid' ||
        'colonia_not_found' => const OpcionNoDisponibleFailure(),
        'photo_invalid' => const FotoNoValidaFailure(),
        _ => const DatosRechazadosFailure(),
      };
    }
    return SolicitudContratoMapper.detalle(r.json);
  }

  @override
  Future<Solicitud> obtener(String id) async {
    return SolicitudContratoMapper.detalle(
      await obtenerJsonONoEncontrado(
        transporte,
        url,
        'solicitudes/${Uri.encodeComponent(id)}',
      ),
    );
  }

  @override
  Future<List<Solicitud>> listar() async {
    final todas = <Solicitud>[];
    String? cursor;
    for (var pagina = 0; pagina < _maxPaginas; pagina++) {
      final r = await enviarJson(
        transporte,
        url,
        'GET',
        'solicitudes',
        consulta: {'limit': '50', 'cursor': ?cursor},
      );
      final p = SolicitudContratoMapper.pagina(r.json);
      todas.addAll(p.items);
      cursor = p.siguiente;
      if (cursor == null) break;
    }
    return todas;
  }

  @override
  Future<ResultadoComparacion> cotizaciones(
    String solicitudId, {
    OrdenCotizaciones orden = OrdenCotizaciones.recomendadas,
  }) async {
    return SolicitudContratoMapper.comparacion(
      await obtenerJsonONoEncontrado(
        transporte,
        url,
        'solicitudes/${Uri.encodeComponent(solicitudId)}/cotizaciones',
        consulta: {'orden': orden.valor},
      ),
    );
  }

  @override
  Future<CitaConfirmada> elegir(String solicitudId, String cotizacionId) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'solicitudes/${Uri.encodeComponent(solicitudId)}/elegir',
      cuerpo: {'cotizacionId': cotizacionId},
      aceptar: const {404, 409, 422},
    );
    switch (r.estado) {
      case 404:
        throw const NoEncontradoFailure();
      case 422:
        throw const DatosRechazadosFailure();
      case 409:
        final motivo = switch (_codigo(r)) {
          'request_already_chosen' => MotivoEleccionRechazada.yaElegida,
          'quote_unavailable' => MotivoEleccionRechazada.cotizacionNoDisponible,
          'request_expired' => MotivoEleccionRechazada.vencida,
          'request_cancelled' => MotivoEleccionRechazada.cancelada,
          'request_without_quotes' => MotivoEleccionRechazada.sinCotizaciones,
          _ => null,
        };
        throw motivo == null
            ? const ConflictoFailure()
            : EleccionRechazadaFailure(motivo);
    }
    return SolicitudContratoMapper.cita(r.json);
  }

  /// El `code` de un error del servidor (ProblemDetails), si lo trae.
  static String? _codigo(RespuestaJson r) {
    final json = r.json;
    if (json is Map<Object?, Object?>) {
      final c = json['code'];
      if (c is String) return c;
    }
    return null;
  }
}
