import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/direcciones/direcciones.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;

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
  job.porCalificar =
      s.estado == act.EstadoSolicitud.terminada && s.visitaId != null;
  if (job.status == 'cancelado') {
    job.cancelNote = s.estado == act.EstadoSolicitud.vencida
        ? 'Esta solicitud venció sin que eligieras una cotización.'
        : 'Esta solicitud se canceló.';
  }
  return job;
}

/// «jue 12, 10:30».
String cuandoDeCotizacion(DateTime dia, String hora) =>
    '${diasLargos[dia.weekday % 7].substring(0, 3)} ${dia.day}, $hora';

/// Experto sintético del técnico de una cotización real: solo lo que manda el
/// servidor (nombre, calificación, verificado); lo demás queda en valores
/// neutros y no se inventan reseñas. El perfil completo sigue simulado.
Prov provDeTecnico(act.TecnicoResumen t, String cat) => Prov(
  id: 'api:${t.id}',
  name: t.nombre,
  ini: initials(t.nombre),
  color: const Color(0xFF2A5568),
  cat: cat,
  taller: cats[cat]!.taller,
  spec: '',
  rate: t.calificacion ?? 0,
  n: 0,
  km: 0,
  years: 0,
  jobs: 0,
  resp: '',
  today: false,
  about: '',
  hours: const [],
  svcs: const [],
  photos: const [],
  dist: const [],
  crit: const [],
  revs: const [],
  ver: t.verificado,
);

/// La cotización real como [Quote] de la maqueta. El experto sintético se
/// agrega a [provs] (idempotente) para que las tarjetas lo dibujen.
Quote quoteDeCotizacion(act.Cotizacion c, String cat) {
  final prov = provDeTecnico(c.tecnico, cat);
  provs[prov.id] = prov;
  final rango = c.tipoPrecio == act.TipoPrecio.rango;
  return Quote(
    pid: prov.id,
    kind: c.tipoPrecio.valor,
    lo: (rango ? c.precioMin : c.precio) ?? 0,
    hi: rango ? (c.precioMax ?? 0) : 0,
    when: cuandoDeCotizacion(c.dia, c.hora),
    soon: 0,
    note: c.nota ?? '',
    cotId: c.id,
    cubre: c.cubre,
    tope: c.tope,
    etiquetas: {for (final e in c.etiquetas) e.valor},
  );
}

/// Texto de un error del servidor, sin códigos HTTP ni URL (CA-12).
String textoDeErrorReal(Object error) => switch (error) {
  NoAutorizadoFailure() => 'Tu sesión venció. Entra de nuevo.',
  NoEncontradoFailure() => 'Esta solicitud ya no está disponible.',
  ServicioNoDisponibleFailure() =>
    'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.',
  DatosInvalidosFailure() => 'Recibimos datos que no entendimos.',
  DatosRechazadosFailure() => 'Revisa los datos e inténtalo de nuevo.',
  ConflictoFailure() =>
    'Esta acción choca con el estado actual de tu solicitud. Revisa la lista.',
  EleccionRechazadaFailure(:final motivo) => switch (motivo) {
    MotivoEleccionRechazada.yaElegida =>
      'Ya elegiste una cotización para esta solicitud.',
    MotivoEleccionRechazada.cotizacionNoDisponible =>
      'Esta cotización ya no está disponible. Elige otra.',
    MotivoEleccionRechazada.vencida =>
      'Esta solicitud venció. Puedes pedir una nueva.',
    MotivoEleccionRechazada.cancelada => 'Esta solicitud se canceló.',
    MotivoEleccionRechazada.sinCotizaciones =>
      'Todavía no hay cotizaciones. Te avisaremos cuando llegue la primera.',
  },
  _ => 'Algo salió mal. Inténtalo de nuevo.',
};

/// Experto sintético del técnico de una visita real: lo que manda el servidor
/// (nombre, verificado) y, en una cita en taller, su dirección.
Prov provDeVisita(act.Visita v, String cat) => Prov(
  id: 'api:visita:${v.id}',
  name: v.tecnico.nombre,
  ini: initials(v.tecnico.nombre),
  color: const Color(0xFF2A5568),
  cat: cat,
  taller: v.esTaller,
  spec: '',
  rate: 0,
  n: 0,
  km: 0,
  years: 0,
  jobs: 0,
  resp: '',
  today: false,
  about: '',
  hours: const [],
  svcs: const [],
  photos: const [],
  dist: const [],
  crit: const [],
  revs: const [],
  addr: v.esTaller ? v.direccion : '',
  ver: v.tecnico.verificado,
);

