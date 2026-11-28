import 'conversacion.dart';
import 'mensaje.dart';

/// Detalle de una conversación (spec 047 §4). Vive solo en memoria.
class DetalleDeConversacion {
  const DetalleDeConversacion({
    required this.id,
    required this.solicitudId,
    required this.rol,
    required this.contraparte,
    required this.servicio,
    required this.estado,
    required this.avisoSeguridad,
    this.visitaId,
    this.motivoCierre,
  });

  final String id;
  final String solicitudId;
  final String? visitaId;

  /// Rol de quien consulta: `cliente` o `tecnico`. Un mensaje es propio si su
  /// `autorRol` es igual a este (CA-03).
  final String rol;
  final ContraparteConversacion contraparte;
  final String servicio;
  final String estado;
  final String? motivoCierre;

  /// Texto del servidor; se muestra tal como llega (spec 047 §7).
  final String avisoSeguridad;

  bool get cerrada => estado == 'cerrada';
  bool get esCliente => rol == 'cliente';
}

/// Una página del historial, **del más reciente al más antiguo**, como la
/// entrega el servidor.
class PaginaDeMensajes {
  const PaginaDeMensajes({required this.items, this.siguiente});

  final List<Mensaje> items;
  final String? siguiente;
}

/// Mensaje que llega por el canal en vivo.
class MensajeEnVivo {
  const MensajeEnVivo({required this.conversacionId, required this.mensaje});

  final String conversacionId;
  final Mensaje mensaje;
}

/// Puerto para abrir y leer una conversación.
abstract interface class LecturaDeConversacion {
  /// Abre (o recupera) la conversación y devuelve su id. El cliente manda
  /// [tecnicoId]; el técnico no.
  Future<String> abrir({required String solicitudId, String? tecnicoId});

  Future<DetalleDeConversacion> detalle(String id);

  Future<PaginaDeMensajes> mensajes(String id, {String? cursor});

  Future<void> marcarLeido(String id, DateTime hasta);
}
