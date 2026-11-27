import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/envio_de_visita.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/visita/visita.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «Fotos del trabajo» de una visita real terminada del cliente. No pide nada
/// hasta que la persona lo abre y no es requisito de ninguna otra acción.
class BotonPermisoFotosReal extends StatelessWidget {
  const BotonPermisoFotosReal({super.key, required this.visitaId});

  final String visitaId;

  @override
  Widget build(BuildContext context) => BtnK(
    AppLocalizations.of(context).visitaPermisoFotosTitulo,
    () => _abrir(context),
    kind: Bk.ghost,
    sm: true,
  );

  void _abrir(BuildContext context) => unawaited(
    hoja<void>(context, (_, _) => _HojaPermisoFotos(visitaId: visitaId)),
  );
}

class _HojaPermisoFotos extends StatelessWidget {
  const _HojaPermisoFotos({required this.visitaId});

  final String visitaId;

  @override
  Widget build(BuildContext context) => stack([
    sheetH(context, AppLocalizations.of(context).visitaPermisoFotosTitulo),
    PermisoFotosReal(visitaId: visitaId),
  ]);
}

/// El interruptor (spec 040, CA-P01 y CA-P02): apagado por omisión y solo
/// cambia con la respuesta del servidor.
class PermisoFotosReal extends ConsumerStatefulWidget {
  const PermisoFotosReal({super.key, required this.visitaId});

  final String visitaId;

  @override
  ConsumerState<PermisoFotosReal> createState() => _PermisoFotosState();
}

class _PermisoFotosState extends ConsumerState<PermisoFotosReal>
    with EnvioDeVisita {
  /// El último valor que confirmó el servidor en esta pantalla.
  bool? _guardado;

  Future<void> _cambiar(bool permiso) async {
    final textos = AppLocalizations.of(context);
    var respuesta = false;
    final bien = await enviarUnaVez(textos.errorConflicto, () async {
      respuesta = await ref
          .read(permisoFotosRepositoryProvider)
          .guardar(widget.visitaId, permiso: permiso);
    });
    if (!bien) return;
    setState(() {
      enviando = false;
      _guardado = respuesta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final proveedor = permisoDeFotosProvider(widget.visitaId);
    return ref
        .watch(proveedor)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(textos.visitaPermisoFotosCargando),
          error: (error, _) => stack([
            NoteK(
              'red',
              'help',
              error is NoEncontradoFailure
                  ? textos.visitaNoDisponible
                  : mensajeDeError(textos, error),
            ),
            BtnK(
              textos.opinionesReintentar,
              () => ref.invalidate(proveedor),
              kind: Bk.sec,
            ),
          ], gap: 12),
          data: (actual) {
            if (!actual.terminada) {
              return NoteK('amber', 'help', textos.visitaNoDisponible);
            }
            return stack([
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: T(textos.visitaPermisoFotosCasilla, size: 15),
                subtitle: sMut(textos.visitaPermisoFotosDetalle),
                value: _guardado ?? actual.permiso,
                onChanged: enviando ? null : _cambiar,
              ),
              if (errorDeEnvio case final error?) NoteK('red', 'help', error),
              if (_guardado != null && !enviando && errorDeEnvio == null)
                sMut(textos.visitaPermisoFotosGuardado),
            ], gap: 12);
          },
        );
  }
}
