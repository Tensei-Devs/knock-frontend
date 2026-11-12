import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/features/actividad/presentation/widgets/selector_fotos.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Paso 2 «Qué pasa»: descripción de 8 a 500 caracteres con contador siempre
/// visible, frases sugeridas y de 1 a 5 fotos (spec 015, R-02 y R-03).
class PasoDescripcionFotos extends ConsumerStatefulWidget {
  const PasoDescripcionFotos({super.key});

  @override
  ConsumerState<PasoDescripcionFotos> createState() =>
      _PasoDescripcionFotosState();
}

class _PasoDescripcionFotosState extends ConsumerState<PasoDescripcionFotos> {
  late final TextEditingController _texto;

  @override
  void initState() {
    super.initState();
    _texto = TextEditingController(
      text: ref.read(solicitudControllerProvider).descripcion,
    );
  }

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  List<String> _frases(AppLocalizations t, String? clave) => switch (clave) {
    'mec' => [
      t.solicitudFraseMecanica1,
      t.solicitudFraseMecanica2,
      t.solicitudFraseMecanica3,
    ],
    'plo' => [
      t.solicitudFrasePlomeria1,
      t.solicitudFrasePlomeria2,
      t.solicitudFrasePlomeria3,
    ],
    'ele' => [
      t.solicitudFraseElectricidad1,
      t.solicitudFraseElectricidad2,
      t.solicitudFraseElectricidad3,
    ],
    _ => const [],
  };

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = ref.watch(solicitudControllerProvider);
    final controlador = ref.read(solicitudControllerProvider.notifier);
    final error = estado.mostrarErrores
        ? switch (validarDescripcion(estado.descripcion)) {
            ErrorDescripcion.corta => textos.solicitudDescripcionCorta,
            ErrorDescripcion.larga => textos.solicitudDescripcionLarga,
            null => null,
          }
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _texto,
          minLines: 3,
          maxLines: 6,
          onChanged: controlador.cambiarDescripcion,
          decoration: InputDecoration(
            labelText: textos.solicitudDescripcionAyuda,
            errorText: error,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            textos.solicitudContador(estado.descripcion.trim().length),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final frase in _frases(textos, estado.oficio?.clave))
              ActionChip(
                label: Text(frase),
                onPressed: () {
                  _texto.text = frase;
                  controlador.cambiarDescripcion(frase);
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        const SelectorFotos(),
      ],
    );
  }
}
