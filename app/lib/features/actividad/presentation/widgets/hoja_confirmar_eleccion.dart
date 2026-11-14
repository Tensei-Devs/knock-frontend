import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/presentation/cotizaciones_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Abre la hoja para elegir [cotizacion] (spec 015, D-08: hoja modal, no ruta).
/// Al cerrarla, la cita se olvida (D-16).
Future<void> mostrarHojaConfirmarEleccion(
  BuildContext context, {
  required String solicitudId,
  required Cotizacion cotizacion,
}) async {
  final contenedor = ProviderScope.containerOf(context);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    // Se cierra solo con sus botones: así no se cierra a media elección (R-18).
    isDismissible: false,
    enableDrag: false,
    builder: (_) => UncontrolledProviderScope(
      container: contenedor,
      child: HojaConfirmarEleccion(
        solicitudId: solicitudId,
        cotizacion: cotizacion,
      ),
    ),
  );
  contenedor.read(eleccionProvider(solicitudId).notifier).reiniciar();
}

/// Confirmación de la elección y, después, la cita con el contacto público del
/// técnico y el lugar (spec 015, CA-11, CA-12, R-09 y R-18).
class HojaConfirmarEleccion extends ConsumerWidget {
  const HojaConfirmarEleccion({
    required this.solicitudId,
    required this.cotizacion,
    super.key,
  });

  final String solicitudId;
  final Cotizacion cotizacion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(eleccionProvider(solicitudId));
    final enCurso = estado is EleccionEnCurso;
    return PopScope(
      canPop: !enCurso,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: switch (estado) {
            EleccionHecha(:final cita) => _Cita(cita: cita),
            _ => _Confirmacion(
              solicitudId: solicitudId,
              cotizacion: cotizacion,
              estado: estado,
            ),
          },
        ),
      ),
    );
  }
}

String _formatoPesos(BuildContext context, int monto) {
  final idioma = Localizations.localeOf(context).toLanguageTag();
  return NumberFormat.currency(
    locale: idioma.startsWith('es') ? 'es_MX' : 'en_US',
    symbol: r'$',
    decimalDigits: 0,
  ).format(monto);
}

String _cuando(BuildContext context, DateTime dia, String hora) {
  final textos = AppLocalizations.of(context);
  final idioma = Localizations.localeOf(context).toLanguageTag();
  return textos.cotizacionCuando(
    DateFormat('EEEE d MMMM', idioma).format(dia),
    hora,
  );
}

class _Confirmacion extends ConsumerWidget {
  const _Confirmacion({
    required this.solicitudId,
    required this.cotizacion,
    required this.estado,
  });

  final String solicitudId;
  final Cotizacion cotizacion;
  final EstadoEleccion estado;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final control = ref.read(eleccionProvider(solicitudId).notifier);
    final enCurso = estado is EleccionEnCurso;
    final fallida = estado is EleccionFallida
        ? estado as EleccionFallida
        : null;
    final puedeConfirmar = fallida == null || fallida.sePuedeReintentar;
    final mensajeError = switch (fallida?.falla) {
      null => null,
      ServicioNoDisponibleFailure() => textos.cotizacionErrorEleccion,
      final Failure falla => mensajeDeError(textos, falla),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          textos.cotizacionConfirmarTitulo(cotizacion.tecnico.nombre),
          style: tema.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(_cuando(context, cotizacion.dia, cotizacion.hora)),
        Text(textos.cotizacionTope(_formatoPesos(context, cotizacion.tope))),
        const SizedBox(height: 12),
        Text(textos.cotizacionConfirmarAvisoContacto),
        if (mensajeError != null) ...[
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Text(
              mensajeError,
              style: TextStyle(color: tema.colorScheme.error),
            ),
          ),
        ],
        if (enCurso) ...[
          const SizedBox(height: 16),
          Semantics(
            label: textos.cotizacionEligiendo,
            child: const LinearProgressIndicator(),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: enCurso ? null : () => Navigator.of(context).pop(),
                child: Text(textos.cotizacionCancelar),
              ),
            ),
            if (puedeConfirmar) ...[
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: enCurso
                      ? null
                      : () => control.elegir(cotizacion.id),
                  child: Text(textos.cotizacionConfirmar),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _Cita extends ConsumerWidget {
  const _Cita({required this.cita});

  final CitaConfirmada cita;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final visitaDisponible = ref.watch(visitaDisponibleProvider);
    final tecnico = cita.tecnico;
    final precio = cita.precio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            textos.cotizacionCitaConfirmada,
            style: tema.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 12),
        Text(tecnico.nombre, style: tema.textTheme.titleMedium),
        Text(_cuando(context, cita.dia, cita.hora)),
        if (precio != null)
          Text(textos.cotizacionPrecioFijo(_formatoPesos(context, precio))),
        Text(textos.cotizacionTope(_formatoPesos(context, cita.tope))),
        Text(
          cita.modalidad == 'taller'
              ? textos.solicitudModalidadTaller
              : textos.solicitudModalidadDomicilio,
        ),
        const SizedBox(height: 12),
        // El contacto y el lugar solo existen en la cita, después de confirmar.
        if (tecnico.telefono != null)
          SelectableText(textos.cotizacionTelefono(tecnico.telefono!)),
        if (tecnico.whatsapp != null)
          SelectableText(textos.cotizacionWhatsapp(tecnico.whatsapp!)),
        if (!tecnico.publicoContacto) Text(textos.cotizacionSinTelefono),
        const SizedBox(height: 8),
        Text(textos.cotizacionLugar(cita.direccion)),
        const SizedBox(height: 20),
        Row(
          children: [
            if (visitaDisponible) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final router = GoRouter.of(context);
                    Navigator.of(context).pop();
                    router.go(Rutas.visita(cita.visitaId));
                  },
                  child: Text(textos.cotizacionVerMiVisita),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(textos.cotizacionListo),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
