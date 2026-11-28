import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/mensajes/domain/conversacion.dart';
import 'package:app/features/mensajes/domain/conversacion_abierta.dart';
import 'package:app/features/mensajes/domain/conversaciones_repository.dart';
import 'package:app/features/mensajes/domain/envio_de_mensajes.dart';
import 'package:app/features/mensajes/domain/mensaje.dart';
import 'package:http/http.dart' as http;

class ConversacionesRepositoryApi
    implements
        ConversacionesRepository,
        EnvioDeMensajes,
        LecturaDeConversacion {
  const ConversacionesRepositoryApi({
    required this.transporte,
    required this.url,
  });
  final http.Client transporte;
  final String url;

  @override
  Future<ResumenConversaciones> consultar({String? cursor}) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'conversaciones',
      consulta: {'limit': '20', 'cursor': ?cursor},
    );
    final m = objetoDelContrato(r.json);
    return ResumenConversaciones(
      conversaciones: List.unmodifiable([
        for (final item in listaDelContrato(m['items']))
          _conversacion(objetoDelContrato(item)),
      ]),
      totalNoLeidos: _entero(m['totalNoLeidos']),
      siguiente: textoOpcional(m['nextCursor']),
    );
  }

  @override
  Future<int> contador() async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'conversaciones/no-leidas',
    );
    return _entero(objetoDelContrato(r.json)['total']);
  }

  @override
  Future<String> abrir({required String solicitudId, String? tecnicoId}) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      'conversaciones',
      cuerpo: {'solicitudId': solicitudId, 'tecnicoId': ?tecnicoId},
      aceptar: const {503},
    );
    if (r.estado == 503) throw const ServicioNoDisponibleFailure();
    // 200 (ya existía) y 201 (nueva) se tratan igual (CA-01).
    if (r.estado != 200 && r.estado != 201) {
      throw const DatosInvalidosFailure();
    }
    return textoObligatorio(objetoDelContrato(r.json)['conversacionId']);
  }

  @override
  Future<DetalleDeConversacion> detalle(String id) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'conversaciones/${Uri.encodeComponent(id)}',
    );
    final m = objetoDelContrato(r.json);
    final persona = objetoDelContrato(m['contraparte']);
    return DetalleDeConversacion(
      id: textoObligatorio(m['conversacionId']),
      solicitudId: textoObligatorio(m['solicitudId']),
      visitaId: textoOpcional(m['visitaId']),
      rol: textoObligatorio(m['rol']),
      contraparte: ContraparteConversacion(
        nombre: textoObligatorio(persona['nombre']),
        fotoUrl: textoOpcional(persona['fotoUrl']),
      ),
      servicio: textoObligatorio(m['servicio']),
      estado: textoObligatorio(m['estado']),
      motivoCierre: textoOpcional(m['motivoCierre']),
      avisoSeguridad: textoObligatorio(m['avisoSeguridad']),
    );
  }

  @override
  Future<PaginaDeMensajes> mensajes(String id, {String? cursor}) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'conversaciones/${Uri.encodeComponent(id)}/mensajes',
      consulta: {'limit': '30', 'cursor': ?cursor},
    );
    final m = objetoDelContrato(r.json);
    return PaginaDeMensajes(
      items: List.unmodifiable([
        for (final item in listaDelContrato(m['items']))
          _mensajeGuardado(objetoDelContrato(item)),
      ]),
      siguiente: textoOpcional(m['nextCursor']),
    );
  }

  @override
  Future<void> marcarLeido(String id, DateTime hasta) async {
    await enviarJson(
      transporte,
      url,
      'POST',
      'conversaciones/${Uri.encodeComponent(id)}/leido',
      cuerpo: {'hasta': hasta.toUtc().toIso8601String()},
    );
  }

  /// `POST /api/v1/conversaciones/{id}/mensajes` (spec 020, enmienda
  /// 2026-11-26). Una escritura: nunca se reintenta aquí (spec 026, R-13).
  ///
  /// Errores: 404 [NoEncontradoFailure]; 409 (`conversation_closed`, el único
  /// 409 del contrato en esta ruta) [ConflictoFailure]; 422
  /// `content_rejected` [ContenidoRechazadoFailure] y otro 422 o 400
  /// [DatosRechazadosFailure]; 429 [DemasiadosIntentosFailure] con la espera
  /// de `Retry-After` (la pone el transporte); 503 `moderation_unavailable`
  /// [ModeracionNoDisponibleFailure] y otro 503 (`market_unavailable`)
  /// [ServicioNoDisponibleFailure].
  @override
  Future<Mensaje> enviar(String conversacionId, String texto) async {
    if (TextoDeMensaje.validar(texto) != null) {
      throw const DatosRechazadosFailure();
    }
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      'conversaciones/${Uri.encodeComponent(conversacionId)}/mensajes',
      cuerpo: {'texto': TextoDeMensaje.preparar(texto)},
      aceptar: const {422, 503},
    );
    if (r.estado == 503) {
      throw _codigo(r.json) == 'moderation_unavailable'
          ? const ModeracionNoDisponibleFailure()
          : const ServicioNoDisponibleFailure();
    }
    if (r.estado == 422) {
      throw _codigo(r.json) == 'content_rejected'
          ? const ContenidoRechazadoFailure()
          : const DatosRechazadosFailure();
    }
    if (r.estado != 201) throw const DatosInvalidosFailure();
    return _mensajeGuardado(objetoDelContrato(r.json));
  }

  static Mensaje _mensajeGuardado(Map<Object?, Object?> m) => Mensaje(
    id: textoObligatorio(m['mensajeId']),
    autorRol: textoObligatorio(m['autorRol']),
    texto: textoObligatorio(m['texto']),
    contactoOculto: booleanoObligatorio(m['contactoOculto']),
    enviadoEn: fechaHoraObligatoria(m['enviadoEn']),
  );

  /// Solo el `code` del ProblemDetails; el resto del cuerpo se descarta.
  static String? _codigo(Object? json) =>
      json is Map<Object?, Object?> && json['code'] is String
      ? json['code']! as String
      : null;

  static Conversacion _conversacion(Map<Object?, Object?> m) {
    final persona = objetoDelContrato(m['contraparte']);
    final ultimo = m['ultimoMensaje'];
    return Conversacion(
      id: textoObligatorio(m['conversacionId']),
      solicitudId: textoObligatorio(m['solicitudId']),
      visitaId: textoOpcional(m['visitaId']),
      rol: textoObligatorio(m['rol']),
      estado: textoObligatorio(m['estado']),
      contraparte: ContraparteConversacion(
        nombre: textoObligatorio(persona['nombre']),
        fotoUrl: textoOpcional(persona['fotoUrl']),
      ),
      servicio: textoObligatorio(m['servicio']),
      noLeidos: _entero(m['noLeidos']),
      ultimoMensaje: ultimo == null
          ? null
          : _mensaje(objetoDelContrato(ultimo)),
    );
  }

  static UltimoMensaje _mensaje(Map<Object?, Object?> m) => UltimoMensaje(
    texto: textoObligatorio(m['texto']),
    enviadoEn: fechaHoraObligatoria(m['enviadoEn']),
    autorRol: textoObligatorio(m['autorRol']),
  );

  static int _entero(Object? valor) {
    final n = valor is int ? valor : int.tryParse('$valor');
    if (n == null || n < 0) throw const DatosInvalidosFailure();
    return n;
  }
}
