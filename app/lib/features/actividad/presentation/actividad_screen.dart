import 'package:app/core/router/rutas.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/core/widgets/pantalla_titulada.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/presentation/solicitud_detalle_screen.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pestaña Actividad: las solicitudes de la persona, la más reciente primero
/// (spec 015, D-03), o el estado vacío de la maqueta (P11) con «Pide tu
/// primera cotización» (spec 015, §7). El listado paginado es de la spec 020.
/// El botón solo aparece mientras «Pedir cotización» está disponible (fuera
/// de release hasta conectar la API real).
class ActividadScreen extends ConsumerWidget {
  const ActividadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final disponible = ref.watch(pedirCotizacionDisponibleProvider);
    final solicitudes = ref.watch(solicitudesActividadProvider).value ?? [];
    if (solicitudes.isNotEmpty) {
      return PantallaTitulada(
        titulo: textos.tabActividad,
        cuerpo: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final solicitud in solicitudes)
              Card(
                child: ListTile(
                  title: Text(solicitud.oficioNombre),
                  subtitle: Text(
                    '${textoEstadoSolicitud(textos, solicitud.estado)}'
                    '\n${solicitud.descripcion}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(Rutas.solicitud(solicitud.id)),
                ),
              ),
            if (disponible)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: OutlinedButton(
                  onPressed: () => context.go(Rutas.solicitudNueva),
                  child: Text(textos.solicitudTitulo),
                ),
              ),
          ],
        ),
      );
    }
    return PantallaTitulada(
      titulo: textos.tabActividad,
      cuerpo: EstadoKnock(
        icono: Icons.receipt_long_outlined,
        titulo: textos.actividadVaciaTitulo,
        detalle: textos.actividadVaciaDetalle,
        accion: disponible
            ? FilledButton(
                onPressed: () => context.go(Rutas.solicitudNueva),
                child: Text(textos.actividadPedirCotizacion),
              )
            : null,
      ),
    );
  }
}
