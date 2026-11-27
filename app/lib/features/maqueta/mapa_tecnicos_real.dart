import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/solicitudes_reales.dart'
    show provDeTecnico;
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Carga, vacío y error del mapa real (spec 036, CA-15 y CA-51).
class EstadoDelMapaReal extends ConsumerWidget {
  const EstadoDelMapaReal({super.key, required this.consulta});

  /// `null` mientras el mapa no ha dicho qué zona muestra.
  final ConsultaMapa? consulta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final zona = consulta;
    if (zona == null) return sMut(t.tecnicosMapaCargando);
    final proveedor = mapaTecnicosControllerProvider(zona);
    return ref
        .watch(proveedor)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(t.tecnicosMapaCargando),
          error: (error, _) => stack([
            sMut(t.tecnicosMapaError),
            if (error is Failure) sMut(mensajeDeError(t, error)),
            BtnK(
              t.busquedaReintentar,
              ref.read(proveedor.notifier).reintentar,
              kind: Bk.sec,
            ),
          ], gap: 8),
          data: (grupos) => grupos.isEmpty
              ? sMut(t.tecnicosMapaVacio)
              : const SizedBox.shrink(),
        );
  }
}

/// Abre el perfil del técnico de un grupo de uno solo. El mapa solo trae su
/// id: el nombre y el oficio salen de `GET /tecnicos/{id}`.
Future<void> abrirTecnicoDelMapa(
  BuildContext context,
  WidgetRef ref,
  String tecnicoId,
) async {
  final t = AppLocalizations.of(context);
  try {
    final perfil = await ref
        .read(perfilPublicoRepositoryProvider)
        .perfil(tecnicoId);
    final oficio = perfil.oficios.where(cats.containsKey).firstOrNull;
    if (oficio == null || !context.mounted) return;
    final prov = provDeTecnico(
      act.TecnicoResumen(
        id: perfil.id,
        nombre: perfil.nombre,
        verificado:
            perfil.verificacion == 'basica' ||
            perfil.verificacion == 'completa',
        calificacion: perfil.calificacion,
      ),
      oficio,
    );
    provs[prov.id] = prov;
    unawaited(context.push(RM.experto(prov.id)));
  } on Failure catch (falla) {
    maq.toast(mensajeDeError(t, falla));
  }
}
