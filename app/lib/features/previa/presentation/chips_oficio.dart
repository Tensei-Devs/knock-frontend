import 'package:app/core/tema/tokens.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Chips de la previa (spec 027, R-05): «Todos», uno por cada oficio real del
/// catálogo y «No sé cuál». [seleccionado] es la clave del oficio elegido, o
/// `null` para «Todos». «No sé cuál» no se queda seleccionado: invita a
/// entrar (CA-13).
///
/// Van en una sola fila que se desplaza de lado, flotando sobre el mapa como
/// en la maqueta (`.mchips`).
class ChipsOficio extends StatelessWidget {
  const ChipsOficio({
    required this.oficios,
    required this.seleccionado,
    required this.alElegir,
    required this.alNoSeCual,
    super.key,
  });

  final List<Oficio> oficios;
  final String? seleccionado;
  final ValueChanged<String?> alElegir;
  final VoidCallback alNoSeCual;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final esquema = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: textos.previaChipsEtiqueta,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          spacing: Espaciado.bloqueChico,
          children: [
            ChoiceChip(
              label: Text(textos.previaChipTodos),
              selected: seleccionado == null,
              onSelected: (_) => alElegir(null),
              elevation: 2,
              backgroundColor: esquema.surface,
            ),
            for (final oficio in oficios)
              ChoiceChip(
                label: Text(oficio.nombre),
                selected: seleccionado == oficio.clave,
                onSelected: (_) => alElegir(oficio.clave),
                elevation: 2,
                backgroundColor: esquema.surface,
              ),
            ActionChip(
              label: Text(textos.previaChipNoSeCual),
              avatar: const Icon(Icons.auto_awesome, size: 16),
              onPressed: alNoSeCual,
              elevation: 2,
              backgroundColor: esquema.surface,
            ),
          ],
        ),
      ),
    );
  }
}
