import 'package:app/core/notificaciones/avisos_provider.dart';
import 'package:app/core/notificaciones/permiso_notificaciones.dart';
import 'package:app/core/preferencias/almacen_avisos.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Configuración → Avisos: qué avisos recibir y el permiso de notificaciones
/// (spec 012, R-05 a R-07). El permiso lo maneja [PermisoDeNotificaciones].
class SeccionAvisos extends ConsumerWidget {
  const SeccionAvisos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final avisos = ref.watch(avisosProvider);
    final etiquetas = {
      TipoAviso.cotizaciones: textos.avisosCotizaciones,
      TipoAviso.mensajes: textos.avisosMensajes,
      TipoAviso.visitas: textos.avisosVisitas,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Semantics(
            header: true,
            child: Text(
              textos.avisosTitulo,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        for (final MapEntry(:key, :value) in etiquetas.entries)
          SwitchListTile(
            title: Text(value),
            value: avisos.recibe(key),
            onChanged: (recibir) =>
                ref.read(avisosProvider.notifier).elegir(key, recibir: recibir),
          ),
        const PermisoDeNotificaciones(),
      ],
    );
  }
}
