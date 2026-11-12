import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Paso 3 «Cuándo y dónde»: seis días, tres franjas y, solo a domicilio, la
/// dirección (spec 015, R-04 y R-05). En taller se avisa y no se pide.
class PasoCuandoDonde extends ConsumerStatefulWidget {
  const PasoCuandoDonde({super.key});

  @override
  ConsumerState<PasoCuandoDonde> createState() => _PasoCuandoDondeState();
}

class _PasoCuandoDondeState extends ConsumerState<PasoCuandoDonde> {
  late final TextEditingController _direccion;

  @override
  void initState() {
    super.initState();
    _direccion = TextEditingController(
      text: ref.read(solicitudControllerProvider).direccion,
    );
  }

  @override
  void dispose() {
    _direccion.dispose();
    super.dispose();
  }

  String _franja(AppLocalizations t, Franja f) => switch (f) {
    Franja.manana => t.solicitudFranjaManana,
    Franja.tarde => t.solicitudFranjaTarde,
    Franja.noche => t.solicitudFranjaNoche,
  };

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final materiales = MaterialLocalizations.of(context);
    final estado = ref.watch(solicitudControllerProvider);
    final controlador = ref.read(solicitudControllerProvider.notifier);
    final dias = diasDisponibles(ref.watch(hoyProvider));
    final errorDireccion = estado.mostrarErrores && estado.esDomicilio
        ? switch (validarDireccion(estado.direccion)) {
            ErrorDireccion.corta => textos.solicitudDireccionCorta,
            ErrorDireccion.larga => textos.solicitudDireccionLarga,
            null => null,
          }
        : null;

    Widget chip(
      String texto, {
      required bool elegido,
      required VoidCallback alTocar,
    }) => Semantics(
      label: elegido ? textos.solicitudSeleccionado(texto) : texto,
      button: true,
      selected: elegido,
      excludeSemantics: true,
      onTap: alTocar,
      child: ChoiceChip(
        label: Text(texto),
        selected: elegido,
        onSelected: (_) => alTocar(),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textos.solicitudDia,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final dia in dias)
              chip(
                materiales.formatShortDate(dia),
                elegido: estado.dia == dia,
                alTocar: () => controlador.elegirDia(dia),
              ),
          ],
        ),
        if (estado.mostrarErrores && estado.dia == null)
          Text(
            textos.solicitudDia,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 16),
        Text(
          textos.solicitudFranja,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final franja in Franja.values)
              chip(
                _franja(textos, franja),
                elegido: estado.franja == franja,
                alTocar: () => controlador.elegirFranja(franja),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (estado.esDomicilio)
          TextField(
            controller: _direccion,
            onChanged: controlador.cambiarDireccion,
            decoration: InputDecoration(
              labelText: textos.solicitudDireccion,
              helperText: textos.solicitudDireccionAyuda,
              errorText: errorDireccion,
            ),
          )
        else
          Row(
            children: [
              const Icon(Icons.build_outlined),
              const SizedBox(width: 8),
              Expanded(child: Text(textos.solicitudTallerAviso)),
            ],
          ),
      ],
    );
  }
}
