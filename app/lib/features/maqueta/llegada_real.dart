import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/rutas_tecnico.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:app/features/visita/visita.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Confirmar llegada» de una visita real (spec 016, CA-10 a CA-17 y CA-20): el
/// técnico escribe el código que le da el cliente. El botón sigue lo que diga
/// `puedeLlegar` del servidor y la app no guarda ese código.
class LlegadaReal extends ConsumerStatefulWidget {
  const LlegadaReal({super.key, required this.visitaId});

  final String visitaId;

  @override
  ConsumerState<LlegadaReal> createState() => _LlegadaRealState();
}

class _LlegadaRealState extends ConsumerState<LlegadaReal> {
  final _codigo = TextEditingController();
  late final AppLifecycleListener _regreso;

  @override
  void initState() {
    super.initState();
    _regreso = AppLifecycleListener(
      onResume: () => ref.invalidate(visitaDelTecnicoProvider(widget.visitaId)),
    );
  }

  @override
  void dispose() {
    _regreso.dispose();
    _codigo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final envio = ref.watch(llegadaControllerProvider(widget.visitaId));
    ref.listen(llegadaControllerProvider(widget.visitaId), (antes, ahora) {
      if (ahora.confirmada != null && antes?.confirmada == null) {
        ref.invalidate(agendaControllerProvider);
      }
    });
    final confirmada = envio.confirmada;
    if (confirmada != null) return _enCurso(textos, confirmada);
    final proveedor = visitaDelTecnicoProvider(widget.visitaId);
    return ref
        .watch(proveedor)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(textos.llegadaCargando),
          error: (error, _) => stack([
            NoteK('red', 'help', _textoDeFalla(textos, error)),
            BtnK(
              textos.opinionesReintentar,
              () => ref.invalidate(proveedor),
              kind: Bk.sec,
            ),
          ], gap: 12),
          data: (visita) => visita.enCurso
              ? _enCurso(textos, visita)
              : _formulario(textos, visita, envio),
        );
  }

  Widget _datos(VisitaDelTecnico visita) => CardK(
    child: stack([
      T('${visita.dia} · ${visita.hora}', w: FontWeight.w900),
      if (visita.colonia case final colonia?) sMut(colonia),
      if (visita.direccion case final direccion?) sMut(direccion),
    ], gap: 4),
  );

  Widget _enCurso(AppLocalizations textos, VisitaDelTecnico visita) {
    final llegada = visita.llegadaEn?.toLocal();
    final formato = MaterialLocalizations.of(context);
    return stack([
      _datos(visita),
      NoteK('green', 'check', textos.llegadaConfirmada),
      if (llegada != null)
        sMut(
          textos.llegadaHora(
            formato.formatTimeOfDay(TimeOfDay.fromDateTime(llegada)),
          ),
        ),
      BtnK(
        textos.visitaTerminarBoton,
        () => context.pushReplacement(RT.cerrar(visita.id)),
      ),
    ], gap: 14);
  }

  Widget _formulario(
    AppLocalizations textos,
    VisitaDelTecnico visita,
    EstadoLlegada envio,
  ) {
    final abierto = visita.puedeLlegar && !envio.cerrada && !envio.enviando;
    final aviso = _aviso(textos, envio);
    return stack([
      _datos(visita),
      if (visita.puedeLlegar)
        sMut(textos.llegadaInstruccion)
      else
        NoteK('amber', 'clock', _razon(textos, visita)),
      FieldK(
        label: textos.llegadaCodigo,
        c: _codigo,
        keyboard: TextInputType.number,
        maxLen: ReglasDeLlegada.digitos,
        center: true,
      ),
      if (aviso != null)
        Semantics(liveRegion: true, child: NoteK('red', 'help', aviso)),
      if (envio.respuestaPerdida)
        NoteK('amber', 'clock', textos.llegadaReintentoCuenta),
      BtnK(
        envio.enviando ? textos.llegadaConfirmando : textos.llegadaConfirmar,
        abierto ? _confirmar : null,
      ),
      if (envio.cerrada)
        BtnK(
          textos.cotizacionActualizar,
          _actualizar,
          kind: Bk.ghost,
          sm: true,
        ),
    ], gap: 14);
  }

  void _confirmar() {
    final controlador = ref.read(
      llegadaControllerProvider(widget.visitaId).notifier,
    );
    unawaited(controlador.confirmar(_codigo.text.trim()));
  }

  void _actualizar() {
    ref.invalidate(llegadaControllerProvider(widget.visitaId));
    ref.invalidate(visitaDelTecnicoProvider(widget.visitaId));
  }

  /// Por qué el servidor no deja confirmar la llegada ahora (CA-20).
  String _razon(AppLocalizations textos, VisitaDelTecnico visita) {
    if (visita.esTaller) return textos.llegadaTaller;
    return switch (visita.estado) {
      'confirmada' => textos.llegadaAunNo,
      'cancelada' => textos.llegadaCancelada,
      _ => textos.errorVisitaNoVigente,
    };
  }

  String? _aviso(AppLocalizations textos, EstadoLlegada envio) {
    if (envio.falla case final falla?) return _textoDeFalla(textos, falla);
    final restantes = envio.intentosRestantes;
    return switch (envio.motivo) {
      null => null,
      MotivoLlegada.formato => textos.llegadaCuatroDigitos,
      MotivoLlegada.codigoIncorrecto => [
        textos.llegadaIncorrecto,
        if (restantes != null) textos.llegadaIntentos(restantes),
      ].join('\n'),
      MotivoLlegada.visitaBloqueada => textos.llegadaBloqueada,
      MotivoLlegada.codigoUsado => textos.llegadaYaUsado,
      MotivoLlegada.codigoVencido => textos.llegadaVencido,
      MotivoLlegada.visitaCancelada => textos.llegadaCancelada,
      MotivoLlegada.visitaNoVigente => textos.errorVisitaNoVigente,
      MotivoLlegada.visitaSinCodigo => textos.llegadaTaller,
      MotivoLlegada.fueraDeVentana => textos.errorFueraDeVentana,
      MotivoLlegada.noEsTecnico => textos.llegadaNoTecnico,
    };
  }

  String _textoDeFalla(AppLocalizations textos, Object falla) {
    if (falla is NoEncontradoFailure) return textos.llegadaNoDisponible;
    if (falla case DemasiadosIntentosFailure(:final espera?)) {
      return textos.llegadaEspera(espera.inSeconds);
    }
    return mensajeDeError(textos, falla);
  }
}
