import 'dart:async';
import 'dart:math' as math;

import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart' show digits;
import 'package:flutter/material.dart';

/// Lado del técnico de la maqueta (`js/tecnico.js`): estado simulado y sus
/// comportamientos con los mismos tiempos.

class Cliente {
  const Cliente(this.n, this.ini, this.c, this.addr, this.col);
  final String n, ini, addr, col;
  final Color c;
}

Cliente cliente(String id) {
  if (id == 'yo') {
    final u = maq.user;
    return Cliente(
      u.name.isEmpty ? 'Cliente' : u.name,
      initials(u.name.isEmpty ? 'C' : u.name),
      const Color(0xFF2A5568),
      u.addr.isEmpty ? 'Dirección del cliente' : u.addr,
      u.col,
    );
  }
  return clientes[id]!;
}

const clientes = <String, Cliente>{
  'ml': Cliente(
    'Mariana L.',
    'ML',
    Color(0xFF7C3A5B),
    'Calle Jacarandas 45',
    'Col. La Malinche',
  ),
  'ap': Cliente(
    'Ana P.',
    'AP',
    Color(0xFFB45309),
    'Av. Tolteca 120',
    'Col. Empleados Tolteca',
  ),
  'jr': Cliente(
    'Jorge R.',
    'JR',
    Color(0xFF365F4A),
    'Calle Hidalgo 8',
    'Col. Centro',
  ),
  'lc': Cliente(
    'Luis C.',
    'LC',
    Color(0xFF4F6F95),
    'Calle Olmos 33',
    'Col. Cruz Azul',
  ),
  'rg': Cliente(
    'Roberto G.',
    'RG',
    Color(0xFF2A5568),
    'Calle Reforma 17',
    'Col. Centro',
  ),
  'cv': Cliente(
    'Carmen V.',
    'CV',
    Color(0xFF8A6A4A),
    'Calle Jacarandas 51',
    'Col. La Malinche',
  ),
};

class Cot {
  Cot({
    this.m = 'rango',
    this.lo = '',
    this.hi = '',
    this.fx = '',
    this.t = 0,
    this.d = 1,
    this.nt = '',
  });
  String m, lo, hi, fx, nt; // m: rango | fijo | visita
  int t, d;
  Cot copy() => Cot(m: m, lo: lo, hi: hi, fx: fx, t: t, d: d, nt: nt);
  String get txt => m == 'rango'
      ? '\$$lo – \$$hi'
      : m == 'visita'
      ? '\$$fx (visita)'
      : '\$$fx';
}

class Borrador extends Cot {
  Borrador({
    super.m,
    super.lo,
    super.hi,
    super.fx,
    super.t,
    super.d,
    super.nt,
    required this.basis,
    required this.msgs,
    required this.ai,
  });
  List<String> basis;
  int msgs;
  Cot ai;
  bool get edited =>
      ai.m != m ||
      ai.lo != lo ||
      ai.hi != hi ||
      ai.fx != fx ||
      ai.t != t ||
      ai.d != d ||
      ai.nt != nt;
}

class Bitacora {
  Bitacora(this.datos, this.falta, this.tools, this.msgs);
  List<String> datos, falta;
  String tools;
  int msgs;
  bool saved = false;
}

class Req {
  Req({
    required this.id,
    required this.k,
    required this.hace,
    required this.cat,
    required this.titulo,
    required this.desc,
    required this.zona,
    required this.cuando,
    required this.cid,
    this.mine = false,
  });
  final String id, cat, titulo, desc, zona, cuando, cid;
  String k, hace; // nuevas | proceso | aceptada | fin
  String nota = '';
  bool mine;
  Cot? quote;
  Bitacora? bit;
  bool bitOpen = false;
}

class Visita {
  Visita({
    required this.id,
    required this.rid,
    required this.cid,
    required this.titulo,
    required this.d,
    required this.time,
    required this.code,
    required this.price,
  });
  final String id, rid, cid, titulo, code;
  int d;
  String time, price;
  bool done = false;
  String closed = '';
  String fin = '';
  Resched? resched;
}

class Opinion {
  Opinion(this.id, this.n, this.s, this.w, this.t);
  final String id, n, w, t;
  final int s;
}

class Trabajo {
  Trabajo(this.img, this.title, this.cat);
  final String img, title, cat;
}

class AvisoT {
  AvisoT(this.icon, this.title, this.text, this.go) : h = nowH();
  final String icon, title, text, go, h;
  bool read = false;
}

class Yo {
  bool registered = false;
  String name = '',
      business = '',
      phone = '',
      other = '',
      how = 'dom',
      km = '8 km',
      address = '',
      about = '',
      years = '';
  Set<String> cats = {};
  bool otherOn = false;
  String? photo;
  List<List<String>> svcs = [];
}

const levels = [
  (0, 'Nuevo'),
  (1, 'Confiable'),
  (5, 'Experto Knock'),
  (15, 'Maestro Knock'),
];
const priceVisitaMax = 250;

({int i, String name, String next, int left, int pct}) repLevel(int done) {
  var i = 0;
  for (var k = 0; k < levels.length; k++) {
    if (done >= levels[k].$1) i = k;
  }
  final nx = i + 1 < levels.length ? levels[i + 1] : null;
  return (
    i: i,
    name: levels[i].$2,
    next: nx?.$2 ?? '',
    left: nx != null ? nx.$1 - done : 0,
    pct: nx != null
        ? ((done - levels[i].$1) * 100 / (nx.$1 - levels[i].$1)).round()
        : 100,
  );
}

