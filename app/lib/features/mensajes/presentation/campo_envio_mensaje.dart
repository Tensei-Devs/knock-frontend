import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

import '../domain/mensaje.dart';
import 'envio_mensajes_controller.dart';

/// Texto para la falla de un envío (spec 020, enmienda 2026-11-26, CA-E02).
String textoDeFallaDeEnvio(AppLocalizations t, Failure falla) =>
    switch (falla) {
      ContenidoRechazadoFailure() => t.chatEnvioErrorContenido,
      DemasiadosIntentosFailure(:final espera) => t.chatEnvioErrorLimite(
        _segundos(espera),
      ),
      ModeracionNoDisponibleFailure() ||
      ServicioNoDisponibleFailure() => t.chatEnvioErrorNoDisponible,
      ConflictoFailure() => t.chatEnvioCerrada,
      NoEncontradoFailure() => t.chatEnvioConversacionNoDisponible,
      _ => mensajeDeError(t, falla),
    };

int _segundos(Duration? espera) {
  if (espera == null || espera <= Duration.zero) return 30;
  return (espera.inMilliseconds / 1000).ceil();
}

String? _textoDeMotivo(AppLocalizations t, MotivoTextoInvalido? motivo) =>
    switch (motivo) {
      MotivoTextoInvalido.muyLargo => t.chatEnvioMuyLargo,
      MotivoTextoInvalido.caracterNoPermitido => t.chatEnvioCaracterNoPermitido,
      MotivoTextoInvalido.vacio || null => null,
    };

/// Mensajes propios (pendiente, fallido o enviado) y campo para escribir.
///
/// Pieza mínima sobre [EnvioMensajesController]; todavía no la monta ninguna
/// pantalla (la conversación es la spec 047). Con la conversación cerrada no hay
/// campo: solo el aviso.
class CampoEnvioMensaje extends StatefulWidget {
  const CampoEnvioMensaje({super.key, required this.controller});

  final EnvioMensajesController controller;

  @override
  State<CampoEnvioMensaje> createState() => _CampoEnvioMensajeState();
}

class _CampoEnvioMensajeState extends State<CampoEnvioMensaje> {
  final _texto = TextEditingController();
  MotivoTextoInvalido? _motivo = MotivoTextoInvalido.vacio;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_actualizar);
    _texto.addListener(_alEscribir);
  }

  @override
  void didUpdateWidget(CampoEnvioMensaje anterior) {
    super.didUpdateWidget(anterior);
    if (anterior.controller != widget.controller) {
      anterior.controller.removeListener(_actualizar);
      widget.controller.addListener(_actualizar);
    }
  }

  void _actualizar() {
    if (mounted) setState(() {});
  }

  void _alEscribir() {
    final motivo = TextoDeMensaje.validar(_texto.text);
    if (motivo != _motivo) setState(() => _motivo = motivo);
  }

  void _enviar() {
    final texto = _texto.text;
    if (TextoDeMensaje.validar(texto) != null) return;
    // El texto pasa al mensaje pendiente; si falla se conserva allí con
    // «Reintentar» (CA-E02).
    _texto.clear();
    unawaited(widget.controller.enviar(texto));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_actualizar);
    _texto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final estado = widget.controller.estado;
    final falla = estado.ultimaFalla;
    final puedeEnviar = !estado.cerrada && !estado.enviando && _motivo == null;
    final motivo = _textoDeMotivo(t, _motivo);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final m in estado.mensajes)
          _MensajePropioVista(m, widget.controller),
        if (falla != null && !estado.cerrada)
          Semantics(
            liveRegion: true,
            child: Text(
              textoDeFallaDeEnvio(t, falla),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (estado.cerrada)
          Semantics(liveRegion: true, child: Text(t.chatEnvioCerrada))
        else
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _texto,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: t.chatEnvioCampo,
                    errorText: motivo,
                  ),
                ),
              ),
              IconButton(
                tooltip: t.chatEnvioEnviar,
                onPressed: puedeEnviar ? _enviar : null,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
      ],
    );
  }
}

class _MensajePropioVista extends StatelessWidget {
  const _MensajePropioVista(this.mensaje, this.controller);

  final MensajePropio mensaje;
  final EnvioMensajesController controller;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cerrada = controller.estado.cerrada;
    final ocupado = controller.estado.enviando;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(mensaje.textoVisible),
            if (mensaje.contactoOculto)
              Text(t.chatContactoOculto, style: const TextStyle(fontSize: 12)),
            if (mensaje.estado == EstadoDeEnvio.pendiente)
              Text(t.chatEnvioPendiente, style: const TextStyle(fontSize: 12)),
            if (mensaje.estado == EstadoDeEnvio.fallido) ...[
              Text(t.chatEnvioFallido, style: const TextStyle(fontSize: 12)),
              Wrap(
                spacing: 8,
                children: [
                  if (!cerrada)
                    TextButton(
                      onPressed: ocupado
                          ? null
                          : () => unawaited(
                              controller.reintentar(mensaje.idLocal),
                            ),
                      child: Text(t.chatEnvioReintentar),
                    ),
                  TextButton(
                    onPressed: () => controller.descartar(mensaje.idLocal),
                    child: Text(t.chatEnvioDescartar),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
