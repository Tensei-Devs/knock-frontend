import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/core/red/errores_api.dart';
import 'package:app/features/actividad/data/contrato_json.dart';
import 'package:app/features/actividad/data/solicitud_contrato_mapper.dart';
import 'package:app/features/actividad/data/solicitud_mapper.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:app/features/actividad/domain/regla_cancelacion.dart';
import 'package:http/http.dart' as http;
import 'package:knock_api/api.dart' as api;

/// REAL: las rutas de `/api/v1/solicitudes` (backend 020 y 021). Todas piden
/// sesión (Bearer, por el transporte con sesión de la spec 026).
///
/// Las fotos suben por el módulo de archivos (spec 013), que el backend aún no
/// tiene: [subirFoto] falla con [ServicioNoDisponibleFailure] y [crear] solo
/// sale adelante cuando el servidor acepta la solicitud (hoy responde 503 por
/// la moderación). Una escritura nunca se reintenta aquí (spec 026, R-13).
class SolicitudRepositoryApi implements SolicitudRepository {
  const SolicitudRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  /// Páginas que se piden como máximo al listar (50 solicitudes por página).
  static const _maxPaginas = 4;

  @override
  Future<ResultadoCancelacion> cancelar(
    String id, {
    MotivoCancelacion? motivo,
  }) async {
    if (!RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(id)) {
      return const CancelacionInvalida();
    }
    final base = normalizarUrlApi(url);
    if (base == null) return const CancelacionError();
    final cliente = api.ApiClient(basePath: base)..client = transporte;
    try {
      final respuesta = await api.CancelacionApi(cliente)
          .apiVversionSolicitudesIdCancelarPostWithHttpInfo(
            id,
            versionApi,
            cancelRequestBody: motivo == null
                ? null
                : api.CancelRequestBody(motivo: motivo.valor),
          );
      Object? cuerpo;
      try {
        cuerpo = jsonDecode(utf8.decode(respuesta.bodyBytes));
      } on FormatException {
        cuerpo = null;
      }
      final mapa = cuerpo is Map ? cuerpo : const <Object?, Object?>{};
      if (respuesta.statusCode == 200) {
        final fecha = mapa['canceladaEn'];
        final instante = fecha is String ? DateTime.tryParse(fecha) : null;
        if (mapa['estado'] != 'cancelada' || instante == null) {
          return const CancelacionError();
        }
        return Cancelada(instante);
      }
      return switch (respuesta.statusCode) {
        400 => const CancelacionInvalida(),
        404 => const CancelacionNoDisponible(),
        409 when mapa['code'] == 'request_with_appointment' =>
          const CancelacionConCita(),
        409 when mapa['code'] == 'request_expired' =>
          const CancelacionYaVencida(),
        429 => CancelacionLimite(
          Duration(
            seconds: int.tryParse(respuesta.headers['retry-after'] ?? '') ?? 0,
          ),
        ),
        _ => const CancelacionError(),
      };
    } on DemasiadosIntentosFailure catch (error) {
      return CancelacionLimite(error.espera ?? Duration.zero);
    } on NoAutorizadoFailure {
      rethrow;
    } on Exception {
      return const CancelacionSinConexion();
    }
  }

  @override
  Future<String> subirFoto(String rutaLocal) async =>
      throw const ServicioNoDisponibleFailure();

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
    final cliente = api.ApiClient(basePath: url)..client = transporte;
    final http.Response respuesta;
    try {
      respuesta = await api.QuoteComparisonApi(cliente)
          .apiVversionSolicitudesIdCotizacionesGetWithHttpInfo(
            Uri.encodeComponent(solicitudId),
            '1',
            orden: orden.valor,
          );
    } on Failure {
      rethrow;
    } on Exception {
      throw const ServicioNoDisponibleFailure();
    }
    if (respuesta.statusCode == 404) throw const NoEncontradoFailure();
    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      throw mapearErrorApi(
        api.ApiException(respuesta.statusCode, respuesta.body),
      );
    }
    final Object? json;
    try {
      json = jsonDecode(utf8.decode(respuesta.bodyBytes));
    } on FormatException {
      throw const DatosInvalidosFailure();
    }
    if (mapaDelContrato(json)['solicitudId'] != solicitudId) {
      throw const DatosInvalidosFailure();
    }
    return SolicitudContratoMapper.comparacion(json);
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
