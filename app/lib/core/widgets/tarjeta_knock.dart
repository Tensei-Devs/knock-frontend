import 'package:app/core/tema/tokens.dart';
import 'package:flutter/material.dart';

/// Tarjeta de la maqueta (`.card`): superficie blanca, radio 22 y la sombra de
/// dos capas de `Sombras.tarjeta`. Spec 014, R-03.
///
/// La sombra va en una capa sin color y el fondo en un `Material`, para que
/// los `ListTile`, `InkWell` y casillas de dentro pinten su tinta sobre el
/// fondo y no debajo de él.
class TarjetaKnock extends StatelessWidget {
  const TarjetaKnock({
    required this.child,
    this.padding = const EdgeInsets.all(Espaciado.tarjeta),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final forma = BorderRadius.circular(Radios.grande);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: forma,
        boxShadow: Sombras.tarjeta,
      ),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: forma,
        clipBehavior: Clip.antiAlias,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
