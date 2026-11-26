import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/tecnicos_confianza/tecnicos_confianza.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// El id del servidor de un técnico real de la maqueta (`api:<id>`), o `null`
/// si es de ejemplo o es el técnico de una visita (que no trae su id).
String? idDeTecnicoReal(String idDeMaqueta) {
  if (!idDeMaqueta.startsWith('api:')) return null;
  final id = idDeMaqueta.substring(4);
  return id.isEmpty || id.contains(':') ? null : id;
}

String _mensaje(BuildContext context, Failure falla) =>
    falla is NoEncontradoFailure
    ? 'Ese técnico ya no está disponible.'
    : mensajeDeError(AppLocalizations.of(context), falla);

/// «Mis técnicos de confianza» con datos reales (spec 032, backend 042):
/// carga, vacío, error con Reintentar (CA-10), páginas por cursor (CA-03) y
/// quitar. No registra nombres (CA-15).
class ConfianzaReal extends ConsumerWidget {
  const ConfianzaReal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(tecnicosConfianzaControllerProvider);
    final controlador = ref.read(tecnicosConfianzaControllerProvider.notifier);
    return stack([
      ...estado.when(
        loading: () => [sMut('Cargando tus técnicos de confianza…')],
        error: (_, _) => [
          const NoteK(
            'red',
            'help',
            'No pudimos cargar tus técnicos de confianza.',
          ),
          BtnK('Reintentar', controlador.reintentar, kind: Bk.sec),
        ],
        data: (pagina) => [
          if (pagina.items.isEmpty)
            sMut(
              'Aún no guardas a nadie. Cuando alguien te funcione, toca «Guardar» en su perfil y aparecerá aquí.',
            )
          else
            for (final t in pagina.items) _Tarjeta(t),
          if (pagina.siguiente != null)
            BtnK('Ver más', () async {
              final falla = await controlador.cargarMas();
              if (falla != null && context.mounted) {
                maq.toast(_mensaje(context, falla));
              }
            }, kind: Bk.ghost),
        ],
      ),
    ], gap: 12);
  }
}

class _Tarjeta extends ConsumerWidget {
  const _Tarjeta(this.tecnico);

  final TecnicoDeConfianza tecnico;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verificado = tecnico.nivelVerificacion != 'sin_verificar';
    return CardK(
      child: stack([
        T(tecnico.nombre, size: 16.5, w: FontWeight.w900),
        sMut(verificado ? 'Verificado' : 'Sin verificar'),
        BtnK(
          'Quitar',
          () async {
            final falla = await ref
                .read(tecnicosConfianzaControllerProvider.notifier)
                .quitar(tecnico.tecnicoId);
            if (!context.mounted) return;
            maq.toast(
              falla == null
                  ? 'Quitado de tus técnicos de confianza'
                  : _mensaje(context, falla),
            );
          },
          kind: Bk.sec,
          sm: true,
        ),
      ], gap: 10),
    );
  }
}

/// El botón «Guardar» del perfil de un técnico real: refleja la lista del
/// servidor y la cambia con `PUT` y `DELETE`.
class GuardarTecnicoReal extends ConsumerStatefulWidget {
  const GuardarTecnicoReal({
    super.key,
    required this.tecnicoId,
    required this.destino,
  });

  final String tecnicoId;

  /// A dónde volver si primero hay que entrar.
  final String destino;

  @override
  ConsumerState<GuardarTecnicoReal> createState() => _GuardarTecnicoState();
}

class _GuardarTecnicoState extends ConsumerState<GuardarTecnicoReal> {
  bool _ocupado = false;

  Future<void> _cambiar({required bool guardado}) async {
    if (_ocupado) return;
    setState(() => _ocupado = true);
    final controlador = ref.read(tecnicosConfianzaControllerProvider.notifier);
    final falla = guardado
        ? await controlador.quitar(widget.tecnicoId)
        : await controlador.guardar(widget.tecnicoId);
    if (!mounted) return;
    setState(() => _ocupado = false);
    maq.toast(
      falla != null
          ? _mensaje(context, falla)
          : guardado
          ? 'Quitado de tus técnicos de confianza'
          : 'Guardado en tus técnicos de confianza',
    );
  }

  @override
  Widget build(BuildContext context) {
    final guardado =
        hayCuenta(context) &&
        (ref
                .watch(tecnicosConfianzaControllerProvider)
                .value
                ?.items
                .any((t) => t.tecnicoId == widget.tecnicoId) ??
            false);
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ChipK(
        guardado ? 'Guardado' : 'Guardar',
        icon: 'heart',
        on: guardado,
        onTap: () {
          if (!pedirCuenta(context, widget.destino)) return;
          unawaited(_cambiar(guardado: guardado));
        },
      ),
    );
  }
}
