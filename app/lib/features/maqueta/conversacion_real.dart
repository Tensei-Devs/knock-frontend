import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/maqueta/bloqueos_reales.dart';
import 'package:app/features/maqueta/perfil_publico_real.dart';
import 'package:app/features/maqueta/reportes_reales.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/mensajes/mensajes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La conversación de la spec 047. Todo lo que se ve viene del servidor y vive
/// solo en memoria.
class ConversacionReal extends ConsumerStatefulWidget {
  const ConversacionReal({
    super.key,
    required this.conversacionId,
    this.tecnicoId,
  });

  final String conversacionId;

  /// Solo se conoce al entrar desde la comparación: sin él no se ofrece
  /// «Ver su perfil» (CA-15).
  final String? tecnicoId;

  @override
  ConsumerState<ConversacionReal> createState() => _ConversacionRealState();
}

class _ConversacionRealState extends ConsumerState<ConversacionReal> {
  late final ConversacionController _controller;

  @override
  void initState() {
    super.initState();
    final globo = ref.read(globoProvider.notifier);
    _controller = ConversacionController(
      conversacionId: widget.conversacionId,
      lectura: ref.read(lecturaDeConversacionProvider),
      envio: ref.read(envioDeMensajesProvider),
      canal: ref.read(canalMensajesProvider),
      alMarcarLeido: () => unawaited(globo.actualizar()),
    )..addListener(_actualizar);
    unawaited(_iniciar());
  }

  Future<void> _iniciar() async {
    await _controller.cargar();
    if (!mounted) return;
    final globo = ref.read(globoProvider);
    if (globo.conectado) {
      await _controller.canalConectado();
    } else if (globo.sinConexion) {
      _controller.canalCaido();
    }
  }

  void _actualizar() {
    if (mounted) setState(() {});
  }

  void _alCambiarCanal(EstadoGlobo? anterior, EstadoGlobo actual) {
    if (actual.conectado && anterior?.conectado != true) {
      unawaited(_controller.canalConectado());
    } else if (!actual.conectado && actual.sinConexion) {
      _controller.canalCaido();
    }
  }

