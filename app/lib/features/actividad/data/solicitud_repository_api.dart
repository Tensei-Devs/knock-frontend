import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/core/red/errores_api.dart';
import 'package:app/features/actividad/data/contrato_json.dart';
import 'package:app/features/actividad/data/solicitud_contrato_mapper.dart';
import 'package:app/features/actividad/data/solicitud_mapper.dart';
import 'package:app/features/actividad/data/subida_de_fotos_api.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:app/features/actividad/domain/regla_cancelacion.dart';
import 'package:http/http.dart' as http;
import 'package:knock_api/api.dart' as api;

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

  static final _idDeSolicitud = RegExp(r'^[a-fA-F0-9]{24}$');

  /// `POST /solicitudes/{id}/cancelar` (backend 029; spec 025, escrito a mano
  /// por ADR-007). El motivo solo viaja si la persona eligió uno.
  @override
  Future<ResultadoCancelacion> cancelar(
    String id, {
    MotivoCancelacion? motivo,
  }) async {
    if (!_idDeSolicitud.hasMatch(id)) return const CancelacionInvalida();
    final RespuestaJson r;
    try {
      r = await enviarJson(
        transporte,
        url,
        'POST',
        'solicitudes/$id/cancelar',
        cuerpo: motivo == null ? null : {'motivo': motivo.valor},
        aceptar: const {400, 404, 409, 500, 502, 503, 504},
      );
    } on DemasiadosIntentosFailure catch (error) {
      return CancelacionLimite(error.espera ?? Duration.zero);
    } on ServicioNoDisponibleFailure {
      return const CancelacionSinConexion();
    } on DatosInvalidosFailure {
      return const CancelacionError();
    }
    return switch (r.estado) {
      200 => _cancelada(r.json),
      400 => const CancelacionInvalida(),
      404 => const CancelacionNoDisponible(),
      409 when _codigo(r) == 'request_with_appointment' =>
        const CancelacionConCita(),
      409 when _codigo(r) == 'request_expired' => const CancelacionYaVencida(),
      _ => const CancelacionError(),
    };
  }

  static ResultadoCancelacion _cancelada(Object? json) {
    if (json is! Map<Object?, Object?>) return const CancelacionError();
    final fecha = json['canceladaEn'];
    final instante = fecha is String ? DateTime.tryParse(fecha) : null;
    if (json['estado'] != 'cancelada' || instante == null) {
      return const CancelacionError();
    }
    return Cancelada(instante);
  }

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
    final cliente = api.ApiClient(basePath: url)..client = transporte;
    final http.Response respuesta;
    try {
      respuesta = await api.ChooseQuoteApi(cliente)
          .apiVversionSolicitudesIdElegirPostWithHttpInfo(
            Uri.encodeComponent(solicitudId),
            '1',
            api.ChooseQuoteBody(cotizacionId: cotizacionId),
          );
    } on Failure {
      rethrow;
    } on api.ApiException catch (error) {
      throw mapearErrorApi(error);
    } on Exception {
      throw const ServicioNoDisponibleFailure();
    }
    Object? json;
    try {
      json = jsonDecode(utf8.decode(respuesta.bodyBytes));
    } on FormatException {
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        throw const DatosInvalidosFailure();
      }
    }
    switch (respuesta.statusCode) {
      case 404:
        throw const NoEncontradoFailure();
      case 422:
        throw const DatosRechazadosFailure();
      case 409:
        final codigo = json is Map ? json['code'] : null;
        final motivo = switch (codigo) {
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
    if (respuesta.statusCode != 200) {
      throw mapearErrorApi(api.ApiException(respuesta.statusCode, ''));
    }
    final cita = SolicitudContratoMapper.cita(json);
    if (cita.solicitudId != solicitudId || cita.cotizacionId != cotizacionId) {
      throw const DatosInvalidosFailure();
    }
    return cita;
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
