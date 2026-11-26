import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/verificacion/verificacion.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La pantalla de estado de mi verificación con datos reales (spec 018). El
/// envío de las fotos todavía no está en la app y la pantalla lo dice. Se
/// refresca al abrirla y al volver a la app.
class EstadoDeVerificacionReal extends ConsumerStatefulWidget {
  const EstadoDeVerificacionReal({super.key});

  @override
  ConsumerState<EstadoDeVerificacionReal> createState() => _EstadoState();
}

class _EstadoState extends ConsumerState<EstadoDeVerificacionReal> {
  late final AppLifecycleListener _alVolver;

  @override
  void initState() {
    super.initState();
    _alVolver = AppLifecycleListener(
      onResume: () => ref.invalidate(verificacionControllerProvider),
    );
  }

  @override
  void dispose() {
    _alVolver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return ref
        .watch(verificacionControllerProvider)
        .when(
          loading: () => sMut(textos.verificacionCargando),
          error: (e, _) => stack([
            NoteK(
              'red',
              'help',
              mensajeDeError(
                textos,
                e is Failure ? e : const ServicioNoDisponibleFailure(),
              ),
            ),
            BtnK(
              textos.verificacionReintentar,
              () => ref.invalidate(verificacionControllerProvider),
              kind: Bk.sec,
            ),
          ], gap: 12),
          data: (v) => stack(_contenido(context, textos, v), gap: 12),
        );
  }

  List<Widget> _contenido(
    BuildContext context,
    AppLocalizations textos,
    Verificacion v,
  ) {
    final completa = v.nivelOtorgado == 'completa';
    final (color, icono, titulo, detalle) = switch (v.estado) {
      EstadoDeVerificacion.sinVerificar || EstadoDeVerificacion.enCaptura => (
        'blue',
        'shield',
        textos.verificacionSinVerificar,
        v.fotosBorradas
            ? textos.verificacionFotosBorradas
            : textos.verificacionSinVerificarDetalle,
      ),
      EstadoDeVerificacion.enRevision => (
        'amber',
        'clock',
        textos.verificacionEnRevision,
        textos.verificacionEnRevisionDetalle,
      ),
      EstadoDeVerificacion.verificada => (
        'green',
        'check',
        completa
            ? textos.verificacionVerificadoCompleto
            : textos.verificacionVerificadoBasico,
        textos.verificacionVerificadoDetalle,
      ),
      EstadoDeVerificacion.noVerificada => (
        'red',
        'help',
        textos.verificacionNoVerificado,
        v.motivo ?? textos.verificacionSinMotivo,
      ),
    };
    final porEnviar = v.estado != EstadoDeVerificacion.enRevision && !completa;
    return [
      h1(titulo),
      NoteK(color, icono, detalle),
      if (v.enviadoEn case final fecha?
          when v.estado == EstadoDeVerificacion.enRevision)
        sMut(
          textos.verificacionEnviadaEl(
            MaterialLocalizations.of(context).formatMediumDate(fecha.toLocal()),
          ),
        ),
      if (v.estado == EstadoDeVerificacion.noVerificada)
        for (final consejo in v.consejos) T('• $consejo', size: 15),
      if (porEnviar) sMut(textos.verificacionEnvioNoDisponible),
    ];
  }
}
