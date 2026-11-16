import 'package:flutter/material.dart';

/// Datos de demostración de la maqueta (`maqueta-knock/js/knock.js`): categorías,
/// expertos, días y horarios. Son simulados: aún no hay endpoint de expertos.

class Cat {
  const Cat({
    required this.id,
    required this.name,
    required this.short,
    required this.plain,
    required this.hint,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.taller,
    required this.people,
    required this.chips,
    required this.single,
  });
  final String id, name, short, plain, hint, people, single;
  final IconData icon;
  final Color bg, fg;

  /// `true` = el cliente va al taller; `false` = el técnico va a su casa.
  final bool taller;
  final List<String> chips;
}

const cats = <String, Cat>{
  'mec': Cat(
    id: 'mec',
    name: 'Mecánica automotriz',
    short: 'Mecánica',
    plain: 'Mi auto',
    hint: 'Fallas, frenos, aceite, afinación',
    icon: Icons.directions_car_outlined,
    bg: Color(0xFFE1ECEF),
    fg: Color(0xFF1C3A4C),
    taller: true,
    people: 'talleres',
    single: 'taller',
    chips: [
      'Ruido al frenar',
      'No arranca',
      'Cambio de aceite',
      'Se calienta',
      'Luz encendida en el tablero',
    ],
  ),
  'plo': Cat(
    id: 'plo',
    name: 'Plomería',
    short: 'Plomería',
    plain: 'Agua y tuberías',
    hint: 'Fugas, boiler, tinaco, drenaje',
    icon: Icons.water_drop_outlined,
    bg: Color(0xFFDCEFFB),
    fg: Color(0xFF1D5B85),
    taller: false,
    people: 'plomeros',
    single: 'plomero',
    chips: [
      'Fuga de agua',
      'El boiler no enciende',
      'Se tapó el drenaje',
      'El tinaco se desborda',
      'Gotea una llave',
    ],
  ),
  'ele': Cat(
    id: 'ele',
    name: 'Electricidad',
    short: 'Electricidad',
    plain: 'Luz y contactos',
    hint: 'Contactos, apagadores, cortos, lámparas',
    icon: Icons.bolt,
    bg: Color(0xFFFFF1C2),
    fg: Color(0xFF8A5A00),
    taller: false,
    people: 'electricistas',
    single: 'electricista',
    chips: [
      'Un contacto no sirve',
      'Se va la luz',
      'Instalar una lámpara',
      'Huele a quemado',
      'Cambiar apagadores',
    ],
  ),
};

const kw = <String, List<String>>{
  'mec': [
    'auto', 'carro', 'coche', 'freno', 'aceite', 'motor', 'llanta', 'mecan',
    'afina', 'clutch', 'bateria', 'batería', 'arranca', 'tablero', 'suspens',
  ],
  'plo': [
    'agua', 'fuga', 'boiler', 'calentador', 'tinaco', 'drenaje', 'baño',
    'llave', 'tubo', 'plomer', 'regadera', 'fregadero', 'wc', 'escusado',
    'gotea',
  ],
  'ele': [
    'luz', 'contacto', 'apagador', 'corto', 'lampara', 'lámpara', 'electr',
    'enchufe', 'cable', 'foco', 'quemado', 'breaker', 'pastilla',
  ],
};

String? guessCat(String texto) {
  final t = texto.toLowerCase();
  for (final e in kw.entries) {
    for (final k in e.value) {
      if (t.contains(k)) return e.key;
    }
  }
  return null;
}

class Review {
  const Review(
    this.n,
    this.ini,
    this.s,
    this.w,
    this.t, {
    this.ph = false,
    this.reply,
  });
  final String n, ini, w, t;
  final int s;
  final bool ph;
  final String? reply;
}

class Prov {
  const Prov({
    required this.id,
    required this.name,
    this.owner,
    required this.ini,
    required this.color,
    required this.cat,
    required this.taller,
    required this.spec,
    required this.rate,
    required this.n,
    required this.km,
    required this.years,
    required this.jobs,
    required this.resp,
    required this.today,
    this.rec = false,
    required this.about,
    this.zone = const [],
    this.radius = '',
    required this.hours,
    required this.svcs,
    required this.photos,
    required this.dist,
    required this.crit,
    required this.revs,
    this.addr = '',
    this.addr2 = '',
    this.open = true,
    this.ver = true,
    this.imgs = const [],
    this.photoPath,
  });
  final String id, name, ini, cat, spec, resp, about, radius, addr, addr2;
  final String? owner, photoPath;
  final bool ver;

