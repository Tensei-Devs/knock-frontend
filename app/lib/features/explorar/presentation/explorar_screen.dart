import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/fila_knock.dart';
import 'package:app/core/widgets/pantalla_titulada.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pestaña Explorar. Su historia agrega el contenido real.
///
/// El acceso «Oficios» es **temporal** (TT-PRU-02): da entrada a la pantalla
/// de oficios y lo reemplaza la historia de Explorar.
class ExplorarScreen extends StatelessWidget {
  const ExplorarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return PantallaTitulada(
      titulo: textos.tabExplorar,
      cuerpo: ListView(
        padding: const EdgeInsets.all(Espaciado.cuerpo),
        children: [
          GrupoDeFilas(
            filas: [
              FilaKnock(
                icono: Icons.handyman_outlined,
                titulo: textos.explorarOficios,
                alTocar: () => context.go(Rutas.oficios),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
