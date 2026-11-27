import 'dart:async';

import 'package:app/core/widgets/globo_conversaciones.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/rutas_tecnico.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/mensajes/mensajes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Globo de todas las pestañas con sesión y API. Sin ellas no pinta nada y
/// siguen los globos de ejemplo.
class GloboReal extends ConsumerWidget {
  const GloboReal({required this.tecnico, super.key});

  /// En la pestaña Trabajo abre los mensajes del técnico.
  final bool tecnico;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(act.solicitudesRealesActivasProvider)) {
      return const SizedBox.shrink();
    }
    final k = kc(context);
    return GloboConversaciones(
      total: ref.watch(globoProvider.select((e) => e.total)),
      fondo: k.navyBg,
      insignia: k.red,
      borde: k.surface,
      trazo: Colors.white,
      alTocar: () async {
        await context.push(tecnico ? RT.mensajes : RM.mensajes);
        if (context.mounted) {
          unawaited(ref.read(globoProvider.notifier).actualizar());
        }
      },
    );
  }
}

/// Aviso de Actividad cuando el canal en vivo está caído (spec 020, CA-14).
class AvisoCanalCaido extends ConsumerWidget {
  const AvisoCanalCaido({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(act.solicitudesRealesActivasProvider) ||
        !ref.watch(globoProvider.select((e) => e.sinConexion))) {
      return const SizedBox.shrink();
    }
    final t = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: stack([
        sMut(t.conversacionesSinConexion),
        BtnK(t.busquedaReintentar, () {
          ref.invalidate(act.solicitudesRealesControllerProvider);
          unawaited(ref.read(globoProvider.notifier).reintentar());
        }, kind: Bk.sec),
      ], gap: 8),
    );
  }
}
