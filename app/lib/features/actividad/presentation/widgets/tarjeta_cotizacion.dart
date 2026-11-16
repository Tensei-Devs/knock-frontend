import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/fotos_permitidas.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Tarjeta de una cotización en la comparación (spec 015, §7, CA-07).
///
/// Solo usa lo que trae [Cotizacion]: el modelo no tiene teléfono ni
/// dirección, así que la tarjeta no puede mostrarlos (CA-10, R-09). La foto
/// del técnico solo se carga si su dirección es `https` de un dominio
/// permitido (CA-21); si no, se muestra su inicial.
class TarjetaCotizacion extends StatelessWidget {
  const TarjetaCotizacion({
    required this.cotizacion,
    required this.dominiosDeFotos,
    this.accion,
    super.key,
  });

  final Cotizacion cotizacion;
  final Set<String> dominiosDeFotos;

  /// Botón «Elegir» (lo agrega KNOCK-245). Sin acción, la tarjeta solo informa.
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final idioma = Localizations.localeOf(context).toLanguageTag();
    // Montos y calificaciones con el formato de México (spec 015 §7: pesos
    // mexicanos), también con la app en inglés: «$1,100» y «4.5».
    final numeros = idioma.startsWith('es') ? 'es_MX' : 'en_US';
    final pesos = NumberFormat.currency(
      locale: numeros,
      symbol: r'$',
      decimalDigits: 0,
    );
    final c = cotizacion;
    final tecnico = c.tecnico;

    final precio = switch (c.tipoPrecio) {
      TipoPrecio.fijo => textos.cotizacionPrecioFijo(
        pesos.format(c.precio ?? 0),
      ),
      TipoPrecio.rango => textos.cotizacionPrecioRango(
        pesos.format(c.precioMin ?? 0),
        pesos.format(c.precioMax ?? 0),
      ),
      TipoPrecio.visita => textos.cotizacionPrecioVisita(
        pesos.format(c.precio ?? 0),
      ),
    };
    final calificacion = tecnico.calificacion == null
        ? textos.cotizacionSinCalificaciones
        : textos.cotizacionCalificacion(
            NumberFormat('0.0', numeros).format(tecnico.calificacion),
          );
    final cuando = textos.cotizacionCuando(
      DateFormat('EEE d MMM', idioma).format(c.dia),
      c.hora,
    );
    final foto =
        tecnico.fotoUrl != null &&
            esFotoPermitida(tecnico.fotoUrl!, dominiosDeFotos)
        ? tecnico.fotoUrl
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ExcludeSemantics(
                  child: CircleAvatar(
                    radius: 24,
                    foregroundImage: foto == null ? null : NetworkImage(foto),
                    child: Text(
                      tecnico.nombre.isEmpty
                          ? '?'
                          : tecnico.nombre.characters.first.toUpperCase(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tecnico.nombre, style: tema.textTheme.titleMedium),
                      Text(calificacion, style: tema.textTheme.bodySmall),
                      if (tecnico.verificado &&
                          tecnico.nivelVerificacion != null)
                        Text(
                          textos.cotizacionNivelVerificacion(
                            tecnico.nivelVerificacion!,
                          ),
                          style: tema.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (c.etiquetas.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final etiqueta in EtiquetaCotizacion.values)
                    if (c.etiquetas.contains(etiqueta))
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: Icon(switch (etiqueta) {
                          EtiquetaCotizacion.verificado =>
                            Icons.verified_outlined,
                          EtiquetaCotizacion.mejorPrecio => Icons.sell_outlined,
                          EtiquetaCotizacion.puedeIrMasPronto =>
                            Icons.schedule_outlined,
                        }, size: 16),
                        label: Text(switch (etiqueta) {
                          EtiquetaCotizacion.verificado =>
                            textos.cotizacionEtiquetaVerificado,
                          EtiquetaCotizacion.mejorPrecio =>
                            textos.cotizacionEtiquetaMejorPrecio,
                          EtiquetaCotizacion.puedeIrMasPronto =>
                            textos.cotizacionEtiquetaPronto,
                        }),
                      ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Text(precio, style: tema.textTheme.titleLarge),
            Text(
              textos.cotizacionTope(pesos.format(c.tope)),
              style: tema.textTheme.bodyMedium,
            ),
            if (c.requiereAprobacion)
              Text(
                textos.cotizacionRequiereAprobacion,
                style: tema.textTheme.bodySmall,
              ),
            const SizedBox(height: 8),
            Text(c.cubre, style: tema.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.event_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(cuando)),
              ],
            ),
            if (c.nota != null && c.nota!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(c.nota!, style: tema.textTheme.bodyMedium),
            ],
            if (accion != null) ...[
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: accion),
            ],
          ],
        ),
      ),
    );
  }
}
