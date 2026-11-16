import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/carga_k.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_cuenta.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String _catIcon(String id) => id == 'mec' ? 'car' : id == 'plo' ? 'drop' : 'bolt';

// ------------------------------------------------------------ pedir cotización

class SolicitarScreen extends StatefulWidget {
  const SolicitarScreen({super.key});
  @override
  State<SolicitarScreen> createState() => _SolicitarScreenState();
}

class _SolicitarScreenState extends State<SolicitarScreen> {
  late final TextEditingController _desc;
  late final TextEditingController _addr;

  @override
  void initState() {
    super.initState();
    maq.req ??= Solicitud();
    _desc = TextEditingController(text: maq.req!.desc);
    _addr = TextEditingController(text: maq.req!.addr);
  }

  @override
  void dispose() {
    _desc.dispose();
    _addr.dispose();
    super.dispose();
  }

  void _back() {
    final r = maq.req!;
    if (r.step > r.first) {
      r.step--;
      maq.refresh();
    } else {
      context.pop();
    }
  }

  Future<void> _fotos() async {
    final r = maq.req!;
    final f = await elegirFotos(max: 5 - r.photos.length);
    for (final p in f) {
      if (r.photos.length < 5) r.photos.add(p);
    }
    maq.refresh();
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final r = maq.req;
    if (r == null) return const Pg(noHeader: true, body: SizedBox());
    final k = kc(context);
    final c = r.cat != null ? cats[r.cat]! : null;
    final pr = r.pid != null ? provs[r.pid]! : null;
    final List<Widget> b = [Prog(r.step, 3)];
    Widget cta = const SizedBox();

    if (r.step == 1) {
      b.addAll([
        h1('¿Qué necesitas arreglar?'),
        stack([
          for (final id in ['mec', 'plo', 'ele'])
            ChoiceK(
              on: r.cat == id,
              onTap: () { r.cat = id; maq.refresh(); },
              title: cats[id]!.plain,
              sub: cats[id]!.hint,
              leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: cats[id]!.bg, borderRadius: BorderRadius.circular(14)), child: Icon(icn(_catIcon(id)), size: 26, color: cats[id]!.fg)),
            ),
        ], gap: 10),
        if (c != null) NoteK('blue', c.taller ? 'store' : 'house', c.taller ? 'Los autos se atienden en el taller. Verás su dirección en el mapa.' : 'Un técnico irá a tu casa. Tu dirección exacta solo se comparte con quien elijas.'),
      ]);
      cta = ctaCol([BtnK('Siguiente', r.cat == null ? null : () { r.step++; maq.refresh(); }), if (r.cat == null) helpT('Elige una opción para continuar')]);
    }
    if (r.step == 2) {
      final ok = r.desc.trim().length >= 8 && r.photos.isNotEmpty;
      b.addAll([
        stack([h1('Cuéntanos qué pasa'), mutT('Con tus palabras, como se lo dirías a un vecino.')], gap: 8),
        stack([labT('Toca una opción o escribe abajo'), chipsWrap([for (final t in c!.chips) ChipK(t, on: r.desc == t, onTap: () { r.desc = t; _desc.text = t; maq.refresh(); })])], gap: 8),
        FieldK(label: '¿Qué pasa y desde cuándo?', c: _desc, lines: 4, maxLen: 500, hint: 'Ej.: El boiler no prende desde ayer, hace clic pero no sale flama.', onChanged: (v) { r.desc = v; maq.refresh(); }, help: '${r.desc.length}/500'),
        stack([
          Row(spacing: 6, children: [labT('Fotos'), T('(mínimo 1)', size: 15, w: FontWeight.w700, color: k.amberInk)]),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(spacing: 10, children: [
            for (var i = 0; i < r.photos.length; i++) PhotoTile(path: r.photos[i], onRemove: () { r.photos.removeAt(i); maq.refresh(); }),
            if (r.photos.length < 5) AddPhoto(onTap: _fotos),
          ])),
          sMut('La foto le muestra al técnico qué herramientas y piezas necesita llevar, y te da un precio más exacto.'),
        ], gap: 8),
        CardK(
          onTap: () { context.push(RM.asistente, extra: {'texto': r.desc, 'cat': r.cat}); },
          child: Row(spacing: 12, children: [
            Icon(icn('sparkle'), color: k.navy),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 2, children: [bT('¿No sabes cómo explicarlo?'), sMut('El asistente te hace preguntas y lo escribe por ti')])),
            Icon(Icons.chevron_right, color: k.mut),
          ]),
        ),
      ]);
      cta = ctaCol([BtnK('Siguiente', ok ? () { r.step++; maq.refresh(); } : null), if (!ok) helpT(r.desc.trim().length < 8 ? 'Escribe qué pasa para continuar' : 'Agrega al menos una foto para continuar')]);
    }
    if (r.step == 3) {
      final days0 = days;
      final d = days0[r.day], s = slots[r.slot];
      final taller = c!.taller;
      final needAddr = !taller && maq.user.addr.isEmpty && r.addr.trim().length < 5;
      b.addAll([
        h1('¿Cuándo te queda bien?'),
        stack([
          labT('Día'),
          Row(spacing: 6, children: [
            for (var i = 0; i < days0.length; i++)
              Expanded(child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () { r.day = i; maq.refresh(); },
                child: Container(
                  constraints: const BoxConstraints(minHeight: 68),
                  decoration: BoxDecoration(color: r.day == i ? k.navyBg : k.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: r.day == i ? k.navyBg : k.line, width: 2)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, spacing: 2, children: [
                    T(days0[i].$1, size: 13, w: FontWeight.w800, color: r.day == i ? const Color(0xFFD5E3E8) : k.mut),
                    T('${days0[i].$2}', size: 20, w: FontWeight.w900, color: r.day == i ? Colors.white : k.ink),
                  ]),
                ),
              )),
          ]),
        ], gap: 8),
        stack([
          labT('Horario'),
          stack([for (var i = 0; i < slots.length; i++) ChoiceK(on: r.slot == i, minH: 58, onTap: () { r.slot = i; maq.refresh(); }, title: slots[i].$1, trailing: sMut(slots[i].$2))], gap: 8),
        ], gap: 8),
        if (taller)
          const NoteK('blue', 'store', 'Llevarás tu auto al taller que elijas. Verás su dirección al aceptar.')
        else
          stack([
            labT('¿Dónde?'),
            if (maq.user.addr.isNotEmpty)
              CardK(child: Row(spacing: 12, children: [
                Icon(icn('house')),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [bT('Casa · ${maq.user.addr}'), sMut('${maq.user.col}, Tula de Allende')])),
                LinkK('Cambiar', () => editarDatos(context)),
              ]))
            else
              FieldK(label: 'Tu calle y número', c: _addr, hint: 'Ej.: Calle Jacarandas 45', onChanged: (v) { r.addr = v; maq.refresh(); }, help: 'Colonia: ${maq.user.col}. La guardamos en tu cuenta para la próxima vez.'),
            const NoteK('green', 'lock', 'Los técnicos solo ven tu colonia. Tu dirección exacta se comparte únicamente con quien elijas.'),
          ], gap: 8),
        CardK(
          child: stack([
            labT('Tu solicitud'),
            T('«${r.desc}»'),
            sMut('${c.name} · ${taller ? 'En taller' : 'A domicilio'} · ${r.day == 0 ? 'Hoy' : '${d.$3} ${d.$2}'}, ${s.$3}${r.photos.isNotEmpty ? ' · ${r.photos.length} foto${r.photos.length > 1 ? 's' : ''}' : ''}'),
            if (pr != null)
              ChoiceK(on: r.also, check: true, minH: 64, onTap: () { r.also = !r.also; maq.refresh(); }, title: 'También pedir a otros expertos cerca', sub: 'Así comparas más cotizaciones'),
            T(pr != null ? (r.also ? 'Se enviará a ${pr.name} y a otros ${c.people} cerca, para que compares.' : 'Se enviará solo a ${pr.name}.') : 'Se enviará a ${c.people} verificados cerca de ti.', size: 14, w: FontWeight.w700, color: k.navy),
          ], gap: 12),
        ),
      ]);
      cta = ctaCol([
        BtnK('Enviar solicitud', needAddr ? null : () {
          final job = maq.sendReq();
          context.go(RM.enviada(job.id));
        }, icon: 'send'),
        if (needAddr) helpT('Escribe tu calle y número para que el experto sepa a dónde ir'),
      ]);
    }
    return Pg(
      title: 'Pedir cotización',
      sub: pr != null ? 'Para ${pr.name} y otros' : null,
      backLabel: 'Atrás',
      onBack: _back,
      body: stack(b, gap: 20),
      cta: cta,
    );
  });
}

