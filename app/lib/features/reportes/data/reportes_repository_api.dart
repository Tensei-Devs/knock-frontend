import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/reportes/domain/reporte.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/reportes`, `/reportes/me`, `/reportes/{id}/apelacion`,
/// `/usuarios/{id}/bloqueo` y `/me/bloqueos` (backend 043). Va por el
/// transporte con sesión (spec 026): un 401 cierra la sesión. No registra
/// textos ni identificadores y una escritura no se reintenta sola.
class ReportesRepositoryApi implements ReportesRepository, BloqueosRepository {
  const ReportesRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<DestinoDeReporte?> destinoDeVisita(String visitaId) async {
    // Solo se leen `tecnicoUsuarioId` y el nombre de `VisitResponse`.
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'visitas/${Uri.encodeComponent(visitaId)}',
    );
    final m = objetoDelContrato(r.json);
    final usuarioId = textoOpcional(m['tecnicoUsuarioId']);
    if (usuarioId == null) return null;
    return DestinoDeReporte(
      usuarioId: usuarioId,
      nombre: textoObligatorio(objetoDelContrato(m['tecnico'])['nombre']),
    );
  }

  @override
  Future<ReporteCreado> crear(NuevoReporte reporte) async {
    // 422 `report_content_rejected` y 503 `report_moderation_unavailable`
    // tienen su propio mensaje (backend 043).
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'reportes',
      cuerpo: {
        'reportadoId': reporte.reportadoId,
        'referencia': {'tipo': 'visita', 'id': reporte.visitaId},
        'motivo': reporte.motivo.valor,
        'descripcion': reporte.descripcion.trim(),
        // Sin fotos mientras no exista su entrega (spec 032).
        'evidencia': <String>[],
      },
      aceptar: const {422, 503},
    );
    if (r.estado == 422) {
      throw _codigo(r) == 'report_content_rejected'
          ? const ContenidoRechazadoFailure()
          : const DatosRechazadosFailure();
    }
    if (r.estado == 503) {
      throw _codigo(r) == 'report_moderation_unavailable'
          ? const ModeracionNoDisponibleFailure()
          : const ServicioNoDisponibleFailure();
    }
    final m = objetoDelContrato(r.json);
    return ReporteCreado(
      reporteId: textoObligatorio(m['reporteId']),
      estado: textoObligatorio(m['estado']),
      creadoEn: fechaHoraObligatoria(m['creadoEn']),
      avisoEmergencia: textoOpcional(m['avisoEmergencia']),
    );
  }

  @override
  Future<PaginaReportes> listar({String? cursor}) async {
    final (items, siguiente) = await _pagina('reportes/me', cursor, _reporte);
    return PaginaReportes(items, siguiente);
  }

  @override
  Future<void> apelar(String reporteId, String texto) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'reportes/${Uri.encodeComponent(reporteId)}/apelacion',
      cuerpo: {'texto': texto.trim()},
      aceptar: const {409},
    );
    if (r.estado == 409) {
      throw _codigo(r) == 'appeal_not_allowed'
          ? const ApelacionNoPermitidaFailure()
          : const ConflictoFailure();
    }
  }

  @override
  Future<void> bloquear(String usuarioId) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      _bloqueo(usuarioId),
      aceptar: const {409},
    );
    if (r.estado == 409) {
      throw _codigo(r) == 'already_blocked'
          ? const YaBloqueadoFailure()
          : const ConflictoFailure();
    }
  }

  @override
  Future<void> desbloquear(String usuarioId) =>
      enviarJsonONoEncontrado(transporte, url, 'DELETE', _bloqueo(usuarioId));

  @override
  Future<PaginaBloqueados> bloqueados({String? cursor}) async {
    final (items, siguiente) = await _pagina('me/bloqueos', cursor, _persona);
    return PaginaBloqueados(items, siguiente);
  }

  /// Los elementos leídos con [leer] y el cursor de la página siguiente.
  Future<(List<T>, String?)> _pagina<T>(
    String ruta,
    String? cursor,
    T Function(Object?) leer,
  ) async {
    final r = await enviarJson(
      transporte,
      url,
      'GET',
      ruta,
      consulta: {'cursor': ?cursor},
    );
    final m = objetoDelContrato(r.json);
    return (
      listaDelContrato(m['items']).map(leer).toList(growable: false),
      textoOpcional(m['nextCursor']),
    );
  }

  static String _bloqueo(String id) =>
      'usuarios/${Uri.encodeComponent(id)}/bloqueo';

  static Object? _codigo(RespuestaJson r) {
    final json = r.json;
    return json is Map<Object?, Object?> ? json['code'] : null;
  }

  static ResumenDeReporte _reporte(Object? json) {
    final m = objetoDelContrato(json);
    final puedeApelar = booleanoObligatorio(m['puedeApelar']);
    return ResumenDeReporte(
      reporteId: textoObligatorio(m['reporteId']),
      motivo: textoObligatorio(m['motivo']),
      estado: textoObligatorio(m['estado']),
      creadoEn: fechaHoraObligatoria(m['creadoEn']),
      puedeApelar: puedeApelar,
    );
  }

  static PersonaBloqueada _persona(Object? json) {
    final m = objetoDelContrato(json);
    final bloqueadoEn = fechaHoraObligatoria(m['bloqueadoEn']);
    return PersonaBloqueada(
      usuarioId: textoObligatorio(m['usuarioId']),
      nombre: textoObligatorio(m['nombre']),
      bloqueadoEn: bloqueadoEn,
    );
  }
}
