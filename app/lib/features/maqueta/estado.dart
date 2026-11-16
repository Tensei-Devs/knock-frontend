import 'dart:async';
import 'dart:math' as math;

import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/tecnico_estado.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Estado simulado de la maqueta (`st` de `knock.js`) con los mismos
/// comportamientos y tiempos. Vive en memoria: es la parte sin endpoint.

class Quote {
  Quote({
    required this.pid,
    required this.kind,
    required this.lo,
    this.hi = 0,
    required this.when,
    required this.soon,
    required this.note,
  });
  final String pid, kind, when, note; // kind: fijo | rango | visita
  final int lo, hi, soon;

  String get price => kind == 'fijo'
      ? money(lo)
      : kind == 'visita'
      ? '${money(lo)} por la visita'
      : '${money(lo)} – ${money(hi)}';
}

const priceCfgPct = {'ele': 20, 'plo': 25, 'mec': 25};
int qTope(Quote q, String cat) {
  final base = q.kind == 'fijo' ? q.lo : q.hi;
  final pct = q.kind == 'fijo' ? 10 : (priceCfgPct[cat] ?? 20);
  return math.max((base * (1 + pct / 100) / 50).round() * 50, base + 100);
}

class Adjust {
  Adjust(this.kind, this.amount, this.tope, this.why);
  String status = 'pending'; // pending | ok | no
  final String kind; // final | ajuste
  final int amount, tope;
  final String why;
}

class Resched {
  Resched(this.d, this.t, this.txt);
  final int d;
  final String t, txt;
}

class Job {
  Job({
    required this.id,
    required this.title,
    required this.cat,
    required this.status,
    this.pid,
    this.sent = '',
    this.desc = '',
    this.pref = '',
    this.photos = 0,
    this.imgs = const [],
    this.when = '',
    this.time = '',
    this.what = '',
    this.price = '',
    this.code = '',
    this.date = '',
    this.rated = 0,
    this.doneAt,
    this.day = 0,
    this.target,
    this.only = false,
  });
  final String id;
  String title, cat;
  String status; // enviada|cotizando|visita|cita|terminado|cancelado
  String? pid, target;
  String sent, desc, pref, when, time, what, price, code, date, cancelNote = '';
  int photos, rated, day;
  List<String> imgs;
  DateTime? doneAt;
  bool only, silent = false, diag = false, dispute = false;
  List<Quote> quotes = [];
  Adjust? adjust;
  Resched? resched;
  Map<String, bool> closed = {};
}

class Msg {
  Msg(this.s, this.t, {this.h = '', this.job, this.img});
  final String s; // sys | p | me | quote
  final String t, h;
  final String? job, img;
  bool read = false;
}

class Notif {
  Notif(this.icon, this.title, this.text, this.go, this.jobId) : h = nowH();
  final String icon, title, text, h, go;
  final String? jobId;
  bool read = false;
}

class Contacto {
  Contacto(this.n, this.ph, this.colorIdx);
  final String n, ph;
  final int colorIdx;
}

class Casa {
  Casa(this.t, this.d, this.tag, this.c);
  final String t, d, tag;
  final String c; // amber|navy|green
}

class Solicitud {
  Solicitud({this.cat, this.pid, this.step = 1, this.first = 1});
  String? cat, pid;
  int step, first;
  String desc = '';
  List<String> photos = [];
  int day = 1, slot = 0;
  String addr = '';
  bool also = false;
}

class AsisMsg {
  AsisMsg(this.me, this.t, {this.img});
  final bool me;
  final String t;
  final String? img;
}

class Asis {
  List<AsisMsg> msgs = [];
  double stage = 0;
  String? cat;
  String text = '', since = '';
  bool typing = false;
  List<String> photos = [];
}

class UserData {
  String name = '',
      first = '',
      phone = '',
      col = 'Col. La Malinche',
      cp = '',
      addr = '';
  String? photoPath;
}

class MaquetaEstado extends ChangeNotifier {
  MaquetaEstado() {
    pv = TecEstado(this);
  }
  late final TecEstado pv;
  final user = UserData();

