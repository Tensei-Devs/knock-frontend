import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/plataforma/captura_en_recientes.dart';
import 'package:app/core/plataforma/enlaces.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/widgets/estado_knock.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:app/features/actividad/presentation/visita_controller.dart';
import 'package:app/features/actividad/presentation/widgets/codigo_visita.dart';
import 'package:app/features/actividad/presentation/widgets/hoja_avisar.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// «Tu visita»: a domicilio con el código de 4 dígitos, o la cita en taller
/// con «Cómo llegar» (spec 016, KNOCK-83). Se refresca al abrirla y al volver
/// a la app, sin sondeo continuo (§7).
class VisitaScreen extends ConsumerStatefulWidget {
  const VisitaScreen({required this.id, super.key});

  final String id;

  @override
  ConsumerState<VisitaScreen> createState() => _VisitaScreenState();
}

class _VisitaScreenState extends ConsumerState<VisitaScreen>
    with WidgetsBindingObserver {
  late final CapturaEnRecientes _captura;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _captura = ref.read(capturaEnRecientesProvider);
    // R-18: sin miniatura del código en la vista de tareas recientes.
    unawaited(_captura.permitir(permitir: false));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_captura.permitir(permitir: true));
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState estado) {
    if (estado == AppLifecycleState.resumed) {
      ref.invalidate(visitaProvider(widget.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final vista = ref.watch(visitaProvider(widget.id));
    return Scaffold(
      appBar: AppBar(title: Text(textos.visitaTitulo)),
      body: switch (vista) {
        AsyncData(value: VisitaEnLinea(:final visita)) => _VisitaEnLinea(
          visita: visita,
        ),
        AsyncData(value: VisitaSinConexion(:final guardada)) => _VisitaGuardada(
          guardada: guardada,
        ),
        AsyncError(:final error) => EstadoKnock(
          icono: error is NoEncontradoFailure
              ? Icons.search_off_outlined
              : Icons.cloud_off_outlined,
          titulo: error is NoEncontradoFailure
              ? textos.visitaNoDisponible
              : mensajeDeError(textos, error),
          accion: error is NoEncontradoFailure
              ? FilledButton(
                  onPressed: () => context.go(Rutas.actividad),
                  child: Text(textos.solicitudVolverActividad),
                )
              : FilledButton(
                  onPressed: () => ref.invalidate(visitaProvider(widget.id)),
                  child: Text(textos.inicioReintentar),
                ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

String _cuando(BuildContext context, DateTime dia, String hora) {
  final idioma = Localizations.localeOf(context).toLanguageTag();
  return AppLocalizations.of(context)
      .visitaCuando(DateFormat('EEEE d MMMM', idioma).format(dia), hora);
}

class _VisitaEnLinea extends ConsumerWidget {
  const _VisitaEnLinea({required this.visita});

  final Visita visita;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final tecnico = visita.tecnico;
    final avisoDisponible = ref.watch(avisoDeConfianzaDisponibleProvider);
    final codigo = visita.codigo;
    final motivo = visita.motivoCodigo;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Chip(label: Text(_estado(textos, visita.estado))),
        ),
        const SizedBox(height: 8),
        if (visita.esTaller)
          Text(textos.visitaTaller, style: tema.textTheme.titleLarge),
        Text(tecnico.nombre, style: tema.textTheme.headlineSmall),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              tecnico.verificado ? Icons.verified_outlined : Icons.help_outline,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              tecnico.verificado
                  ? textos.visitaVerificado
                  : textos.visitaSinVerificar,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(_cuando(context, visita.dia, visita.hora)),
        const SizedBox(height: 16),
        if (visita.esTaller) ...[
          Text(textos.visitaDireccionTaller(visita.direccion)),
          const SizedBox(height: 8),
          _BotonEnlace(
            icono: Icons.directions_outlined,
            texto: textos.visitaComoLlegar,
            enlace: Enlaces.mapa(visita.direccion),
            avisoSiFalla: textos.visitaSinMapas,
          ),
        ] else if (codigo != null) ...[
          CodigoVisita(codigo: codigo),
          const SizedBox(height: 8),
          Text(textos.visitaCodigoRegla(tecnico.nombre)),
        ],
        if (codigo == null && motivo != null && !visita.esTaller)
          Text(_mensajeMotivo(textos, motivo), style: tema.textTheme.bodyLarge),
        const SizedBox(height: 16),
        _Contacto(tecnico: tecnico),
        if (visita.puedeAvisar && avisoDisponible) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => mostrarHojaAvisar(context, visita.id),
            icon: const Icon(Icons.share_outlined),
            label: Text(textos.visitaAvisar),
          ),
        ],
      ],
    );
  }
}

/// Sin conexión: los datos mínimos guardados (CA-02).
class _VisitaGuardada extends StatelessWidget {
  const _VisitaGuardada({required this.guardada});

  final VisitaGuardada guardada;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final codigo = guardada.codigo;
    final direccion = guardada.direccionTaller;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Semantics(
          liveRegion: true,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tema.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              textos.visitaSinConexion,
              style: TextStyle(color: tema.colorScheme.onSecondaryContainer),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(guardada.tecnicoNombre, style: tema.textTheme.headlineSmall),
        Text(_cuando(context, guardada.dia, guardada.hora)),
        const SizedBox(height: 16),
        if (direccion != null)
          Text(textos.visitaDireccionTaller(direccion))
        else if (codigo != null) ...[
          CodigoVisita(codigo: codigo),
          const SizedBox(height: 8),
          Text(textos.visitaCodigoRegla(guardada.tecnicoNombre)),
        ],
      ],
    );
  }
}

