import 'dart:async';
import 'dart:ui';

import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/mapa_google.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ------------------------------------------------------------ tarjeta de experto

Widget provCard(BuildContext c, Prov o) {
  final k = kc(c);
  return CardK(
    onTap: () => c.push(RM.experto(o.id)),
    child: Row(spacing: 12, children: [
      Av.prov(o, size: 58),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 2, children: [
          Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
            T(o.name, size: 16.5, w: FontWeight.w900),
            if (o.rec) const Pill('Recomendado', kind: 'amber'),
          ]),
          sMut('${o.spec}${o.years > 0 ? ' · ${o.years} años' : ''}'),
          Wrap(spacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
            rateW(o),
            if (o.n > 0) sMut('(${o.n} opiniones)'),
            sMut('· a ${o.km} km'),
          ]),
          g4,
          Wrap(spacing: 6, runSpacing: 4, children: [
            Pill(whereTxt(o), icon: o.taller ? 'store' : 'house'),
            if (o.today) const Pill('Disponible hoy', kind: 'green'),
          ]),
        ]),
      ),
      Icon(Icons.chevron_right, color: k.mut),
    ]),
  );
}

// ------------------------------------------------------------ buscar

class BuscarScreen extends StatefulWidget {
  const BuscarScreen({super.key, this.focus = false});
  final bool focus;
  @override
  State<BuscarScreen> createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  final _c = TextEditingController();
  String? _pin;