  /// Ubicación de prueba (Zona de pruebas); `null` usa la real.
  ({double lat, double lng})? ubicacionSimulada;
  Map<String, bool> saved = {};
  List<Job> jobs = [];
  Map<String, List<Msg>> threads = {};
  Map<String, int> unread = {};
  List<Notif> notifs = [];
  Map<String, bool> blocked = {};
  List<Contacto> contacts = [];
  List<Casa> home = [];
  ({String m, String y})? car;
  bool remind = false;
  bool tipDone = false;
  List<bool> notifPref = [true, true, false];
  List<bool> cons = [false, true, true];
  bool sessions = true;
  DateTime? delAt;
  Solicitud? req;
  Asis asis = Asis();
  final fold = <String, bool>{};
  final typing = <String, bool>{};
  int _seq = 10;

  // búsqueda
  String sCat = 'plo', sQ = '';
  bool sNone = false;
  final sF = {'dist': false, 'cal': false, 'tipo': false, 'hoy': false};
  bool sMapView = false;
  // explorar
  String? exCat;

  final _timers = <Timer>[];

  void refresh() => notifyListeners();

  /// El celular con el que se entró se recuerda en el dispositivo (solo para
  /// mostrarlo en Mi cuenta, como la maqueta).
  Future<void> cargarTelefono() async {
    if (user.phone.isNotEmpty) return;
    final p = await SharedPreferences.getInstance();
    user.phone = p.getString('maq_telefono') ?? '';
    if (user.phone.isNotEmpty) notifyListeners();
  }

  Future<void> guardarTelefono(String t) async {
    user.phone = t;
    final p = await SharedPreferences.getInstance();
    await p.setString('maq_telefono', t);
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }

  void after(int ms, VoidCallback f) {
    _timers.add(
      Timer(Duration(milliseconds: ms), () {
        f();
        notifyListeners();
      }),
    );
  }

  /// Avisos que la interfaz recoge una vez (toast con acción).
  final avisos = StreamController<AvisoToast>.broadcast();
  void toast(String msg, {String? accion, VoidCallback? alAccion}) =>
      avisos.add(AvisoToast(msg, accion, alAccion));

  // ---------- consultas ----------
  Job? job(String? id) {
    for (final j in jobs) {
      if (j.id == id) return j;
    }
    return null;
  }

  int get unreadCount => unread.values.fold(0, (a, b) => a + b);
  bool get cUnread => notifs.any((n) => !n.read);

  void notif(
    String icon,
    String title,
    String text,
    String go, [
    String? jobId,
  ]) {
    notifs.insert(0, Notif(icon, title, text, go, jobId));
  }

  List<Prov> results() {
    final l = provs.values.where((o) {
      if (o.cat != sCat) return false;
      if (sF['dist']! && o.km > 5) return false;
      if (sF['cal']! && o.rate < 4.5) return false;
      if (sF['tipo']! && o.taller) return false;
      if (sF['hoy']! && !o.today) return false;
      return true;
    }).toList();
    l.sort((a, b) {
      final r = (b.rec ? 1 : 0) - (a.rec ? 1 : 0);
      return r != 0 ? r : b.rate.compareTo(a.rate);
    });
    return l;
  }

  int get nFilters => sF.values.where((v) => v).length;

  List<String> convIds() => threads.keys
      .where((k) => blocked[k] != true && provs.containsKey(k))
      .toList();

  bool accepted(String pid) => jobs.any(
    (j) => j.pid == pid && ['visita', 'cita', 'terminado'].contains(j.status),
  );

  // ---------- acciones ----------
  void toggleSave(String id) {
    saved[id] = !(saved[id] ?? false);
    notifyListeners();
  }

  void openChat(String id) {
    unread.remove(id);
    notifyListeners();
  }

  void sendMsg(String id, String t) {
    final th = threads.putIfAbsent(id, () => []);
    th.add(Msg('me', t, h: nowH()));
    notifyListeners();
    after(700, () {
      for (final m in th) {
        if (m.s == 'me') m.read = true;
      }
      typing[id] = true;
    });
    after(2200, () {
      th.add(
        Msg('p', 'Claro, con gusto. Le confirmo en un momento.', h: nowH()),
      );
      typing[id] = false;
      // Un mensaje nuevo cuando no se está en la conversación suma al no leído.
      if (!(chatAbierto == id)) unread[id] = (unread[id] ?? 0) + 1;
    });
  }

  /// Conversación abierta en pantalla (para no marcar no leído).
  String? chatAbierto;

  void block(String id) {
    blocked[id] = true;
    notifyListeners();
  }

