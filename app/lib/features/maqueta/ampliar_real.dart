import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «Pedir también a otros» de una solicitud real que todavía no tiene
/// cotizaciones (spec 038). El servidor decide si se puede ampliar.
class AmpliarSolicitudReal extends ConsumerStatefulWidget {
  const AmpliarSolicitudReal({super.key, required this.solicitudId});

  final String solicitudId;

  @override
  ConsumerState<AmpliarSolicitudReal> createState() => _AmpliarState();
}

enum _Paso { listo, pidiendo, hecho }

class _AmpliarState extends ConsumerState<AmpliarSolicitudReal> {
  _Paso _paso = _Paso.listo;
  Failure? _falla;

  Future<void> _pedir() async {
    if (_paso != _Paso.listo) return;
    setState(() {
      _paso = _Paso.pidiendo;
      _falla = null;
    });
    Failure? falla;
    try {
      await ref
          .read(act.ampliarSolicitudApiProvider)
          .ampliar(widget.solicitudId);
    } on Failure catch (e) {
      falla = e;
    }
    if (!mounted) return;
    setState(() {
      _falla = falla;
      _paso = falla == null ? _Paso.hecho : _Paso.listo;
    });
    if (falla == null) maq.reintentarSolicitudes?.call();
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    if (_paso == _Paso.hecho) {
      return NoteK('green', 'check', textos.solicitudesAmpliada);
    }
    return stack([
      sMut(textos.solicitudesAmpliarExplicacion),
      if (_falla case final falla?)
        NoteK('red', 'help', switch (falla) {
          ConflictoFailure() => textos.solicitudesNoAmpliable,
          NoEncontradoFailure() => textos.solicitudesNoDisponible,
          _ => mensajeDeError(textos, falla),
        }),
      BtnK(
        textos.solicitudesAmpliar,
        _paso == _Paso.listo ? _pedir : null,
        kind: Bk.sec,
        sm: true,
      ),
    ], gap: 8);
  }
}
