import 'package:app/core/tema/tokens.dart';
import 'package:app/features/previa/presentation/catalogo_previa.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Catálogo de oficios sin sesión (`/previa/oficios`, spec 027, R-07). Se
/// abre encima de la previa: el botón de regreso vuelve a ella (CA-19).
class PreviaOficiosScreen extends StatelessWidget {
  const PreviaOficiosScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(AppLocalizations.of(context).previaCatalogoTitulo),
    ),
    body: ListView(
      padding: const EdgeInsets.all(Espaciado.cuerpo),
      children: const [CatalogoPrevia()],
    ),
  );
}
