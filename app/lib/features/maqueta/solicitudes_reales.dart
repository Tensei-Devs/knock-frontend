import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';

/// Pasa las solicitudes reales (`GET /solicitudes`, spec 015 y backend 020) al
/// modelo de la maqueta (spec 045, enmienda 1): una [Job] marcada como real.

/// La clave de oficio (`mec`, `plo`, `ele`) que la maqueta sabe dibujar para
/// el [nombre] que trae la lista, o `null` si no la reconoce.
///
/// La lista de solicitudes no trae la clave (solo el detalle); se busca en el
/// catálogo de oficios que ya cargó la app y, si no está, en los nombres de
/// los oficios de la maqueta.
String? claveDeOficio(String nombre, Map<String, String> catalogo) {
  final n = nombre.trim().toLowerCase();
  final clave = catalogo[n];
  if (clave != null && cats.containsKey(clave)) return clave;
  for (final c in cats.values) {
    if (c.name.toLowerCase() == n || c.short.toLowerCase() == n) return c.id;
  }
  return null;
}

/// Estado de la maqueta para el estado de la solicitud del servidor.
///
/// Un estado que la app no conoce se muestra como «en proceso»: esperando
/// cotizaciones, o con ellas si ya hay.
String estadoDeJob(act.Solicitud s, {required bool taller}) =>
    switch (s.estado) {
      act.EstadoSolicitud.enviada => 'enviada',
      act.EstadoSolicitud.cotizando => 'cotizando',
      act.EstadoSolicitud.citaConfirmada => taller ? 'cita' : 'visita',
      act.EstadoSolicitud.terminada ||
      act.EstadoSolicitud.calificada => 'terminado',
      act.EstadoSolicitud.cancelada ||
      act.EstadoSolicitud.vencida => 'cancelado',
      act.EstadoSolicitud.desconocido =>
        s.totalCotizaciones > 0 ? 'cotizando' : 'enviada',
    };

/// «sábado 26 de septiembre, en la mañana».
String preferenciaDeSolicitud(act.Solicitud s) {
  final franja = switch (s.franja) {
    act.Franja.manana => slots[0].$3,
    act.Franja.tarde => slots[1].$3,
    act.Franja.noche => slots[2].$3,
  };
  return '${longDate(s.dia)}, $franja';
}

/// La solicitud como [Job] real, o `null` si su oficio no se puede dibujar.
Job? jobDeSolicitud(act.Solicitud s, {required Map<String, String> catalogo}) {
  final cat = s.oficioClave != null && cats.containsKey(s.oficioClave)
      ? s.oficioClave!
      : claveDeOficio(s.oficioNombre, catalogo);
  if (cat == null) return null;
  final descripcion = s.descripcion.trim();
  final job = Job(
    id: s.id,
    title: s.oficioNombre,
    cat: cat,
    status: estadoDeJob(s, taller: cats[cat]!.taller),
    desc: descripcion,
    pref: preferenciaDeSolicitud(s),
    photos: s.totalFotos,
    real: true,
    quoteCount: s.totalCotizaciones,
    colonia: s.coloniaNombre ?? '',
    visitaId: s.visitaId,
  );
  if (job.status == 'cancelado') {
    job.cancelNote = s.estado == act.EstadoSolicitud.vencida
        ? 'Esta solicitud venció sin que eligieras una cotización.'
        : 'Esta solicitud se canceló.';
  }
  return job;
}

/// Texto de un error del servidor, sin códigos HTTP ni URL (CA-12).
String textoDeErrorReal(Object error) => switch (error) {
  NoAutorizadoFailure() => 'Tu sesión venció. Entra de nuevo.',
  NoEncontradoFailure() => 'Esta solicitud ya no está disponible.',
  ServicioNoDisponibleFailure() =>
    'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.',
  DatosInvalidosFailure() => 'Recibimos datos que no entendimos.',
  _ => 'Algo salió mal. Inténtalo de nuevo.',
};
