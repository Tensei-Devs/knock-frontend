import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/reportes/reportes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String _motivo(AppLocalizations t, MotivoDeReporte? motivo) => switch (motivo) {
  MotivoDeReporte.acoso => t.bloqueosMotivoAcoso,
  MotivoDeReporte.fraude => t.bloqueosMotivoFraude,
  MotivoDeReporte.malServicio => t.bloqueosMotivoMalServicio,
  MotivoDeReporte.comportamientoInapropiado => t.bloqueosMotivoComportamiento,
  MotivoDeReporte.peligro => t.bloqueosMotivoPeligro,
  MotivoDeReporte.otro || null => t.bloqueosMotivoOtro,
};

/// Un texto de 8 a 500 caracteres, como piden el reporte y la apelación.
bool _textoValido(String texto) {
  final largo = texto.trim().length;
  return largo >= NuevoReporte.largoMinimo && largo <= NuevoReporte.largoMaximo;
}

/// «Reportar un problema» sobre una visita real (REP-01). La otra persona sale
/// de la visita del servidor; un error deja intacto lo escrito (CA-12).
class ReportarReal extends ConsumerWidget {
  const ReportarReal({
    super.key,
    required this.visitaId,
    required this.trabajo,
  });

  final String visitaId;
  final String trabajo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    Widget soloTexto(List<Widget> hijos) =>
        Pg(title: textos.bloqueosTitulo, body: stack(hijos, gap: 12));
    return ref
        .watch(destinoDeReporteProvider(visitaId))
        .when(
          skipLoadingOnRefresh: false,
          loading: () => soloTexto([sMut(textos.bloqueosCargando)]),
          error: (e, _) => soloTexto([
            NoteK(
              'red',
              'help',
              e is NoEncontradoFailure
                  ? textos.bloqueosNoDisponible
                  : mensajeDeError(textos, e),
            ),
            NoteK('red', 'phone', textos.bloqueosAviso911),
            BtnK(
              textos.bloqueosReintentar,
              () => ref.invalidate(destinoDeReporteProvider(visitaId)),
              kind: Bk.sec,
            ),
          ]),
          data: (destino) => destino == null
              ? soloTexto([
                  NoteK('amber', 'help', textos.bloqueosNoDisponible),
                  NoteK('red', 'phone', textos.bloqueosAviso911),
                ])
              : _Formulario(
                  visitaId: visitaId,
                  reportadoId: destino.usuarioId,
                  sobre: '${destino.nombre} · $trabajo',
                ),
        );
  }
}

class _Formulario extends ConsumerStatefulWidget {
  const _Formulario({
    required this.visitaId,
    required this.reportadoId,
    required this.sobre,
  });

  final String visitaId;
  final String reportadoId;
  final String sobre;

  @override
  ConsumerState<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends ConsumerState<_Formulario> {
  MotivoDeReporte? _elegido;
  ReporteCreado? _creado;
  bool _enviando = false;
  String? _error;
  final _descripcion = TextEditingController();

  @override
  void dispose() {
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_enviando) return;
    final textos = AppLocalizations.of(context);
    setState(() {
      _enviando = true;
      _error = null;
    });
    try {
      final creado = await ref
          .read(reportesRepositoryProvider)
          .crear(
            NuevoReporte(
              reportadoId: widget.reportadoId,
              visitaId: widget.visitaId,
              motivo: _elegido!,
              descripcion: _descripcion.text,
            ),
          );
      if (!mounted) return;
      ref.invalidate(misReportesControllerProvider);
      setState(() => _creado = creado);
    } on Failure catch (falla) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
        _error = mensajeDeError(textos, falla);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final creado = _creado;
    if (creado != null) {
      return Pg(
        title: textos.bloqueosTitulo,
        body: stack([
          h2(textos.bloqueosRecibido),
          if (creado.avisoEmergencia case final aviso?)
            NoteK('red', 'phone', aviso),
        ], gap: 12),
        cta: BtnK(textos.bloqueosVolver, () => context.pop(), kind: Bk.sec),
      );
    }
    final listo = _elegido != null && _textoValido(_descripcion.text);
    return Pg(
      title: textos.bloqueosTitulo,
      body: stack([
        // Con un motivo de peligro, el 911 va primero (D-04).
        if (_elegido == MotivoDeReporte.peligro)
          NoteK('red', 'phone', textos.bloqueosAviso911),
        T(widget.sobre, w: FontWeight.w800),
        labT(textos.bloqueosQuePaso),
        for (final motivo in MotivoDeReporte.values)
          ChoiceK(
            on: _elegido == motivo,
            minH: 58,
            onTap: () => setState(() => _elegido = motivo),
            title: _motivo(textos, motivo),
          ),
        FieldK(
          label: textos.bloqueosDescripcion,
          c: _descripcion,
          lines: 3,
          maxLen: NuevoReporte.largoMaximo,
          onChanged: (_) => setState(() {}),
        ),
        if (_elegido != MotivoDeReporte.peligro)
          NoteK('red', 'phone', textos.bloqueosAviso911),
        if (_error case final error?) NoteK('red', 'help', error),
      ], gap: 10),
      cta: ctaCol([
        BtnK(
          _enviando ? textos.bloqueosEnviando : textos.bloqueosEnviar,
          listo && !_enviando ? _enviar : null,
          kind: Bk.danger,
        ),
        if (!listo) helpT(textos.bloqueosFalta),
      ]),
    );
  }
}

