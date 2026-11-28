import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/mensajes/mensajes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Preguntar» (cliente) o «Chatear» (técnico): abre la conversación de una
/// solicitud y entra en ella (spec 047, CA-01).
class BotonConversacion extends ConsumerStatefulWidget {
  const BotonConversacion({
    super.key,
    required this.etiqueta,
    required this.solicitudId,
    this.tecnicoId,
    this.kind = Bk.ghost,
    this.sm = false,
    this.auto = false,
  });

  final String etiqueta;
  final String solicitudId;

  /// Lo manda el cliente; el técnico no.
  final String? tecnicoId;
  final Bk kind;
  final bool sm;
  final bool auto;

  @override
  ConsumerState<BotonConversacion> createState() => _BotonConversacionState();
}

class _BotonConversacionState extends ConsumerState<BotonConversacion> {
  bool _abriendo = false;

  Future<void> _abrir() async {
    setState(() => _abriendo = true);
    final avisos = ScaffoldMessenger.maybeOf(context);
    final textos = AppLocalizations.of(context);
    try {
      final id = await ref
          .read(lecturaDeConversacionProvider)
          .abrir(solicitudId: widget.solicitudId, tecnicoId: widget.tecnicoId);
      if (!mounted) return;
      await context.push(Rutas.conversacion(id, tecnicoId: widget.tecnicoId));
      if (mounted) unawaited(ref.read(globoProvider.notifier).actualizar());
    } on Failure catch (falla) {
      avisos?.showSnackBar(
        SnackBar(content: Text(_textoDeFalla(textos, falla))),
      );
    } finally {
      if (mounted) setState(() => _abriendo = false);
    }
  }

  static String _textoDeFalla(AppLocalizations t, Failure falla) =>
      switch (falla) {
        NoEncontradoFailure() => t.chatEnvioConversacionNoDisponible,
        ConflictoFailure() => t.chatEnvioCerrada,
        DemasiadosIntentosFailure(:final espera) => t.chatEnvioErrorLimite(
          espera == null || espera <= Duration.zero
              ? 30
              : (espera.inMilliseconds / 1000).ceil(),
        ),
        ServicioNoDisponibleFailure() => t.conversacionAbrirError,
        _ => mensajeDeError(t, falla),
      };

  @override
  Widget build(BuildContext context) => BtnK(
    widget.etiqueta,
    _abriendo ? null : () => unawaited(_abrir()),
    kind: widget.kind,
    sm: widget.sm,
    auto: widget.auto,
    icon: 'chat',
  );
}