  void unblock(String id) {
    blocked.remove(id);
    notifyListeners();
  }

  // ----- solicitud -----
  void startReq({
    String? cat,
    String? pid,
    String desc = '',
    List<String>? photos,
    int? step,
  }) {
    req = Solicitud(
      cat: cat,
      pid: pid,
      step: cat != null ? 2 : 1,
      first: cat != null ? 2 : 1,
    );
    req!.desc = desc;
    req!.photos = [...?photos];
    if (step != null) req!.step = step;
    notifyListeners();
  }

  Job sendReq() {
    final r = req!;
    final c = cats[r.cat]!;
    final d = days[r.day], s = slots[r.slot];
    if (!c.taller && user.addr.isEmpty) {
      user.addr = r.addr.trim().replaceAll(RegExp(r'\s+'), ' ');
    }
    final first = r.desc.split(RegExp(r'[.\n]')).first;
    final title = c.chips.contains(r.desc)
        ? r.desc
        : first.length > 42
        ? '${first.substring(0, 42)}…'
        : first;
    for (final x in jobs) {
      final n = int.tryParse(x.id.replaceAll(RegExp(r'\D'), '')) ?? 0;
      if (n > _seq) _seq = n;
    }
    final job = Job(
      id: 'j${++_seq}',
      title: title,
      cat: r.cat!,
      status: 'enviada',
      sent: 'Hoy, ahora',
      desc: r.desc,
      pref: '${r.day == 0 ? 'hoy' : '${d.$3} ${d.$2}'}, ${s.$3}',
      photos: r.photos.length,
      imgs: [...r.photos],
      day: r.day,
      target: r.pid,
      only: r.pid != null && !r.also,
    );
    jobs.insert(0, job);
    req = null;
    startClientQuotes(job);
    notifyListeners();
    return job;
  }

  void startClientQuotes(Job job, {bool widen = false}) {
    final col = user.col;
    final pool = provs.keys
        .where((k) => provs[k]!.cat == job.cat && blocked[k] != true)
        .toList();
    bool reach(Prov o) => o.zone.isEmpty || o.zone.contains(col);
    pool.sort((a, b) {
      final t = a == job.target ? -1 : (b == job.target ? 1 : 0);
      if (t != 0) return t;
      final r = (reach(provs[a]!) ? 0 : 1) - (reach(provs[b]!) ? 0 : 1);
      return r != 0 ? r : provs[a]!.km.compareTo(provs[b]!.km);
    });
    if (widen) {
      final rest = pool.where((k) => k != job.target).take(2).toList();
      for (var i = 0; i < rest.length; i++) {
        after(4500 + i * 5500, () => _cliQuote(job.id, rest[i], i + 1));
      }
      return;
    }
    if (job.only && job.target != null && provs.containsKey(job.target)) {
      after(60000, () => _cliQuote(job.id, job.target!, 0));
      after(12000, () {
        final j = this.job(job.id);
        if (j != null && j.only && j.quotes.isEmpty) j.silent = true;
      });
      return;
    }
    final take = pool.take(3).toList();
    for (var i = 0; i < take.length; i++) {
      after(4500 + i * 5500, () => _cliQuote(job.id, take[i], i));
    }
  }

  void widen(String jobId) {
    final j = job(jobId);
    if (j == null) return;
    j.only = false;
    j.silent = false;
    startClientQuotes(j, widen: true);
    notifyListeners();
    toast('Enviamos tu solicitud a más expertos');
  }

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
  int _r50(num n) => (n / 50).round() * 50;

