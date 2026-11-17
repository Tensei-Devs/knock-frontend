import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';

/// Aviso cuando no se pudo pedir el catálogo de oficios al backend
/// (`GET /oficios`): no se inventan oficios, se ofrece reintentar.
class AvisoOficios extends StatelessWidget {
  const AvisoOficios({super.key});

  @override
  Widget build(BuildContext context) => ChipK(
    'No pudimos cargar los oficios. Toca para reintentar',
    onTap: () => maq.reintentarOficios?.call(),
  );
}
