import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/agenda_real.dart';
import 'package:app/features/maqueta/bandeja_trabajo_real.dart';
import 'package:app/features/maqueta/disponible_hoy_real.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart' show PgTab;
import 'package:app/features/maqueta/pantallas_tecnico.dart'
    show TrabajoMaqueta;
import 'package:app/features/maqueta/rutas_tecnico.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:app/features/visita/visita.dart';
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
    return const _TrabajoReal();
  }
}

/// Se actualiza al deslizar hacia abajo y al volver a la app.
class _TrabajoReal extends ConsumerStatefulWidget {
  const _TrabajoReal();

  @override
  ConsumerState<_TrabajoReal> createState() => _TrabajoRealState();
}

class _TrabajoRealState extends ConsumerState<_TrabajoReal> {
  late final AppLifecycleListener _regreso;

  @override
  void initState() {
    super.initState();
    _regreso = AppLifecycleListener(onResume: _invalidar);
  }

  @override
  void dispose() {
    _regreso.dispose();
    super.dispose();
  }

  void _invalidar() {
    ref
      ..invalidate(disponibleHoyProvider)
      ..invalidate(agendaControllerProvider)
      ..invalidate(solicitudesRecibidasProvider)
      ..invalidate(cotizacionesEnviadasProvider);
  }

  Future<void> _actualizar() async {
    _invalidar();
    try {
      await Future.wait<Object?>([
        ref.read(disponibleHoyProvider.future),
        ref.read(agendaControllerProvider.future),
        ref.read(solicitudesRecibidasProvider.future),
        ref.read(cotizacionesEnviadasProvider.future),
      ]);
    } on Exception {
      // Cada sección muestra su propio error con «Reintentar».
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return PgTab(
      title: 'Trabajo',
      onRefresh: _actualizar,
      body: stack([
        const DisponibleHoyReal(),
        h2(t.trabajoProximasVisitas),
        const AgendaReal(avisoDeMapa: false),
        const SolicitudesNuevasReal(),
        const CotizacionesEnviadasReal(),
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
