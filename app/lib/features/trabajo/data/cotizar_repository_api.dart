import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/trabajo/domain/cotizar.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /tecnicos/me/solicitudes`, `GET /tecnicos/me/cotizaciones`,
/// `GET /solicitudes/{id}`, `POST /solicitudes/{id}/cotizaciones` y
/// `GET /cotizaciones/referencia-mercado`.
/// No registra ni guarda descripción, colonia ni enlaces (046, CA-10).
class CotizarRepositoryApi implements CotizarRepository {
  const CotizarRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  Future<Map<Object?, Object?>> _pedir(
    String metodo,
    String ruta, {
    Map<String, String>? consulta,
    Map<String, Object?>? cuerpo,
  }) async {
    final r = await enviarJson(
      transporte,
      url,
      metodo,
      ruta,
      consulta: consulta,
      cuerpo: cuerpo,
      aceptar: const {403, 404, 409, 422, 503},
    );
    if (r.estado < 200 || r.estado > 299) throw _falla(r);
    return objetoDelContrato(r.json);
  }

  Failure _falla(RespuestaJson r) {
    final json = r.json;
    final codigo = json is Map<Object?, Object?> ? json['code'] : null;
    return switch (r.estado) {
      403 when codigo == 'not_a_technician' => const SinPerfilTecnicoFailure(),
      403 when codigo == 'account_suspended' => const CuentaSuspendidaFailure(),
      403 => const AccesoDenegadoFailure(),
      404 => const NoEncontradoFailure(),
      409 => switch (codigo) {
        'request_not_quotable' => const CotizacionNoPermitidaFailure(
          MotivoCotizacionRechazada.yaNoSeCotiza,
        ),
        'quote_duplicate' => const CotizacionNoPermitidaFailure(
          MotivoCotizacionRechazada.yaCotizada,
        ),
        'quote_quota_full' => const CotizacionNoPermitidaFailure(
          MotivoCotizacionRechazada.cupoLleno,
        ),
        _ => const ConflictoFailure(),
      },
      422 when codigo == 'content_rejected' =>
        const ContenidoRechazadoFailure(),
      422 => const DatosRechazadosFailure(),
      503 when codigo == 'moderation_unavailable' =>
        const ModeracionNoDisponibleFailure(),
      _ => const ServicioNoDisponibleFailure(),
    };
  }

  @override
  Future<PaginaDeSolicitudes> recibidas({String? cursor}) async {
    final (items, siguiente) = await _pagina(
      'tecnicos/me/solicitudes',
      'limit',
      cursor,
      _recibida,
    );
    return PaginaDeSolicitudes(items, siguiente);
  }

  /// Spec 019 / backend 028. Transport temporal por ADR-007.
  @override
  Future<ResultadoDescarte> descartar(String solicitudId) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'solicitudes/${Uri.encodeComponent(solicitudId)}/descartar',
      aceptar: const {403, 404, 409},
    );
    final json = r.json;
    return switch (r.estado) {
      204 => ResultadoDescarte.descartada,
      404 => ResultadoDescarte.noDisponible,
      409 when json is Map && json['code'] == 'request_not_dismissable' =>
        ResultadoDescarte.noDescartable,
      403 || 409 => throw _falla(r),
      _ => throw const DatosInvalidosFailure(),
    };
  }

  @override
  Future<PaginaDeCotizaciones> enviadas({String? cursor}) async {
    final (items, siguiente) = await _pagina(
      'tecnicos/me/cotizaciones',
      'limite',
      cursor,
      _cotizacion,
    );
    return PaginaDeCotizaciones(items, siguiente);
  }

  /// Las dos listas del contrato nombran distinto el tamaño de página.
  Future<(List<T>, String?)> _pagina<T>(
    String ruta,
    String tamano,
    String? cursor,
    T Function(Map<Object?, Object?>) leer,
  ) async {
    final m = await _pedir(
      'GET',
      ruta,
      consulta: {tamano: '20', 'cursor': ?cursor},
    );
    return (
      [
        for (final e in listaDelContrato(m['items']))
          leer(objetoDelContrato(e)),
      ],
      textoOpcional(m['nextCursor']),
    );
  }

  SolicitudRecibida _recibida(Map<Object?, Object?> s) => SolicitudRecibida(
    solicitudId: textoObligatorio(s['solicitudId']),
    oficio: _nombre(s['oficio']),
    colonia: _nombre(s['colonia']),
    descripcion: textoObligatorio(s['descripcion']),
    dia: textoObligatorio(s['dia']),
    franja: textoObligatorio(s['franja']),
    yaCotizo: booleanoObligatorio(s['yaCotizo']),
  );

  @override
  Future<SolicitudParaCotizar> solicitud(String id) async {
    final m = await _pedir('GET', 'solicitudes/${Uri.encodeComponent(id)}');
    return SolicitudParaCotizar(
      id: textoObligatorio(m['id']),
      oficio: _nombre(m['oficio']),
      oficioClave: textoObligatorio(objetoDelContrato(m['oficio'])['clave']),
      colonia: _nombre(m['colonia']),
      descripcion: textoObligatorio(m['descripcion']),
      dia: textoObligatorio(m['dia']),
      franja: textoObligatorio(m['franja']),
      creadoEn: fechaHoraObligatoria(m['creadoEn']),
      fotos: [for (final e in listaDelContrato(m['fotos'])) _foto(e)],
    );
  }

  @override
  Future<CotizacionPropia> enviar(
    String solicitudId,
    CotizacionNueva nueva,
  ) async {
    final m = await _pedir(
      'POST',
      'solicitudes/${Uri.encodeComponent(solicitudId)}/cotizaciones',
      cuerpo: {
        'tipoPrecio': nueva.tipo.name,
        'precio': ?nueva.precio,
        'precioMin': ?nueva.precioMin,
        'precioMax': ?nueva.precioMax,
        'dia': nueva.dia,
        'hora': nueva.hora,
      },
    );
    return _cotizacion(
      m,
      requiereAprobacion: booleanoObligatorio(m['requiereAprobacion']),
    );
  }

  CotizacionPropia _cotizacion(
    Map<Object?, Object?> c, {
    bool? requiereAprobacion,
  }) => CotizacionPropia(
    id: textoObligatorio(c['id']),
    solicitudId: textoObligatorio(c['solicitudId']),
    estado: textoObligatorio(c['estado']),
    tipoPrecio: textoObligatorio(c['tipoPrecio']),
    precio: _montoOpcional(c['precio']),
    precioMin: _montoOpcional(c['precioMin']),
    precioMax: _montoOpcional(c['precioMax']),
    tope: _montoOpcional(c['tope']) ?? (throw const DatosInvalidosFailure()),
    dia: textoObligatorio(c['dia']),
    hora: textoObligatorio(c['hora']),
    requiereAprobacion: requiereAprobacion,
  );

  FotoParaCotizar _foto(Object? valor) {
    final f = objetoDelContrato(valor);
    return FotoParaCotizar(
      id: textoObligatorio(f['id']),
      url: textoObligatorio(f['url']),
    );
  }

  @override
  Future<ReferenciaDeMercado> referenciaDeMercado({
    required String oficio,
    required TipoPrecio tipo,
  }) async {
    final m = await _pedir(
      'GET',
      'cotizaciones/referencia-mercado',
      consulta: {'oficio': oficio, 'tipoTrabajo': tipo.name},
    );
    return ReferenciaDeMercado(
      origen: switch (m['origen']) {
        'mercado' => OrigenReferencia.mercado,
        'categoria' => OrigenReferencia.categoria,
        'sin_datos' => OrigenReferencia.sinDatos,
        _ => throw const DatosInvalidosFailure(),
      },
      p25: _montoOpcional(m['p25']),
      mediana: _montoOpcional(m['mediana']),
      p75: _montoOpcional(m['p75']),
    );
  }

  String _nombre(Object? valor) =>
      textoObligatorio(objetoDelContrato(valor)['nombre']);

  /// El contrato declara los montos como número o texto.
  int? _montoOpcional(Object? valor) {
    if (valor == null) return null;
    final n = valor is num ? valor : num.tryParse(valor is String ? valor : '');
    if (n == null) throw const DatosInvalidosFailure();
    return n.round();
  }
}
