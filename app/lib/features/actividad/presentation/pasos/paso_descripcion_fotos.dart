import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/features/actividad/presentation/widgets/selector_fotos.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Paso 2 «Qué pasa»: descripción de 8 a 500 caracteres con contador y de 1
/// a 5 fotos (spec 015, R-02, R-03, CA-02 y CA-03).
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

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final formulario = ref.watch(solicitudControllerProvider);
    final control = ref.read(solicitudControllerProvider.notifier);
    final largo = largoVisible(formulario.descripcion);
    final error = switch (formulario.errorDescripcion) {
      ErrorDeLargo.corto when formulario.mostrarErrores =>
        textos.solicitudDescripcionCorta,
      // Pasarse de 500 se avisa al momento, sin esperar a «Siguiente».
      ErrorDeLargo.largo => textos.solicitudDescripcionLarga,
      _ => null,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          textos.solicitudPaso2,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _texto,
          minLines: 3,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
          onChanged: control.cambiarDescripcion,
          decoration: InputDecoration(
            labelText: textos.solicitudDescripcion,
            helperText: textos.solicitudDescripcionAyuda,
            helperMaxLines: 3,
            errorText: error,
            errorMaxLines: 2,
            counterText: '$largo/$maximoDescripcion',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const SelectorFotos(),
      ],
    );
  }
}
