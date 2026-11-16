import 'dart:async';

import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String _catIcon(String id) => id == 'mec'
    ? 'car'
    : id == 'plo'
    ? 'drop'
    : 'bolt';

/// Pestaña Explorar (`js/explorar.js`): servicios populares, trabajos reales,
/// expertos cercanos, mejor calificados e ideas.
class ExplorarMaqueta extends StatelessWidget {
  const ExplorarMaqueta({super.key});

  void _pedir(BuildContext context, String cat, String desc) {
    maq.startReq(cat: cat, desc: desc);
    if (pedirCuenta(context, RM.solicitar)) {
      unawaited(context.push(RM.solicitar));
    }
  }

  @override
  Widget build(BuildContext context) => MaqBuilder((context) {
    final k = kc(context);
    final cat = maq.exCat;
    final svcs = exServices.where((s) => cat == null || s.$1 == cat).toList();
    final pros = provs.values
        .where((o) => cat == null || o.cat == cat)
        .toList();
    // fotos de trabajos mezcladas para que no queden por técnico
    final demo = <(Prov, String, Color)>[];
    for (final o in pros) {
      for (final p in o.photos) {
        demo.add((o, p.$1, p.$2));
      }
    }
    final works = <(Prov, String, Color)>[];
    var i = 0;
    while (demo.isNotEmpty) {
      works.add(demo.removeAt((i++ * 3) % demo.length));
    }
    final near = [...pros]..sort((a, b) => a.km.compareTo(b.km));
    final top3 = pros.where((o) => o.n > 0).toList()
      ..sort((a, b) {
        final r = b.rate.compareTo(a.rate);
        return r != 0 ? r : b.n.compareTo(a.n);
      });
    final tips = exTips.where((x) => cat == null || x.$1 == cat).toList();

    final top = Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 0, 10),
      decoration: BoxDecoration(
        color: k.surface,
        border: Border(bottom: BorderSide(color: k.line2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Material(
              color: k.bg,
              shape: StadiumBorder(side: BorderSide(color: k.line)),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: () => context.push(RM.buscar, extra: 'focus'),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 52),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      spacing: 12,
                      children: [
                        Icon(Icons.search, color: k.mut),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const T(
                                'Busca un experto cerca de ti',
                                size: 15.5,
                                w: FontWeight.w900,
                              ),
                              T(
                                'Mecánica · Plomería · Electricidad',
                                size: 13,
                                w: FontWeight.w700,
                                color: k.mut,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                ChipK(
                  'Todo',
                  on: cat == null,
                  onTap: () {
                    maq.exCat = null;
                    maq.refresh();
                  },
                ),
                for (final id in ['mec', 'plo', 'ele'])
                  ChipK(
                    cats[id]!.plain,
                    icon: _catIcon(id),
                    on: cat == id,
                    onTap: () {
                      maq.exCat = id;
                      maq.refresh();
                    },
                  ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );

    Widget sec(String title, Widget child, {String? sub}) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [h2(title), if (sub != null) sMut(sub)],
        ),
        child,
      ],
    );
    Widget row(List<Widget> c) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(spacing: 12, children: c),
    );

    Widget pro(Prov o) => InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.push(RM.experto(o.id)),
      child: Container(
        width: 176,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: k.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F1E3A5F),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Color(0x0D1E3A5F),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Av.prov(o),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: T(o.name, size: 15.5, w: FontWeight.w900, maxLines: 2),
            ),
            sMut('${cats[o.cat]!.short} · ${whereTxt(o)}', size: 13),
            Wrap(
              spacing: 6,
              children: [
                rateW(o, size: 13),
                sMut('· ${o.km.toStringAsFixed(1)} km', size: 13),
              ],
            ),
          ],
        ),
      ),
    );

    const heights = [150.0, 190.0, 130.0, 170.0, 200.0, 140.0];
    Widget tile(int idx) {
      final w = works[idx];
      final c = cats[w.$1.cat]!;
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(RM.experto(w.$1.id)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: k.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x141E3A5F),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: heights[idx % 6],
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [w.$3, w.$3.withAlpha(0xCC)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icn(_catIcon(c.id)),
                      color: Colors.white.withAlpha(220),
                    ),
                    Text(
                      tr(w.$2),
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    T(w.$1.name, size: 13.5, w: FontWeight.w900),
                    sMut(
                      '${w.$1.n > 0 ? '★ ${w.$1.rate.toStringAsFixed(1)}' : 'Nuevo'} · ${c.short}',
                      size: 12.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final nW = works.length > 12 ? 12 : works.length;
    final colA = [for (var n = 0; n < nW; n += 2) tile(n)];
    final colB = [for (var n = 1; n < nW; n += 2) tile(n)];

    return PgTab(
      title: 'Explorar',
      top: top,
      fab: msgFab(context),
      body: stack([
        sec(
          'Servicios populares',
          row([
            for (final s in svcs)
              Builder(
                builder: (_) {
                  final c = cats[s.$1]!;
                  return InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => _pedir(context, s.$1, s.$5),
                    child: Container(
                      width: 156,
                      constraints: const BoxConstraints(minHeight: 150),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: c.bg,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(165),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(icn(_catIcon(c.id)), color: c.fg),
                          ),
                          Text(
                            tr(s.$2),
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                              color: c.fg,
                            ),
                          ),
                          Text(
                            tr(s.$3),
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: c.fg.withAlpha(205),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(165),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${tr('desde')} \$${s.$4}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w900,
                                color: c.fg,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ]),
        ),
        if (works.isNotEmpty)
          sec(
            'Trabajos reales',
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Expanded(child: Column(children: colA)),
                Expanded(child: Column(children: colB)),
              ],
            ),
            sub: 'de expertos cerca de ti',
          ),
        if (near.isNotEmpty)
          sec('Cerca de ti', row([for (final o in near.take(8)) pro(o)])),
        if (top3.isNotEmpty)
          sec('Mejor calificados', row([for (final o in top3.take(8)) pro(o)])),
        if (tips.isNotEmpty)
          sec(
            'Ideas para tu casa y tu auto',
            stack([
              for (final x in tips)
                CardK(
                  child: stack([
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cats[x.$1]!.bg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(x.$2, color: cats[x.$1]!.fg),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [h3(x.$3), sMut(x.$4)],
                          ),
                        ),
                      ],
                    ),
                    BtnK(
                      'Pedir cotización',
                      () => _pedir(context, x.$1, x.$5),
                      kind: Bk.sec,
                      sm: true,
                    ),
                  ], gap: 10),
                ),
            ], gap: 12),
          ),
      ], gap: 26),
    );
  });
}
