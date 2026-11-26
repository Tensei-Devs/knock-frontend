import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/visita/visita.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgendaReal extends ConsumerWidget {
  const AgendaReal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final controller = ref.read(agendaControllerProvider.notifier);
    return ref
        .watch(agendaControllerProvider)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(t.agendaCargando),
          error: (_, _) => stack([
            sMut(t.agendaError),
            BtnK(t.opinionesReintentar, controller.reintentar, kind: Bk.sec),
          ], gap: 8),
          data: (pagina) => stack([
            sMut(t.agendaSinMapa),
            if (pagina.items.isEmpty) sMut(t.agendaVacia),
            for (final visita in pagina.items)
              CardK(
                child: stack([
                  T('${visita.dia} · ${visita.hora}'),
                  sMut(
                    '${t.agendaModalidad(visita.modalidad)} · ${t.agendaEstado(visita.estado)}',
                  ),
                ], gap: 4),
              ),
            if (pagina.siguiente != null)
              BtnK(t.agendaVerMas, () async {
                final falla = await controller.cargarMas();
                if (falla != null && context.mounted) {
                  maq.toast(mensajeDeError(t, falla));
                }
              }, kind: Bk.sec),
          ], gap: 8),
        );
  }
}
