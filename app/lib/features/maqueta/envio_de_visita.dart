import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Un envío a la vez de una acción sobre la visita. Si falla, deja el texto
/// del error en [errorDeEnvio] y no toca lo elegido o escrito.
mixin EnvioDeVisita<W extends ConsumerStatefulWidget> on ConsumerState<W> {
  bool enviando = false;
  String? errorDeEnvio;

  /// `true` si [accion] terminó bien y la pantalla sigue montada.
  /// [conflicto] es el mensaje del 409 de esa ruta.
  Future<bool> enviarUnaVez(
    String conflicto,
    Future<void> Function() accion,
  ) async {
    if (enviando) return false;
    final textos = AppLocalizations.of(context);
    setState(() {
      enviando = true;
      errorDeEnvio = null;
    });
    try {
      await accion();
    } on Failure catch (falla) {
      if (!mounted) return false;
      setState(() {
        enviando = false;
        errorDeEnvio = switch (falla) {
          ConflictoFailure() => conflicto,
          NoEncontradoFailure() => textos.visitaNoDisponible,
          _ => mensajeDeError(textos, falla),
        };
      });
      return false;
    }
    return mounted;
  }
}

/// El error al cargar algo de la visita, con «Reintentar».
class ErrorDeCargaDeVisita extends StatelessWidget {
  const ErrorDeCargaDeVisita({
    super.key,
    required this.error,
    required this.alReintentar,
  });

  final Object error;
  final VoidCallback alReintentar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return stack([
      NoteK(
        'red',
        'help',
        error is NoEncontradoFailure
            ? textos.visitaNoDisponible
            : mensajeDeError(textos, error),
      ),
      BtnK(textos.opinionesReintentar, alReintentar, kind: Bk.sec),
    ], gap: 12);
  }
}
