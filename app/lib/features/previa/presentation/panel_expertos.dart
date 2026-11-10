import 'package:app/core/config/modo_demostracion.dart';
import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/tarjeta_knock.dart';
import 'package:app/features/previa/presentation/panel_demostracion.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Panel «expertos cerca de ti» y zona del mapa de la previa (spec 027,
/// R-10 a R-12).
///
/// En la compilación de tienda (o sin `KNOCK_DEMO_DATOS`) es
/// [PanelProximamente]: no existe el endpoint de expertos cercanos y no se
/// inventa nada. Con la bandera, fuera de `release`, es [PanelDemostracion].
/// La condición es una constante de compilación (`demoDatosActivo`): en
/// `release` el compilador elimina la rama de demostración y sus datos.
Widget panelDeExpertos() =>
    demoDatosActivo ? const PanelDemostracion() : const PanelProximamente();

/// Estado vacío honesto: sin cifras, nombres, pines ni calificaciones (CA-25).
class PanelProximamente extends StatelessWidget {
  const PanelProximamente({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final c = context.colores;
    return TarjetaKnock(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Container(
              width: Alturas.iconoFila,
              height: Alturas.iconoFila,
              decoration: BoxDecoration(
                color: c.navySoft,
                borderRadius: BorderRadius.circular(Radios.iconoFila),
              ),
              child: Icon(Icons.map_outlined, color: c.sobreNavySoft),
            ),
          ),
          const SizedBox(width: Espaciado.iconoAFila),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    textos.previaProximamenteTitulo,
                    style: tema.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: Espaciado.bloqueChico / 2),
                Text(
                  textos.previaProximamenteDetalle,
                  style: tema.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
