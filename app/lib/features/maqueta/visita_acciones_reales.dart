import 'dart:async';

import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/envio_de_visita.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/visita/visita.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// «Reprogramar» y «Cancelar» de una visita o cita real (spec 040). Solo se
/// ofrecen en los estados que el servidor acepta; con una propuesta de fecha
/// pendiente no se puede proponer otra.
class AccionesVisitaReal extends ConsumerWidget {
  const AccionesVisitaReal({super.key, required this.visitaId});

  final String visitaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(act.visitaRealProvider(visitaId)).value;
    final confirmada = v?.estado == act.EstadoVisita.confirmada;
    if (v == null || !(confirmada || v.estado == act.EstadoVisita.enCurso)) {
      return const SizedBox.shrink();
    }
    final textos = AppLocalizations.of(context);
    return stack([
      if (v.reprogramacionPendiente)
        NoteK('amber', 'clock', textos.visitaCambioPendiente)
      else if (confirmada)
        BtnK(
          textos.visitaReprogramar,
          () => _hojaReprogramar(context, visitaId),
          kind: Bk.sec,
          sm: true,
          icon: 'cal',
        ),
      BtnK(
        textos.visitaCancelar,
        () => _hojaCancelar(context, visitaId),
        kind: Bk.ghost,
        sm: true,
        icon: 'x',
      ),
    ], gap: 12);
  }
}

/// «No se terminó» de un trabajo real terminado (VIS-10). El plazo de 7 días y
/// el «una sola vez» los decide el servidor.
class BotonNoTerminadoReal extends StatelessWidget {
  const BotonNoTerminadoReal({super.key, required this.visitaId});

  final String visitaId;

  @override
  Widget build(BuildContext context) => BtnK(
    AppLocalizations.of(context).visitaNoTerminadoBoton,
    () => _hojaNoTerminado(context, visitaId),
    kind: Bk.ghost,
    sm: true,
    icon: 'flag',
  );
}

/// «El cliente no estaba» (VIS-07): el técnico confirma y el servidor decide si
/// está dentro de la ventana de la cita.
void hojaClienteAusente(BuildContext context, String visitaId) {
  final textos = AppLocalizations.of(context);
  _abrir(
    context,
    _HojaDeEnvio(
      titulo: textos.visitaAusenteBoton,
      boton: textos.visitaAusenteConfirmar,
      conflicto: textos.visitaAusenteFueraDeVentana,
      listo: (_) => true,
      contenido: (_, _) => [sMut(textos.visitaAusenteExplicacion)],
      enviar: (ref, _) async {
        await ref
            .read(accionesVisitaRepositoryProvider)
            .clienteAusente(visitaId);
        ref.invalidate(agendaControllerProvider);
        return textos.visitaAusenteRegistrada;
      },
    ),
  );
}

void _hojaCancelar(BuildContext context, String visitaId) {
  final textos = AppLocalizations.of(context);
  final router = GoRouter.of(context);
  var motivo = '';
  _abrir(
    context,
    _HojaDeEnvio(
      titulo: textos.visitaCancelarTitulo,
      boton: textos.visitaCancelarConfirmar,
      tipo: Bk.danger,
      conflicto: textos.visitaYaCerrada,
      listo: (_) => motivo.isNotEmpty,
      contenido: (_, cambiar) => [
        NoteK('amber', 'clock', textos.visitaCancelarAviso),
        labT(textos.visitaCancelarMotivo),
        chipsWrap([
          for (final m in [
            textos.visitaMotivoResuelto,
            textos.visitaMotivoPlanes,
            textos.visitaMotivoOtraOpcion,
            textos.visitaMotivoOtro,
          ])
            ChipK(m, on: motivo == m, onTap: () => cambiar(() => motivo = m)),
        ]),
      ],
      enviar: (ref, _) async {
        final r = await ref
            .read(accionesVisitaRepositoryProvider)
            .cancelar(visitaId, motivo);
        ref.invalidate(act.visitaRealProvider(visitaId));
        return r.tardia ? textos.visitaCanceladaTardia : textos.visitaCancelada;
      },
      despues: () => router.go('/actividad'),
    ),
  );
}

