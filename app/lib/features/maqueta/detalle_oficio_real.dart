import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Las opciones de «Toca una opción» al pedir cotización. Con sesión y API son
/// las frases de `GET /oficios/{clave}`; sin ellas, las de [ejemplo].
class FrasesDelOficio extends ConsumerWidget {
  const FrasesDelOficio({
    super.key,
    required this.clave,
    required this.ejemplo,
    required this.opciones,
  });

  final String clave;
  final List<String> ejemplo;

  /// Cómo se dibujan las opciones.
  final Widget Function(List<String>) opciones;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(solicitudesRealesActivasProvider)) return opciones(ejemplo);
    final textos = AppLocalizations.of(context);
    final proveedor = detalleOficioControllerProvider(clave);
    return ref
        .watch(proveedor)
        .when(
          loading: () => sMut(textos.pedirCargandoOpciones),
          error: (e, _) => stack([
            NoteK(
              'amber',
              'help',
              e is NoEncontradoFailure
                  ? textos.pedirOficioNoDisponible
                  : textos.pedirSinOpciones,
            ),
            LinkK(textos.pedirReintentar, () => ref.invalidate(proveedor)),
          ], gap: 8),
          data: (vista) => stack([
            if (vista.copiaDel case final fecha?)
              NoteK(
                'amber',
                'clock',
                textos.pedirCopiaGuardada(
                  MaterialLocalizations.of(context)
                      .formatShortDate(fecha.toLocal()),
                ),
              ),
            if (vista.detalle.frasesSugeridas.isEmpty)
              sMut(textos.pedirOpcionesVacias)
            else
              opciones(vista.detalle.frasesSugeridas),
          ], gap: 8),
        );
  }
}

/// Manda el oficio escrito en «Otro oficio» (`POST /oficios-pedidos`). Si
/// falla, el alta ya quedó hecha: se avisa y se ofrece reintentar.
Future<void> pedirOficioNuevo(
  DetalleOficioRepository repositorio,
  AppLocalizations textos,
  String texto,
) async {
  try {
    await repositorio.pedirOficio(texto);
  } on Failure catch (falla) {
    maq.toast(
      textos.pedirOficioNuevoFallo(mensajeDeError(textos, falla)),
      accion: textos.pedirReintentar,
      alAccion: () => unawaited(pedirOficioNuevo(repositorio, textos, texto)),
    );
  }
}