  @override
  void initState() {
    super.initState();
    _c.text = maq.sQ;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _doSearch() {
    final q = _c.text.trim();
    maq.sQ = q;
    if (q.isEmpty) return;
    final cat = guessCat(q);
    if (cat != null) {
      maq.sCat = cat;
      maq.sNone = false;
    } else {
      maq.sNone = true;
    }
    maq.refresh();
  }

  void _filtros() {
    hoja<void>(context, (ctx, set) {
      final f = maq.sF;
      const defs = [('dist', 'A menos de 5 km'), ('cal', '4.5 estrellas o más'), ('tipo', 'Que vaya a mi casa'), ('hoy', 'Disponible hoy')];
      return stack([
        sheetH(ctx, 'Filtros'),
        stack([
          for (final d in defs) ChoiceK(on: f[d.$1]!, check: true, title: d.$2, minH: 64, onTap: () { f[d.$1] = !f[d.$1]!; maq.refresh(); }),
        ], gap: 8),
        BtnK('Ver ${maq.results().length} resultados', () => Navigator.pop(ctx)),
        if (maq.nFilters > 0) BtnK('Quitar filtros', () { for (final x in f.keys) { f[x] = false; } maq.refresh(); Navigator.pop(ctx); }, kind: Bk.ghost),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final c = cats[maq.sCat]!;
    final list = maq.results();
    final top = Column(children: [
      Container(
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: k.surface,
        child: Row(spacing: 6, children: [
          InkWell(onTap: () => context.pop(), borderRadius: BorderRadius.circular(24), child: Padding(padding: const EdgeInsets.all(8), child: Icon(Icons.chevron_left, size: 28, color: k.navy))),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: k.bg, borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.only(left: 14, right: 6),
              child: Row(children: [
                Icon(Icons.search, size: 20, color: k.mut),
                g8,
                Expanded(
                  child: TextField(
                    controller: _c,
                    autofocus: widget.focus,
                    textInputAction: TextInputAction.search,
                    onChanged: (v) { maq.sQ = v; setState(() {}); },
                    onSubmitted: (_) => _doSearch(),
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: k.ink),
                    decoration: InputDecoration(border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, filled: false, hintText: tr('Ej.: boiler, frenos, un contacto'), hintStyle: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: k.mut.withAlpha(160))),
                  ),
                ),
                if (_c.text.isNotEmpty) IconButton(onPressed: () { _c.clear(); maq.sQ = ''; maq.sNone = false; maq.refresh(); }, icon: Icon(Icons.close, size: 18, color: k.mut), tooltip: tr('Borrar')),
              ]),
            ),
          ),
        ]),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
        decoration: BoxDecoration(color: k.surface, border: Border(bottom: BorderSide(color: k.line2))),
        width: double.infinity,
        child: chipsScroll([
          for (final id in ['mec', 'plo', 'ele'])
            ChipK(cats[id]!.short, icon: cats[id]!.id == 'mec' ? 'car' : cats[id]!.id == 'plo' ? 'drop' : 'bolt', on: !maq.sNone && maq.sCat == id, onTap: () { maq.sCat = id; maq.sNone = false; maq.sQ = ''; _c.clear(); maq.refresh(); }),
        ]),
      ),
    ]);
    Widget body;
    if (maq.sNone) {
      body = emptyK('search', 'No encontramos «${maq.sQ}»', 'Por ahora Knock ayuda con autos, agua y luz. Elige uno o cuéntale tu problema al asistente.', BtnK('Contarle mi problema al asistente', () { maq.asis = Asis(); context.push(RM.asistente, extra: maq.sQ); }, icon: 'chat'));
    } else {
      final people = list.length == 1 ? c.single : c.people;
      body = SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
            child: Row(children: [
              Expanded(child: h3('${list.length} $people cerca')),
              ChipK('Filtros${maq.nFilters > 0 ? ' (${maq.nFilters})' : ''}', icon: 'filter', on: maq.nFilters > 0, onTap: _filtros),
              g8,
              ChipK(maq.sMapView ? 'Lista' : 'Mapa', icon: maq.sMapView ? 'list' : 'map', onTap: () { maq.sMapView = !maq.sMapView; maq.refresh(); }),
            ]),
          ),
          if (list.isEmpty)
            SizedBox(height: 380, child: emptyK('filter', 'Nadie cumple todos los filtros', 'Prueba quitando alguno para ver más opciones.', BtnK('Quitar filtros', () { for (final x in maq.sF.keys) { maq.sF[x] = false; } maq.refresh(); }, kind: Bk.sec, auto: true)))
          else if (maq.sMapView)
            _miniMapa(context, list)
          else
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: CargaInicial(clave: 'buscar', esqueleto: const EsqueletoLista(n: 4), child: stack(escalona([for (final o in list) provCard(context, o)]), gap: 12))),
        ]),
      );
    }
    return Pg(noHeader: true, top: top, body: body, scroll: false);
  });

  final _ctrlMapa = ControlMapaGoogle();

  Widget _miniMapa(BuildContext context, List<Prov> list) {
    final sel = provs[_pin] != null && list.any((o) => o.id == _pin) ? provs[_pin]! : list.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 470,
          child: Stack(children: [
            Positioned.fill(child: MapaGoogleKnock(control: _ctrlMapa, expertos: list, seleccionado: sel.id, alTocarExperto: (o) => setState(() => _pin = o.id))),
            Positioned(left: 10, right: 10, bottom: 10, child: provCard(context, sel)),
          ]),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------ perfil del experto

Widget reviewW(BuildContext c, Review r, Prov o) {
  final k = kc(c);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 8, children: [
      Row(spacing: 10, children: [
        Av(ini: r.ini, color: const Color(0xFF64748B), size: 40),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [bT(r.n), sMut(r.w)])),
      ]),
      Row(spacing: 8, children: [Stars(r.s), const Pill('Servicio verificado', kind: 'green', icon: 'check', size: 12)]),
      T(r.t),
      if (r.ph) Row(spacing: 10, children: const [PhotoTile(label: 'Foto', color: Color(0xFF4F6F95)), PhotoTile(label: 'Foto', color: Color(0xFF6F8DB0))]),
      if (r.reply != null)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: k.bg, borderRadius: BorderRadius.circular(12)),
          child: rich('**Respuesta de ${o.taller ? 'el taller' : o.first}:** ${r.reply}', size: 14.5, w: FontWeight.w400),
        ),
    ]),
  );
}

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key, required this.id});
  final String id;
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  void _whyVerified() {
    hoja<void>(context, (ctx, _) => stack([
      sheetH(ctx, '¿Qué significa «identidad verificada»?'),
      stack([
        for (final x in const [('idcard', 'Mostró su INE vigente'), ('selfie', 'Su selfie coincide con la foto de su INE'), ('phone', 'Confirmó su número de celular')])
          Row(spacing: 12, children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: kc(ctx).greenSoft, borderRadius: BorderRadius.circular(12)), child: Icon(icn(x.$1), color: kc(ctx).green)),
            Expanded(child: T(x.$2, w: FontWeight.w800)),
          ]),
      ], gap: 12),
      const NoteK('blue', 'house', 'En visitas a tu casa recibirás un **código de 4 números**. Si quien llega no lo sabe, no abras.'),
      BtnK('Entendido', () => Navigator.pop(ctx), kind: Bk.sec),
    ]));
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final o = provs[widget.id]!;
    final c = cats[o.cat]!;
    final k = kc(context);
    final auth = hayCuenta(context);
    final saved = auth && (maq.saved[o.id] ?? false);
    final first = o.first;
    final about = o.about;
    final short = about.length > 110 ? '${about.substring(0, about.lastIndexOf(' ', 105))}…' : about;
    final aboutOpen = maq.fold['ab-${o.id}'] ?? false;

    final header = Column(spacing: 12, children: [
      Av.prov(o, size: 92),
      Column(spacing: 4, children: [
        T(o.name, size: 24, w: FontWeight.w900, align: TextAlign.center),
        sMut('${c.name}${o.owner != null ? ' · ${o.owner}' : ''}', size: 16, a: TextAlign.center),
        Wrap(alignment: WrapAlignment.center, spacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
          rateW(o, size: 15),
          if (o.n > 0) sMut('${o.n} opiniones', size: 15),
          sMut('· a ${o.km} km', size: 15),
        ]),
      ]),
      Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 6, children: [
        InkWell(borderRadius: BorderRadius.circular(999), onTap: _whyVerified, child: const Pill('Identidad verificada', kind: 'green', icon: 'shield', size: 14)),
        Pill(whereTxt(o), icon: o.taller ? 'store' : 'house', size: 14),
      ]),
      Row(spacing: 8, children: [
        for (final f in [(o.years > 0 ? '${o.years} años' : 'Nuevo', o.years > 0 ? 'de experiencia' : 'en Knock'), ('${o.jobs}', 'trabajos con Knock'), (o.resp, 'tarda en responder')])
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(color: k.bg, borderRadius: BorderRadius.circular(14)),
            child: Column(spacing: 2, children: [T(f.$1, size: 17, w: FontWeight.w900, align: TextAlign.center), T(f.$2, size: 12.5, w: FontWeight.w700, color: k.mut, align: TextAlign.center)]),
          )),
      ]),
    ]);

    final aboutCard = CardK(
      child: stack([
        h3('¿Qué hace?'),
        about.length > 110 && auth
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                T(aboutOpen ? about : short),
                InkWell(onTap: () { maq.fold['ab-${o.id}'] = !aboutOpen; maq.refresh(); }, child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: T(aboutOpen ? 'Ver menos' : 'Ver más', size: 14.5, w: FontWeight.w800, color: k.navy))),
              ])
            : T(about.length > 110 && !auth ? short : about),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: T(o.svcs.first[0], w: FontWeight.w800)),
          T('desde ${o.svcs.first[2]}', w: FontWeight.w900, color: k.navy),
        ]),
      ], gap: 10),
    );

    final List<Widget> cards;
    if (!auth) {
      final ghost = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: IgnorePointer(child: stack([
          CardK(child: stack([h3('Servicios y precios'), for (final t in const ['Revisión y diagnóstico', 'Servicio de ejemplo', 'Otro servicio']) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: T(t, w: FontWeight.w800)), T(r'desde $000', w: FontWeight.w900, color: k.navy)])], gap: 8)),
          CardK(child: stack([h3('Lo que dicen sus clientes'), T('★★★★★ ★ 4.8 de 5'), T('Muy buen servicio, llegó a tiempo y dejó todo limpio. Lo recomiendo con confianza.'), T('Resolvió el problema el mismo día y explicó cada paso con claridad.')], gap: 6)),
          CardK(child: stack([h3(o.taller ? '¿Dónde está?' : '¿Llega a tu colonia?'), chipsWrap(const [Pill('Colonia de ejemplo', kind: 'gray'), Pill('Otra colonia', kind: 'green'), Pill('Zona centro', kind: 'gray')])], gap: 8)),
          CardK(child: stack([h3('Fotos de sus trabajos'), Row(spacing: 10, children: const [PhotoTile(label: 'Foto', color: Color(0xFF4F6F95)), PhotoTile(label: 'Foto', color: Color(0xFF7A5230)), PhotoTile(label: 'Foto', color: Color(0xFF365F4A))])])),
        ], gap: 12)),
      );
      cards = [
        aboutCard,
        Stack(alignment: Alignment.center, children: [
          ghost,
          Positioned.fill(child: ColoredBox(color: k.bg.withAlpha(90))),
          CardK(
            child: Column(spacing: 10, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, spacing: 6, children: [Icon(icn('shield'), size: 18, color: k.ink), h3('Ver el perfil completo')]),
              sMut(o.taller ? 'Servicios y precios, opiniones, ubicación y horario y fotos de sus trabajos.' : 'Servicios y precios, opiniones, colonias que atiende y fotos de sus trabajos.', a: TextAlign.center),
              BtnK('Iniciar sesión para ver más', () => pedirCuenta(context, RM.experto(o.id)), sm: true),
            ]),
          ),
        ]),
      ];
    } else {
      final cheapest = (o.svcs.map((s) => int.parse(s[2].replaceAll(RegExp(r'\D'), ''))).toList()..sort()).first;
      cards = [
        aboutCard,
        FoldK(k: 'sv-${o.id}', title: 'Servicios y precios', summary: '${o.svcs.length} servicios · desde ${money(cheapest)}', icon: 'doc', child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < o.svcs.length; i++)
            Container(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 12, bottom: 12),
              decoration: i == 0 ? null : BoxDecoration(border: Border(top: BorderSide(color: k.line2))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: 12, children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [T(o.svcs[i][0], w: FontWeight.w800), sMut(o.svcs[i][1], size: 13.5)])),
                T('desde ${o.svcs[i][2]}', w: FontWeight.w900, color: k.navy),
              ]),
            ),
          sMut('Son precios de referencia. El precio final lo acuerdas directo con ${o.taller ? 'el taller' : first}.'),
        ])),
        FoldK(k: 'op-${o.id}', title: 'Lo que dicen sus clientes', summary: o.n > 0 ? '★ ${o.rate.toStringAsFixed(1)} de 5 · ${o.n} opiniones' : 'Aún sin opiniones', icon: 'star', open0: true, child: o.n > 0
            ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                for (final r in o.revs.take(2)) reviewW(context, r, o),
                BtnK('Ver las ${o.n} opiniones', () => context.push(RM.opiniones(o.id)), kind: Bk.sec, sm: true),
              ])
            : mutT('Todavía no tiene opiniones. Las primeras llegan después de su primer servicio por Knock.')),
        if (o.taller)
          FoldK(k: 'lc-${o.id}', title: '¿Dónde está?', summary: '${o.addr} · ${o.open ? 'abierto ahora' : 'cerrado ahora'}', icon: 'pin', child: stack([
            Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: 12, children: [Icon(icn('pin')), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [bT(o.addr), sMut('${o.addr2} · a ${o.km} km')]))]),
            _horas(context, o),
            BtnK('Cómo llegar', () => maq.toast('Abriendo el mapa con la ruta…'), kind: Bk.sec, sm: true, icon: 'route'),
          ], gap: 12))
        else
          FoldK(k: 'lc-${o.id}', title: '¿Llega a tu colonia?', summary: o.zone.contains(maq.user.col) ? 'Sí, llega a ${maq.user.col}' : 'Revisa las colonias que atiende', icon: 'house', child: stack([
            T('Va a domicilio hasta ${o.radius} de su base. Atiende:'),
            chipsWrap([for (final z in o.zone) Pill(z, kind: z == maq.user.col ? 'green' : 'gray', icon: z == maq.user.col ? 'check' : null, size: 14)]),
            _horas(context, o),
          ], gap: 12)),
        if (o.photos.isNotEmpty)
          FoldK(k: 'ph-${o.id}', title: 'Fotos de sus trabajos', summary: '${o.photos.length} ${o.photos.length == 1 ? 'foto' : 'fotos'}', icon: 'camera', child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(spacing: 10, children: [for (final p in o.photos) PhotoTile(label: p.$1, color: p.$2)]))),
      ];
    }

    final right = Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ChipK(saved ? 'Guardado' : 'Guardar', icon: 'heart', on: saved, onTap: () {
        if (!pedirCuenta(context, RM.experto(o.id))) return;
        maq.toggleSave(o.id);
        maq.toast(saved ? 'Quitado de tus técnicos de confianza' : 'Guardado en tus técnicos de confianza', accion: saved ? null : 'Ver', alAccion: () => context.push(RM.confianza));
      }),
    );
    return Pg(
      right: right,
      body: stack([header, ...cards], gap: 12),
      cta: Row(spacing: 10, children: [
        BtnK('Mensaje', () { if (!pedirCuenta(context, RM.chat(o.id))) return; maq.openChat(o.id); context.push(RM.chat(o.id)); }, auto: true, kind: Bk.sec, icon: 'chat'),
        Expanded(child: BtnK('Pedir cotización', () {
          maq.startReq(cat: o.cat, pid: o.id);
          if (!pedirCuenta(context, RM.solicitar)) return;
          context.push(RM.solicitar);
        })),
      ]),
    );
  });

  Widget _horas(BuildContext context, Prov o) => Column(spacing: 6, children: [
    for (final h in o.hours) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [T(h[0], size: 15, w: FontWeight.w700), T(h[1], size: 15, w: FontWeight.w700)]),
  ]);
}