  Future<void> _refrescar() async {
    unawaited(ref.read(globoProvider.notifier).reintentar());
    await _controller.releer();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_actualizar)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(globoProvider, _alCambiarCanal);
    ref.listen(sesionProvider.select((s) => s != null), (_, conSesion) {
      if (!conSesion) _controller.limpiar();
    });
    final t = AppLocalizations.of(context);
    final estado = _controller.estado;
    final detalle = estado.detalle;
    return Pg(
      title: detalle?.contraparte.nombre ?? t.conversacionTitulo,
      sub: detalle?.servicio,
      scroll: false,
      pad: false,
      padBottom: 0,
      right: detalle == null ? null : _menu(context, t, detalle),
      body: detalle == null ? _sinDetalle(t, estado) : _cuerpo(t, estado),
    );
  }

  Widget _sinDetalle(AppLocalizations t, EstadoDeConversacion estado) {
    final falla = estado.falla;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: stack([
          if (falla == null)
            sMut(t.conversacionCargando)
          else if (falla is NoEncontradoFailure)
            // La misma frase para una ajena o inexistente (CA-13).
            NoteK('amber', 'help', t.chatEnvioConversacionNoDisponible)
          else ...[
            NoteK('red', 'help', mensajeDeError(t, falla)),
            BtnK(t.bloqueosReintentar, _controller.cargar, kind: Bk.sec),
          ],
        ], gap: 12),
      ),
    );
  }

  Widget _cuerpo(AppLocalizations t, EstadoDeConversacion estado) {
    final detalle = estado.detalle!;
    final cerrada = detalle.cerrada || _controller.envio.estado.cerrada;
    final noDisponible = estado.falla is NoEncontradoFailure;
    return LayoutBuilder(
      builder: (context, medidas) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // El aviso del servidor siempre está a la vista (CA-03). Con texto
          // grande, cada franja se desplaza dentro de su límite.
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: medidas.maxHeight * 0.3),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: stack([
                NoteK('amber', 'help', detalle.avisoSeguridad),
                if (estado.sinCanal) ...[
                  sMut(t.conversacionSinEnVivo),
                  BtnK(t.conversacionActualizar, _refrescar, kind: Bk.sec),
                ],
                if (noDisponible)
                  NoteK('red', 'help', t.chatEnvioConversacionNoDisponible),
              ], gap: 8),
            ),
          ),
          Expanded(child: _historial(t, estado, detalle)),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: medidas.maxHeight * 0.45),
            child: SingleChildScrollView(
              reverse: true,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: cerrada || noDisponible
                  ? Semantics(
                      liveRegion: true,
                      child: sMut(_motivoDeCierre(t, detalle.motivoCierre)),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _respuestasRapidas(t, detalle),
                        CampoEnvioMensaje(
                          controller: _controller.envio,
                          mostrarEnviados: false,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historial(
    AppLocalizations t,
    EstadoDeConversacion estado,
    DetalleDeConversacion detalle,
  ) {
    final mensajes = estado.mensajes;
    if (mensajes.isEmpty) {
      return Center(
        child: SingleChildScrollView(child: sMut(t.conversacionSinMensajes)),
      );
    }
    final hayAnteriores = estado.siguiente != null;
    return NotificationListener<ScrollNotification>(
      onNotification: (aviso) {
        // La lista va invertida: el final del recorrido es lo más antiguo.
        if (aviso is ScrollUpdateNotification &&
            estado.fallaDeAnteriores == null &&
            aviso.metrics.pixels >= aviso.metrics.maxScrollExtent - 80) {
          unawaited(_controller.cargarAnteriores());
        }
        return false;
      },
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: mensajes.length + (hayAnteriores ? 1 : 0),
        itemBuilder: (context, i) {
          if (i == mensajes.length) {
            return stack([
              if (estado.fallaDeAnteriores case final falla?)
                sMut(mensajeDeError(t, falla)),
              BtnK(
                t.conversacionVerAnteriores,
                estado.cargandoAnteriores ? null : _controller.cargarAnteriores,
                kind: Bk.ghost,
              ),
            ], gap: 4);
          }
          return _Burbuja(mensajes[mensajes.length - 1 - i], detalle);
        },
      ),
    );
  }

  Widget _respuestasRapidas(AppLocalizations t, DetalleDeConversacion detalle) {
    final textos = !detalle.esCliente
        ? [
            t.conversacionRapidaFoto,
            t.conversacionRapidaColonia,
            t.conversacionRapidaDia,
            t.conversacionRapidaMateriales,
          ]
        : detalle.visitaId == null
        ? [
            t.conversacionRapidaCuando,
            t.conversacionRapidaIncluye,
            t.conversacionRapidaTarda,
          ]
        : [
            t.conversacionRapidaEnCamino,
            t.conversacionRapidaIncluye,
            t.conversacionRapidaGracias,
          ];
    final ocupado = _controller.envio.estado.enviando;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          for (final texto in textos)
            ActionChip(
              label: Text(texto),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onPressed: ocupado
                  ? null
                  : () => unawaited(_controller.envio.enviar(texto)),
            ),
        ],
      ),
    );
  }

  /// Solo lo que se puede cumplir; sin opciones no hay menú (CA-15).
  Widget? _menu(
    BuildContext context,
    AppLocalizations t,
    DetalleDeConversacion detalle,
  ) {
    final tecnicoId = widget.tecnicoId;
    final visitaId = detalle.visitaId;
    final opciones = <(String, WidgetBuilder)>[
      if (detalle.esCliente && tecnicoId != null)
        (
          t.conversacionVerPerfil,
          (_) => Pg(
            title: detalle.contraparte.nombre,
            body: PerfilPublicoReal(tecnicoId: tecnicoId, conSesion: true),
          ),
        ),
      if (detalle.esCliente && visitaId != null) ...[
        (
          t.conversacionReportar,
          (_) => ReportarReal(visitaId: visitaId, trabajo: detalle.servicio),
        ),
        (
          t.conversacionBloquear,
          (_) => Pg(
            title: t.bloqueosPantallaBloquear,
            body: BloquearReal(visitaId: visitaId, trabajo: detalle.servicio),
          ),
        ),
      ],
    ];
    if (opciones.isEmpty) return null;
    return PopupMenuButton<int>(
      tooltip: t.conversacionMenu,
      onSelected: (i) => unawaited(
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: opciones[i].$2)),
      ),
      itemBuilder: (_) => [
        for (final (i, opcion) in opciones.indexed)
          PopupMenuItem(value: i, child: Text(opcion.$1)),
      ],
    );
  }
}

String _motivoDeCierre(AppLocalizations t, String? motivo) => switch (motivo) {
  'request_cancelled' => t.conversacionCerradaCancelada,
  'request_expired' => t.conversacionCerradaVencida,
  'other_quote_chosen' => t.conversacionCerradaOtraElegida,
  'dismissed' => t.conversacionCerradaDescartada,
  _ => t.chatEnvioCerrada,
};

class _Burbuja extends StatelessWidget {
  const _Burbuja(this.mensaje, this.detalle);

  final Mensaje mensaje;
  final DetalleDeConversacion detalle;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final k = kc(context);
    final propio = mensaje.autorRol == detalle.rol;
    final autor = propio ? t.conversacionTu : detalle.contraparte.nombre;
    final material = MaterialLocalizations.of(context);
    final local = mensaje.enviadoEn.toLocal();
    final hora =
        '${material.formatShortMonthDay(local)} '
        '${material.formatTimeOfDay(TimeOfDay.fromDateTime(local))}';
    // Se lee junto: autor, hora, texto y, si aplica, el aviso (CA-17). Lo
    // propio se distingue por el lado y por el nombre, no solo por el color.
    return MergeSemantics(
      child: Align(
        alignment: propio ? Alignment.centerRight : Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.85,
          child: Column(
            crossAxisAlignment: propio
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              sMut('$autor · $hora', size: 12),
              Container(
                margin: const EdgeInsets.only(top: 2, bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: propio ? k.navySoft : k.surface,
                  border: Border.all(color: k.line2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    T(mensaje.texto),
                    if (mensaje.contactoOculto)
                      sMut(t.chatContactoOculto, size: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
