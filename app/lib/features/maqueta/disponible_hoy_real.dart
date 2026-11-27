import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/envio_de_visita.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// El interruptor «Disponible hoy» de Trabajo (spec 019, CA-D01; spec 036,
/// CA-33 a CA-35). Solo cambia con la respuesta del servidor.
class DisponibleHoyReal extends ConsumerStatefulWidget {
  const DisponibleHoyReal({super.key});

  @override
  ConsumerState<DisponibleHoyReal> createState() => _DisponibleHoyState();
}

class _DisponibleHoyState extends ConsumerState<DisponibleHoyReal>
    with EnvioDeVisita {
  /// El último valor que confirmó el servidor en esta pantalla.
  bool? _confirmado;

  Future<void> _cambiar(bool disponible) async {
    final textos = AppLocalizations.of(context);
    var respuesta = false;
    final bien = await enviarUnaVez(textos.errorConflicto, () async {
      final r = await ref
          .read(horariosRepositoryProvider)
          .cambiarDisponibilidad(disponibleHoy: disponible);
      respuesta = r.disponibleHoy;
    });
    if (!bien) return;
    setState(() {
      enviando = false;
      _confirmado = respuesta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    // Un dato recién leído manda sobre lo confirmado antes en esta pantalla.
    ref.listen(disponibleHoyProvider, (_, ahora) {
      if (ahora is AsyncData<bool> && !ahora.isLoading) {
        _confirmado = null;
        errorDeEnvio = null;
      }
    });
    return ref
        .watch(disponibleHoyProvider)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(textos.trabajoDisponibleCargando),
          error: (error, _) => stack([
            sMut(
              error is Failure
                  ? mensajeDeError(textos, error)
                  : textos.errorInesperado,
            ),
            BtnK(
              textos.opinionesReintentar,
              () => ref.invalidate(disponibleHoyProvider),
              kind: Bk.ghost,
              sm: true,
            ),
          ], gap: 8),
          data: (inicial) => stack([
            Material(
              type: MaterialType.transparency,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: T(textos.trabajoDisponibleHoy, w: FontWeight.w900),
                subtitle: sMut(textos.trabajoDisponibleDetalle),
                value: _confirmado ?? inicial,
                onChanged: enviando ? null : _cambiar,
              ),
            ),
            if (errorDeEnvio case final error?) NoteK('red', 'help', error),
          ], gap: 8),
        );
  }
}
