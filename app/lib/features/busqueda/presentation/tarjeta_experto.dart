import 'package:app/features/busqueda/domain/busqueda.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Tarjeta de un experto en los resultados de búsqueda (spec 021, CA-10, R-11).
///
/// Un solo nodo semántico que se lee completo; no muestra teléfono, contacto
/// ni dirección (CA-10, R-07). Mide al menos 48 dp (R-11).
class TarjetaExperto extends StatelessWidget {
  const TarjetaExperto({
    required this.experto,
    required this.alTocar,
    super.key,
  });

  final ExpertoBuscado experto;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final km = experto.distanciaKm;

    final resumen = [
      experto.oficios.map((o) => o.nombre).join(' · '),
      l.busquedaCalificacion(
        experto.calificacion.toStringAsFixed(1),
        experto.totalResenas,
      ),
      if (km != null) l.busquedaDistancia(km),
      if (experto.coloniaBase != null) experto.coloniaBase!,
    ].join(' · ');

    return MergeSemantics(
      child: Semantics(
        label:
            '${experto.nombre}. $resumen.'
            '${experto.verificado ? ' ${l.busquedaVerificado(experto.nivelVerificacion)}.' : ''}'
            '${experto.atiendeTuColonia ? '' : ' ${l.busquedaNoAtiende}.'}',
        button: true,
        child: Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: alTocar,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(experto.nombre, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    experto.oficios.map((o) => o.nombre).join(' · '),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      l.busquedaCalificacion(
                        experto.calificacion.toStringAsFixed(1),
                        experto.totalResenas,
                      ),
                      if (km != null) l.busquedaDistancia(km),
                      if (experto.coloniaBase != null) experto.coloniaBase!,
                    ].join(' · '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (experto.verificado)
                        Chip(
                          label: Text(
                            l.busquedaVerificado(experto.nivelVerificacion),
                            style: theme.textTheme.labelSmall,
                          ),
                          avatar: Icon(
                            Icons.verified_outlined,
                            size: 14,
                            color: cs.primary,
                          ),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      if (!experto.atiendeTuColonia)
                        Chip(
                          label: Text(
                            l.busquedaNoAtiende,
                            style: theme.textTheme.labelSmall,
                          ),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
