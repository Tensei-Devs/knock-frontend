import 'dart:async';

import 'package:app/core/notificaciones/registro_dispositivo_controller.dart';
import 'package:app/core/permisos/explicacion_permiso.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado y activación del permiso de notificaciones (spec 012, R-06 y R-07).
///
/// El permiso se pide aquí, con su explicación previa; al concederlo se
/// registra el dispositivo. Si se niega, la app sigue igual y solo se avisa de
/// cómo activarlo.
class PermisoDeNotificaciones extends ConsumerStatefulWidget {
  const PermisoDeNotificaciones({super.key});

  @override
  ConsumerState<PermisoDeNotificaciones> createState() =>
      _PermisoDeNotificacionesState();
}

class _PermisoDeNotificacionesState
    extends ConsumerState<PermisoDeNotificaciones> {
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
    final noDisponibles = ref.watch(
      registroDispositivoControllerProvider,
    ) is NotificacionesNoDisponibles;
    if (_permiso.concedida && noDisponibles) {
      return ListTile(
        leading: const Icon(Icons.notifications_off_outlined),
        title: Text(textos.avisosNoDisponibles),
      );
    }
    if (_permiso.concedida) {
      return ListTile(
        leading: const Icon(Icons.notifications_active_outlined),
        title: Text(textos.avisosActivadas),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }
}
