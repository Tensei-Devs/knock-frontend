import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Campo de búsqueda de la maqueta que no se escribe aquí: al tocarlo abre la
/// pantalla de búsqueda con el teclado listo (Inicio y Explorar).
class CampoBuscarK extends StatelessWidget {
  const CampoBuscarK({super.key, required this.fondo, this.elevacion = 0});

  /// Color de fondo del campo.
  final Color fondo;

  /// Sombra del campo (Inicio lo eleva sobre el mapa).
  final double elevacion;

  @override
  Widget build(BuildContext context) {
    final k = kc(context);
    return Material(
      color: fondo,
      elevation: elevacion,
      shape: StadiumBorder(side: BorderSide(color: k.line)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => context.push(RM.buscar, extra: 'focus'),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              spacing: 12,
              children: [
                Icon(Icons.search, color: k.mut),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const T(
                        'Busca un experto cerca de ti',
                        size: 15.5,
                        w: FontWeight.w900,
                      ),
                      T(
                        'Mecánica · Plomería · Electricidad',
                        size: 13,
                        w: FontWeight.w700,
                        color: k.mut,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
