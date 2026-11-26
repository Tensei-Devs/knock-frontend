import 'dart:async';

import 'package:app/features/maqueta/campo_buscar.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/explorar_real.dart';
import 'package:app/features/maqueta/oficios_reales.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pestaña Explorar (`js/explorar.js`): servicios populares, trabajos reales,
/// expertos cercanos, mejor calificados e ideas. Desde la spec 036 los bloques
/// son los reales de `GET /explorar` ([ExplorarReal]); los chips eligen el
/// filtro.
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
            child: CampoBuscarK(fondo: k.bg),
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
                if (maq.oficiosError && maq.oficios.isEmpty)
                  const AvisoOficios(),
                for (final id in maq.oficios)
                  ChipK(
                    cats[id]!.plain,
                    icon: iconoDeOficio(id),
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

    return PgTab(
      title: 'Explorar',
      top: top,
      fab: msgFab(context),
      // Spec 036: bloques reales (TEC-14) en lugar de los simulados.
      body: ExplorarReal(
        oficio: cat,
        alPedir: (oficio) => _pedir(context, oficio, ''),
      ),
    );
  });
}
