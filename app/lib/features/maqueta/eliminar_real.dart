import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:app/features/cuenta/cuenta.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/privacidad_real.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Lo que tienes pendiente» antes de eliminar la cuenta (spec 029, USR-09).
class PendientesReales extends ConsumerWidget {
  const PendientesReales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final k = kc(context);
    return ref
        .watch(pendientesControllerProvider)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(l.cuentaPendientesCargando),
          error: (error, _) => stack([
            NoteK('red', 'help', mensajeDeError(l, error)),
            BtnK(
              l.cuentaReintentar,
              ref.read(pendientesControllerProvider.notifier).reintentar,
              kind: Bk.sec,
            ),
          ], gap: 12),
          data: (p) => !p.hayPendientes
              ? sMut(l.cuentaPendientesVacio)
              : CardK(
                  outline: k.amber,
                  child: stack([
                    h3(l.cuentaPendientesTitulo),
                    T(l.cuentaPendientesCitas(p.citas), w: FontWeight.w700),
                    T(
                      l.cuentaPendientesCotizaciones(p.cotizaciones),
                      w: FontWeight.w700,
                    ),
                    sMut(l.cuentaPendientesNota),
                  ], gap: 8),
                ),
        );
  }
}

/// Segundo paso con la API (USR-10): escribir `ELIMINAR` y, si la sesión tiene
/// más de 24 horas, volver a verificar el celular con un SMS. Un error conserva
/// lo escrito.
class EliminarCuentaReal extends ConsumerStatefulWidget {
  const EliminarCuentaReal({super.key});

  @override
  ConsumerState<EliminarCuentaReal> createState() => _EliminarCuentaRealState();
}

class _EliminarCuentaRealState extends ConsumerState<EliminarCuentaReal> {
  final _confirmacion = TextEditingController();
  late final _celular = TextEditingController(
    text: _diezDigitos(maq.user.phone),
  );
  final _codigo = TextEditingController();
  bool _pideCodigo = false;
  bool _ocupado = false;
  SolicitudCodigo? _solicitud;

  /// Prueba de Firebase ya obtenida: un reintento (sin red, 429) no gasta otro
  /// SMS. Solo en memoria.
  String? _prueba;
  String? _error;

  static String _diezDigitos(String texto) =>
      texto.replaceAll(RegExp(r'\D'), '');

  @override
  void dispose() {
    _confirmacion.dispose();
    _celular.dispose();
    _codigo.dispose();
    super.dispose();
  }

  bool get _listo =>
      !_ocupado &&
      _confirmacion.text.trim() == EliminacionRepository.confirmacion &&
      (!_pideCodigo ||
          _prueba != null ||
          (_solicitud != null && _diezDigitos(_codigo.text).length == 6));

  Future<void> _hacer(Future<void> Function() accion) async {
    final l = AppLocalizations.of(context);
    setState(() {
      _ocupado = true;
      _error = null;
    });
    try {
      await accion();
    } on Failure catch (falla) {
      _error = falla is ConflictoFailure
          ? l.cuentaEliminarNoPermitida
          : mensajeDeError(l, falla);
    }
    if (mounted) setState(() => _ocupado = false);
  }

  Future<void> _enviarCodigo() => _hacer(() async {
    final solicitud = await ref
        .read(verificadorCelularProvider)
        .enviarCodigo(_diezDigitos(_celular.text), anterior: _solicitud);
    _solicitud = solicitud;
    _prueba = null;
    _codigo.clear();
  });

