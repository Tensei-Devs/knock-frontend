/// Resumen de una conversación; los mensajes se conservan solo en memoria.
class Conversacion {
  const Conversacion({
    required this.id,
    required this.solicitudId,
    required this.rol,
    required this.estado,
    required this.contraparte,
    required this.servicio,
    required this.noLeidos,
    this.visitaId,
    this.ultimoMensaje,
  });

  final String id;
  final String solicitudId;
  final String? visitaId;
  final String rol;
  final String estado;
  final ContraparteConversacion contraparte;
  final String servicio;
  final UltimoMensaje? ultimoMensaje;
  final int noLeidos;
}

class ContraparteConversacion {
  const ContraparteConversacion({required this.nombre, this.fotoUrl});

  final String nombre;
  final String? fotoUrl;
}

class UltimoMensaje {
  const UltimoMensaje({
    required this.texto,
    required this.enviadoEn,
    required this.autorRol,
  });

  final String texto;
  final DateTime enviadoEn;
  final String autorRol;
}

class ContadorDeNoLeidos {
  const ContadorDeNoLeidos({required this.total});

  final int total;
}

class ResumenConversaciones {
  const ResumenConversaciones({
    required this.conversaciones,
    required this.totalNoLeidos,
  });

  final List<Conversacion> conversaciones;
  final int totalNoLeidos;
}
