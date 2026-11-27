import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/agenda_real.dart';
import 'package:app/features/maqueta/disponible_hoy_real.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart' show PgTab;
import 'package:app/features/maqueta/pantallas_tecnico.dart'
    show TrabajoMaqueta;
import 'package:app/features/maqueta/rutas_tecnico.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// La pestaña «Trabajo»: con sesión y API, las visitas reales del técnico y sin
/// datos de ejemplo; sin ellas, la pantalla de la maqueta (spec 045).
class TrabajoSegunSesion extends ConsumerWidget {
  const TrabajoSegunSesion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(solicitudesRealesActivasProvider)) {
      return const TrabajoMaqueta();
    }
    final t = AppLocalizations.of(context);
    return PgTab(
      title: 'Trabajo',
      body: stack([
        const DisponibleHoyReal(),
        h3(t.trabajoProximasVisitas),
        const AgendaReal(avisoDeMapa: false),
        sMut(t.trabajoPendiente),
        GroupK([
          LiK(
            'shield',
            t.trabajoVerificacion,
            onTap: () => context.push(RT.verif),
          ),
          LiK(
            'award',
            t.trabajoReputacion,
            onTap: () => context.push(RT.reputacion),
          ),
        ]),
      ], gap: 16),
    );
  }
}
