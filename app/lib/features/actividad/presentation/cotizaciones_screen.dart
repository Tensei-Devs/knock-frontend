import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/presentation/cotizaciones_controller.dart';
import 'package:app/features/actividad/presentation/widgets/hoja_confirmar_eleccion.dart';
import 'package:app/features/actividad/presentation/widgets/tarjeta_cotizacion.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Ver y elegir»: compara hasta cinco cotizaciones en el orden del servidor
/// (spec 015, CA-07 a CA-10) y elige una con la hoja de confirmación (CA-11,
/// CA-12).
class CotizacionesScreen extends ConsumerWidget {
  const CotizacionesScreen({required this.solicitudId, super.key});

  final String solicitudId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final orden = ref.watch(ordenCotizacionesProvider(solicitudId));
    final comparacion = ref.watch(cotizacionesProvider(solicitudId));

    String nombreOrden(OrdenCotizaciones o) => switch (o) {
      OrdenCotizaciones.recomendadas => textos.cotizacionOrdenRecomendadas,
      OrdenCotizaciones.precio => textos.cotizacionOrdenPrecio,
      OrdenCotizaciones.calificacion => textos.cotizacionOrdenCalificacion,
      OrdenCotizaciones.pronto => textos.cotizacionOrdenPronto,
    };

    return Scaffold(
      appBar: AppBar(title: Text(textos.cotizacionTitulo)),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                for (final o in OrdenCotizaciones.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(nombreOrden(o)),
                      selected: o == orden,
                      onSelected: (_) => ref
                          .read(ordenCotizacionesProvider(solicitudId).notifier)
                          .elegir(o),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: switch (comparacion) {
              AsyncData(:final value) => _Lista(
                solicitudId: solicitudId,
                resultado: value,
              ),
              AsyncError(:final error) => EstadoKnock(
                icono: error is NoEncontradoFailure
                    ? Icons.search_off_outlined
                    : Icons.cloud_off_outlined,
                titulo: mensajeDeError(textos, error),
                accion: FilledButton(
                  onPressed: error is NoEncontradoFailure
                      ? () => context.go(Rutas.actividad)
                      : () => ref.invalidate(cotizacionesProvider(solicitudId)),
                  child: Text(
                    error is NoEncontradoFailure
                        ? textos.solicitudVolverActividad
                        : textos.inicioReintentar,
                  ),
                ),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

class _Lista extends ConsumerWidget {
  const _Lista({required this.solicitudId, required this.resultado});

  final String solicitudId;
  final ResultadoComparacion resultado;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final dominios = ref.watch(dominiosDeFotosProvider);
    final visitaDisponible = ref.watch(visitaDisponibleProvider);
    // Mientras una elección está en curso no se puede elegir otra (R-18).
    final eligiendo =
        ref.watch(eleccionProvider(solicitudId)) is EleccionEnCurso;

    final motivo = resultado.puedeElegir ? null : resultado.motivo;
    final textoMotivo = switch (motivo) {
      MotivoSinEleccion.sinCotizaciones =>
        textos.cotizacionMotivoSinCotizaciones,
      MotivoSinEleccion.vencida => textos.cotizacionMotivoVencida,
      MotivoSinEleccion.cancelada => textos.cotizacionMotivoCancelada,
      MotivoSinEleccion.yaElegida => textos.cotizacionYaElegida,
      null => null,
    };
    final visitaId = resultado.visitaId;

    if (resultado.cotizaciones.isEmpty) {
      return EstadoKnock(
        icono: Icons.hourglass_empty_outlined,
        titulo: textoMotivo ?? textos.cotizacionMotivoSinCotizaciones,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (textoMotivo != null)
          _Aviso(
            texto: textoMotivo,
            accion:
                motivo == MotivoSinEleccion.yaElegida &&
                    visitaId != null &&
                    visitaDisponible
                ? FilledButton(
                    onPressed: () => context.go(Rutas.visita(visitaId)),
                    child: Text(textos.cotizacionVerMiVisita),
                  )
                : null,
          ),
        if (resultado.hayMasDeLasMostradas)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              textos.cotizacionMostrandoDe(
                resultado.cotizaciones.length,
                resultado.totalCotizaciones,
              ),
              style: tema.textTheme.bodyMedium,
            ),
          ),
        if (resultado.tiposMixtos)
          _Aviso(texto: textos.cotizacionTiposMixtos, informativo: true),
        for (final cotizacion in resultado.cotizaciones)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TarjetaCotizacion(
              cotizacion: cotizacion,
              dominiosDeFotos: dominios,
              // Sin «Elegir» cuando el servidor dice que no se puede (CA-09).
              accion: resultado.puedeElegir
                  ? FilledButton(
                      onPressed: eligiendo
                          ? null
                          : () => mostrarHojaConfirmarEleccion(
                              context,
                              solicitudId: solicitudId,
                              cotizacion: cotizacion,
                            ),
                      child: Text(textos.cotizacionElegir),
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}

class _Aviso extends StatelessWidget {
  const _Aviso({required this.texto, this.accion, this.informativo = false});

  final String texto;
  final Widget? accion;
  final bool informativo;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final fondo = informativo
        ? esquema.secondaryContainer
        : esquema.tertiaryContainer;
    final letra = informativo
        ? esquema.onSecondaryContainer
        : esquema.onTertiaryContainer;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texto, style: TextStyle(color: letra)),
          if (accion != null) ...[const SizedBox(height: 8), accion!],
        ],
      ),
    );
  }
}
