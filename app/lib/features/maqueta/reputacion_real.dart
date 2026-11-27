import 'package:app/features/maqueta/explorar_real.dart' show fechaDeCopia;
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReputacionReal extends ConsumerWidget {
  const ReputacionReal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final reintentar = ref
        .read(reputacionControllerProvider.notifier)
        .reintentar;
    Widget aviso(String mensaje) => stack([
      sMut(mensaje),
      BtnK(textos.opinionesReintentar, reintentar, kind: Bk.sec),
    ], gap: 8);
    return ref
        .watch(reputacionControllerProvider)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(textos.opinionesCargando),
          error: (_, _) => aviso(textos.opinionesError),
          data: (vista) {
            final datos = vista.reputacion;
            final nivel = switch (datos.nivel) {
              'nuevo' => textos.reputacionNuevo,
              'confiable' => textos.reputacionConfiable,
              'destacado' => textos.reputacionDestacado,
              _ => datos.nivel,
            };
            return stack([
              if (vista.copiaDel case final fecha?)
                aviso(textos.opinionesCopia(fechaDeCopia(fecha))),
              CardK(
                child: stack([
                  T(
                    textos.reputacionNivel(nivel),
                    size: 20,
                    w: FontWeight.w800,
                  ),
                  if (datos.promedio case final promedio?)
                    T(textos.opinionesPromedio(promedio.toStringAsFixed(1))),
                  sMut(textos.opinionesTotal(datos.total)),
                  if (datos.total == 0) sMut(textos.opinionesVacio),
                  for (var n = 5; n >= 1; n--)
                    sMut(
                      textos.opinionesEstrellas(n, datos.distribucion[n] ?? 0),
                    ),
                ], gap: 8),
              ),
            ], gap: 12);
          },
        );
  }
}