void _hojaReprogramar(BuildContext context, String visitaId) {
  final textos = AppLocalizations.of(context);
  var dia = 1;
  var hora = rsTimes[1];
  DateTime elegida() {
    final base = DateTime.now().add(Duration(days: dia));
    final partes = hora.split(':').map(int.parse).toList();
    return DateTime(base.year, base.month, base.day, partes[0], partes[1]);
  }

  bool aTiempo() =>
      elegida().isAfter(DateTime.now().add(ReglasDeVisita.anticipacionMinima));

  _abrir(
    context,
    _HojaDeEnvio(
      titulo: textos.visitaReprogramar,
      boton: textos.visitaReprogramarEnviar,
      conflicto: textos.visitaNoReprogramable,
      listo: (_) => aTiempo(),
      contenido: (_, cambiar) {
        final opciones = days;
        return [
          sMut(textos.visitaReprogramarExplicacion),
          labT(textos.visitaDia),
          chipsWrap([
            for (var i = 0; i < opciones.length; i++)
              ChipK(
                '${opciones[i].$1} ${opciones[i].$2}',
                on: dia == i,
                onTap: () => cambiar(() => dia = i),
              ),
          ]),
          labT(textos.visitaHora),
          chipsWrap([
            for (final h in rsTimes)
              ChipK(h, on: hora == h, onTap: () => cambiar(() => hora = h)),
          ]),
          if (!aTiempo()) helpT(textos.visitaFechaMuyCercana),
        ];
      },
      enviar: (ref, _) async {
        await ref
            .read(accionesVisitaRepositoryProvider)
            .reprogramar(visitaId, elegida());
        ref.invalidate(act.visitaRealProvider(visitaId));
        return textos.visitaReprogramacionEnviada;
      },
    ),
  );
}

void _hojaNoTerminado(BuildContext context, String visitaId) {
  final textos = AppLocalizations.of(context);
  _abrir(
    context,
    _HojaDeEnvio(
      titulo: textos.visitaNoTerminadoTitulo,
      boton: textos.visitaNoTerminadoEnviar,
      conflicto: textos.visitaReporteCerrado,
      listo: (campo) =>
          campo.text.trim().length >= ReglasDeVisita.reporteMinimo,
      contenido: (campo, cambiar) => [
        FieldK(
          label: textos.visitaNoTerminadoCampo,
          help: textos.visitaNoTerminadoAyuda,
          c: campo,
          lines: 4,
          maxLen: ReglasDeVisita.reporteMaximo,
          onChanged: (_) => cambiar(() {}),
        ),
      ],
      enviar: (ref, campo) async {
        await ref
            .read(accionesVisitaRepositoryProvider)
            .reportarNoTerminado(visitaId, campo.text.trim());
        return textos.visitaNoTerminadoEnviado;
      },
    ),
  );
}

void _abrir(BuildContext context, Widget contenido) =>
    unawaited(hoja<void>(context, (_, _) => contenido));

/// Una hoja que envía una acción: un envío a la vez, y un error deja intacto
/// lo elegido o escrito.
class _HojaDeEnvio extends ConsumerStatefulWidget {
  const _HojaDeEnvio({
    required this.titulo,
    required this.boton,
    required this.conflicto,
    required this.listo,
    required this.contenido,
    required this.enviar,
    this.tipo = Bk.pri,
    this.despues,
  });

  final String titulo;
  final String boton;

  /// El mensaje del 409 de esta ruta.
  final String conflicto;
  final bool Function(TextEditingController) listo;
  final List<Widget> Function(TextEditingController, StateSetter) contenido;

  /// Hace la llamada y devuelve el aviso de éxito.
  final Future<String> Function(WidgetRef, TextEditingController) enviar;
  final Bk tipo;
  final VoidCallback? despues;

  @override
  ConsumerState<_HojaDeEnvio> createState() => _HojaDeEnvioState();
}

class _HojaDeEnvioState extends ConsumerState<_HojaDeEnvio> with EnvioDeVisita {
  final _campo = TextEditingController();

  @override
  void dispose() {
    _campo.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    var aviso = '';
    final bien = await enviarUnaVez(
      widget.conflicto,
      () async => aviso = await widget.enviar(ref, _campo),
    );
    if (!bien || !mounted) return;
    Navigator.pop(context);
    maq.reintentarSolicitudes?.call();
    widget.despues?.call();
    maq.toast(aviso);
  }

  @override
  Widget build(BuildContext context) => stack([
    sheetH(context, widget.titulo),
    ...widget.contenido(_campo, setState),
    if (errorDeEnvio case final error?) NoteK('red', 'help', error),
    BtnK(
      enviando ? AppLocalizations.of(context).visitaEnviando : widget.boton,
      !enviando && widget.listo(_campo) ? _enviar : null,
      kind: widget.tipo,
    ),
  ]);
}