  Future<void> _eliminar() => _hacer(() async {
    final l = AppLocalizations.of(context);
    final verificador = ref.read(verificadorCelularProvider);
    final control = ref.read(eliminacionControllerProvider.notifier);
    final solicitud = _solicitud;
    if (_pideCodigo && _prueba == null && solicitud != null) {
      _prueba = await verificador.tokenDeId(
        solicitud,
        _diezDigitos(_codigo.text),
      );
      // La app ya tiene su sesión; la de Firebase no se necesita.
      try {
        await verificador.cerrarSesion();
      } on Exception {
        // Sin registro: podría llevar datos.
      }
    }
    final resultado = await control.programar(firebaseIdToken: _prueba);
    switch (resultado) {
      case EliminacionProgramada():
        if (mounted) context.go(RM.eliminado);
      case PideVerificacion(:final rechazada):
        _pideCodigo = true;
        if (rechazada) {
          _prueba = null;
          _solicitud = null;
          _codigo.clear();
          _error = l.cuentaEliminarVerificacionRechazada;
        }
    }
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final error = _error;
    return Pg(
      title: l.cuentaEliminarTitulo,
      body: stack([
        const Prog(2, 2),
        h1(l.cuentaEliminarPregunta),
        T(l.cuentaEliminarGracia),
        FieldK(
          label: l.cuentaEliminarEscribe,
          c: _confirmacion,
          onChanged: (_) => setState(() {}),
        ),
        if (_pideCodigo) ...[
          NoteK('blue', 'lock', l.cuentaEliminarVerifica),
          FieldK(
            label: l.cuentaEliminarCelular,
            c: _celular,
            keyboard: TextInputType.phone,
            maxLen: 10,
            onChanged: (_) => setState(() {
              _solicitud = null;
              _prueba = null;
            }),
          ),
          BtnK(
            l.cuentaEliminarEnviarCodigo,
            !_ocupado && _diezDigitos(_celular.text).length == 10
                ? () => unawaited(_enviarCodigo())
                : null,
            kind: Bk.sec,
          ),
          if (_solicitud != null)
            FieldK(
              label: l.cuentaEliminarCodigo,
              c: _codigo,
              keyboard: TextInputType.number,
              maxLen: 6,
              center: true,
              onChanged: (_) => setState(() {}),
            ),
        ],
        if (error != null)
          Semantics(liveRegion: true, child: NoteK('red', 'help', error)),
        if (_ocupado) sMut(l.cuentaEliminarEnviando),
      ]),
      cta: ctaCol([
        BtnK(
          l.cuentaEliminarBoton,
          _listo ? () => unawaited(_eliminar()) : null,
          kind: Bk.danger,
        ),
        BtnK(
          l.cuentaEliminarMejorNo,
          () => context.go('/cuenta'),
          kind: Bk.ghost,
        ),
      ]),
    );
  }
}

/// Cancela la eliminación y avisa el resultado. `true` si quedó cancelada.
Future<bool> _cancelarEliminacion(WidgetRef ref, AppLocalizations l) async {
  final falla = await ref
      .read(eliminacionControllerProvider.notifier)
      .cancelar();
  maq.toast(switch (falla) {
    null => l.cuentaEliminacionCancelada,
    ConflictoFailure() => l.cuentaEliminacionNadaQueCancelar,
    _ => mensajeDeError(l, falla),
  });
  return falla == null;
}

/// Aviso de «Mi cuenta» mientras corren los 7 días de gracia (USR-11).
class AvisoDeEliminacionReal extends ConsumerWidget {
  const AvisoDeEliminacionReal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final fecha = ref.watch(eliminacionControllerProvider);
    return CardK(
      outline: kc(context).amber,
      child: stack([
        bT(
          fecha == null
              ? l.cuentaEliminacionProgramada
              : l.cuentaEliminacionProgramadaEl(fechaDeCuenta(context, fecha)),
        ),
        BtnK(
          l.cuentaEliminacionCancelar,
          () => unawaited(_cancelarEliminacion(ref, l)),
          sm: true,
        ),
      ], gap: 10),
    );
  }
}

/// «Eliminada» con la API: la fecha y «Cancelar la eliminación» durante la
/// gracia. [alSalir] cierra la sesión.
class EliminadaReal extends ConsumerWidget {
  const EliminadaReal({super.key, required this.alSalir});

  final Future<void> Function() alSalir;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final k = kc(context);
    final fecha = ref.watch(eliminacionControllerProvider);
    final enCurso = ref.watch(eliminacionEnCursoProvider);
    final perfil = ref.watch(perfilControllerProvider);
    final cargando = fecha == null && perfil.isLoading;
    final error = fecha == null ? perfil.error : null;
    final titulo = cargando
        ? l.cuentaEliminacionCargando
        : error != null
        ? mensajeDeError(l, error)
        : !enCurso
        ? l.cuentaEliminacionNinguna
        : fecha == null
        ? l.cuentaEliminacionProgramada
        : l.cuentaEliminacionProgramadaEl(fechaDeCuenta(context, fecha));
    return Pg(
      noHeader: true,
      scroll: false,
      body: stateK(Icons.schedule, k.amberSoft, k.amberInk, titulo, [
        if (enCurso) mutT(l.cuentaEliminacionDetalle, a: TextAlign.center),
      ]),
      cta: ctaCol([
        if (error != null)
          BtnK(
            l.cuentaReintentar,
            ref.read(perfilControllerProvider.notifier).reintentar,
          ),
        if (enCurso)
          BtnK(l.cuentaEliminacionCancelar, () async {
            if (await _cancelarEliminacion(ref, l) && context.mounted) {
              context.go('/cuenta');
            }
          })
        else
          BtnK(
            l.cuentaEliminacionIrACuenta,
            () => context.go('/cuenta'),
            kind: Bk.sec,
          ),
        BtnK(
          l.cuentaEliminacionSalir,
          () => unawaited(alSalir()),
          kind: Bk.ghost,
        ),
      ]),
    );
  }
}
