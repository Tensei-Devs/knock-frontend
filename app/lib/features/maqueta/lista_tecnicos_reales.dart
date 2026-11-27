import 'dart:async';

import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/solicitudes_reales.dart'
    show provDeTecnico;
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ListaTecnicosReales extends ConsumerStatefulWidget {
  const ListaTecnicosReales({super.key, this.oficio});
  final String? oficio;

  @override
  ConsumerState<ListaTecnicosReales> createState() =>
      _ListaTecnicosRealesState();
}

class _ListaTecnicosRealesState extends ConsumerState<ListaTecnicosReales> {
  bool _verificados = false;
  bool _disponibles = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final filtros = (
      oficio: widget.oficio,
      verificados: _verificados,
      disponibles: _disponibles,
    );
    final provider = listaTecnicosControllerProvider(filtros);
    final controlador = ref.read(provider.notifier);
    return stack([
      Wrap(
        spacing: 8,
        children: [
          FilterChip(
            label: Text(t.busquedaSoloVerificados),
            selected: _verificados,
            onSelected: (v) => setState(() => _verificados = v),
          ),
          FilterChip(
            label: Text(t.tecnicoDisponibleHoy),
            selected: _disponibles,
            onSelected: (v) => setState(() => _disponibles = v),
          ),
        ],
      ),
      ref
          .watch(provider)
          .when(
            skipLoadingOnRefresh: false,
            loading: () => sMut(t.busquedaCargando),
            error: (_, _) => stack([
              sMut(t.busquedaNoDisponible),
              BtnK(t.busquedaReintentar, controlador.reintentar, kind: Bk.sec),
            ], gap: 8),
            data: (pagina) => stack([
              if (pagina.items.isEmpty) sMut(t.busquedaSinResultados),
              for (final tecnico in pagina.items)
                CardK(
                  child: ListTile(
                    title: Text(tecnico.nombre),
                    subtitle: Text(
                      tecnico.oficios
                          .where(cats.containsKey)
                          .map((c) => cats[c]!.short)
                          .join(', '),
                    ),
                    onTap: tecnico.oficios.any(cats.containsKey)
                        ? () {
                            final oficio = tecnico.oficios.firstWhere(
                              cats.containsKey,
                            );
                            final prov = provDeTecnico(
                              act.TecnicoResumen(
                                id: tecnico.id,
                                nombre: tecnico.nombre,
                                verificado:
                                    tecnico.verificacion == 'basica' ||
                                    tecnico.verificacion == 'completa',
                              ),
                              oficio,
                            );
                            provs[prov.id] = prov;
                            unawaited(context.push(RM.experto(prov.id)));
                          }
                        : null,
                  ),
                ),
              if (pagina.siguiente != null)
                BtnK(t.busquedaCargarMas, () async {
                  final falla = await controlador.cargarMas();
                  if (falla != null && context.mounted) {
                    maq.toast(mensajeDeError(t, falla));
                  }
                }, kind: Bk.sec),
            ], gap: 8),
          ),
    ], gap: 8);
  }
}
