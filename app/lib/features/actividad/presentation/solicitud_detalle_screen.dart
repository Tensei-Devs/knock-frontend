import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// La solicitud [id] de la persona. Sin caché (spec 015, R-11).
final solicitudDetalleProvider = FutureProvider.autoDispose
    .family<Solicitud, String>(
      (ref, id) => ref.watch(solicitudRepositoryProvider).obtener(id),
    );

/// Detalle de una solicitud: estado, oficio, descripción, día, franja y
/// número de fotos (spec 015, §7). Un 404 se muestra como «ya no está
/// disponible», igual para una ajena que para una inexistente (CA-13).
class SolicitudDetalleScreen extends ConsumerWidget {
  const SolicitudDetalleScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final detalle = ref.watch(solicitudDetalleProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text(textos.solicitudDetalleTitulo)),
      body: switch (detalle) {
        AsyncData(:final value) => _Contenido(solicitud: value),
        AsyncError(:final error) => EstadoKnock(
          icono: error is NoEncontradoFailure
              ? Icons.search_off_outlined
              : Icons.cloud_off_outlined,
          titulo: mensajeDeError(textos, error),
          accion: error is NoEncontradoFailure
              ? FilledButton(
                  onPressed: () => context.go(Rutas.actividad),
                  child: Text(textos.solicitudVolverActividad),
                )
              : FilledButton(
                  onPressed: () => ref.invalidate(solicitudDetalleProvider(id)),
                  child: Text(textos.inicioReintentar),
                ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({required this.solicitud});

  final Solicitud solicitud;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final idioma = Localizations.localeOf(context).toLanguageTag();
    final estado = switch (solicitud.estado) {
      EstadoSolicitud.enviada => textos.solicitudEstadoEnviada,
      EstadoSolicitud.cotizando => textos.solicitudEstadoCotizando,
      EstadoSolicitud.citaConfirmada => textos.solicitudEstadoCita,
      EstadoSolicitud.terminada ||
      EstadoSolicitud.calificada => textos.solicitudEstadoTerminada,
      EstadoSolicitud.cancelada => textos.solicitudEstadoCancelada,
      EstadoSolicitud.vencida => textos.solicitudEstadoVencida,
      EstadoSolicitud.desconocido => textos.solicitudEstadoEnProceso,
    };
    final franja = switch (solicitud.franja) {
      Franja.manana => textos.solicitudFranjaManana,
      Franja.tarde => textos.solicitudFranjaTarde,
      Franja.noche => textos.solicitudFranjaNoche,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Chip(
            avatar: const Icon(Icons.schedule_send_outlined, size: 18),
            label: Text(estado),
          ),
        ),
        const SizedBox(height: 12),
        Text(solicitud.oficioNombre, style: tema.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(solicitud.descripcion, style: tema.textTheme.bodyLarge),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.event_outlined),
          title: Text(
            textos.solicitudCuando(
              DateFormat('EEEE d MMMM', idioma).format(solicitud.dia),
              franja,
            ),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.photo_library_outlined),
          title: Text(textos.solicitudTotalFotos(solicitud.totalFotos)),
        ),
        const SizedBox(height: 16),
        // «Ver y elegir (N)» solo con cotizaciones; sin ellas, el aviso de §7.
        if (solicitud.totalCotizaciones > 0)
          FilledButton(
            onPressed: () => context.go(Rutas.cotizaciones(solicitud.id)),
            child: Text(
              textos.solicitudVerCotizaciones(solicitud.totalCotizaciones),
            ),
          )
        else
          Text(
            textos.cotizacionMotivoSinCotizaciones,
            style: tema.textTheme.bodyMedium,
          ),
      ],
    );
  }
}
