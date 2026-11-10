import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Buscador de la previa (spec 027, R-04): se ve siempre, pero no busca; al
/// tocarlo invita a entrar (decisión D-07). Sin campo de texto, así que no
/// abre el teclado ni hace ninguna petición.
class BuscadorPrevia extends StatelessWidget {
  const BuscadorPrevia({required this.alTocar, super.key});

  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '${textos.previaBuscadorTitulo}. ${textos.previaBuscadorLeyenda}',
      onTap: alTocar,
      child: Material(
        color: esquema.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.boton),
          side: BorderSide(color: context.colores.linea),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: alTocar,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: Alturas.campo),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Espaciado.tarjeta,
                vertical: Espaciado.fila,
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: esquema.onSurfaceVariant),
                  const SizedBox(width: Espaciado.fila),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textos.previaBuscadorTitulo,
                          style: tema.textTheme.titleMedium,
                        ),
                        Text(
                          textos.previaBuscadorLeyenda,
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: esquema.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
