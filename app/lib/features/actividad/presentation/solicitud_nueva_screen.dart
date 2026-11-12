import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/presentation/pasos/paso_cuando_donde.dart';
import 'package:app/features/actividad/presentation/pasos/paso_descripcion_fotos.dart';
import 'package:app/features/actividad/presentation/pasos/paso_oficio.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Contenedor de los tres pasos de «Pedir cotización» (spec 015, R-01).
///
/// Con [oficioClave] el paso 1 se salta (CA-24). Lo escrito se guarda como
/// borrador y se recupera al volver (R-07).
class SolicitudNuevaScreen extends ConsumerStatefulWidget {
  const SolicitudNuevaScreen({this.oficioClave, super.key});

  final String? oficioClave;

  @override
  ConsumerState<SolicitudNuevaScreen> createState() =>
      _SolicitudNuevaScreenState();
}

class _SolicitudNuevaScreenState extends ConsumerState<SolicitudNuevaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        ref
            .read(solicitudControllerProvider.notifier)
            .iniciar(oficioClave: widget.oficioClave),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = ref.watch(solicitudControllerProvider);
    final controlador = ref.read(solicitudControllerProvider.notifier);

    ref.listen(solicitudControllerProvider.select((e) => e.creada), (
      anterior,
      creada,
    ) {
      if (creada == null) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(textos.solicitudEnviada)));
      context.go('/actividad/solicitud/${creada.id}');
      controlador.reiniciar();
    });

    final encabezado = switch (estado.paso) {
      0 => textos.solicitudPaso1,
      1 => textos.solicitudPaso2,
      _ => textos.solicitudPaso3,
    };
    final mensaje = _mensaje(textos, estado);

    return Scaffold(
      appBar: AppBar(title: Text(textos.solicitudTitulo)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        encabezado,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    switch (estado.paso) {
                      0 => const PasoOficio(),
                      1 => const PasoDescripcionFotos(),
                      _ => const PasoCuandoDonde(),
                    },
                  ],
                ),
              ),
            ),
            if (mensaje != null)
              Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    mensaje,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            if (estado.paso > 0)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: estado.enviando ? null : controlador.atras,
                      child: Text(textos.solicitudAtras),
                    ),
                    const Spacer(),
                    if (estado.paso == 1)
                      FilledButton(
                        onPressed: controlador.siguiente,
                        child: Text(textos.solicitudSiguiente),
                      )
                    else
                      FilledButton(
                        onPressed: estado.enviando || estado.espera != null
                            ? null
                            : controlador.enviar,
                        child: estado.enviando
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(textos.solicitudEnviando),
                                ],
                              )
                            : Text(textos.solicitudEnviar),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String? _mensaje(AppLocalizations textos, EstadoSolicitudForm estado) {
    if (estado.sinZona) return textos.solicitudSinZona;
    final espera = estado.espera;
    if (espera != null) return textos.solicitudEspera(espera.inSeconds);
    final error = estado.error;
    if (error == null) return null;
    if (error is ServicioNoDisponibleFailure) {
      return textos.solicitudBorradorGuardado;
    }
    return mensajeDeError(textos, error);
  }
}