class TecEstado {
  TecEstado(this.m);
  final MaquetaEstado m;

  final me = Yo();
  String status =
      'nuevo'; // nuevo | pendiente | revision | verificado | rechazado
  int verifAt = 0;
  String level = '', targetLevel = '', vReason = '';
  ({String res, String why})? vOutcome;
  bool vExpired = false, consent = false, avail = false, upgrade = false;
  final skip = <String, bool>{};
  final hours = [true, true, false];
  final replied = <String, String>{};
  final drafts = <String, Borrador>{};
  final th = <String, List<Msg>>{};
  final unread = <String, int>{};
  String? typing;
  List<Req> reqs = [];
  List<Visita> visits = [];
  List<Opinion> reviews = [];
  List<Trabajo> works = [];
  List<AvisoT> notifs = [];
  bool tip = true;
  Timer? _ticker;

  /// Acción pendiente tras ofrecer la verificación.
  ({String why, void Function() cont})? after;

  void seed() {
    String dl(int i) {
      final d = days[i];
      return '${d.$1} ${d.$2}';
    }

    reqs = [
      Req(
        id: 'r1',
        k: 'nuevas',
        hace: 'Hace 8 min',
        cat: 'plo',
        titulo: 'El boiler no enciende',
        desc: 'Boiler de gas que no enciende desde ayer. Hace clic pero no prende la flama. 1 foto.',
        zona: 'Col. La Malinche · 2.4 km',
        cuando: '${dl(2)} · mañana',
        cid: 'ml',
      ),
      Req(
        id: 'r2',
        k: 'nuevas',
        hace: 'Hace 25 min',
        cat: 'plo',
        titulo: 'Fuga debajo del fregadero',
        desc: 'Gotea el tubo debajo de la tarja de la cocina. Ya cerré la llave de paso. 2 fotos.',
        zona: 'Col. Empleados Tolteca · 3.8 km',
        cuando: 'Hoy · tarde',
        cid: 'ap',
      ),
      Req(
        id: 'r3',
        k: 'nuevas',
        hace: 'Hace 12 min',
        cat: 'mec',
        titulo: 'Ruido al frenar',
        desc: 'Rechina al frenar, sobre todo en bajadas. Es un Nissan Versa 2018.',
        zona: 'Col. Centro · 1.9 km',
        cuando: '${dl(4)} · mañana',
        cid: 'jr',
      ),
      Req(
        id: 'r4',
        k: 'nuevas',
        hace: 'Hace 40 min',
        cat: 'mec',
        titulo: 'No arranca en las mañanas',
        desc: 'Por las mañanas tarda mucho en arrancar; en la tarde enciende normal.',
        zona: 'Col. Cruz Azul · 4.2 km',
        cuando: 'Hoy · tarde',
        cid: 'lc',
      ),
      Req(
        id: 'r5',
        k: 'nuevas',
        hace: 'Hace 18 min',
        cat: 'ele',
        titulo: 'Contacto sin corriente en la cocina',
        desc:
            'Un contacto de la cocina dejó de funcionar. Los demás sí sirven.',
        zona: 'Col. Centro · 2.0 km',
        cuando: '${dl(2)} · tarde',
        cid: 'rg',
      ),
      Req(
        id: 'r6',
        k: 'nuevas',
        hace: 'Hace 1 h',
        cat: 'ele',
        titulo: 'Instalar una lámpara en la sala',
        desc: 'Tengo la lámpara y el techo ya tiene la caja. Solo falta instalarla.',
        zona: 'Col. La Malinche · 2.6 km',
        cuando: '${dl(3)} · mañana',
        cid: 'cv',
      ),
    ];
  }

  /// Atajo de pruebas: un técnico con una visita aceptada, un trabajo
  /// terminado y una opinión, para ver todas las pantallas.
  void seedDemo() {
    if (reqs.isEmpty) seed();
    final r1 = req('r1')!;
    final r2 = req('r2')!;
    r1.k = 'aceptada';
    r1.quote = Cot(
      m: 'rango',
      lo: '450',
      hi: '650',
      fx: '550',
      t: 1,
      d: 1,
      nt: 'Llevo el termopar.',
    );
    r1.nota = 'Aceptada · visita mañana · \$450 – \$650';
    ensureThread(r1)
        .add(Msg('me', '¿Me manda una foto de la etiqueta?', h: '9:30'));
    visits = [
      Visita(
        id: 'vr1',
        rid: 'r1',
        cid: 'ml',
        titulo: r1.titulo,
        d: 1,
        time: '10:00',
        code: '4827',
        price: '\$450 – \$650',
      ),
    ];
    r2.k = 'fin';
    r2.quote = Cot(m: 'fijo', fx: '400');
    r2.nota = 'Terminado · \$400';
    reviews = [
      Opinion(
        'rvr2',
        'Ana P.',
        5,
        'Fuga debajo del fregadero · hace 2 días',
        'Muy puntual y dejó todo limpio. Me explicó qué había fallado.',
      ),
    ];
    reqs.add(
      Req(
          id: 'r7',
          k: 'proceso',
          hace: 'Hace 1 h',
          cat: 'plo',
          titulo: 'Llave de la regadera',
          desc: 'Gotea la llave de la regadera.',
          zona: 'Col. Centro · 2.1 km',
          cuando: 'Hoy · tarde',
          cid: 'jr',
        )
        ..quote = Cot(m: 'fijo', fx: '300')
        ..nota = 'Tu cotización: \$300 · esperando respuesta',
    );
    avail = true;
    syncMe();
    m.refresh();
  }