// ------------------------------------------------------------ enviada

class EnviadaScreen extends StatelessWidget {
  const EnviadaScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final j = maq.job(id);
    if (j == null) return const Pg(noHeader: true, body: SizedBox());
    final c = cats[j.cat]!;
    final k = kc(context);
    final got = j.status != 'enviada';
    Widget step(int i, String t, String s, {bool done = false, bool now = false, bool last = false}) => IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: 14, children: [
        Column(children: [
          Container(width: 32, height: 32, alignment: Alignment.center, decoration: BoxDecoration(color: done ? k.green : now ? k.amber : k.line2, shape: BoxShape.circle), child: done ? const Icon(Icons.check, size: 18, color: Colors.white) : Text('$i', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 14, color: now ? const Color(0xFF231A15) : k.mut))),
          if (!last) Expanded(child: Container(width: 2, color: k.line2)),
        ]),
        Expanded(child: Padding(padding: EdgeInsets.only(bottom: last ? 0 : 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [bT(t), sMut(s)]))),
      ]),
    );
    return Pg(
      noHeader: true,
      body: stack([
        const SizedBox(height: 16),
        Column(spacing: 14, children: [
          const ExitoK(),
          h1('¡Listo! Tu solicitud va en camino', a: TextAlign.center),
          mutT(j.only && provs[j.target] != null ? 'La enviamos a ${provs[j.target]!.name}.' : 'La enviamos a ${c.people} cerca de ${maq.user.col}.', a: TextAlign.center),
        ]),
        _widen(context, j),
        if (!got) const Row(mainAxisAlignment: MainAxisAlignment.center, spacing: 8, children: [CargaK(tipo: TipoCarga.puntos, size: 44), Flexible(child: MensajesRotativos(mensajesBusqueda))]),
        AnimatedSize(duration: const Duration(milliseconds: 300), child: CardK(child: Column(children: [
          step(1, 'Enviaste tu solicitud', 'Hoy, ahora', done: true),
          step(2, got ? 'Llegaron ${j.quotes.length} cotizaciones' : 'Te llegan cotizaciones', got ? 'Ya puedes compararlas' : 'Casi siempre en menos de 30 minutos. Tu solicitud queda abierta 48 horas. Te avisamos.', done: got, now: !got),
          step(3, 'Comparas y eliges', 'Con precio, fecha y opiniones a la vista', now: got, last: true),
        ]))),
      ], gap: 16),
      cta: ctaCol([
        got ? BtnK('Ver cotizaciones', () => context.go(RM.comparar(j.id))) : BtnK('Ver mis trabajos', () => context.go('/actividad')),
        BtnK('Volver al inicio', () => context.go('/inicio'), kind: Bk.ghost),
      ]),
    );
  });
}