class _Contacto extends StatelessWidget {
  const _Contacto({required this.tecnico});

  final TecnicoDeVisita tecnico;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final telefono = tecnico.telefono;
    final whatsapp = tecnico.whatsapp;
    final llamada = telefono == null ? null : Enlaces.llamada(telefono);
    final chat = whatsapp == null ? null : Enlaces.whatsapp(whatsapp);
    if (llamada == null && chat == null) {
      return Text(textos.cotizacionSinTelefono);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (llamada != null)
          _BotonEnlace(
            icono: Icons.phone_outlined,
            texto: textos.visitaLlamar,
            enlace: llamada,
            avisoSiFalla: textos.visitaNoSePudoAbrir(telefono!),
          ),
        if (chat != null)
          _BotonEnlace(
            icono: Icons.chat_outlined,
            texto: textos.visitaWhatsapp,
            enlace: chat,
            avisoSiFalla: textos.visitaNoSePudoAbrir(whatsapp!),
          ),
      ],
    );
  }
}

/// Abre un enlace del sistema; si no hay app, avisa sin bloquear (R-05).
class _BotonEnlace extends ConsumerWidget {
  const _BotonEnlace({
    required this.icono,
    required this.texto,
    required this.enlace,
    required this.avisoSiFalla,
  });

  final IconData icono;
  final String texto;
  final Uri enlace;
  final String avisoSiFalla;

  @override
  Widget build(BuildContext context, WidgetRef ref) => OutlinedButton.icon(
    onPressed: () async {
      final mensajero = ScaffoldMessenger.of(context);
      final abierto = await ref.read(abridorDeEnlacesProvider).abrir(enlace);
      if (!abierto) {
        mensajero.showSnackBar(SnackBar(content: Text(avisoSiFalla)));
      }
    },
    icon: Icon(icono),
    label: Text(texto),
  );
}

String _estado(AppLocalizations textos, EstadoVisita estado) =>
    switch (estado) {
      EstadoVisita.confirmada => textos.visitaEstadoConfirmada,
      EstadoVisita.enCurso => textos.visitaEstadoEnCurso,
      EstadoVisita.terminada => textos.visitaEstadoTerminada,
      EstadoVisita.cancelada ||
      EstadoVisita.noPresentado => textos.visitaEstadoCancelada,
      EstadoVisita.desconocido => textos.solicitudEstadoEnProceso,
    };

/// Texto de cada motivo sin código (spec 016 §7).
String _mensajeMotivo(AppLocalizations textos, MotivoCodigo motivo) {
  final mensajes = {
    MotivoCodigo.usado: textos.visitaMotivoUsado,
    MotivoCodigo.vencido: textos.visitaMotivoVencido,
    MotivoCodigo.bloqueada: textos.visitaMotivoBloqueada,
    MotivoCodigo.noAplica: textos.visitaMotivoNoAplica,
  };
  return mensajes[motivo]!;
}
