import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/visita/visita.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La cotización final y los cambios de precio que el cliente aprueba o
/// rechaza en su visita real (spec 039). Sin nada que mostrar no ocupa lugar.
class PrecioDeVisitaReal extends ConsumerWidget {
  const PrecioDeVisitaReal({super.key, required this.visitaId});

  final String visitaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final proveedor = precioDeVisitaControllerProvider(visitaId);
    return ref
        .watch(proveedor)
        .when(
          skipLoadingOnRefresh: false,
          loading: () => sMut(textos.cotizacionCargandoPrecio),
          error: (e, _) => stack([
            NoteK(
              'red',
              'help',
              mensajeDeError(
                textos,
                e is Failure ? e : const ServicioNoDisponibleFailure(),
              ),
            ),
            BtnK(
              textos.cotizacionActualizar,
              () => ref.invalidate(proveedor),
              kind: Bk.sec,
              sm: true,
            ),
          ], gap: 12),
          data: (precio) {
            final cotizacion = precio.cotizacionFinal;
            if (cotizacion == null && precio.ajustes.isEmpty) {
              return const SizedBox.shrink();
            }
            return stack([
              if (cotizacion != null) _cotizacion(textos, cotizacion),
              for (final a in precio.ajustes)
                _TarjetaPorDecidir(
                  key: ValueKey(a.id),
                  visitaId: visitaId,
                  titulo: textos.cotizacionAjusteTitulo,
                  monto: a.montoNuevo,
                  texto: a.motivo,
                  explicacion: textos.cotizacionAjusteExplicacion,
                  venceEn: a.venceEn,
                  conflicto: textos.cotizacionAjusteYaDecidido,
                  aprobado: textos.cotizacionAjusteAprobado,
                  rechazado: textos.cotizacionAjusteRechazado,
                  decidir: (ref, aprueba) => ref
                      .read(precioDeVisitaRepositoryProvider)
                      .decidirAjuste(a.id, aprueba: aprueba),
                ),
            ], gap: 12);
          },
        );
  }

  Widget _cotizacion(AppLocalizations textos, CotizacionFinal c) {
    if (!c.porDecidir) {
      final aprobada = c.estado == 'aprobada';
      return NoteK(
        aprobada ? 'green' : 'amber',
        aprobada ? 'check' : 'clock',
        switch (c.estado) {
          'aprobada' => textos.cotizacionFinalAprobada,
          'rechazada' => textos.cotizacionFinalRechazada,
          _ => textos.cotizacionFinalVencida,
        },
      );
    }
    return _TarjetaPorDecidir(
      key: const ValueKey('cotizacion-final'),
      visitaId: visitaId,
      titulo: textos.cotizacionFinalTitulo,
      monto: c.precio,
      texto: c.descripcion,
      explicacion: textos.cotizacionFinalExplicacion,
      venceEn: c.venceEn,
      conflicto: textos.cotizacionFinalYaDecidida,
      aprobado: textos.cotizacionFinalAprobada,
      rechazado: textos.cotizacionFinalRechazada,
      decidir: (ref, aprueba) => ref
          .read(precioDeVisitaRepositoryProvider)
          .decidirCotizacionFinal(visitaId, aprueba: aprueba),
    );
  }
}

/// Un precio con sus botones Aprobar y Rechazar: un envío a la vez y el error
/// se queda en la tarjeta con la opción de actualizar.
class _TarjetaPorDecidir extends ConsumerStatefulWidget {
  const _TarjetaPorDecidir({
    super.key,
    required this.visitaId,
    required this.titulo,
    required this.monto,
    required this.texto,
    required this.explicacion,
    required this.venceEn,
    required this.conflicto,
    required this.aprobado,
    required this.rechazado,
    required this.decidir,
  });

  final String visitaId;
  final String titulo;
  final num monto;
  final String texto;
  final String explicacion;
  final DateTime venceEn;

  /// El mensaje del 409 de esta ruta.
  final String conflicto;
  final String aprobado;
  final String rechazado;
  final Future<void> Function(WidgetRef, bool) decidir;

  @override
  ConsumerState<_TarjetaPorDecidir> createState() => _TarjetaPorDecidirState();
}

class _TarjetaPorDecidirState extends ConsumerState<_TarjetaPorDecidir> {
  bool _enviando = false;
  String? _error;

  void _actualizar() {
    ref.invalidate(precioDeVisitaControllerProvider(widget.visitaId));
    ref.invalidate(act.visitaRealProvider(widget.visitaId));
  }

  Future<void> _decidir(bool aprueba) async {
    if (_enviando) return;
    final textos = AppLocalizations.of(context);
    setState(() {
      _enviando = true;
      _error = null;
    });
    try {
      await widget.decidir(ref, aprueba);
    } on Failure catch (falla) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
        _error = switch (falla) {
          ConflictoFailure() => widget.conflicto,
          NoEncontradoFailure() => textos.visitaNoDisponible,
          _ => mensajeDeError(textos, falla),
        };
      });
      return;
    }
    if (!mounted) return;
    maq.toast(aprueba ? widget.aprobado : widget.rechazado);
    maq.reintentarSolicitudes?.call();
    _actualizar();
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final formato = MaterialLocalizations.of(context);
    final vence = widget.venceEn.toLocal();
    final fecha =
        '${formato.formatShortDate(vence)} '
        '${formato.formatTimeOfDay(TimeOfDay.fromDateTime(vence))}';
    return CardK(
      outline: kc(context).amber,
      child: stack([
        T(widget.titulo, size: 16, w: FontWeight.w900),
        T(money(widget.monto), size: 24, w: FontWeight.w900),
        T(widget.texto, size: 14),
        sMut(widget.explicacion),
        sMut(textos.cotizacionRespondeAntes(fecha)),
        if (_error case final error?) ...[
          NoteK('red', 'help', error),
          BtnK(
            textos.cotizacionActualizar,
            _actualizar,
            kind: Bk.ghost,
            sm: true,
          ),
        ],
        BtnK(
          textos.cotizacionAprobar,
          _enviando ? null : () => _decidir(true),
          icon: 'check',
          sm: true,
        ),
        BtnK(
          textos.cotizacionRechazar,
          _enviando ? null : () => _decidir(false),
          kind: Bk.sec,
          sm: true,
        ),
      ], gap: 8),
    );
  }
}
