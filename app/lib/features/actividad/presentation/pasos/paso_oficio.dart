import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Paso 1: elegir el oficio, con su modalidad (spec 015, §7).
class PasoOficio extends ConsumerWidget {
  const PasoOficio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final formulario = ref.watch(solicitudControllerProvider);
    final control = ref.read(solicitudControllerProvider.notifier);

    final error = formulario.errorOficios;
    if (error != null) {
      return EstadoKnock(
        icono: Icons.cloud_off_outlined,
        titulo: mensajeDeError(textos, error),
        accion: FilledButton(
          onPressed: control.reintentarOficios,
          child: Text(textos.inicioReintentar),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          textos.solicitudPaso1,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        for (final oficio in formulario.oficios)
          Card(
            child: ListTile(
              minTileHeight: 56,
              title: Text(oficio.nombre),
              subtitle: Text(
                oficio.modalidad.esTaller
                    ? textos.solicitudModalidadTaller
                    : textos.solicitudModalidadDomicilio,
              ),
              selected: formulario.oficio?.clave == oficio.clave,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => control.elegirOficio(oficio),
            ),
          ),
      ],
    );
  }
}
