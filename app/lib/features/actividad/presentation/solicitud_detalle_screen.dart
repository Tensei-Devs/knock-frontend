import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/regla_cancelacion.dart';
import 'package:app/features/actividad/domain/vencimiento.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// La solicitud [id] de la persona. Sin caché (spec 015, R-11). Mientras
/// espera cotizaciones se vuelve a pedir sola cada
/// [intervaloRefrescoSolicitudProvider], para que «Ver y elegir (N)» aparezca
/// sin salir de la pantalla; el temporizador se cancela al cerrarla.
final solicitudDetalleProvider = FutureProvider.autoDispose
    .family<Solicitud, String>((ref, id) async {
      final solicitud = await ref
          .watch(solicitudRepositoryProvider)
          .obtener(id);
      final intervalo = ref.watch(intervaloRefrescoSolicitudProvider);
      if (intervalo != null && esperaCotizaciones(solicitud)) {
        final temporizador = Timer(intervalo, ref.invalidateSelf);
        ref.onDispose(temporizador.cancel);
      }
      return solicitud;
    });

/// Si la solicitud aún no tiene cotizaciones que mostrar.
bool esperaCotizaciones(Solicitud solicitud) =>
    solicitud.totalCotizaciones == 0 &&
    (solicitud.estado == EstadoSolicitud.enviada ||
        solicitud.estado == EstadoSolicitud.cotizando);

/// Texto del estado de una solicitud (spec 015, §7).
String textoEstadoSolicitud(AppLocalizations textos, EstadoSolicitud estado) =>
    switch (estado) {
      EstadoSolicitud.enviada => textos.solicitudEstadoEnviada,
      EstadoSolicitud.cotizando => textos.solicitudEstadoCotizando,
      EstadoSolicitud.citaConfirmada => textos.solicitudEstadoCita,
      EstadoSolicitud.terminada ||
      EstadoSolicitud.calificada => textos.solicitudEstadoTerminada,
      EstadoSolicitud.cancelada => textos.solicitudEstadoCancelada,
      EstadoSolicitud.vencida => textos.solicitudEstadoVencida,
      EstadoSolicitud.desconocido => textos.solicitudEstadoEnProceso,
    };

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

class _Contenido extends ConsumerWidget {
  const _Contenido({required this.solicitud});

  final Solicitud solicitud;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final idioma = Localizations.localeOf(context).toLanguageTag();
    final estado = textoEstadoSolicitud(textos, solicitud.estado);
    final puedeCancelar = ReglaCancelacion(solicitud.estado).puedeCancelar;
    final vencimiento = solicitud.venceEn;
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
        if (puedeCancelar && vencimiento != null)
          Text(switch (Vencimiento(
            venceEn: vencimiento,
            ahora: ref.watch(relojSolicitudProvider)(),
          ).presentacion) {
            VencimientoAbsoluto(:final dia, :final hora) =>
              textos.solicitudVenceEl(
                DateFormat.yMMMMd(idioma).format(dia),
                hora,
              ),
            VencimientoRelativo(:final horas) => textos.solicitudVenceEnHoras(
              horas,
            ),
            MenosDeUnaHora() => textos.solicitudVenceMenosHora,
            VencimientoCerrando() => textos.solicitudCerrando,
          }),
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
        if (puedeCancelar)
          TextButton.icon(
            onPressed: () => _mostrarCancelacion(context, ref, solicitud.id),
            icon: const Icon(Icons.cancel_outlined),
            label: Text(textos.solicitudCancelar),
          ),
      ],
    );
  }
}

Future<void> _mostrarCancelacion(
  BuildContext context,
  WidgetRef ref,
  String id,
) async {
  final textos = AppLocalizations.of(context);
  MotivoCancelacion? motivo;
  var enviando = false;
  String? error;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, actualizar) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textos.solicitudCancelarTitulo,
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              Text(textos.solicitudCancelarDetalle),
              Text(textos.solicitudCancelarMotivo),
              Wrap(
                children: [
                  for (final (valor, nombre) in [
                    (
                      MotivoCancelacion.yaNoLoNecesito,
                      textos.solicitudMotivoYaNo,
                    ),
                    (
                      MotivoCancelacion.loResolviPorOtroMedio,
                      textos.solicitudMotivoResolvi,
                    ),
                    (MotivoCancelacion.tardaMucho, textos.solicitudMotivoTarda),
                    (MotivoCancelacion.otro, textos.solicitudMotivoOtro),
                  ])
                    ChoiceChip(
                      label: Text(nombre),
                      selected: motivo == valor,
                      onSelected: enviando
                          ? null
                          : (_) => actualizar(
                              () => motivo = motivo == valor ? null : valor,
                            ),
                    ),
                ],
              ),
              if (error != null) Text(error!),
              TextButton(
                onPressed: enviando ? null : () => Navigator.pop(ctx),
                child: Text(textos.solicitudCancelarMantener),
              ),
              FilledButton(
                onPressed: enviando
                    ? null
                    : () async {
                        actualizar(() {
                          enviando = true;
                          error = null;
                        });
                        final resultado = await ref
                            .read(solicitudRepositoryProvider)
                            .cancelar(id, motivo: motivo);
                        if (!ctx.mounted) return;
                        if (resultado is Cancelada) {
                          ref.invalidate(solicitudDetalleProvider(id));
                          ref.invalidate(solicitudesActividadProvider);
                          Navigator.pop(ctx);
                          return;
                        }
                        if (resultado is CancelacionConCita ||
                            resultado is CancelacionYaVencida) {
                          ref.invalidate(solicitudDetalleProvider(id));
                        }
                        actualizar(() {
                          enviando = false;
                          error = switch (resultado) {
                            CancelacionConCita() =>
                              textos.solicitudErrorConCita,
                            CancelacionYaVencida() =>
                              textos.solicitudErrorYaVencida,
                            CancelacionNoDisponible() => mensajeDeError(
                              textos,
                              const NoEncontradoFailure(),
                            ),
                            _ => mensajeDeError(
                              textos,
                              const ServicioNoDisponibleFailure(),
                            ),
                          };
                        });
                      },
                child: enviando
                    ? const CircularProgressIndicator()
                    : Text(textos.solicitudCancelarConfirmar),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
