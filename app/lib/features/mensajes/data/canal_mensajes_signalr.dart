import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/features/mensajes/domain/canal_mensajes.dart';
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
    conexion.onclose(({error}) {
      if (identical(_conexion, conexion)) alCaerse();
    });
    await conexion.start();
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

/// `total` del evento `noLeidos` `{ conversacionId, noLeidos, total }`, o
/// `null` si el cuerpo no es válido: no se inventa un contador.
int? totalDeNoLeidos(List<Object?>? argumentos) {
  final cuerpo = argumentos == null || argumentos.isEmpty
      ? null
      : argumentos.first;
  final total = cuerpo is Map ? cuerpo['total'] : null;
  return total is int && total >= 0 ? total : null;
}
