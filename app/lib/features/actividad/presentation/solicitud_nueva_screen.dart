import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/actividad/presentation/pasos/paso_cuando_donde.dart';
import 'package:app/features/actividad/presentation/pasos/paso_descripcion_fotos.dart';
import 'package:app/features/actividad/presentation/pasos/paso_oficio.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Pedir cotización» en tres pasos (spec 015, R-01 y §7).
///
/// [oficioClave] llega cuando se abre desde un oficio y salta el paso 1
/// (CA-24). Al enviar se muestra «Solicitud enviada» y se abre el detalle
/// (CA-01).
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
    unawaited(
      Future.microtask(
        () => ref
            .read(solicitudControllerProvider.notifier)
            .iniciar(oficioClave: widget.oficioClave),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final formulario = ref.watch(solicitudControllerProvider);
    final control = ref.read(solicitudControllerProvider.notifier);

    ref.listen(solicitudControllerProvider.select((f) => f.creada), (
      _,
      creada,
    ) {
      if (creada == null) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(textos.solicitudEnviada)));
      context.go(Rutas.solicitud(creada.id));
    });

    final pasoNumero = formulario.paso.index + 1;
    final cuerpo = formulario.cargando
        ? const Center(child: CircularProgressIndicator())
        : switch (formulario.paso) {
            PasoSolicitud.oficio => const PasoOficio(),
            PasoSolicitud.descripcion => const PasoDescripcionFotos(),
            PasoSolicitud.cuandoDonde => const PasoCuandoDonde(),
          };

    return Scaffold(
      appBar: AppBar(
        title: Text(textos.solicitudTitulo),
        actions: [
          IconButton(
            tooltip: textos.solicitudDescartar,
            onPressed: formulario.enviando ? null : control.descartar,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              textos.solicitudPasoDeTotal(
                pasoNumero,
                PasoSolicitud.values.length,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: cuerpo),
            _Avisos(formulario: formulario),
            if (!formulario.cargando)
              _Botones(formulario: formulario, control: control),
          ],
        ),
      ),
    );
  }
}

/// Error del envío, espera por 429 o falta de zona, encima de los botones.
class _Avisos extends StatelessWidget {
  const _Avisos({required this.formulario});

  final FormularioSolicitud formulario;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final error = formulario.error;
    final String? texto;
    if (formulario.sinZona) {
      texto = textos.solicitudSinZona;
    } else if (error is DemasiadosIntentosFailure && formulario.esperando) {
      final segundos = (error.espera ?? esperaPorOmision).inSeconds;
      texto = textos.solicitudEspera(segundos);
    } else if (error != null && error is! DemasiadosIntentosFailure) {
      texto = mensajeDeError(textos, error);
    } else {
      texto = null;
    }
    if (texto == null) return const SizedBox.shrink();
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: tema.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          texto,
          style: TextStyle(color: tema.colorScheme.onErrorContainer),
        ),
      ),
    );
  }
}

class _Botones extends StatelessWidget {
  const _Botones({required this.formulario, required this.control});

  final FormularioSolicitud formulario;
  final SolicitudController control;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final ultimo = formulario.paso == PasoSolicitud.cuandoDonde;
    final ocupado = formulario.enviando || formulario.agregandoFoto;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (formulario.paso != PasoSolicitud.oficio)
            Expanded(
              child: OutlinedButton(
                onPressed: ocupado ? null : control.retroceder,
                child: Text(textos.solicitudAtras),
              ),
            ),
          if (formulario.paso != PasoSolicitud.oficio)
            const SizedBox(width: 12),
          if (formulario.paso != PasoSolicitud.oficio)
            Expanded(
              child: ultimo
                  ? FilledButton(
                      onPressed: ocupado || formulario.esperando
                          ? null
                          : control.enviar,
                      child: formulario.enviando
                          ? Semantics(
                              label: textos.solicitudEnviando,
                              child: const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : Text(textos.solicitudEnviar),
                    )
                  : FilledButton(
                      onPressed: ocupado ? null : control.avanzar,
                      child: Text(textos.solicitudSiguiente),
                    ),
            ),
        ],
      ),
    );
  }
}