// ------------------------------------------------------------ opiniones

class OpinionesScreen extends StatefulWidget {
  const OpinionesScreen({super.key, required this.id});
  final String id;
  @override
  State<OpinionesScreen> createState() => _OpinionesScreenState();
}

class _OpinionesScreenState extends State<OpinionesScreen> {
  String _f = 'todas';
  @override
  Widget build(BuildContext context) {
    final o = provs[widget.id]!;
    final k = kc(context);
    if (o.n == 0) return Pg(title: 'Opiniones', sub: o.name, body: emptyK('star', 'Aún sin opiniones', 'Las primeras llegan después de su primer servicio por Knock.'), scroll: false);
    final tot = o.dist.fold(0, (a, b) => a + b);
    final revs = o.revs.where((r) => _f == 'todas' || (_f == 'fotos' && r.ph) || (_f == 'cinco' && r.s == 5) || (_f == 'criticas' && r.s <= 4)).toList();
    return Pg(
      title: 'Opiniones',
      sub: o.name,
      body: stack([
        CardK(child: Row(spacing: 18, children: [
          Column(spacing: 2, children: [T(o.rate.toStringAsFixed(1), size: 40, w: FontWeight.w900), Stars(o.rate.round()), sMut('${o.n} opiniones')]),
          Expanded(child: Column(spacing: 6, children: [
            for (var i = 0; i < 5; i++)
              Row(spacing: 8, children: [
                SizedBox(width: 26, child: sMut('${5 - i}★')),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: o.dist[i] / tot, minHeight: 8, backgroundColor: k.line2, color: k.amber))),
              ]),
          ])),
        ])),
        FoldK(k: 'cr-${o.id}', title: 'Calificación por partes', summary: 'Puntualidad ${o.crit[0].toStringAsFixed(1)} · Calidad ${o.crit[1].toStringAsFixed(1)} · …', icon: 'list', child: GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.2, children: [
          for (var i = 0; i < 4; i++)
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: k.bg, borderRadius: BorderRadius.circular(14)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [T('${o.crit[i].toStringAsFixed(1)} ★', size: 17, w: FontWeight.w900), sMut(const ['Puntualidad', 'Calidad', 'Precio justo', 'Trato'][i], size: 12.5)])),
        ])),
        NoteK('green', 'shield', 'Solo opinan personas que tuvieron un servicio real con ${o.taller ? 'este taller' : o.first} a través de Knock.'),
        chipsScroll([
          for (final x in const [('todas', 'Todas'), ('fotos', 'Con fotos'), ('cinco', '5 estrellas'), ('criticas', 'Críticas')]) ChipK(x.$2, on: _f == x.$1, onTap: () => setState(() => _f = x.$1)),
        ], pad: 0),
        if (revs.isNotEmpty) CardK(child: Column(children: [for (var i = 0; i < revs.length; i++) Container(decoration: i == 0 ? null : BoxDecoration(border: Border(top: BorderSide(color: k.line2))), child: reviewW(context, revs[i], o))])) else CardK(child: T('No hay opiniones con este filtro.', w: FontWeight.w700, color: k.mut, align: TextAlign.center)),
      ]),
    );
  }
}

