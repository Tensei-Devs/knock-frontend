import 'dart:async';

import 'package:app/core/notificaciones/avisos_provider.dart';
import 'package:app/core/notificaciones/registro_dispositivo_controller.dart';
import 'package:app/core/permisos/explicacion_permiso.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/core/preferencias/almacen_avisos.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Configuración → Avisos: qué avisos recibir y el permiso de notificaciones
/// (spec 012, R-05 a R-07).
///
/// El permiso se pide aquí, con su explicación previa; si se niega, la app
/// sigue igual y solo se avisa de cómo activarlo.
class SeccionAvisos extends ConsumerStatefulWidget {
  const SeccionAvisos({super.key});

  @override
  ConsumerState<SeccionAvisos> createState() => _SeccionAvisosState();
}

class _SeccionAvisosState extends ConsumerState<SeccionAvisos> {
  EstadoPermiso _permiso = EstadoPermiso.sinPedir;

  @override
  void initState() {
    super.initState();
    unawaited(_leerPermiso());
  }

  Future<void> _leerPermiso() async {
    final estado = await ref
        .read(gestorPermisosProvider)
        .estado(PermisoApp.notificaciones);
    if (mounted) setState(() => _permiso = estado);
  }

  Future<void> _activar() async {
    if (!await explicarPermiso(context, PermisoApp.notificaciones)) return;
    final estado = await ref
        .read(gestorPermisosProvider)
        .pedir(PermisoApp.notificaciones);
    if (!mounted) return;
    setState(() => _permiso = estado);
    if (estado.concedida) {
      await ref
          .read(registroDispositivoControllerProvider.notifier)
          .alIniciarSesion();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        if (_permiso.concedida)
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: Text(textos.avisosActivadas),
          )
        else ...[
          if (_permiso != EstadoPermiso.sinPedir)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Text(textos.avisosApagadas),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: _permiso == EstadoPermiso.denegadoParaSiempre
                  ? OutlinedButton(
                      onPressed: ref.read(gestorPermisosProvider).abrirAjustes,
                      child: Text(textos.avisosAbrirAjustes),
                    )
                  : FilledButton(
                      onPressed: _activar,
                      child: Text(textos.avisosActivar),
                    ),
            ),
          ),
        ],
      ],
    );
  }
}