  // ---------------- consultas ----------------
  bool get verified => status == 'verificado';
  String get first => me.name.trim().split(' ').first;
  List<String> get meCats => me.cats.toList();
  List<String> get trades => [
    for (final c in meCats) cats[c]!.short,
    if (me.otherOn && me.other.isNotEmpty) me.other,
  ];
  String get summary =>
      '${trades.isEmpty ? 'Sin oficio' : trades.join(' · ')} · ${me.how == 'taller' ? 'En taller' : 'A domicilio'}';
  List<Req> get myReqs =>
      reqs.where((r) => r.k != 'nuevas' || me.cats.contains(r.cat)).toList();
  int get nuevasN => myReqs.where((r) => r.k == 'nuevas').length;
  ({int sent, int accepted, int done}) get stats => (
    sent: reqs.where((r) => r.quote != null).length,
    accepted: reqs.where((r) => r.k == 'aceptada' || r.k == 'fin').length,
    done: reqs.where((r) => r.k == 'fin').length,
  );
  Req? req(String id) => reqs.where((r) => r.id == id).firstOrNull;
  Req? reqOfClient(String cid) => reqs.where((r) => r.cid == cid).firstOrNull;
  Visita? visita(String? id) => visits.where((v) => v.id == id).firstOrNull;
  Visita? get nextVisit {
    final l = visits.where((v) => !v.done).toList()
      ..sort(
        (a, b) => a.d != b.d ? a.d.compareTo(b.d) : a.time.compareTo(b.time),
      );
    return l.firstOrNull;
  }

  int get unreadN => unread.values.fold(0, (a, b) => a + b);
  int get notifUnread => notifs.where((n) => !n.read).length;
  String dayLabel(int d) {
    final x = days[d.clamp(0, 5)];
    return d == 0
        ? 'Hoy'
        : d == 1
        ? 'Mañana'
        : '${x.$3[0].toUpperCase()}${x.$3.substring(1)} ${x.$2}';
  }

  String verifLabel() => switch (status) {
    'verificado' =>
      level == 'completo'
          ? 'Verificada · validada con el INE'
          : 'Verificada · básica',
    'pendiente' => 'En revisión',
    'revision' => 'Revisión manual · hasta 24 h',
    'rechazado' => 'No se pudo verificar · intenta de nuevo',
    _ => 'Sin verificar · opcional, te da una insignia verde',
  };

  // ---------------- registro ----------------
  void register({
    required String name,
    required String business,
    required String phone,
    required Set<String> cats0,
    required bool otherOn,
    required String other,
    required String how,
    required String km,
    required String address,
    required String about,
    required String years,
    required List<List<String>> svcs,
  }) {
    me
      ..registered = true
      ..name = name.trim().replaceAll(RegExp(r'\s+'), ' ')
      ..business = business.trim()
      ..phone = phone
      ..cats = {...cats0}
      ..otherOn = otherOn
      ..other = otherOn ? other.trim() : ''
      ..how = how
      ..km = km
      ..address = address.trim()
      ..about = about.trim()
      ..years = years.trim()
      ..photo = null
      ..svcs = svcs.isNotEmpty ? svcs : defaultSvcs(cats0.toList());
    if (m.user.first.isEmpty) {
      m.user.name = me.name;
      m.user.first = first;
    }
    if (m.user.phone.isEmpty) m.user.phone = phone;
    if (reqs.isEmpty) seed();
    syncMe();
    startTicker();
    m.refresh();
  }

  List<List<String>> defaultSvcs(List<String> cs) {
    const d = {
      'mec': [
        ['Revisión y diagnóstico', 'Revisamos tu auto', r'$300'],
      ],
      'plo': [
        ['Visita de revisión', 'Diagnóstico en tu casa', r'$250'],
      ],
      'ele': [
        ['Visita de revisión', 'Diagnóstico en tu casa', r'$250'],
      ],
    };
    return [for (final c in cs) ...?d[c]];
  }