// ------------------------------------------------------------ asistente

class AsistenteScreen extends StatefulWidget {
  const AsistenteScreen({super.key, this.texto, this.cat});
  final String? texto, cat;
  @override
  State<AsistenteScreen> createState() => _AsistenteScreenState();
}

class _AsistenteScreenState extends State<AsistenteScreen> {
  final _c = TextEditingController();
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    final a = maq.asis = Asis();
    a.cat = widget.cat;
    a.msgs.add(AsisMsg(false, '${hayCuenta(context) && maq.user.first.isNotEmpty ? '¡Hola, ${maq.user.first}! ' : '¡Hola! '}Cuéntame con tus palabras qué necesitas arreglar. Yo armo la solicitud por ti.'));
    if (widget.texto != null && widget.texto!.trim().length > 2) {
      Timer(const Duration(milliseconds: 300), () => _user(widget.texto!.trim()));
    }
  }

  @override
  void dispose() {
    _c.dispose();
    _sc.dispose();
    super.dispose();
  }

  void _end() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_sc.hasClients) _sc.animateTo(_sc.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  });

  void _bot(String t) {
    final a = maq.asis;
    a.typing = true;
    maq.refresh();
    _end();
    Timer(const Duration(milliseconds: 700), () {
      a.typing = false;
      a.msgs.add(AsisMsg(false, t));
      if (mounted) maq.refresh();
      _end();
    });
  }

  void _user(String t) {
    final a = maq.asis;
    if (t.isEmpty) return;
    a.msgs.add(AsisMsg(true, t));
    _c.clear();
    maq.refresh();
    _end();
    if (a.stage == 0) {
      a.text = t;
      a.cat ??= guessCat(t);
      if (a.cat == null) { a.stage = 0.5; _bot('¿Es algo de tu auto, del agua o de la luz?'); return; }
      a.stage = 1;
      _bot('Entiendo. ¿Desde cuándo pasa?');
      return;
    }
    if (a.stage == 0.5) {
      a.cat = guessCat(t) ?? (t.contains('auto') ? 'mec' : t.contains('agua') ? 'plo' : 'ele');
      a.stage = 1;
      _bot('Perfecto. ¿Desde cuándo pasa?');
      return;
    }
    if (a.stage == 1) {
      a.since = t;
      a.stage = 2;
      _bot('Gracias. Necesito al menos una foto: así el técnico ve qué herramientas y piezas debe llevar.');
      return;
    }
    if (a.stage == 2) _bot('Para armar tu solicitud necesito una foto del problema. Toca «Subir foto».');
  }

  Future<void> _foto() async {
    final f = await elegirFotos(varias: false);
    if (f.isEmpty) return;
    final a = maq.asis;
    a.photos.add(f.first);
    a.msgs.add(AsisMsg(true, '📷 Foto del problema', img: f.first));
    maq.refresh();
    _end();
    a.stage = 3;
    final c = cats[a.cat]!;
    _bot('Listo. Esto es un trabajo de ${c.name}${c.taller ? ' en taller' : ' a domicilio'}. Te armé la solicitud:');
  }

  void _use(int step) {
    final a = maq.asis;
    final desc = '${a.text}. Pasa ${a.since.toLowerCase()}.';
    maq.startReq(cat: a.cat, desc: desc, photos: a.photos, step: step);
    if (!pedirCuenta(context, RM.solicitar)) return;
    context.push(RM.solicitar);
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final a = maq.asis;
    final k = kc(context);
    List<String> chips = const [];
    if (a.stage == 0) chips = const ['Mi boiler no enciende', 'Tengo una fuga de agua', 'Mi auto hace ruido al frenar', 'Un contacto no sirve'];
    if (a.stage == 0.5) chips = const ['De mi auto', 'Del agua', 'De la luz'];
    if (a.stage == 1) chips = const ['Desde hoy', 'Desde ayer', 'Desde hace días'];
    final msgs = <Widget>[
      for (final m in a.msgs) _burbuja(context, m),
      if (a.typing) _burbuja(context, AsisMsg(false, '…')),
      if (a.stage == 3 && !a.typing) _resumen(context, a),
    ];
    return Pg(
      title: 'Asistente Knock',
      sub: 'Asistente automático · no es una persona',
      scroll: false,
      body: ListView(controller: _sc, padding: const EdgeInsets.all(16), children: [for (final w in msgs) Padding(padding: const EdgeInsets.only(bottom: 10), child: w)]),
      foot: Container(
        color: k.surface,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (a.stage == 2 && !a.typing) Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 0), child: Align(alignment: Alignment.centerLeft, child: BtnK('Subir foto', _foto, sm: true, auto: true, icon: 'camera'))),
          if (chips.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(spacing: 8, children: [for (final t in chips) _quick(context, t, () => _user(t))]))),
          if (a.stage < 3) _composer(context, 'Escribe aquí…', _c, () => _user(_c.text.trim())),
          if (a.stage >= 3) SizedBox(height: MediaQuery.of(context).padding.bottom),
        ]),
      ),
    );
  });

  Widget _resumen(BuildContext context, Asis a) {
    final c = cats[a.cat]!;
    return CardK(
      child: stack([
        Row(spacing: 8, children: [Pill(c.name, icon: c.id == 'mec' ? 'car' : c.id == 'plo' ? 'drop' : 'bolt'), Pill(c.taller ? 'En taller' : 'A domicilio', kind: 'gray')]),
        h3(a.text),
        sMut('Pasa ${a.since.toLowerCase()} · ${a.photos.length} foto${a.photos.length > 1 ? 's' : ''}'),
        BtnK('Revisar y enviar', () => _use(3)),
        BtnK('Cambiar algo', () => _use(2), kind: Bk.sec, sm: true),
        if (RegExp('boiler|gas|calentador', caseSensitive: false).hasMatch(a.text)) const NoteK('amber', 'flag', 'Si algún día hueles a gas: cierra la llave, abre ventanas y no prendas luces. Llama al 911.'),
      ], gap: 10),
    );
  }
}

