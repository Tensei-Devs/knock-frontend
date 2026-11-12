import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Paso 3 «Cuándo y dónde»: seis días, tres franjas y, solo a domicilio, la
/// dirección (spec 015, R-04, R-05, CA-04, CA-05 y CA-17).
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

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final idioma = Localizations.localeOf(context).toLanguageTag();
    final formulario = ref.watch(solicitudControllerProvider);
    final control = ref.read(solicitudControllerProvider.notifier);
    final dias = control.diasOfrecidos;
    final formatoDia = DateFormat('EEE d MMM', idioma);

    final errorDireccion = !formulario.mostrarErrores
        ? null
        : switch (formulario.errorDireccion) {
            ErrorDeLargo.corto => textos.solicitudDireccionCorta,
            ErrorDeLargo.largo => textos.solicitudDireccionLarga,
            null => null,
          };

    String nombreFranja(Franja franja) => switch (franja) {
      Franja.manana => textos.solicitudFranjaManana,
      Franja.tarde => textos.solicitudFranjaTarde,
      Franja.noche => textos.solicitudFranjaNoche,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(textos.solicitudPaso3, style: tema.textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(textos.solicitudDia, style: tema.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final dia in dias)
              ChoiceChip(
                label: Text(
                  dia == dias.first
                      ? textos.solicitudHoy
                      : formatoDia.format(dia),
                ),
                selected: formulario.dia == dia,
                onSelected: (_) => control.elegirDia(dia),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(textos.solicitudFranja, style: tema.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final franja in Franja.values)
              ChoiceChip(
                label: Text(nombreFranja(franja)),
                selected: formulario.franja == franja,
                onSelected: (_) => control.elegirFranja(franja),
              ),
          ],
        ),
        if (formulario.mostrarErrores && formulario.faltaDiaOFranja)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              textos.solicitudFaltaDiaYFranja,
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.colorScheme.error,
              ),
            ),
          ),
        const SizedBox(height: 20),
        if (formulario.esTaller)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.car_repair_outlined),
            title: Text(textos.solicitudTallerAviso),
          )
        else
          TextField(
            controller: _direccion,
            onChanged: control.cambiarDireccion,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.fullStreetAddress],
            decoration: InputDecoration(
              labelText: textos.solicitudDireccion,
              helperText: textos.solicitudDireccionAyuda,
              helperMaxLines: 2,
              errorText: errorDireccion,
              errorMaxLines: 2,
              border: const OutlineInputBorder(),
            ),
          ),
      ],
    );
  }
}
