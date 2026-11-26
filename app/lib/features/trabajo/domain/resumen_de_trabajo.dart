import 'package:app/features/actividad/actividad.dart' show Franja, TipoPrecio;
import 'package:app/features/oficios/oficios.dart' show Modalidad;

enum EstadoVisitaProxima { confirmada, enCurso }

enum EstadoCotizacionEnviada { enviada, aceptada, rechazada, retirada }

final class NivelDeTrabajo {
  const NivelDeTrabajo({required this.clave, required this.nombre});
  final String clave;
  final String nombre;
}

final class OficioDeSolicitud {
  const OficioDeSolicitud({required this.clave, required this.nombre});
  final String clave;
  final String nombre;
}

final class ColoniaDeSolicitud {
  const ColoniaDeSolicitud({required this.nombre, required this.cp});
  final String nombre;
  final String cp;
}

final class VisitaProxima {
  const VisitaProxima({
    required this.visitaId,
    required this.solicitudId,
    required this.dia,
    required this.hora,
    required this.modalidad,
    required this.coloniaCliente,
    required this.direccion,
    required this.precio,
    required this.tope,
    required this.estado,
    required this.puedeLlegar,
  });
  final String visitaId;
  final String solicitudId;
  final DateTime dia;
  final String hora;
  final Modalidad modalidad;
  final String coloniaCliente;
  final String? direccion;
  final double? precio;
  final double tope;
  final EstadoVisitaProxima estado;
  final bool puedeLlegar;
}

final class SolicitudNueva {
  SolicitudNueva({
    required this.solicitudId,
    required this.oficio,
    required this.colonia,
    required this.descripcion,
    required List<String> fotos,
    required this.dia,
    required this.franja,
    required this.modalidad,
    required this.venceEn,
    required this.oleada,
    required this.recibidaEn,
    required this.yaCotizo,
  }) : fotos = List.unmodifiable(fotos);
  final String solicitudId;
  final OficioDeSolicitud oficio;
  final ColoniaDeSolicitud colonia;
  final String descripcion;
  final List<String> fotos;
  final DateTime dia;
  final Franja franja;
  final Modalidad modalidad;
  final DateTime venceEn;
  final int oleada;
  final DateTime recibidaEn;
  final bool yaCotizo;
}

final class CotizacionEnviada {
  const CotizacionEnviada({
    required this.cotizacionId,
    required this.solicitudId,
    required this.oficio,
    required this.tipoPrecio,
    required this.precio,
    this.precioMin,
    this.precioMax,
    required this.tope,
    required this.estado,
    this.motivoRechazo,
    required this.enviadaEn,
  });
  final String cotizacionId;
  final String solicitudId;
  final String oficio;
  final TipoPrecio tipoPrecio;
  final double? precio;
  final double? precioMin;
  final double? precioMax;
  final double tope;
  final EstadoCotizacionEnviada estado;
  final String? motivoRechazo;
  final DateTime enviadaEn;
}

final class TrabajoTerminado {
  const TrabajoTerminado({
    required this.solicitudId,
    required this.oficio,
    required this.terminadaEn,
    required this.precio,
    this.calificacion,
  });
  final String solicitudId;
  final String oficio;
  final DateTime terminadaEn;
  final double? precio;
  final double? calificacion;
}

final class ResumenDeTrabajo {
  ResumenDeTrabajo({
    required this.disponibleHoy,
    required this.estadoVerificacion,
    required this.nivel,
    required List<VisitaProxima> proximasVisitas,
    required List<SolicitudNueva> solicitudesNuevas,
    required List<CotizacionEnviada> cotizacionesEnviadas,
    required List<TrabajoTerminado> terminadas,
    required this.trabajosTerminados,
    required this.calificacion,
  }) : proximasVisitas = List.unmodifiable(proximasVisitas),
       solicitudesNuevas = List.unmodifiable(solicitudesNuevas),
       cotizacionesEnviadas = List.unmodifiable(cotizacionesEnviadas),
       terminadas = List.unmodifiable(terminadas);
  final bool disponibleHoy;
  final String estadoVerificacion;
  final NivelDeTrabajo nivel;
  final List<VisitaProxima> proximasVisitas;
  final List<SolicitudNueva> solicitudesNuevas;
  final List<CotizacionEnviada> cotizacionesEnviadas;
  final List<TrabajoTerminado> terminadas;
  final int trabajosTerminados;
  final double? calificacion;
}