/// «Mis reportes» dentro del Centro de ayuda (REP-02 y REP-03): estados,
/// «Ver más» y apelar una decisión.
class MisReportesReales extends ConsumerWidget {
  const MisReportesReales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final control = ref.read(misReportesControllerProvider.notifier);
    return stack([
      h2(textos.bloqueosMios),
      ref
          .watch(misReportesControllerProvider)
          .when(
            skipLoadingOnRefresh: false,
            loading: () => sMut(textos.bloqueosCargandoLista),
            error: (e, _) => stack([
              NoteK(
                'red',
                'help',
                e is ServicioNoDisponibleFailure
                    ? textos.errorSinConexion
                    : textos.bloqueosErrorLista,
              ),
              BtnK(textos.bloqueosReintentar, control.reintentar, kind: Bk.sec),
            ], gap: 8),
            data: (pagina) => stack([
              if (pagina.items.isEmpty) sMut(textos.bloqueosVacio),
              for (final r in pagina.items)
                _TarjetaDeReporte(r, key: ValueKey(r.reporteId)),
              if (pagina.siguiente != null)
                BtnK(textos.bloqueosVerMas, () async {
                  final falla = await control.cargarMas();
                  if (falla != null && context.mounted) {
                    maq.toast(mensajeDeError(textos, falla));
                  }
                }, kind: Bk.ghost),
            ], gap: 10),
          ),
    ], gap: 10);
  }
}

class _TarjetaDeReporte extends ConsumerStatefulWidget {
  const _TarjetaDeReporte(this.reporte, {super.key});

  final ResumenDeReporte reporte;

  @override
  ConsumerState<_TarjetaDeReporte> createState() => _TarjetaDeReporteState();
}

class _TarjetaDeReporteState extends ConsumerState<_TarjetaDeReporte> {
  bool _abierta = false;
  bool _enviando = false;
  String? _error;
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _apelar() async {
    if (_enviando) return;
    final textos = AppLocalizations.of(context);
    setState(() {
      _enviando = true;
      _error = null;
    });
    final falla = await ref
        .read(misReportesControllerProvider.notifier)
        .apelar(widget.reporte.reporteId, _texto.text);
    if (falla == null) {
      maq.toast(textos.bloqueosApelacionEnviada);
      return;
    }
    if (!mounted) return;
    setState(() {
      _enviando = false;
      _error = mensajeDeError(textos, falla);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final r = widget.reporte;
    final fecha = MaterialLocalizations.of(context)
        .formatMediumDate(r.creadoEn.toLocal());
    return CardK(
      child: stack([
        T(
          _motivo(textos, MotivoDeReporte.desdeTexto(r.motivo)),
          w: FontWeight.w900,
        ),
        sMut(
          '$fecha · ${switch (r.estado) {
            'abierto' => textos.bloqueosEstadoAbierto,
            'decidido' => textos.bloqueosEstadoDecidido,
            'en_apelacion' => textos.bloqueosEstadoEnApelacion,
            _ => textos.bloqueosEstadoOtro,
          }}',
        ),
        if (r.puedeApelar && !_abierta)
          BtnK(
            textos.bloqueosApelar,
            () => setState(() => _abierta = true),
            kind: Bk.sec,
          ),
        if (r.puedeApelar && _abierta) ...[
          FieldK(
            label: textos.bloqueosApelacionTexto,
            c: _texto,
            lines: 3,
            maxLen: NuevoReporte.largoMaximo,
            onChanged: (_) => setState(() {}),
          ),
          if (_error case final error?) NoteK('red', 'help', error),
          BtnK(
            _enviando
                ? textos.bloqueosEnviando
                : textos.bloqueosEnviarApelacion,
            _textoValido(_texto.text) && !_enviando ? _apelar : null,
            kind: Bk.dark,
          ),
        ],
      ], gap: 8),
    );
  }
}
