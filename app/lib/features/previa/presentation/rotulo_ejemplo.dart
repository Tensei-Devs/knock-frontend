import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Rótulo fijo «Datos de ejemplo» (spec 027, R-12 y R-17): marca como
/// inventados el mapa y el panel. No se puede ocultar y se lee en voz alta.
class RotuloDeEjemplo extends StatelessWidget {
  const RotuloDeEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.amberSoft,
        borderRadius: BorderRadius.circular(Radios.chip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          AppLocalizations.of(context).previaDatosDeEjemplo,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: c.sobreAmberSoft, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