Widget stateK0(BuildContext c, IconData icon, Color bg, Color fg, String title, String text) => Column(spacing: 14, children: [
  if (icon == Icons.check) const ExitoK(size: 130) else Container(width: 110, height: 110, decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, size: 52, color: fg)),
  h1(title, a: TextAlign.center),
  mutT(text, a: TextAlign.center),
]);

Widget _widen(BuildContext context, Job j) => widenBlock(context, j);

Widget widenBlock(BuildContext context, Job j) {
  if (!j.silent || !j.only) return const SizedBox();
  final o = provs[j.target];
  final n = o?.first ?? 'El experto';
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(color: kc(context).amberSoft, borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 10, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: 10, children: [Icon(icn('clock'), color: kc(context).amberInk), Expanded(child: rich('**$n aún no responde.** Puedes seguir esperando o pedir también a otros expertos cerca.', size: 15, color: kc(context).amberInk))]),
      BtnK('Pedir también a otros', () => maq.widen(j.id), kind: Bk.sec, sm: true),
    ]),
  );
}

// ------------------------------------------------------------ comparar

class CompararScreen extends StatefulWidget {
  const CompararScreen({super.key, required this.id});
  final String id;
  @override
  State<CompararScreen> createState() => _CompararScreenState();
}

class _CompararScreenState extends State<CompararScreen> {
  int _o = 0;

