import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Abre la hoja que invita a entrar (spec 027, R-04): «Entrar»,
/// «Registrarme» y «Ahora no». No hace ninguna petición ni búsqueda.
///
/// «Entrar» y «Registrarme» abren `/entrar` con el [destino] al que volver, si
/// lo hay; «Ahora no» (o deslizar hacia abajo) solo la cierra.
Future<void> mostrarHojaInvitacion(BuildContext context, {String? destino}) {
  final router = GoRouter.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (hoja) => _HojaInvitacion(
      alEntrar: () {
        Navigator.of(hoja).pop();
        router.go(rutaDeEntrada(destino));
      },
    ),
  );
}

class _HojaInvitacion extends StatelessWidget {
  const _HojaInvitacion({required this.alEntrar});

  final VoidCallback alEntrar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    const alto = Size(double.infinity, Alturas.boton);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          Espaciado.cuerpo,
          0,
          Espaciado.cuerpo,
          Espaciado.cuerpo,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                textos.previaInvitacionTitulo,
                style: tema.textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: Espaciado.bloqueChico),
            Text(
              textos.previaInvitacionDetalle,
              style: tema.textTheme.bodyLarge,
            ),
            const SizedBox(height: Espaciado.bloque),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: alto),
              onPressed: alEntrar,
              child: Text(textos.previaEntrar),
            ),
            const SizedBox(height: Espaciado.bloqueChico),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: alto),
              onPressed: alEntrar,
              child: Text(textos.previaRegistrarme),
            ),
            const SizedBox(height: Espaciado.bloqueChico),
            TextButton(
              style: TextButton.styleFrom(minimumSize: alto),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(textos.previaAhoraNo),
            ),
          ],
        ),
      ),
    );
  }
}