  Quote _clientQuote(Job job, String pid, int i) {
    final all = '${job.title} ${job.desc}'.toLowerCase();
    var base = _def[job.cat]!;
    String? kind;
    for (final r in _rules[job.cat]!) {
      if (RegExp(r.$1).hasMatch(all)) {
        base = r.$2;
        kind = r.$3;
        break;
      }
    }
    final k = [1.0, 0.9, 1.15][i.clamp(0, 2)];
    final lo = _r50(base[0] * k), hi = _r50(base[1] * k);
    final day = math.min(math.max(job.day + (i == 2 ? 1 : 0), 0), 5);
    final dd = days[day];
    final when = day == 0
        ? ['17:00 a 18:00', '18:00 a 19:00', '19:00 a 20:00'][i.clamp(0, 2)]
        : ['10:00', '16:00', '9:00'][i.clamp(0, 2)];
    final fijo = i == 1;
    final o = provs[pid]!;
    final reach = o.zone.isEmpty || o.zone.contains(user.col);
    final dayTxt = day == 0 ? 'Hoy' : '${dd.$1} ${dd.$2}';
    if (i == 2) {
      return Quote(
        pid: pid,
        kind: 'visita',
        lo: 200,
        when: '$dayTxt, $when',
        soon: day,
        note: 'Necesito verlo en persona para darle un precio justo. La visita cuesta \$200 y se le descuenta si me contrata. Después le envío la cotización final por aquí.',
      );
    }
    final note =
        'Vi su foto y ${_diag[kind] ?? 'lo reviso para darle un diagnóstico'}. '
        '${fijo ? 'Precio fijo con revisión incluida; si hace falta una pieza, se la cotizo aparte antes de cambiarla.' : 'El precio final depende de lo que encuentre; se lo confirmo antes de empezar.'}'
        '${o.taller
            ? ' Lo espero en el taller.'
            : reach
            ? ''
            : ' Estoy un poco lejos de su colonia, pero puedo ir.'}';
    return Quote(
      pid: pid,
      kind: fijo ? 'fijo' : 'rango',
      lo: fijo ? _r50((lo + hi) / 2) : lo,
      hi: fijo ? 0 : hi,
      when: '$dayTxt, $when',
      soon: day,
      note: note,
    );
  }

  void _cliQuote(String jobId, String pid, int i) {
    final job = this.job(jobId);
    if (job == null || (job.status != 'enviada' && job.status != 'cotizando')) {
      return;
    }
    if (job.quotes.any((q) => q.pid == pid)) return;
    final q = _clientQuote(job, pid, i);
    final first = job.quotes.isEmpty;
    final o = provs[pid]!;
    job.quotes.add(q);
    job.status = 'cotizando';
    final th = threads.putIfAbsent(pid, () => []);
    th.add(Msg('sys', 'Enviaste la solicitud «${job.title}»'));
    th.add(Msg('quote', '', job: job.id));
    unread[pid] = (unread[pid] ?? 0) + 1;
    notif(
      'bell',
      'Cotización recibida',
      '${o.name} cotizó «${job.title}»: ${q.price}.',
      'comparar',
      job.id,
    );
    if (first) {
      toast(
        'Llegó tu primera cotización',
        accion: 'Ver',
        alAccion: () => irA?.call('comparar', job.id),
      );
    }
  }

  /// Navegación que la interfaz registra para los avisos con acción.
  void Function(String destino, String jobId)? irA;

  void accept(String jobId, String pid) {
    final j = job(jobId)!;
    final pr = provs[pid]!;
    final q = j.quotes.firstWhere((x) => x.pid == pid);
    j.pid = pid;
    j.price = q.price;
    final w = q.when.split(',');
    j.when = w[0] == 'Hoy' ? 'Hoy, ${longDate(DateTime.now())}' : w[0];
    j.time = w.length > 1 ? w[1].trim() : 'Por confirmar';
    if (pr.taller) {
      j.status = 'cita';
      j.what = 'Diagnóstico';
    } else {
      j.status = 'visita';
      j.code = (1000 + math.Random().nextInt(9000)).toString();
    }
    threads[pid] = [
      ...?threads[pid],
      Msg('sys', 'Elegiste la cotización de ${pr.first} · ${j.price}'),
      Msg('sys', 'Pueden seguir hablando aquí, en la app, o por WhatsApp'),
    ];
    notif(
      pr.taller ? 'cal' : 'house',
      pr.taller ? 'Cita confirmada' : 'Visita confirmada',
      '${pr.name} · ${j.when}${j.time.isNotEmpty ? ', ${j.time}' : ''}.',
      pr.taller ? 'cita' : 'visita',
      j.id,
    );
    for (final x in j.quotes) {
      if (x.pid != pid) {
        j.closed[x.pid] = true;
        threads
            .putIfAbsent(x.pid, () => [])
            .add(
              Msg(
                'sys',
                'Elegiste a otra persona para «${j.title}». Esta conversación se cerró.',
              ),
            );
      }
    }
    j.diag = q.kind == 'visita';
    if (j.diag || q.kind == 'rango') after(20000, () => _cliAdjust(j.id));
    after(40000, () => _cliDone(j.id));
    notifyListeners();
  }

  void _cliAdjust(String id) {
    final j = job(id);
    if (j == null || j.status != 'visita' || j.adjust != null) return;
    final q = j.quotes.where((x) => x.pid == j.pid).firstOrNull;
    if (q == null) return;
    final diag = q.kind == 'visita';
    final amount = diag ? 650 : _r50(q.hi * 1.4);
    j.adjust = Adjust(
      diag ? 'final' : 'ajuste',
      amount,
      qTope(q, j.cat),
      diag
          ? 'Ya revisé: hay que cambiar la pieza dañada y la mano de obra incluye pruebas.'
          : 'Al abrir encontré otra pieza dañada que no se veía en la foto.',
    );
    threads
        .putIfAbsent(j.pid!, () => [])
        .add(
          Msg(
            'sys',
            '${diag ? 'Cotización final: ' : 'Propone un cambio de precio: '}${money(amount)}. Necesita tu aprobación.',
          ),
        );
    final o = provs[j.pid]!;
    notif(
      'bell',
      diag ? 'Cotización final' : 'Cambio de precio',
      '${o.name} propone ${money(amount)} para «${j.title}».',
      'visita',
      j.id,
    );
    toast(
      '${o.first} propone ${money(amount)}',
      accion: 'Ver',
      alAccion: () => irA?.call('visita', j.id),
    );
  }

  void adjOk(String id) {
    final j = job(id)!;
    j.adjust!.status = 'ok';
    j.price = money(j.adjust!.amount);
    threads
        .putIfAbsent(j.pid!, () => [])
        .add(Msg('sys', 'Aprobaste el nuevo precio: ${j.price}'));
    notifyListeners();
    toast('Aprobaste ${j.price}');
  }

  void adjNo(String id) {
    final j = job(id)!;
    final a = j.adjust!;
    a.status = 'no';
    j.status = 'cancelado';
    j.cancelNote = a.kind == 'final'
        ? 'Cancelado. Pagas solo la visita.'
        : 'Cancelado sin costo.';
    threads
        .putIfAbsent(j.pid!, () => [])
        .add(Msg('sys', 'Rechazaste el nuevo precio. Trabajo cancelado.'));
    notifyListeners();
    toast(j.cancelNote);
  }

  void _cliDone(String id) {
    final j = job(id);
    if (j == null || (j.status != 'visita' && j.status != 'cita')) return;
    if (j.adjust != null && j.adjust!.status == 'pending') {
      after(8000, () => _cliDone(id));
      return;
    }
    final o = provs[j.pid]!;
    j.status = 'terminado';
    j.date = 'hoy';
    j.doneAt = DateTime.now();
    j.rated = 0;
    j.resched = null;
    threads.putIfAbsent(j.pid!, () => []).add(Msg('sys', 'Servicio terminado'));
    notif(
      'check',
      'Trabajo terminado',
      '${o.name} terminó «${j.title}». Califícalo cuando quieras.',
      'calificar',
      j.id,
    );
    toast(
      '${o.first} terminó tu trabajo',
      accion: 'Calificar',
      alAccion: () => irA?.call('calificar', j.id),
    );
  }

  void reprog(String id, int d, String t) {
    final j = job(id)!;
    final txt = '${d == 0 ? 'hoy' : '${days[d].$3} ${days[d].$2}'} a las $t';
    j.resched = Resched(d, t, txt);
    threads
        .putIfAbsent(j.pid!, () => [])
        .add(Msg('sys', 'Pediste mover la cita a $txt'));
    after(5000, () {
      final x = job(id);
      if (x == null || x.resched == null) return;
      final o = provs[x.pid]!;
      final r = x.resched!;
      x.when = r.d == 0
          ? 'Hoy, ${longDate(DateTime.now())}'
          : '${days[r.d].$1} ${days[r.d].$2}';
      x.time = r.t;
      x.resched = null;
      notif(
        'cal',
        'Cita reprogramada',
        '${o.name} aceptó mover la cita a ${r.txt}.',
        x.status == 'cita' ? 'cita' : 'visita',
        x.id,
      );
      toast('Cita reprogramada: ${r.txt}');
    });
    notifyListeners();
    toast('Le pedimos a ${provs[j.pid]!.first} confirmar el cambio');
  }

  bool isLate(Job j) => RegExp(r'^(Hoy|Mañana)').hasMatch(j.when);

  void cancelJob(String id) {
    final j = job(id)!;
    final late = isLate(j);
    j.status = 'cancelado';
    j.resched = null;
    j.cancelNote = late
        ? 'Cancelado por ti con menos de 24 h de aviso.'
        : 'Cancelado por ti sin costo.';
    threads
        .putIfAbsent(j.pid!, () => [])
        .add(
          Msg(
            'sys',
            'Esta persona canceló el servicio${late ? ' con menos de 24 h de aviso.' : '.'}',
          ),
        );
    notifyListeners();
    toast('Cancelaste el servicio con ${provs[j.pid]!.first}');
  }

  void rate(String id, int stars, bool save) {
    final j = job(id)!;
    j.rated = stars;
    if (save && j.pid != null) saved[j.pid!] = true;
    notifyListeners();
  }

  void report(String id, String op) {
    final j = job(id);
    if (op == 'El trabajo no se terminó' && j != null) j.dispute = true;
    notifyListeners();
  }

  void addContact(String n, String ph) {
    contacts.add(Contacto(n, ph, contacts.length % contactColors.length));
    notifyListeners();
  }

  // ----- eliminar cuenta -----
  List<String> pendingItems() {
    const s = {
      'enviada': 'esperando cotizaciones',
      'cotizando': 'con cotizaciones',
      'visita': 'visita confirmada',
      'cita': 'cita confirmada',
    };
    return [
      for (final j in jobs)
        if (j.status != 'terminado' && j.status != 'cancelado')
          '«${j.title}» · ${s[j.status]}',
      if (pv.me.registered) ...[
        if (pv.visits.where((v) => !v.done).isNotEmpty)
          '${pv.visits.where((v) => !v.done).length} visita(s) pendiente(s) como técnico',
        if (pv.reqs.where((r) => r.k == 'proceso').isNotEmpty)
          '${pv.reqs.where((r) => r.k == 'proceso').length} cotización(es) enviada(s) abierta(s)',
      ],
    ];
  }

  void scheduleDelete() {
    for (final j in jobs) {
      if (j.status != 'terminado' && j.status != 'cancelado') {
        j.status = 'cancelado';
        j.resched = null;
        if (j.pid != null) {
          threads
              .putIfAbsent(j.pid!, () => [])
              .add(Msg('sys', 'Esta persona canceló la solicitud'));
        }
      }
    }
    delAt = DateTime.now().add(const Duration(days: 7));
    notifyListeners();
  }

  void cancelDelete() {
    delAt = null;
    notifyListeners();
  }

  /// Carga el set de demostración (atajo «Cliente con historial de ejemplo»).
  void loadDemo() {
    final nowT = DateTime.now();
    saved = {'tr': true, 'rm': true, 'lg': true};
    final j1 = Job(
      id: 'j1',
      title: 'El boiler no enciende',
      cat: 'plo',
      status: 'cotizando',
      sent: 'Hoy 9:10',
      desc: 'El boiler no enciende desde ayer en la noche. Es de gas, hace clic pero no prende. No huele a gas.',
      pref: 'sáb 26 de sep, en la mañana',
      photos: 1,
    );
    j1.quotes = [
      Quote(
        pid: 'rm',
        kind: 'rango',
        lo: 450,
        hi: 650,
        when: 'Hoy, 17:00 a 18:00',
        soon: 0,
        note: 'Por lo que describe, puede ser el termopar. Llevo la refacción por si hace falta cambiarla.',
      ),
      Quote(
        pid: 'hs',
        kind: 'fijo',
        lo: 400,
        when: 'Sáb 26, 10:00',
        soon: 1,
        note: 'Incluye revisión y limpieza del quemador. Si hay que cambiar alguna pieza, se la cotizo aparte antes de hacerlo.',
      ),
      Quote(
        pid: 'mo',
        kind: 'rango',
        lo: 500,
        hi: 700,
        when: 'Lun 28, 9:00',
        soon: 3,
        note: 'Reviso piloto, termopar y válvula. El precio final depende de lo que encuentre.',
      ),
    ];
    jobs = [
      j1,
      Job(
        id: 'j2',
        title: 'Ruido al frenar',
        cat: 'mec',
        status: 'cita',
        pid: 'tr',
        when: 'Lunes 28 de septiembre',
        time: '9:30',
        what: 'Diagnóstico de frenos',
        price: 'Diagnóstico desde \$200',
      ),
      Job(
        id: 'j3',
        title: 'Contacto sin corriente en la cocina',
        cat: 'ele',
        status: 'visita',
        pid: 'lg',
        when: 'Sábado 26 de septiembre',
        time: '11:00 a 12:00',
        price: '\$250 – \$400',
        code: '5193',
      ),
      Job(
        id: 'j4',
        title: 'Instalación de lámpara',
        cat: 'ele',
        status: 'terminado',
        pid: 'fr',
        date: '12 de sep',
        rated: 0,
        doneAt: nowT.subtract(const Duration(days: 3)),
      ),
      Job(
        id: 'j5',
        title: 'Cambio de aceite',
        cat: 'mec',
        status: 'terminado',
        pid: 'tr',
        date: '15 de mar',
        rated: 5,
        doneAt: nowT.subtract(const Duration(days: 60)),
      ),
    ];
    threads = {
      'rm': [
        Msg('sys', 'Enviaste la solicitud «El boiler no enciende»'),
        Msg(
          'p',
          'Buenos días, ${user.first.isEmpty ? 'Mariana' : user.first}. ¿Me puede mandar una foto de la etiqueta del boiler?',
          h: '9:32',
        ),
        Msg('me', '📷 Foto de la etiqueta', h: '9:35'),
        Msg(
          'p',
          'Gracias. Es de paso, de 6 litros. Casi seguro es el termopar; llevo uno por si acaso.',
          h: '10:38',
        ),
        Msg('quote', '', job: 'j1'),
        Msg(
          'p',
          'Le envié la cotización, ¿le parece bien hoy a las 5?',
          h: '10:42',
        ),
      ],
      'hs': [
        Msg('sys', 'Enviaste la solicitud «El boiler no enciende»'),
        Msg('quote', '', job: 'j1'),
        Msg('p', 'Puedo ir mañana a las 10. Llevo todo.', h: '9:15'),
      ],
      'mo': [
        Msg('sys', 'Enviaste la solicitud «El boiler no enciende»'),
        Msg('quote', '', job: 'j1'),
        Msg('me', '¿Incluye materiales?', h: '8:50'),
      ],
      'tr': [
        Msg('sys', 'Cita confirmada · lunes 28, 9:30'),
        Msg('p', 'Lo esperamos el lunes a las 9:30.', h: 'Ayer'),
      ],
      'lg': [
        Msg('sys', 'Visita confirmada · sábado 26, 11:00'),
        Msg('p', 'Nos vemos el sábado a las 11.', h: 'Ayer'),
      ],
      'fr': [
        Msg('sys', 'Servicio terminado'),
        Msg('p', 'Quedó lista. Cualquier cosa me escribe.', h: '12 sep'),
      ],
    };
    unread = {'rm': 2, 'hs': 1};
    home = [
      Casa(
        'Tinaco de 1,100 litros',
        'Última limpieza: marzo 2026',
        'Limpiar pronto',
        'amber',
      ),
      Casa(
        'Boiler de gas',
        'No enciende · 3 cotizaciones recibidas',
        'En solicitud',
        'navy',
      ),
      Casa(
        'Instalación eléctrica',
        'Lámpara de la sala · 12 sep 2026',
        'Al día',
        'green',
      ),
    ];
    remind = true;
    car = (m: 'Nissan Versa', y: '2018');
    contacts = [
      Contacto('Mamá', '771 234 5678', 0),
      Contacto('Carlos, mi hermano', '771 987 6543', 1),
    ];
    notifyListeners();
  }

  /// Reinicia lo del cliente (cuenta eliminada o «Borrar todo»).
  void resetAll() {
    saved = {};
    jobs = [];
    threads = {};
    unread = {};
    notifs = [];
    blocked = {};
    contacts = [];
    home = [];
    car = null;
    remind = false;
    tipDone = false;
    delAt = null;
    req = null;
    notifyListeners();
  }
}

class AvisoToast {
  AvisoToast(this.msg, this.accion, this.alAccion);
  final String msg;
  final String? accion;
  final VoidCallback? alAccion;
}

final maq = MaquetaEstado();
