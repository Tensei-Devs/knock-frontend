import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Explica para qué sirve [permiso] antes de que el sistema lo pida (spec 012,
/// R-06). Devuelve `true` si la persona elige continuar.
///
/// Cerrar el aviso o tocar «Ahora no» devuelve `false`: no se muestra la
/// petición del sistema y la app sigue funcionando sin el permiso (R-07).
Future<bool> explicarPermiso(BuildContext context, PermisoApp permiso) async {
  final textos = AppLocalizations.of(context);
  final (titulo, cuerpo) = switch (permiso) {
    PermisoApp.notificaciones => (
      textos.permisoNotificacionesTitulo,
      textos.permisoNotificacionesCuerpo,
    ),
    PermisoApp.ubicacion => (
      textos.permisoUbicacionTitulo,
      textos.permisoUbicacionCuerpo,
    ),
  };
  final continuar = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      title: Text(titulo),
      content: SingleChildScrollView(child: Text(cuerpo)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(contexto).pop(false),
          child: Text(textos.permisoAhoraNo),
        ),
        FilledButton(
          onPressed: () => Navigator.of(contexto).pop(true),
          child: Text(textos.permisoContinuar),
        ),
      ],
    ),
  );
  return continuar ?? false;
}