  /// Fotos reales de trabajos terminados (rutas de archivo).
  final List<String> imgs;
  final Color color;
  final bool taller, today, rec, open;
  final double rate, km;
  final int n, years, jobs;
  final List<String> zone;
  final List<List<String>> hours; // [dia, horas]
  final List<List<String>> svcs; // [nombre, detalle, precio]
  final List<(String, Color)> photos;
  final List<int> dist;
  final List<double> crit;
  final List<Review> revs;

  String get first => name.split(' ').first;
  bool get online {
    final m = int.tryParse(resp.replaceAll(RegExp(r'\D'), '')) ?? 99;
    return m <= 15 && !(taller && !open);
  }
}

final provs = <String, Prov>{
  'rm': Prov(
    id: 'rm', name: 'Ricardo Mendoza', ini: 'RM', color: Color(0xFF2A5568),
    cat: 'plo', taller: false, spec: 'Boilers, tinacos y fugas', rate: 4.9,
    n: 87, km: 2.4, years: 12, jobs: 92, resp: '~12 min', today: true,
    rec: true,
    about:
        'Plomero desde hace 12 años. Me especializo en boilers de gas, tinacos y fugas. Llego con herramienta y refacciones comunes para resolver en la primera visita.',
    zone: ['Col. La Malinche', 'Col. Centro', 'Col. Empleados Tolteca', 'Col. Cruz Azul', '+4 más'],
    radius: '8 km',
    hours: [['Lunes a viernes', '8:00 a 19:00'], ['Sábado', '9:00 a 14:00'], ['Domingo', 'Solo urgencias']],
    svcs: [
      ['Visita de revisión', 'Diagnóstico en tu casa', r'$250'],
      ['Reparación de boiler', 'Termopar, piloto, válvula', r'$400'],
      ['Reparación de fugas', 'Tubería, llaves, conexiones', r'$300'],
      ['Instalación de tinaco', 'Hasta 1,100 litros', r'$800'],
    ],
    photos: [('Boiler', Color(0xFF5B7FA6)), ('Tinaco', Color(0xFF3E6B5A)), ('Fregadero', Color(0xFF8A6A4A))],
    dist: [70, 13, 3, 1, 0], crit: [4.9, 4.9, 4.7, 5.0],
    revs: [
      Review('Carmen Vázquez', 'CV', 5, 'Llave de regadera · hace 2 semanas', 'Muy puntual y dejó todo limpio. Me explicó cómo cerrar la llave de paso.'),
      Review('Jorge Luna', 'JL', 4, 'Instalación de tinaco · hace 3 semanas', 'Buen trabajo, aunque tuvo que regresar al día siguiente por una pieza.', reply: 'Gracias, Jorge. La válvula que traía venía defectuosa; preferí cambiarla por una nueva.'),
    ],
  ),
  'mo': Prov(
    id: 'mo', name: 'Martín Ortega', ini: 'MO', color: Color(0xFF365F4A),
    cat: 'plo', taller: false, spec: 'Fugas y drenaje', rate: 4.8, n: 63,
    km: 4.1, years: 8, jobs: 58, resp: '~20 min', today: true,
    about: 'Atiendo fugas, drenajes tapados y cambio de llaves. Trabajo limpio y con garantía de 30 días en mano de obra.',
    zone: ['Col. Centro', 'Col. Morelos', 'Col. Empleados Tolteca'], radius: '6 km',
    hours: [['Lunes a sábado', '8:00 a 18:00'], ['Domingo', 'Cerrado']],
    svcs: [
      ['Visita de revisión', 'Diagnóstico en tu casa', r'$200'],
      ['Destape de drenaje', 'Con equipo de presión', r'$450'],
      ['Cambio de llave', 'Lavabo, cocina o regadera', r'$250'],
    ],
    photos: [('Drenaje', Color(0xFF4F6F95)), ('Lavabo', Color(0xFF6F8DB0))],
    dist: [48, 11, 3, 1, 0], crit: [4.8, 4.8, 4.7, 4.9],
    revs: [Review('Rosa Pérez', 'RP', 5, 'Destape de drenaje · hace 1 mes', 'Llegó rápido y resolvió en una hora. Cobró lo acordado.')],
  ),
  'hs': Prov(
    id: 'hs', name: 'Héctor Sánchez', ini: 'HS', color: Color(0xFF7A5230),
    cat: 'plo', taller: false, spec: 'Boilers y calentadores', rate: 4.6, n: 41,
    km: 3.0, years: 20, jobs: 40, resp: '~35 min', today: false,
    about: '20 años arreglando boilers y calentadores de paso y de depósito. Doy precio fijo antes de empezar.',
    zone: ['Col. La Malinche', 'Col. Cruz Azul'], radius: '5 km',
    hours: [['Lunes a viernes', '9:00 a 18:00'], ['Sábado', '9:00 a 13:00']],
    svcs: [
      ['Revisión de boiler', 'Incluye limpieza de quemador', r'$400'],
      ['Cambio de termopar', 'Refacción incluida', r'$550'],
    ],
    photos: [('Calentador', Color(0xFF8A6A4A))],
    dist: [28, 8, 3, 1, 1], crit: [4.6, 4.7, 4.8, 4.4],
    revs: [Review('Luis Ramos', 'LR', 5, 'Revisión de boiler · hace 2 meses', 'Precio justo y explicó todo antes de empezar.')],
  ),
  'tr': Prov(
    id: 'tr', name: 'Taller Automotriz Ramírez', owner: 'Jorge Ramírez', ini: 'TR',
    color: Color(0xFF1C3A4C), cat: 'mec', taller: true,
    spec: 'Diagnóstico por computadora', rate: 4.8, n: 126, km: 1.2, years: 15,
    jobs: 310, resp: '~10 min', today: true, rec: true,
    about: 'Taller familiar con escáner para diagnóstico por computadora. Trabajamos autos nacionales e importados. Te explicamos qué tiene tu auto antes de tocar cualquier pieza.',
    addr: 'Av. Juárez 214, Col. Centro',
    addr2: 'Tula de Allende, Hgo. · Entre calle Hidalgo y Morelos',
    hours: [['Lunes a viernes', '9:00 a 19:00'], ['Sábado', '9:00 a 14:00'], ['Domingo', 'Cerrado']],
    svcs: [
      ['Diagnóstico por computadora', 'Lectura de fallas con escáner · 40 min', r'$200'],
      ['Cambio de aceite y filtro', 'Aceite sintético o mineral · 30 min', r'$650'],
      ['Afinación mayor', 'Bujías, filtros y limpieza de inyectores', r'$1,200'],
      ['Frenos', 'Cambio de balatas y rectificado de discos', r'$900'],
      ['Suspensión', 'Amortiguadores, rótulas y bujes', r'$1,500'],
      ['Sistema de enfriamiento', 'Radiador, termostato y mangueras', r'$700'],
    ],
    photos: [('Afinación', Color(0xFF4F6F95)), ('Frenos', Color(0xFF7C3A5B)), ('Suspensión', Color(0xFF3E6B5A))],
    dist: [98, 20, 5, 2, 1], crit: [4.9, 4.8, 4.6, 4.9],
    revs: [
      Review('Alejandra Torres', 'AT', 5, 'Afinación mayor · hace 1 semana', 'Me explicaron todo con fotos antes de cambiar piezas. Me entregaron el auto el mismo día y al precio que acordamos.', ph: true, reply: 'Gracias, Alejandra. Nos da gusto que su auto quedara bien. Aquí la esperamos para el siguiente servicio.'),
      Review('Miguel Ángel Reyes', 'MR', 4, 'Frenos · hace 3 semanas', 'Buen diagnóstico. Tardaron un día más de lo que dijeron, pero me avisaron por mensaje y no me cobraron de más.', reply: 'Tiene razón, Miguel. La refacción llegó tarde del proveedor. Gracias por su paciencia.'),
      Review('Sofía Castillo', 'SC', 5, 'Cambio de aceite · hace 1 mes', 'Rápidos y muy amables. Me recordaron revisar las llantas sin intentar venderme nada más.'),
    ],
  ),
  'mx': Prov(
    id: 'mx', name: 'Mecánica Express Olvera', owner: 'Raúl Olvera', ini: 'MX',
    color: Color(0xFF4B5563), cat: 'mec', taller: true,
    spec: 'Afinación y frenos', rate: 4.5, n: 38, km: 3.6, years: 9, jobs: 96,
    resp: '~30 min', today: false,
    about: 'Servicio rápido de afinación, frenos y cambio de aceite. Citas en el mismo día cuando hay espacio.',
    addr: 'Blvd. Colosio 88, Col. Centro', addr2: 'Tula de Allende, Hgo.', open: false,
    hours: [['Lunes a sábado', '8:30 a 18:00'], ['Domingo', 'Cerrado']],
    svcs: [
      ['Cambio de aceite', 'Incluye filtro', r'$600'],
      ['Afinación menor', 'Bujías y filtros', r'$850'],
    ],
    photos: [('Taller', Color(0xFF6B7280))],
    dist: [24, 9, 3, 1, 1], crit: [4.6, 4.5, 4.6, 4.4],
    revs: [Review('Daniela Cruz', 'DC', 4, 'Cambio de aceite · hace 1 mes', 'Rápido, aunque tuve que esperar un poco sin cita.')],
  ),
  'lg': Prov(
    id: 'lg', name: 'Laura Gutiérrez', ini: 'LG', color: Color(0xFF7C3A5B),
    cat: 'ele', taller: false, spec: 'Contactos, apagadores e iluminación',
    rate: 4.7, n: 54, km: 3.1, years: 7, jobs: 61, resp: '~15 min', today: true,
    rec: true,
    about: 'Electricista certificada. Reviso la instalación antes de cambiar cualquier cosa y te explico qué encontré.',
    zone: ['Col. La Malinche', 'Col. Centro', 'Col. Cruz Azul'], radius: '7 km',
    hours: [['Lunes a viernes', '9:00 a 18:00'], ['Sábado', '9:00 a 14:00']],
    svcs: [
      ['Visita de revisión', 'Detección de fallas', r'$250'],
      ['Cambio de contacto o apagador', 'Pieza aparte', r'$180'],
      ['Instalación de lámpara', 'Hasta 3 m de altura', r'$350'],
    ],
    photos: [('Tablero', Color(0xFF8A5A00)), ('Lámpara', Color(0xFFB45309))],
    dist: [40, 10, 3, 1, 0], crit: [4.8, 4.7, 4.6, 4.8],
    revs: [Review('Mariana López', 'ML', 5, 'Cambio de apagadores · hace 4 meses', 'Muy profesional, dejó todo funcionando y limpio.')],
  ),
  'fr': Prov(
    id: 'fr', name: 'Fernando Ruiz', ini: 'FR', color: Color(0xFFB45309),
    cat: 'ele', taller: false, spec: 'Instalaciones eléctricas', rate: 4.6,
    n: 29, km: 2.8, years: 10, jobs: 33, resp: '~25 min', today: false,
    about: 'Instalaciones eléctricas residenciales, lámparas y ventiladores de techo.',
    zone: ['Col. La Malinche', 'Col. Morelos'], radius: '5 km',
    hours: [['Lunes a sábado', '9:00 a 18:00']],
    svcs: [
      ['Instalación de lámpara', 'Incluye revisión de cableado', r'$300'],
      ['Ventilador de techo', 'Instalación completa', r'$450'],
    ],
    photos: [('Lámpara', Color(0xFFB45309))],
    dist: [20, 6, 2, 1, 0], crit: [4.7, 4.6, 4.6, 4.7],
    revs: [Review('Pedro Gómez', 'PG', 5, 'Ventilador de techo · hace 2 meses', 'Trabajo limpio y seguro.')],
  ),
};