Widget _burbuja(BuildContext context, AsisMsg m) {
  final k = kc(context);
  return Align(
    alignment: m.me ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: m.me ? k.navyBg : k.surface, borderRadius: BorderRadius.only(topLeft: const Radius.circular(18), topRight: const Radius.circular(18), bottomLeft: Radius.circular(m.me ? 18 : 6), bottomRight: Radius.circular(m.me ? 6 : 18))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        if (m.img != null) Padding(padding: const EdgeInsets.only(bottom: 4), child: ClipRRect(borderRadius: BorderRadius.circular(10), child: PhotoTile(path: m.img, size: 140))),
        Text(tr(m.t), style: TextStyle(fontFamily: 'Nunito', fontSize: 15.5, height: 1.4, fontWeight: FontWeight.w600, color: m.me ? Colors.white : k.ink)),
      ]),
    ),
  );
}

Widget _quick(BuildContext c, String t, VoidCallback onTap) {
  final k = kc(c);
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(19),
    child: Container(
      constraints: const BoxConstraints(minHeight: 38),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: k.surface, borderRadius: BorderRadius.circular(19), border: Border.all(color: k.line, width: 1.5)),
      child: Text(tr(t), style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800, fontSize: 14, color: k.navy)),
    ),
  );
}

Widget _composer(BuildContext c, String hint, TextEditingController ctl, VoidCallback onSend) {
  final k = kc(c);
  return Container(
    padding: EdgeInsets.fromLTRB(12, 10, 12, 12 + MediaQuery.of(c).padding.bottom),
    decoration: BoxDecoration(color: k.surface, border: Border(top: BorderSide(color: k.line2))),
    child: Row(spacing: 8, children: [
      Expanded(
        child: TextField(
          controller: ctl,
          onSubmitted: (_) => onSend(),
          style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600, color: k.ink),
          decoration: InputDecoration(
            hintText: tr(hint),
            hintStyle: TextStyle(fontFamily: 'Nunito', color: k.mut.withAlpha(160)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: k.line, width: 2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: k.navy, width: 2)),
          ),
        ),
      ),
      Material(color: k.amber, shape: const CircleBorder(), child: InkWell(customBorder: const CircleBorder(), onTap: onSend, child: const SizedBox(width: 48, height: 48, child: Icon(Icons.send, color: Color(0xFF231A15), size: 22)))),
    ]),
  );
}

Widget composerK(BuildContext c, String hint, TextEditingController ctl, VoidCallback onSend) => _composer(c, hint, ctl, onSend);
Widget quickK(BuildContext c, String t, VoidCallback onTap) => _quick(c, t, onTap);
Widget burbujaK(BuildContext c, AsisMsg m) => _burbuja(c, m);
