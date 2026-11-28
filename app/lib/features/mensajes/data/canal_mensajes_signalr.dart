import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/features/mensajes/domain/canal_mensajes.dart';
import 'package:app/features/mensajes/domain/conversacion_abierta.dart';
import 'package:app/features/mensajes/domain/mensaje.dart';
import 'package:signalr_netcore/signalr_client.dart';

/// Canal `/hubs/chat` con SignalR. Al conectarse, el servidor mete la conexión
/// en el grupo de la persona, que recibe el evento `noLeidos`.
///
/// No se configura registro: la URL del WebSocket lleva el token en la
/// consulta (el gateway lo pasa a `Authorization` y lo quita) y no debe
/// escribirse en ningún lado.
class CanalMensajesSignalR implements CanalMensajes {
  CanalMensajesSignalR({required this.url, required this.token});

  final String url;

  /// Token de acceso vigente, o `null` sin sesión.
  final String? Function() token;

  HubConnection? _conexion;
  final _enVivo = StreamController<MensajeEnVivo>.broadcast();

  @override
  Stream<MensajeEnVivo> get mensajesEnVivo => _enVivo.stream;

  @override
  Future<void> abrir({
    required void Function(int total) alCambiarContador,
    required void Function() alCaerse,
  }) async {
    await cerrar();
    final base = normalizarUrlApi(url);
    if (base == null) throw const ApiNoConfiguradaFailure();
    if (token() == null) throw const NoAutorizadoFailure();
    final conexion = HubConnectionBuilder()
        .withUrl(
          '$base/hubs/chat',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token() ?? '',
            requestTimeout: 15000,
          ),
        )
        .build();
    _conexion = conexion;
    conexion.on('noLeidos', (argumentos) {
      final total = totalDeNoLeidos(argumentos);
      if (total != null && identical(_conexion, conexion)) {
        alCambiarContador(total);
      }
    });
    conexion.on('mensajeConversacion', (argumentos) {
      final evento = mensajeDelCanal(argumentos);
      if (evento != null && identical(_conexion, conexion)) _enVivo.add(evento);
    });
    conexion.onclose(({error}) {
      if (identical(_conexion, conexion)) alCaerse();
    });
    await conexion.start();
  }

  @override
  Future<bool> unirse(String conversacionId) async {
    final conexion = _conexion;
    if (conexion == null || conexion.state != HubConnectionState.Connected) {
      return false;
    }
    try {
      final r = await conexion.invoke(
        'UnirseAConversacion',
        args: [conversacionId],
      );
      return r is Map && r['ok'] == true;
    } on Object {
      // El error puede traer la URL con el token: no se propaga ni se anota.
      return false;
    }
  }

  @override
  Future<void> salir(String conversacionId) async {
    final conexion = _conexion;
    if (conexion == null || conexion.state != HubConnectionState.Connected) {
      return;
    }
    try {
      await conexion.invoke('SalirDeConversacion', args: [conversacionId]);
    } on Object {
      // Salir es de mejor esfuerzo.
    }
  }

  @override
  Future<void> cerrar() async {
    final conexion = _conexion;
    _conexion = null;
    try {
      await conexion?.stop();
    } on Object {
      // Cerrar es de mejor esfuerzo; el error puede traer la URL con el token.
    }
  }
}

/// El evento `mensajeConversacion` `{ conversacionId, mensajeId, autorRol,
/// texto, contactoOculto, enviadoEn }`, o `null` si el cuerpo no es válido.
MensajeEnVivo? mensajeDelCanal(List<Object?>? argumentos) {
  final c = argumentos == null || argumentos.isEmpty ? null : argumentos.first;
  if (c is! Map) return null;
  final conversacionId = c['conversacionId'];
  final id = c['mensajeId'];
  final autorRol = c['autorRol'];
  final texto = c['texto'];
  final oculto = c['contactoOculto'];
  final enviadoEn = c['enviadoEn'];
  if (conversacionId is! String ||
      id is! String ||
      autorRol is! String ||
      texto is! String ||
      oculto is! bool ||
      enviadoEn is! String) {
    return null;
  }
  final fecha = DateTime.tryParse(enviadoEn);
  if (fecha == null) return null;
  return MensajeEnVivo(
    conversacionId: conversacionId,
    mensaje: Mensaje(
      id: id,
      autorRol: autorRol,
      texto: texto,
      contactoOculto: oculto,
      enviadoEn: fecha,
    ),
  );
}

/// `total` del evento `noLeidos` `{ conversacionId, noLeidos, total }`, o
/// `null` si el cuerpo no es válido: no se inventa un contador.
int? totalDeNoLeidos(List<Object?>? argumentos) {
  final cuerpo = argumentos == null || argumentos.isEmpty
      ? null
      : argumentos.first;
  final total = cuerpo is Map ? cuerpo['total'] : null;
  return total is int && total >= 0 ? total : null;
}
