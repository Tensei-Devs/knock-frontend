import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Paso 1: elegir el oficio, con sus estados de carga, error y vacío
/// (spec 015, §7).
class PasoOficio extends ConsumerWidget {
  const PasoOficio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final oficios = ref.watch(oficiosParaSolicitudProvider);
    // «Cargando» primero: tras Reintentar el estado conserva el error anterior.
    if (oficios.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          semanticsLabel: textos.solicitudCargandoOficios,
        ),
      );
    }
    if (oficios.hasError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mensajeDeError(textos, oficios.error!)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => ref.invalidate(oficiosParaSolicitudProvider),
            child: Text(textos.solicitudReintentar),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            textos.solicitudEligeOficio,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 8),
        for (final oficio in oficios.requireValue)
          ListTile(
            minTileHeight: 56,
            title: Text(oficio.nombre),
            subtitle: Text(
              oficio.modalidad.esTaller
                  ? textos.solicitudTallerAviso
                  : textos.solicitudDomicilio,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ref
                .read(solicitudControllerProvider.notifier)
                .elegirOficio(oficio),
          ),
      ],
    );
  }
}
