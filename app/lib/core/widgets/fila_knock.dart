import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:flutter/material.dart';

/// Grupo de filas de la maqueta (`.group`): superficie con radio 22 y un
/// divisor entre filas. Spec 014, R-03.
class GrupoDeFilas extends StatelessWidget {
  const GrupoDeFilas({required this.filas, super.key});

  final List<Widget> filas;

  @override
  Widget build(BuildContext context) {
    final linea = context.colores.linea;
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radios.grande),
      ),
      child: Column(
        children: [
          for (var i = 0; i < filas.length; i++) ...[
            if (i > 0) Divider(height: 1, thickness: 1, color: linea),
            filas[i],
          ],
        ],
      ),
    );
  }
}

/// Fila de la maqueta (`.li`): cuadro de ícono de 40, título 16/800, detalle y
/// flecha. Se apoya en `ListTile` para conservar tinta, foco y semántica.
class FilaKnock extends StatelessWidget {
  const FilaKnock({
    required this.icono,
    required this.titulo,
    this.detalle,
    this.alTocar,
    this.mostrarFlecha = true,
    this.etiquetaIcono,
    super.key,
  });

  final IconData icono;
  final String titulo;
  final String? detalle;

  /// Sin acción, la fila es informativa y no muestra flecha.
  final VoidCallback? alTocar;
  final bool mostrarFlecha;

  /// Si el ícono dice algo que el texto no dice, su etiqueta para lectores de
  /// pantalla; sin ella el ícono es decorativo y se excluye de la semántica.
  final String? etiquetaIcono;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final c = context.colores;
    return ListTile(
      minTileHeight: Alturas.fila,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Espaciado.tarjeta,
        vertical: 6,
      ),
      horizontalTitleGap: Espaciado.iconoAFila,
      leading: ExcludeSemantics(
        excluding: etiquetaIcono == null,
        child: Container(
          width: Alturas.iconoFila,
          height: Alturas.iconoFila,
          decoration: BoxDecoration(
            color: c.navySoft,
            borderRadius: BorderRadius.circular(Radios.iconoFila),
          ),
          child: Icon(
            icono,
            color: c.sobreNavySoft,
            semanticLabel: etiquetaIcono,
          ),
        ),
      ),
      title: Text(
        titulo,
        style: tema.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
      subtitle: detalle == null
          ? null
          : Text(
              detalle!,
              style: tema.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
      trailing: alTocar != null && mostrarFlecha
          ? ExcludeSemantics(
              child: Icon(
                Icons.chevron_right,
                color: tema.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      onTap: alTocar,
    );
  }
}
