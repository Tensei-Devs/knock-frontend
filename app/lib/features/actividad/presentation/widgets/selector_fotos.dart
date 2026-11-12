import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Agregar, quitar y validar las fotos de la solicitud: de 1 a 5 (spec 015,
/// R-03). Las miniaturas reales llegan con el selector del sistema; aquí cada
/// foto es un marcador con su etiqueta «Foto n de total» y «Quitar».
class SelectorFotos extends ConsumerWidget {
  const SelectorFotos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final estado = ref.watch(solicitudControllerProvider);
    final controlador = ref.read(solicitudControllerProvider.notifier);
    final total = estado.rutasDeFotos.length;
    final falta =
        estado.mostrarErrores &&
        validarCantidadDeFotos(total) == ErrorFotos.falta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < total; i++)
          Row(
            children: [
              Expanded(
                child: Semantics(
                  label: textos.solicitudFotoEtiqueta(i + 1, total),
                  excludeSemantics: true,
                  child: Row(
                    children: [
                      const Icon(Icons.photo_outlined),
                      const SizedBox(width: 8),
                      Text(textos.solicitudFotoEtiqueta(i + 1, total)),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: textos.solicitudFotoQuitar,
                onPressed: () => controlador.quitarFoto(i),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: controlador.agregarFoto,
          icon: const Icon(Icons.add_a_photo_outlined),
          label: Text(textos.solicitudAgregarFoto),
        ),
        if (estado.errorFotos == ErrorFotos.maximo)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(textos.solicitudFotoMaximo),
          ),
        if (falta)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              textos.solicitudFotoFalta,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}