/// Pasa la visita real a la [Job] de la maqueta (idempotente). El código solo
/// vive en memoria mientras la pantalla está abierta: no se guarda.
void aplicarVisitaAlJob(Job j, act.Visita v) {
  final prov = provDeVisita(v, j.cat);
  provs[prov.id] = prov;
  j
    ..pid = prov.id
    ..when = longDate(v.dia)
    ..time = v.hora
    ..code = v.codigo ?? ''
    ..motivoCodigo = v.motivoCodigo?.valor
    ..direccion = v.direccion
    ..price = v.precio == null ? '' : money(v.precio!);
}

/// El `coloniaId` de la colonia de la persona. La maqueta solo guarda su
/// nombre y su código postal; el identificador sale del catálogo del servidor
/// (`GET /zonas/cp/{cp}`, spec 017) buscando la colonia por nombre. Falla con
/// [OpcionNoDisponibleFailure] si no la encuentra (la persona debe elegir su
/// zona de nuevo). Con [colonia] busca esa otra, del mismo código postal.
Future<String> coloniaIdDeLaPersona(
  WidgetRef ref,
  UserData user, {
  String? colonia,
}) async {
  final cp = user.cp.trim();
  if (cp.length != 5) throw const OpcionNoDisponibleFailure();
  final zona = await ref.read(zonasRepositoryProvider).porCodigoPostal(cp);
  final nombre = (colonia ?? user.col).trim().toLowerCase();
  for (final c in zona.colonias) {
    if (c.nombre.trim().toLowerCase() == nombre) return c.id;
  }
  throw const OpcionNoDisponibleFailure();
}

/// Sube las fotos (de 1 a 5, backend 062), crea la solicitud en el servidor
/// (`POST /solicitudes`, spec 015 y backend 020) y la devuelve como [Job] real.
///
/// [subidas] recuerda el `archivoId` de cada foto ya subida: si algo falla
/// después, el reintento no la sube otra vez. Si el servidor rechaza una foto
/// al crear, se olvidan todas. Falla con un `Failure`; nunca reintenta (una
/// escritura no se repite sola).
Future<Job> crearSolicitudReal(
  WidgetRef ref,
  Solicitud req,
  Map<String, String> subidas,
) async {
  final cat = cats[req.cat]!;
  final user = maq.user;
  final hoy = DateTime.now().add(Duration(days: req.day));
  // A domicilio se usa la dirección elegida entre las guardadas (spec 030).
  final guardada = cat.taller ? null : ref.read(direccionParaPedirProvider);
  if (!cat.taller && guardada == null) throw const DatosRechazadosFailure();
  final coloniaId = await coloniaIdDeLaPersona(
    ref,
    user,
    colonia: guardada?.colonia,
  );
  if (req.photos.isEmpty || req.photos.length > 5) {
    throw const FotoNoValidaFailure();
  }
  final repositorio = ref.read(act.solicitudesRealesRepositoryProvider);
  final archivoIds = <String>[];
  for (final ruta in [...req.photos]) {
    archivoIds.add(subidas[ruta] ??= await repositorio.subirFoto(ruta));
  }
  final nueva = act.NuevaSolicitud(
    oficioClave: req.cat!,
    descripcion: req.desc.trim(),
    archivoIds: archivoIds,
    dia: DateTime(hoy.year, hoy.month, hoy.day),
    franja: switch (req.slot) {
      0 => act.Franja.manana,
      1 => act.Franja.tarde,
      _ => act.Franja.noche,
    },
    coloniaId: coloniaId,
    direccion: guardada?.calleNumero,
  );
  final act.Solicitud creada;
  try {
    creada = await repositorio.crear(nueva);
  } on FotoNoValidaFailure {
    subidas.clear();
    rethrow;
  }
  final job = jobDeSolicitud(creada, catalogo: const {});
  if (job == null) throw const DatosInvalidosFailure();
  job.sent = 'Hoy, ahora';
  return job;
}
