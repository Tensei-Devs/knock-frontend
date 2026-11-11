import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Barra de marca de la previa: logo y los botones «Entrar» y «Registrarme»
/// (spec 027, R-03). Ambos abren `/entrar`: el alta y el ingreso comparten el
/// flujo de celular de HU-001 (decisión D-01).
///
/// Usa `Wrap` para que con texto al 200 % los botones pasen a otra línea en
/// lugar de cortarse.
class BarraMarca extends StatelessWidget {
  const BarraMarca({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    const minimo = Size(Alturas.areaTactil, Alturas.areaTactil);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: Espaciado.fila,
      runSpacing: Espaciado.bloqueChico,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: esquema.primary,
                  borderRadius: BorderRadius.circular(Radios.pequeno),
                ),
                child: Icon(
                  Icons.door_front_door_rounded,
                  color: esquema.onPrimary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: Espaciado.fila),
            Semantics(
              header: true,
              child: Text(
                textos.appTitle,
                style: tema.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: esquema.onSurface,
                ),
              ),
            ),
          ],
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Espaciado.bloqueChico,
          children: [
            TextButton(
              style: TextButton.styleFrom(minimumSize: minimo),
              onPressed: () => context.go(Rutas.entrar),
              child: Text(textos.previaEntrar),
            ),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: minimo),
              onPressed: () => context.go(Rutas.entrar),
              child: Text(textos.previaRegistrarme),
            ),
          ],
        ),
      ],
    );
  }
}
