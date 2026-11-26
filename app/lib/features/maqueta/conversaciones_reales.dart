import 'dart:async';

import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/mensajes/mensajes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversacionesReales extends ConsumerStatefulWidget {
  const ConversacionesReales({super.key});

  @override
  ConsumerState<ConversacionesReales> createState() =>
      _ConversacionesRealesState();
}

class _ConversacionesRealesState extends ConsumerState<ConversacionesReales> {
  late final ConversacionesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConversacionesController(
      ref.read(conversacionesRepositoryProvider),
    );
    _controller.addListener(_actualizar);
    unawaited(_controller.reintentar());
  }

  void _actualizar() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_actualizar);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sesionProvider, (anterior, actual) {
      if (anterior == actual) return;
      _controller.limpiar();
      if (actual != null) unawaited(_controller.reintentar());
    });
    final t = AppLocalizations.of(context);
    final estado = _controller.estado;
    return stack([
      if (estado.sinConexion) ...[
        sMut(t.conversacionesSinConexion),
        BtnK(t.busquedaReintentar, _controller.reintentar, kind: Bk.sec),
      ],
      if (estado.cargando) sMut(t.conversacionesCargando),
      if (!estado.cargando &&
          estado.conversaciones.isEmpty &&
          !estado.sinConexion)
        sMut(t.conversacionesVacias),
      if (!estado.cargando &&
          estado.conversaciones.isEmpty &&
          estado.totalNoLeidos != null)
        sMut(t.conversacionesVacias),
      for (final c in estado.conversaciones)
        CardK(
          child: stack([
            T(c.contraparte.nombre, w: FontWeight.w800),
            T(c.servicio),
            if (c.ultimoMensaje case final ultimo?) sMut(ultimo.texto),
            if (c.noLeidos > 0) sMut(t.conversacionesNoLeidos(c.noLeidos)),
          ], gap: 4),
        ),
      if (estado.conversaciones.isNotEmpty)
        sMut(t.conversacionesAbrirPendiente),
      if (estado.siguiente != null)
        BtnK(
          t.opinionesVerMas,
          estado.cargando ? null : _controller.cargarMas,
          kind: Bk.sec,
        ),
    ], gap: 8);
  }
}
