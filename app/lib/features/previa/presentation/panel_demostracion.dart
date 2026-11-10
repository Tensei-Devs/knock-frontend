import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/tarjeta_knock.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:app/features/previa/domain/requerir_cuenta.dart';
import 'package:app/features/previa/presentation/mapa_ejemplo.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Panel de la maqueta con datos de ejemplo (spec 027, R-12, CA-26): «N
/// expertos cerca de ti», la colonia, «Ver lista», el mapa dibujado con pines
/// y las tarjetas de los expertos, todo con el rótulo «Datos de ejemplo».
///
/// Solo se alcanza con `KNOCK_DEMO_DATOS=true` fuera de `release`. Tocar una
/// tarjeta, un pin o «Ver lista» pide cuenta (CA-28): nunca muestra contacto
/// ni dirección. No pide ubicación ni ningún permiso (CA-30).
class PanelDemostracion extends StatelessWidget {
  const PanelDemostracion({super.key});

  void _pedirCuenta(BuildContext context) =>
      requerirCuenta(destino: Rutas.explorar, navegar: context.go);

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          label: textos.previaDatosDeEjemplo,
          // Con texto grande el botón baja bajo el título en lugar de
          // apretarlo hasta desbordar (CA-31).
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Espaciado.fila,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      textos.previaExpertosCerca(expertosDeEjemplo.length),
                      style: tema.textTheme.titleLarge,
                    ),
                  ),
                  Text(coloniaDeEjemplo, style: tema.textTheme.bodyMedium),
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(
                    Alturas.areaTactil,
                    Alturas.areaTactil,
                  ),
                ),
                onPressed: () => _pedirCuenta(context),
                child: Text(textos.previaVerLista),
              ),
            ],
          ),
        ),
        const SizedBox(height: Espaciado.bloqueChico),
        const Align(alignment: Alignment.centerLeft, child: RotuloDeEjemplo()),
        const SizedBox(height: Espaciado.bloque),
        MapaDeEjemplo(
          expertos: expertosDeEjemplo,
          alTocarExperto: (_) => _pedirCuenta(context),
        ),
        const SizedBox(height: Espaciado.bloque),
        for (final experto in expertosDeEjemplo) ...[
          _TarjetaExperto(
            experto: experto,
            alTocar: () => _pedirCuenta(context),
          ),
          const SizedBox(height: Espaciado.bloqueChico),
        ],
      ],
    );
  }
}

class _TarjetaExperto extends StatelessWidget {
  const _TarjetaExperto({required this.experto, required this.alTocar});

  final ExpertoDeEjemplo experto;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: textos.previaTarjetaSemantica(experto.nombre, experto.oficio),
      onTap: alTocar,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radios.grande),
        onTap: alTocar,
        child: TarjetaKnock(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: Alturas.areaTactil),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(experto.nombre, style: tema.textTheme.titleMedium),
                      Text(experto.oficio, style: tema.textTheme.bodyMedium),
                    ],
                  ),
                ),
                const Icon(Icons.star_rounded, size: 20),
                const SizedBox(width: 4),
                Text(experto.calificacion, style: tema.textTheme.titleSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
