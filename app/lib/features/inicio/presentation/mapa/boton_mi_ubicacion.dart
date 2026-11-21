import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/permisos/explicacion_permiso.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/features/inicio/presentation/mapa/mi_ubicacion_controller.dart';

/// Botón flotante «Mi ubicación» (propio, no el nativo de Maps).
///
/// El permiso se pide solo al tocarlo, nunca al abrir la pantalla. Si no se
/// puede centrar el mapa, muestra el aviso en un `SnackBar`. Mientras
/// [camara] es `null` (el mapa aún no está listo) queda deshabilitado.
class BotonMiUbicacion extends ConsumerWidget {
  const BotonMiUbicacion({required this.camara, super.key});

  /// Texto del botón para lectores de pantalla y la descripción emergente.
  static const etiqueta = 'Mi ubicación';

  /// Texto de la acción del aviso cuando el permiso se negó para siempre.
  static const abrirAjustes = 'Abrir ajustes';

  final CamaraMapa? camara;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AvisoUbicacion?>(miUbicacionControllerProvider, (_, aviso) {
      if (aviso == null) return;
      final mensajero = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
      mensajero.showSnackBar(
        SnackBar(
          content: Text(aviso.texto),
          action: aviso.ofreceAjustes
              ? SnackBarAction(
                  label: abrirAjustes,
                  onPressed: () => ref
                      .read(miUbicacionControllerProvider.notifier)
                      .abrirAjustes(),
                )
              : null,
        ),
      );
    });

    final camaraLista = camara;
    return FloatingActionButton(
      tooltip: etiqueta,
      onPressed: camaraLista == null
          ? null
          : () => ref
                .read(miUbicacionControllerProvider.notifier)
                .centrar(
                  camaraLista,
                  explicar: avisoPrevioDe(context, PermisoApp.ubicacion),
                ),
      child: const Icon(Icons.my_location, semanticLabel: etiqueta),
    );
  }
}
