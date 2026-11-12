import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detalle de una solicitud con carga, datos, error y «ya no está disponible»
/// (spec 015, §7). La comparación de cotizaciones llega en el siguiente corte.
class SolicitudDetalleScreen extends ConsumerWidget {
  const SolicitudDetalleScreen({required this.id, super.key});

  final String id;

  String _estado(AppLocalizations t, EstadoSolicitud e) => switch (e) {
    EstadoSolicitud.enviada => t.solicitudEstadoEnviada,
    EstadoSolicitud.cotizando => t.solicitudEstadoCotizando,
    EstadoSolicitud.citaConfirmada => t.solicitudEstadoCita,
    EstadoSolicitud.vencida => t.solicitudEstadoVencida,
    EstadoSolicitud.terminada ||
    EstadoSolicitud.calificada => t.solicitudEstadoTerminada,
    EstadoSolicitud.cancelada => t.solicitudEstadoCancelada,
    EstadoSolicitud.enProceso => t.solicitudEstadoEnProceso,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final solicitud = ref.watch(solicitudDetalleProvider(id));
    final Widget cuerpo;
    if (solicitud.isLoading) {
      cuerpo = const Center(child: CircularProgressIndicator());
    } else if (solicitud.hasError) {
      final error = solicitud.error!;
      cuerpo = Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mensajeDeError(textos, error)),
            if (error is! NoEncontradoFailure) ...[
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(solicitudDetalleProvider(id)),
                child: Text(textos.solicitudReintentar),
              ),
            ],
          ],
        ),
      );
    } else {
      final s = solicitud.requireValue;
      cuerpo = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(s.oficioNombre, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(_estado(textos, s.estado)),
          const SizedBox(height: 12),
          Text(s.descripcion),
          const SizedBox(height: 12),
          if (s.estado == EstadoSolicitud.vencida)
            Text(textos.solicitudVencidaAviso)
          else
            Text(textos.solicitudSinCotizaciones),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(textos.solicitudDetalleTitulo)),
      body: cuerpo,
    );
  }
}