  // ---------------- PROV.me ----------------
  void syncMe() {
    if (!me.registered || me.cats.isEmpty) {
      provs.remove('me');
      return;
    }
    final n = reviews.length;
    final avg = n == 0 ? 0.0 : reviews.fold<int>(0, (a, r) => a + r.s) / n;
    final dist = [0, 0, 0, 0, 0];
    for (final r in reviews) {
      dist[5 - r.s]++;
    }
    const hd = [
      ['Lunes a viernes', '8:00 a 19:00'],
      ['Sábado', '9:00 a 14:00'],
      ['Domingo', 'Solo urgencias'],
    ];
    final cs = meCats;
    final nm = me.business.isNotEmpty ? me.business : me.name;
    provs['me'] = Prov(
      id: 'me',
      name: nm,
      owner: me.business.isNotEmpty ? me.name : null,
      ini: initials(nm),
      color: const Color(0xFF2A5568),
      cat: cs.first,
      taller: me.how == 'taller',
      spec: trades.join(' · '),
      rate: avg,
      n: n,
      km: 1.2,
      years: int.tryParse(me.years) ?? 0,
      jobs: reqs.where((r) => r.k == 'fin').length,
      resp: '—',
      today: avail,
      about: me.about.isNotEmpty
          ? me.about
          : 'Atiendo ${me.how == 'taller' ? 'en mi taller' : 'a domicilio'}. Escríbeme y te cotizo sin compromiso.',
      zone: colores,
      radius: me.km,
      addr: me.address,
      addr2: 'Tula de Allende, Hgo.',
      hours: [
        for (var i = 0; i < 3; i++) [hd[i][0], hours[i] ? hd[i][1] : 'Cerrado'],
      ],
      svcs: me.svcs.isNotEmpty ? me.svcs : defaultSvcs(cs),
      photos: [for (final w in works) (w.title, const Color(0xFF4F6F95))],
      dist: dist,
      crit: [avg, avg, avg, avg],
      revs: [
        for (final r in reviews)
          Review(r.n, initials(r.n), r.s, r.w, r.t, reply: replied[r.id]),
      ],
      ver: verified,
      imgs: [for (final w in works) w.img],
      photoPath: me.photo,
    );
  }

  // ---------------- verificación ----------------
  /// Ofrece la verificación (opcional). `true` si abrió algo y debe detenerse.
  bool needVerif(
    String why,
    void Function() cont, {
    required void Function() openSheet,
    required void Function() goVerif,
    bool soft = true,
  }) {
    if (verified || status == 'pendiente' || status == 'revision') return false;
    if (!soft) {
      goVerif();
      return true;
    }
    if (skip[why] ?? false) return false;
    after = (why: why, cont: cont);
    openSheet();
    return true;
  }

  void verifSkip() {
    final a = after;
    after = null;
    if (a != null) {
      skip[a.why] = true;
      a.cont();
    }
  }

  void verifSend(String phone) {
    final last = digits(phone).length >= 2
        ? digits(phone).substring(digits(phone).length - 2)
        : '';
    vOutcome = upgrade
        ? (res: 'ok', why: '')
        : last == '71'
        ? (res: 'rechazado', why: 'vencido')
        : last == '72'
        ? (res: 'rechazado', why: 'cara')
        : last == '73'
        ? (res: 'revision', why: '')
        : last == '74'
        ? (res: 'sinrevision', why: '')
        : (res: 'ok', why: '');
    status = 'pendiente';
    verifAt = DateTime.now().millisecondsSinceEpoch;
    upgrade = false;
    vExpired = false;
    startTicker();
    m.refresh();
  }