/// Posiciones de los pines en el mapa dibujado (mundo 1200x1600), en el
/// mismo orden relativo que `MAPPOS` de la maqueta.
const mapPos = <String, (double, double)>{
  'tr': (500, 640), 'mx': (700, 600), 'rm': (420, 700), 'mo': (680, 690),
  'hs': (590, 760), 'lg': (380, 620), 'fr': (730, 780),
};

const colores = ['Col. La Malinche', 'Col. Centro', 'Col. Empleados Tolteca', 'Col. Cruz Azul'];

const cpCol = {
  '42800': 'Col. Centro',
  '42833': 'Col. Empleados Tolteca',
  '42809': 'Col. La Malinche',
  '42846': 'Col. Cruz Azul',
};

const slots = [
  ('Mañana', '8 a 12 h', 'en la mañana'),
  ('Tarde', '12 a 16 h', 'en la tarde'),
  ('Noche', '16 a 20 h', 'en la noche'),
];
const rsTimes = ['8:00', '10:00', '12:00', '14:00', '16:00', '18:00'];

const _short = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
const diasLargos = ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'];
const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

/// Los próximos 6 días: (etiqueta corta, día del mes, nombre largo).
List<(String, int, String)> get days {
  final out = <(String, int, String)>[];
  for (var i = 0; i < 6; i++) {
    final d = DateTime.now().add(Duration(days: i));
    out.add((i == 0 ? 'Hoy' : _short[d.weekday % 7], d.day, diasLargos[d.weekday % 7]));
  }
  return out;
}