  void _accept(Job j, String pid) {
    final pr = provs[pid]!;
    final q = j.quotes.firstWhere((x) => x.pid == pid);
    hoja<void>(context, (ctx, _) {
      final items = pr.taller
          ? const [('cal', 'Te apartamos la cita que te propuso'), ('pin', 'Verás la dirección exacta del taller')]
          : const [('lock', 'Le compartimos tu dirección y tu número solo a él'), ('shield', 'Te damos un código para cuando toque tu puerta')];
      return stack([
        sheetH(ctx, '¿Elegir a ${pr.first}?', big: true),
        Row(spacing: 12, children: [Av.prov(pr), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [bT(pr.name), sMut(q.price)])]),
        stack([for (final x in [...items, ('help', 'El pago lo acuerdas directo con él')]) Row(spacing: 12, children: [Icon(icn(x.$1)), Expanded(child: T(x.$2, size: 15.5, w: FontWeight.w700))])], gap: 8),
        BtnK('Sí, elegir a ${pr.first}', () {
          Navigator.pop(ctx);
          maq.accept(j.id, pid);
          context.pushReplacement(pr.taller ? RM.cita(j.id) : RM.visita(j.id));
          maq.toast(pr.taller ? 'Cita confirmada' : 'Visita confirmada');
        }),
        BtnK('Seguir comparando', () => Navigator.pop(ctx), kind: Bk.ghost),
      ]);
    });
  }

  Widget _cuerpo(BuildContext context) {
    final j = maq.job(widget.id);
    if (j == null) return const Pg(title: 'Cotizaciones', body: SizedBox());
    final c = cats[j.cat]!;
    final head = CardK(child: stack([h2(j.title), sMut('${c.short} · ${c.taller ? 'En taller' : 'A domicilio'} · ${maq.user.col}'), sMut('Prefieres: ${j.pref}')], gap: 6));
    if (j.quotes.isEmpty) {
      return Pg(
        title: 'Cotizaciones',
        body: stack([
          head,
          Center(child: Column(spacing: 14, children: [
            const CargaK(tipo: TipoCarga.buscando, size: 150),
            h2('Esperando cotizaciones'),
            const MensajesRotativos(mensajesBusqueda),
            mutT('Casi siempre llegan las primeras en menos de 30 minutos. Te avisamos; puedes salir de esta pantalla.', a: TextAlign.center),
          ])),
        ]),
        cta: BtnK('Volver al inicio', () => context.go('/inicio'), kind: Bk.ghost),
      );
    }
    final qs = [...j.quotes];
    final comp = qs.where((q) => q.kind != 'visita').toList();
    final minP = comp.isEmpty ? 0 : comp.map((q) => q.lo).reduce((a, b) => a < b ? a : b);
    final minS = qs.map((q) => q.soon).reduce((a, b) => a < b ? a : b);
    if (_o == 1) qs.sort((a, b) { final v = (a.kind == 'visita' ? 1 : 0) - (b.kind == 'visita' ? 1 : 0); return v != 0 ? v : a.lo.compareTo(b.lo); });
    if (_o == 2) qs.sort((a, b) => provs[b.pid]!.rate.compareTo(provs[a.pid]!.rate));
    if (_o == 3) qs.sort((a, b) => a.soon.compareTo(b.soon));
    final mixed = qs.any((q) => q.kind == 'visita') || qs.any((q) => q.kind != qs.first.kind);
    return Pg(
      title: 'Cotizaciones',
      sub: '${j.quotes.length} recibidas',
      body: stack([
        head,
        if (mixed) const NoteK('blue', 'help', '**Ojo:** no todas cuestan lo mismo por lo mismo. Una **visita** solo cubre ir a ver el trabajo; un **precio fijo** o **aproximado** es por el arreglo. Mira «Qué cubre» en cada tarjeta.'),
        stack([labT('Ordenar por'), chipsScroll([for (var i = 0; i < 4; i++) ChipK(const ['Recomendadas', 'Menor precio', 'Mejor calificadas', 'Más pronto'][i], on: _o == i, onTap: () => setState(() => _o = i))], pad: 0)], gap: 8),
        for (final q in qs) _quote(context, j, q, comp.length > 1 && q.kind != 'visita' && q.lo == minP, q.soon == minS),
        const NoteK('blue', 'help', 'Knock no cobra ni recibe pagos. El precio y la forma de pago los acuerdas directo con el técnico.'),
      ], gap: 14),
    );
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) => AnimatedSwitcher(
    duration: sinMovimiento(context) ? Duration.zero : const Duration(milliseconds: 420),
    child: KeyedSubtree(key: ValueKey(maq.job(widget.id)?.quotes.isEmpty), child: _cuerpo(context)),
  ));

  Widget _quote(BuildContext context, Job j, Quote q, bool best, bool soon) {
    final k = kc(context);
    final pr = provs[q.pid]!;
    final c = cats[j.cat]!;
    final open = maq.fold['qn${j.id}${q.pid}'] ?? false;
    final covers = q.kind == 'visita'
        ? '**Qué cubre:** solo ir a ver el trabajo. Después te manda el precio del arreglo.'
        : q.kind == 'fijo'
        ? '**Qué cubre:** el arreglo completo con mano de obra. Si hace falta una refacción, te la cotiza aparte.'
        : '**Qué cubre:** el arreglo completo (estimado). El precio final queda dentro del rango.';
    final rule = q.kind == 'visita' ? 'Primero ve el trabajo y te cotiza. Se descuenta si lo contratas; si no, pagas solo la visita.' : 'No pasará de ${money(qTope(q, j.cat))} sin tu aprobación.';
    return CardK(
      child: stack([
        InkWell(
          onTap: () => context.push(RM.experto(pr.id)),
          child: Row(spacing: 12, children: [
            Av.prov(pr, size: 50),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 2, children: [T(pr.name, size: 16.5, w: FontWeight.w900), Wrap(spacing: 6, children: [rateW(pr), sMut('(${pr.n}) · ${pr.km} km')])])),
            Icon(Icons.chevron_right, color: k.mut),
          ]),
        ),
        if (best || soon) Wrap(spacing: 6, children: [if (best) const Pill('Mejor precio', kind: 'green'), if (soon) const Pill('Puede ir más pronto', kind: 'amber')]),
        Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sMut(q.kind == 'fijo' ? 'Precio fijo' : q.kind == 'visita' ? 'Visita para cotizar' : 'Precio aproximado'),
            T(q.price, size: 26, w: FontWeight.w900, color: k.navy),
            sMut(rule),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [sMut('Puede ${c.taller ? 'recibirte' : 'ir'}'), bT(q.when)]),
        ]),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: k.navySoft, borderRadius: BorderRadius.circular(10)), child: rich(covers, size: 14, color: k.navy)),
        if (open) Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(color: k.bg, borderRadius: BorderRadius.circular(12)), child: T('“${q.note}”')),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () { maq.fold['qn${j.id}${q.pid}'] = !open; maq.refresh(); }, child: Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: T(open ? 'Ocultar su mensaje' : 'Leer su mensaje', size: 14.5, w: FontWeight.w800, color: k.navy)))),
        Row(spacing: 10, children: [
          BtnK('Preguntar', () { maq.openChat(pr.id); context.push(RM.chat(pr.id)); }, kind: Bk.ghost, sm: true, icon: 'chat', auto: true),
          Expanded(child: BtnK('Elegir a ${pr.first}', () => _accept(j, pr.id), kind: Bk.dark, sm: true)),
        ]),
      ], gap: 12),
    );
  }
}
