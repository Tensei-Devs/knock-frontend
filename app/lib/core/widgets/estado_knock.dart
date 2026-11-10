import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:flutter/material.dart';

/// Estado vacío o de error de la maqueta (`.empty` / `.state`): círculo con
/// ícono, título, detalle y una acción opcional. Se desplaza si no cabe
/// (texto al 200 %). Spec 014, R-03.
class EstadoKnock extends StatelessWidget {
  const EstadoKnock({
    required this.icono,
    required this.titulo,
    this.detalle,
    this.accion,
    super.key,
  });

  final IconData icono;
  final String titulo;
  final String? detalle;

  /// Normalmente un botón; sin acción, el estado solo informa.
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final c = context.colores;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: Alturas.estadoVacio,
                  height: Alturas.estadoVacio,
                  decoration: BoxDecoration(
                    color: c.navySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icono, size: 44, color: c.sobreNavySoft),
                ),
              ),
              const SizedBox(height: 14),
              Semantics(
                header: true,
                child: Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: tema.textTheme.headlineSmall,
                ),
              ),
              if (detalle != null) ...[
                const SizedBox(height: 14),
                Text(
                  detalle!,
                  textAlign: TextAlign.center,
                  style: tema.textTheme.bodyLarge?.copyWith(
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (accion != null) ...[const SizedBox(height: 14), accion!],
            ],
          ),
        ),
      ),
    );
  }
}