  void startTicker() {
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// Avisos de pantalla de la verificación (la interfaz los escucha).
  void Function(String estado)? alCambiarVerif;

  void _tick() {
    final el = DateTime.now().millisecondsSinceEpoch - verifAt;
    final o = vOutcome ?? (res: 'ok', why: '');
    if (status == 'pendiente' && verifAt > 0 && el >= 6000) {
      if (o.res == 'revision' || o.res == 'sinrevision') {
        status = 'revision';
        alCambiarVerif?.call('revision');
      } else if (o.res == 'rechazado') {
        status = 'rechazado';
        vReason = o.why;
        alCambiarVerif?.call('rechazado');
      } else {
        status = 'verificado';
        level = targetLevel.isEmpty ? 'basico' : targetLevel;
        alCambiarVerif?.call('verificado');
      }
      syncMe();
      m.refresh();
    } else if (status == 'revision' && o.res == 'sinrevision' && el >= 12000) {
      status = 'nuevo';
      vExpired = true;
      vOutcome = null;
      alCambiarVerif?.call('expirado');
      m.refresh();
    } else if (status == 'revision' && o.res != 'sinrevision' && el >= 16000) {
      status = 'verificado';
      level = targetLevel.isEmpty ? 'basico' : targetLevel;
      syncMe();
      alCambiarVerif?.call('verificado');
      m.refresh();
    } else if (status == 'pendiente') {
      m.refresh();
    }
  }

  void dispose() => _ticker?.cancel();

  // ---------------- conversaciones ----------------
  List<Msg> ensureThread(Req r) => th.putIfAbsent(
    r.cid,
    () => [Msg('sys', 'Solicitud: «${r.titulo}»'), Msg('p', r.desc, h: r.hace)],
  );
  int workerMsgs(List<Msg> t) => t.where((x) => x.s == 'me').length;

  String _replyFor(Req r, String text) {
    final x = text.toLowerCase();
    final c = cliente(r.cid);
    final day = RegExp(r's[aá]b', caseSensitive: false).hasMatch(r.cuando)
        ? 'el sábado'
        : RegExp('dom', caseSensitive: false).hasMatch(r.cuando)
        ? 'el domingo'
        : RegExp('lun', caseSensitive: false).hasMatch(r.cuando)
        ? 'el lunes'
        : 'hoy en la tarde';
    bool t(String p) => RegExp(p).hasMatch(x);
    if (t(r'foto|imagen|etiqueta')) return 'Claro, ya le envié la foto.';
    if (t(r'direcci|ubica|d[oó]nde|colonia')) {
      return 'Estoy en ${c.col}. Le paso la dirección exacta cuando acepte la cotización.';
    }
    if (t(r'gas|el[eé]ctric|tipo|modelo|a[nñ]o|marca')) {
      return 'Como le conté en la solicitud: ${r.desc.split('.').first.toLowerCase()}.';
    }
    if (t(r'llevo|llevar')) return 'Perfecto, gracias por avisar.';
    if (t(r'material|refacci|pieza|incluye')) {
      return 'Si hace falta una pieza, prefiero que usted la lleve y me diga cuánto sale antes de cambiarla.';
    }
    if (t(r'd[ií]a|cu[aá]ndo|hora|disponib|puede venir|ir el|visita')) {
      return 'Me acomoda $day.';
    }
    if (t(r'precio|cu[aá]nto|cost|cobr')) {
      return '¿Me puede dar un aproximado antes de ir? Con eso me decido.';
    }
    if (t(r'urgen|hoy mismo')) {
      return 'Sí, sería ideal que fuera hoy mismo, es urgente.';
    }
    if (t(r'hola|buen')) return 'Hola, buenas. Gracias por responder.';
    return 'Gracias, quedo atento. ¿Necesita saber algo más?';
  }

  String? chatAbierto;

  void workerSay(String rid, String text) {
    final r = req(rid);
    if (r == null) return;
    final t = ensureThread(r);
    t.add(Msg('me', text, h: nowH()));
    typing = r.cid;
    m.refresh();
    m.after(1100 + math.min(text.length * 12, 1200), () {
      final tt = ensureThread(r);
      tt.add(Msg('p', _replyFor(r, text), h: nowH()));
      if (typing == r.cid) typing = null;
      if (chatAbierto != r.cid) {
        unread[r.cid] = (unread[r.cid] ?? 0) + 1;
        m.toast(
          '${cliente(r.cid).n} te respondió',
          accion: 'Ver',
          alAccion: () => irChat?.call(r.cid, r.id),
        );
      }
    });
  }

  void Function(String cid, String rid)? irChat;
  void Function(String destino)? irA;

  void reject(String id) {
    final i = reqs.indexWhere((r) => r.id == id);
    if (i < 0) return;
    final r = reqs.removeAt(i);
    m.refresh();
    m.toast(
      'Solicitud descartada',
      accion: 'Deshacer',
      alAccion: () {
        reqs.insert(i, r);
        m.refresh();
      },
    );
  }

  // ---------------- IA simulada ----------------
  static const tools = {
    'boiler': 'Llave stillson, multímetro, termopar de repuesto, cerillos o encendedor largo',
    'fuga': 'Cinta teflón, llaves ajustables, cubeta, sellador y conexiones de repuesto',
    'drenaje': 'Sonda o serpentina, desarmadores, guantes y cubeta',
    'tinaco': 'Flotador de repuesto, llaves ajustables y cinta teflón',
    'llave': 'Llave de repuesto, cinta teflón y llaves ajustables',
    'frenos': 'Juego de llaves, gato y soportes, balatas de repuesto y limpiador de frenos',
    'aceite': 'Aceite y filtro, llave de filtro y charola',
    'arranque': 'Multímetro, cables pasacorriente y herramienta básica',
    'contacto':
        'Multímetro, desarmadores, cinta aislante y un contacto de repuesto',
    'lámpara': 'Desarmadores, pinzas, cinta aislante y escalera',
    'corto': 'Multímetro, pinzas, cinta aislante y pastilla de repuesto',
  };
  static const _rules = <String, List<(String, List<int>, String)>>{
    'plo': [
      (r'boiler|calentador|termopar|piloto', [450, 650], 'boiler'),
      (r'fuga|gotea|tubo|fregadero|tarja', [350, 550], 'fuga'),
      (r'drenaje|tap[oó]|destap', [400, 600], 'drenaje'),
      (r'tinaco|flotador', [350, 500], 'tinaco'),
      (r'llave|regadera', [250, 400], 'llave'),
    ],
    'mec': [
      (r'freno|rechin|balata', [600, 900], 'frenos'),
      (r'aceite', [450, 700], 'aceite'),
      (r'arranca|bater[ií]a|marcha', [400, 750], 'arranque'),
    ],
    'ele': [
      (r'contacto|enchufe|apagador', [250, 400], 'contacto'),
      (r'l[aá]mpara|foco|luminaria', [300, 450], 'lámpara'),
      (r'corto|chispa|quemado|breaker|pastilla', [400, 700], 'corto'),
    ],
  };
  static const _def = {
    'plo': [300, 500],
    'mec': [350, 600],
    'ele': [300, 500],
  };
  static const _diag = {
    'boiler': 'puede ser el termopar o el piloto del boiler',
    'fuga': 'reviso la tubería y las conexiones para ubicar la fuga',
    'drenaje': 'destapo con equipo y reviso el flujo',
    'tinaco': 'reviso el flotador y la válvula del tinaco',
    'llave': 'reviso y cambio lo necesario en la llave',
    'frenos': 'reviso balatas, discos y el nivel de líquido',
    'aceite': 'hago el cambio y reviso niveles',
    'arranque': 'reviso batería, marcha y bornes',
    'contacto': 'reviso el cableado y el contacto',
    'lámpara': 'instalo y pruebo la lámpara',
    'corto': 'ubico el corto y reviso la protección',
  };

  String? _kind(Req r, String all) {
    for (final x in _rules[r.cat] ?? const <(String, List<int>, String)>[]) {
      if (RegExp(x.$1).hasMatch(all)) return x.$3;
    }
    return null;
  }

  int dayIndexFor(String text) {
    String norm(String s) => s
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
    final tx = norm(text.toLowerCase());
    final ds = days;
    for (var i = 1; i < ds.length; i++) {
      final nm = norm(ds[i].$3);
      if (RegExp('\\b($nm|${nm.substring(0, 3)})\\b').hasMatch(tx)) return i;
    }
    return RegExp(r'\bhoy\b').hasMatch(tx) ? 0 : -1;
  }

  Bitacora summary0(Req r) {
    final chat = ensureThread(r).where((x) => x.s != 'sys').toList();
    final cl = chat
        .where((x) => x.s == 'p')
        .map((x) => x.t)
        .join(' ')
        .toLowerCase();
    final mi = chat
        .where((x) => x.s == 'me')
        .map((x) => x.t)
        .join(' ')
        .toLowerCase();
    final all = '${r.titulo} ${r.desc} $cl'.toLowerCase();
    final kind = _kind(r, all);
    final asked = dayIndexFor(cl);
    final when = asked >= 0 ? (asked == 0 ? 'hoy' : days[asked].$3) : r.cuando;
    final datos = <String>[
      'Problema: ${r.desc}',
      'Zona: ${r.zona} (aproximada)',
      'Cuándo le acomoda: $when',
    ];
    final falta = <String>[];
    if (RegExp('foto').hasMatch(cl) &&
        RegExp(r'ya le envi|le mand|aqu[ií] est').hasMatch(cl)) {
      datos.add('Ya compartió una foto');
    } else if (RegExp('foto').hasMatch(mi)) {
      falta.add('Pedirle la foto que mencionaste');
    }
    if (r.cat == 'plo' && RegExp('gas').hasMatch(all)) {
      datos.add('El equipo es de gas');
    }
    if (RegExp(r'urgen|hoy mismo|lo antes posible').hasMatch(cl)) {
      datos.add('Pidió atención urgente');
    }
    if (RegExp(r'llevo|llevar').hasMatch(mi) &&
        RegExp(r'material|refacci|pieza').hasMatch(mi)) {
      datos.add('Acordaste llevar los materiales');
    } else if (RegExp(r'material|refacci|pieza').hasMatch(cl)) {
      falta.add('El cliente preguntó por refacciones: aclara quién las compra');
    }
    if (asked < 0 &&
        !RegExp(
          r'ma[nñ]ana|hoy|lunes|martes|mi[eé]rcoles|jueves|viernes|s[aá]bado|domingo',
        ).hasMatch(cl)) {
      falta.add('Confirmar el día y la hora de la visita');
    }
    if (!RegExp(r'colonia|calle|direcci').hasMatch(cl)) {
      falta.add('Confirmar la colonia o referencias de llegada');
    }
    return Bitacora(
      datos,
      falta,
      tools[kind] ?? 'Herramienta básica del oficio',
      chat.length,
    );
  }

  Borrador makeDraft(Req r) {
    final chat = ensureThread(r).where((x) => x.s != 'sys').toList();
    final mine = chat.where((x) => x.s == 'me').toList();
    final all = '${r.titulo} ${chat.map((x) => x.t).join(' ')}'.toLowerCase();
    final cl = chat
        .where((x) => x.s == 'p')
        .map((x) => x.t)
        .join(' ')
        .toLowerCase();
    final mi = mine.map((x) => x.t).join(' ').toLowerCase();
    var base = _def[r.cat]!;
    String? kind;
    for (final x in _rules[r.cat]!) {
      if (RegExp(x.$1).hasMatch(all)) {
        base = x.$2;
        kind = x.$3;
        break;
      }
    }
    var lo = base[0], hi = base[1];
    final basis = <String>[
      'Problema: «${r.titulo}»${kind != null ? ' (se parece a un trabajo de $kind)' : ''}',
    ];
    final llevo =
        RegExp(r'llevo|llevar|llevaré').hasMatch(mi) &&
        RegExp(r'material|refacci|pieza').hasMatch(mi);
    final urgente = RegExp(r'urgen|hoy mismo|lo antes posible').hasMatch(cl);
    if (RegExp('foto').hasMatch(cl) && RegExp(r'ya le envi').hasMatch(cl)) {
      basis.add('El cliente ya te compartió una foto');
    }
    if (RegExp('gas').hasMatch(all) && r.cat == 'plo') {
      basis.add('Es un equipo de gas');
    }
    if (llevo) {
      hi += 100;
      basis.add(
        'Acordaste llevar los materiales: sumé un margen para refacciones',
      );
    } else if (RegExp(r'material|refacci|pieza').hasMatch(cl)) {
      basis.add(
        'El cliente preguntó por refacciones: la nota aclara que se cotizan aparte',
      );
    }
    if (urgente) {
      lo += 50;
      hi += 100;
      basis.add('Pidió atención urgente: sumé un cargo por urgencia');
    }
    final dflt = dayIndexFor(r.cuando.toLowerCase());
    final asked = dayIndexFor(cl);
    final d = asked >= 0 ? asked : (dflt >= 0 ? dflt : 1);
    if (asked >= 0) {
      basis.add(
        'El cliente dijo que le acomoda ${asked == 0 ? 'hoy' : days[asked].$3}',
      );
    } else if (dflt >= 0) {
      basis.add('En la solicitud prefiere: ${r.cuando}');
    }
    var mm = 'rango';
    final fx = (((lo + hi) / 2) / 50).round() * 50;
    if (RegExp('fijo').hasMatch(mi)) {
      mm = 'fijo';
      basis.add('Mencionaste precio fijo');
    }
    final t = RegExp('instal|tinaco').hasMatch(all)
        ? 2
        : RegExp('boiler|freno|drenaje|corto|arranca').hasMatch(all)
        ? 1
        : 0;
    final nt =
        'Según lo que platicamos, ${_diag[kind] ?? 'reviso y te doy un diagnóstico'}. ${llevo ? 'Llevo las refacciones comunes; si hace falta una pieza distinta te la cotizo aparte antes de cambiarla.' : 'Si hace falta una refacción, te la cotizo aparte antes de cambiarla.'}${d == 0 ? ' Puedo ir hoy.' : ' Puedo ir ${d == 1 ? 'mañana' : 'el ${days[d].$3}'}.'}';
    final ai = Cot(
      m: mm,
      lo: '${(lo / 50).round() * 50}',
      hi: '${(hi / 50).round() * 50}',
      fx: '$fx',
      t: t,
      d: d,
      nt: nt,
    );
    final b = Borrador(
      m: mm,
      lo: ai.lo,
      hi: ai.hi,
      fx: ai.fx,
      t: t,
      d: d,
      nt: nt,
      basis: basis,
      msgs: chat.length,
      ai: ai,
    );
    drafts[r.id] = b;
    return b;
  }

  Borrador draft(Req r) => drafts[r.id] ?? makeDraft(r);

  ({int lo, int hi, int med, int n, String what}) marketRef(Req r) {
    const market = {
      'boiler': [450, 650, 550, 38],
      'fuga': [350, 550, 450, 52],
      'drenaje': [400, 600, 500, 29],
      'tinaco': [350, 500, 420, 24],
      'llave': [250, 400, 320, 41],
      'frenos': [600, 900, 750, 47],
      'aceite': [450, 700, 550, 63],
      'arranque': [400, 750, 550, 31],
      'contacto': [250, 400, 300, 44],
      'lámpara': [300, 450, 350, 36],
      'corto': [400, 700, 520, 22],
    };
    const cat = {
      'plo': [300, 500, 380, 120],
      'mec': [350, 600, 450, 150],
      'ele': [300, 500, 380, 110],
    };
    final all =
        '${r.titulo} ${r.desc} ${ensureThread(r).map((x) => x.t).join(' ')}'
            .toLowerCase();
    final kind = _kind(r, all);
    final mk = kind != null ? market[kind] : null;
    if (mk != null && mk[3] >= 10) {
      return (lo: mk[0], hi: mk[1], med: mk[2], n: mk[3], what: '«$kind»');
    }
    final c = cat[r.cat]!;
    return (
      lo: c[0],
      hi: c[1],
      med: c[2],
      n: c[3],
      what: 'de ${cats[r.cat]!.short.toLowerCase()}',
    );
  }

  bool draftOk(Cot d) => d.m == 'rango'
      ? ((int.tryParse(d.lo) ?? 0) > 0 &&
            (int.tryParse(d.hi) ?? 0) >= (int.tryParse(d.lo) ?? 0))
      : d.m == 'visita'
      ? ((int.tryParse(d.fx) ?? 0) > 0 &&
            (int.tryParse(d.fx) ?? 0) <= priceVisitaMax)
      : (int.tryParse(d.fx) ?? 0) > 0;

  int tTope(Cot q, String cat) => q.m == 'visita'
      ? 0
      : qTope(
          Quote(
            pid: '',
            kind: q.m == 'fijo' ? 'fijo' : 'rango',
            lo: int.tryParse(q.fx) ?? 0,
            hi: int.tryParse(q.hi) ?? 0,
            when: '',
            soon: 0,
            note: '',
          ),
          cat,
        );

  void sendQuote(Req r) {
    final d = draft(r);
    r.k = 'proceso';
    r.hace = 'Ahora';
    r.quote = Cot(
      m: d.m,
      lo: d.lo,
      hi: d.hi,
      fx: d.fx,
      t: d.t,
      d: d.d,
      nt: d.nt,
    );
    r.nota = 'Tu cotización: ${r.quote!.txt} · esperando respuesta';
    ensureThread(r)
        .add(Msg('sys', 'Enviaste una cotización · ${r.quote!.txt}'));
    drafts.remove(r.id);
    m.after(9000, () => _accept(r.id));
    m.refresh();
  }

  static const _codes = {
    'r1': '4827',
    'r2': '1359',
    'r3': '7716',
    'r4': '2048',
    'r5': '9301',
    'r6': '5582',
  };

  void _accept(String rid) {
    final r = req(rid);
    if (r == null || r.k != 'proceso' || r.quote == null) return;
    final q = r.quote!;
    final c = cliente(r.cid);
    r.k = 'aceptada';
    r.nota = 'Aceptada · visita ${dayLabel(q.d).toLowerCase()} · ${q.txt}';
    visits.add(
      Visita(
        id: 'v${r.id}',
        rid: r.id,
        cid: r.cid,
        titulo: r.titulo,
        d: q.d,
        time: '10:00',
        code: _codes[r.id] ?? '4827',
        price: q.txt,
      ),
    );
    final t = ensureThread(r);
    t.add(
      Msg('sys', '${c.n.split(' ').first} aceptó tu cotización · ${q.txt}'),
    );
    t.add(
      Msg(
        'p',
        'Perfecto, lo espero. Cuando llegue le doy mi código de visita.',
        h: nowH(),
      ),
    );
    unread[r.cid] = (unread[r.cid] ?? 0) + 1;
    pushNotif(
      'check',
      'Cotización aceptada',
      '${c.n} aceptó tu cotización para «${r.titulo}».',
      'trabajo',
    );
    m.toast(
      '${c.n} aceptó tu cotización',
      accion: 'Ver agenda',
      alAccion: () => irA?.call('trabajo'),
    );
  }

  void pushNotif(String icon, String title, String text, String go) =>
      notifs.insert(0, AvisoT(icon, title, text, go));

  // ---------------- visitas ----------------
  void reprogVisit(String id, int d, String t) {
    final v = visita(id);
    if (v == null) return;
    final txt = '${d == 0 ? 'hoy' : '${days[d].$3} ${days[d].$2}'} a las $t';
    v.resched = Resched(d, t, txt);
    m.after(4000, () {
      final x = visita(id);
      if (x == null || x.resched == null) return;
      final r = x.resched!;
      x.d = r.d;
      x.time = r.t;
      x.resched = null;
      pushNotif(
        'cal',
        'Visita reprogramada',
        '${cliente(x.cid).n} aceptó mover «${x.titulo}» a ${r.txt}.',
        'trabajo',
      );
      m.toast(
        '${cliente(x.cid).n.split(' ').first} aceptó el cambio: ${r.txt}',
      );
    });
    m.refresh();
    m.toast(
      'Le pedimos a ${cliente(v.cid).n.split(' ').first} confirmar el cambio',
    );
  }

  void cancelVisit(String id, {required bool absent}) {
    final v = visita(id);
    if (v == null) return;
    v.done = true;
    v.closed = absent ? 'ausente' : 'cancelada';
    final f = cliente(v.cid).n.split(' ').first;
    m.refresh();
    m.toast(
      absent
          ? 'Registramos que $f no estaba'
          : 'Cancelaste la visita; avisamos a $f',
    );
  }

  void adjust(String id, int n, String why) {
    final v = visita(id);
    final r = v == null ? null : req(v.rid);
    if (v == null || r == null || r.quote == null) return;
    final fin = r.quote!.m == 'visita';
    final over = !fin && n > tTope(r.quote!, r.cat);
    v.fin = fin || over
        ? 'Enviado al cliente: \$$n · esperando aprobación'
        : 'Registrado: \$$n (dentro del tope)';
    if (!(fin || over)) v.price = '\$$n';
    if (fin || over) {
      m.after(5000, () {
        v.fin = 'Aprobado por el cliente: \$$n';
        v.price = '\$$n';
        pushNotif(
          'check',
          'Precio aprobado',
          '${cliente(v.cid).n} aprobó \$$n para «${v.titulo}».',
          'trabajo',
        );
        m.toast('El cliente aprobó \$$n');
      });
    }
    m.refresh();
    m.toast(
      fin || over ? 'Enviamos tu propuesta al cliente' : 'Cambio registrado',
    );
  }

  static const _reviewTexts = [
    'Muy puntual y dejó todo limpio. Me explicó qué había fallado.',
    'Resolvió el problema en la primera visita y cobró lo acordado.',
    'Buen trato y trabajo bien hecho. Lo recomiendo.',
    'Llegó a la hora, explicó el precio antes de empezar y quedó perfecto.',
  ];

  void closeJob(String id, List<String> photos) {
    final v = visita(id);
    if (v == null) return;
    v.done = true;
    final r = req(v.rid);
    for (final p in photos) {
      works.insert(0, Trabajo(p, v.titulo, r?.cat ?? 'plo'));
    }
    if (works.length > 12) works = works.sublist(0, 12);
    if (r != null) {
      r.k = 'fin';
      r.nota = 'Terminado · ${v.price}';
      ensureThread(r).add(Msg('sys', 'Servicio terminado'));
      m.after(4000, () {
        reviews.insert(
          0,
          Opinion(
            'rv${r.id}',
            cliente(r.cid).n,
            5,
            '${r.titulo} · hace un momento',
            _reviewTexts[(int.tryParse(r.id.substring(1)) ?? 0) %
                _reviewTexts.length],
          ),
        );
        pushNotif(
          'star',
          'Nueva opinión',
          '${cliente(r.cid).n} te calificó con 5 estrellas.',
          'provReputacion',
        );
        syncMe();
        m.toast(
          '${cliente(r.cid).n} te calificó con 5 estrellas',
          accion: 'Ver',
          alAccion: () => irA?.call('reputacion'),
        );
      });
    }
    syncMe();
    m.refresh();
    m.toast('Servicio terminado. ¡Buen trabajo!');
  }
}