String longDate(DateTime d) =>
    '${diasLargos[d.weekday % 7]} ${d.day} de ${meses[d.month - 1]}';

String money(num n) {
  final s = n.round().toString();
  final b = StringBuffer(r'$');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

String nowH() {
  final d = DateTime.now();
  return '${d.hour}:${d.minute.toString().padLeft(2, '0')}';
}

String initials(String n) {
  final w = n.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (w.isEmpty) return '?';
  return (w.first[0] + (w.length > 1 ? w.last[0] : '')).toUpperCase();
}

/// Servicios populares de Explorar: (cat, nombre, detalle, precio, texto).
const exServices = [
  ('mec', 'Cambio de aceite', 'Aceite y filtro', 450, 'Cambio de aceite y filtro'),
  ('plo', 'Boiler que no enciende', 'Revisión y reparación', 450, 'El boiler no enciende'),
  ('ele', 'Contacto sin corriente', 'Revisión del cableado', 250, 'Un contacto no sirve'),
  ('mec', 'Ruido al frenar', 'Revisión de frenos', 600, 'Ruido al frenar'),
  ('plo', 'Fuga de agua', 'Ubicamos y reparamos', 350, 'Fuga de agua'),
  ('ele', 'Instalar una lámpara', 'Instalación y prueba', 300, 'Instalar una lámpara'),
  ('plo', 'Destapar el drenaje', 'Con equipo profesional', 400, 'Se tapó el drenaje'),
  ('mec', 'No arranca', 'Batería, marcha y bornes', 400, 'No arranca'),
];

const exTips = [
  ('plo', Icons.water_drop_outlined, 'Antes de que haga frío, revisa tu boiler', 'Si tarda en prender o hace ruido, conviene una revisión antes de que lo necesites todos los días.', 'Revisión del boiler antes del frío'),
  ('ele', Icons.bolt, 'Contactos calientes o con chispas', 'No esperes a que falle: un electricista revisa el cableado y la protección en una visita.', 'Revisión de contactos y cableado'),
  ('mec', Icons.directions_car_outlined, 'Tu auto pide cambio de aceite cada ~5,000 km', 'Un cambio a tiempo cuida el motor y te ahorra reparaciones grandes.', 'Cambio de aceite y filtro'),
];

const contactColors = [Color(0xFFB45309), Color(0xFF365F4A), Color(0xFF7C3A5B), Color(0xFF2A5568), Color(0xFF8A6A4A)];

const faq = <(String, IconData, List<(String, String)>)>[
  ('Cotizaciones', Icons.description_outlined, [
    ('¿Knock cobra por usar la app?', 'No. Pedir cotizaciones y hablar con expertos es gratis. El pago del trabajo lo acuerdas directo con el proveedor.'),
    ('¿Qué hago si el precio cambió?', 'Una cotización puede cambiar si el trabajo no coincide con lo que describiste. Si te cobran distinto sin explicarte, repórtalo desde la visita.'),
    ('¿Cuántas cotizaciones recibo?', 'Normalmente entre 2 y 5. Puedes aceptar una en cuanto te convenza.'),
  ]),
  ('Seguridad', Icons.shield_outlined, [
    ('¿Cómo sé que es la persona que contraté?', 'Compara su cara con la foto verificada y pídele tu código de servicio de 4 números. Si no lo tiene, no abras.'),
    ('¿Por qué no hay que pagar por adelantado?', 'Porque el trabajo aún no se hace. Paga cuando el experto termine y estés conforme, como lo hayan acordado.'),
    ('¿Qué pasa cuando reporto a alguien?', 'Suspendemos su cuenta mientras revisamos tu caso y te respondemos en menos de 24 horas.'),
  ]),
  ('Verificación', Icons.badge_outlined, [
    ('¿Qué revisa Knock de cada experto?', 'Su identidad: INE por ambos lados, selfie con prueba de vida y número de teléfono.'),
    ('¿Por qué rechazaron mi verificación?', 'Casi siempre es por fotos borrosas o con reflejos. Verás el motivo y podrás intentarlo de nuevo.'),
  ]),
  ('Cuenta', Icons.person_outline, [
    ('¿Cómo cambio mi número?', 'En Mi cuenta › Mis datos. Te enviaremos un código por SMS al número nuevo.'),
    ('¿Cómo borro mi cuenta?', 'En Configuración › Eliminar mi cuenta. Son dos pasos y te decimos qué se borra antes de confirmar.'),
  ]),
];
