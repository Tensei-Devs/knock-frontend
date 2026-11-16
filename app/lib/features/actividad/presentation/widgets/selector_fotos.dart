import 'dart:io';

import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fotos del paso «Qué pasa»: de 1 a 5, con «Tomar foto», «Elegir de la
/// galería» y «Quitar» (spec 015, R-03 y CA-03).
class SelectorFotos extends ConsumerWidget {
  const SelectorFotos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final formulario = ref.watch(solicitudControllerProvider);
    final control = ref.read(solicitudControllerProvider.notifier);
    final fotos = formulario.fotos;
    final cabe = puedeAgregarFoto(fotos.length) && !formulario.agregandoFoto;

    final aviso = switch (formulario.errorFotos) {
      ErrorDeFotos.faltan when formulario.mostrarErrores =>
        textos.solicitudFotoFalta,
      ErrorDeFotos.sobran => textos.solicitudFotoMaximo,
      _ when !puedeAgregarFoto(fotos.length) => textos.solicitudFotoMaximo,
      _ => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textos.solicitudFotos(fotos.length),
          style: tema.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (fotos.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < fotos.length; i++)
                _Miniatura(
                  ruta: fotos[i],
                  etiqueta: textos.solicitudFotoEtiqueta(i + 1, fotos.length),
                  quitar: textos.solicitudFotoQuitar(i + 1),
                  alQuitar: () => control.quitarFoto(fotos[i]),
                ),
            ],
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: cabe ? control.tomarFoto : null,
              icon: const Icon(Icons.photo_camera_outlined),
              label: Text(textos.solicitudFotoTomar),
            ),
            OutlinedButton.icon(
              onPressed: cabe ? control.elegirFotos : null,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(textos.solicitudFotoElegir),
            ),
          ],
        ),
        if (formulario.agregandoFoto)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(),
          ),
        if (aviso != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              aviso,
              style: tema.textTheme.bodySmall?.copyWith(
                color: formulario.errorFotos == ErrorDeFotos.faltan
                    ? tema.colorScheme.error
                    : null,
              ),
            ),
          ),
        if (formulario.errorFoto != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              mensajeDeError(textos, formulario.errorFoto!),
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

class _Miniatura extends StatelessWidget {
  const _Miniatura({
    required this.ruta,
    required this.etiqueta,
    required this.quitar,
    required this.alQuitar,
  });

  final String ruta;
  final String etiqueta;
  final String quitar;
  final VoidCallback alQuitar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Semantics(
      label: etiqueta,
      image: true,
      child: SizedBox(
        width: 96,
        height: 96,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(ruta),
                  fit: BoxFit.cover,
                  cacheWidth: 192,
                  excludeFromSemantics: true,
                  errorBuilder: (context, error, stack) => ColoredBox(
                    color: tema.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton.filledTonal(
                tooltip: quitar,
                onPressed: alQuitar,
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
