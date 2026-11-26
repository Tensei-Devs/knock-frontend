import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Con sesión y API, los horarios del servidor; sin ellas, los de [ejemplo].
class HorariosSegunSesion extends ConsumerWidget {
  const HorariosSegunSesion({super.key, required this.ejemplo});

  final Widget ejemplo;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(solicitudesRealesActivasProvider)
      ? const HorariosReales()
      : ejemplo;
}

const _nombres = {
  DiaSemana.lunes: 'Lunes',
  DiaSemana.martes: 'Martes',
  DiaSemana.miercoles: 'Miércoles',
  DiaSemana.jueves: 'Jueves',
  DiaSemana.viernes: 'Viernes',
  DiaSemana.sabado: 'Sábado',
  DiaSemana.domingo: 'Domingo',
};

String _detalle(HorarioDelDia d, {required bool sePuedeAbrir}) {
  if (d.abierto) {
    return d.franjas.map((f) => '${f.inicio} a ${f.fin}').join(' y ');
  }
  return sePuedeAbrir ? 'Cerrado' : 'Cerrado · aún no se puede abrir aquí';
}

/// Los horarios de «Tu perfil público» con datos reales (spec 036, TEC-10 y
/// TEC-11): carga, vacío, error con Reintentar y un interruptor por día que se
/// guarda al tocarlo.
class HorariosReales extends ConsumerWidget {
  const HorariosReales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final control = ref.read(horariosControllerProvider.notifier);
    final reintentar = BtnK('Reintentar', control.reintentar, kind: Bk.sec);
    return stack([
      h3('Tus horarios'),
      ...ref
          .watch(horariosControllerProvider)
          .when(
            loading: () => [sMut('Cargando tus horarios…')],
            error: (error, _) => [
              NoteK(
                'red',
                'help',
                error is NoEncontradoFailure
                    ? 'No encontramos tu perfil de técnico.'
                    : 'No pudimos cargar tus horarios.',
              ),
              reintentar,
            ],
            data: (semana) => semana.isEmpty
                ? [sMut('Aún no hay horarios.'), reintentar]
                : [
                    GroupK([
                      for (final d in semana) _fila(context, control, d),
                    ]),
                  ],
          ),
    ], gap: 12);
  }

  Widget _fila(
    BuildContext context,
    HorariosController control,
    HorarioDelDia d,
  ) {
    final sePuedeAbrir = control.franjasParaAbrir(d.dia).isNotEmpty;
    final nombre = _nombres[d.dia]!;
    final alTocar = d.abierto || sePuedeAbrir
        ? () => unawaited(
            control.cambiar(d.dia, abierto: !d.abierto).then((falla) {
              if (falla == null || !context.mounted) return;
              maq.toast(mensajeDeError(AppLocalizations.of(context), falla));
            }),
          )
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        spacing: 14,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                T(nombre, w: FontWeight.w800),
                sMut(_detalle(d, sePuedeAbrir: sePuedeAbrir), size: 13.5),
              ],
            ),
          ),
          Semantics(
            container: true,
            label: nombre,
            toggled: d.abierto,
            enabled: alTocar != null,
            onTap: alTocar,
            excludeSemantics: true,
            // El área que se puede tocar mide al menos 48 dp (CA-59).
            child: GestureDetector(
              key: ValueKey('horario-${d.dia.valor}'),
              behavior: HitTestBehavior.opaque,
              onTap: alTocar,
              child: SizedBox(
                width: 56,
                height: 48,
                child: Center(
                  child: IgnorePointer(
                    child: Sw(on: d.abierto, onTap: alTocar),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
