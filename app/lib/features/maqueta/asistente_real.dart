import 'dart:async';

import 'package:app/core/config/asistente_ia.dart';
import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/asistente/asistente.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// El asistente se usa solo con el interruptor encendido, sesión y API.
final asistenteDisponibleProvider = Provider<bool>(
  (ref) =>
      ref.watch(asistenteIaActivoProvider) &&
      ref.watch(solicitudesRealesActivasProvider),
);

/// Aviso en las pantallas de ejemplo cuando hay sesión real: lo que muestran no
/// salió de una IA (y, con el interruptor apagado, no está disponible).
class NotaIaDeEjemplo extends ConsumerWidget {
  const NotaIaDeEjemplo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(solicitudesRealesActivasProvider)) {
      return const SizedBox.shrink();
    }
    final t = AppLocalizations.of(context);
    return NoteK(
      'amber',
      'help',
      ref.watch(asistenteIaActivoProvider)
          ? t.asistenteEjemplo
          : '${t.asistenteEjemplo} ${t.asistenteNoDisponible}',
    );
  }
}

String _mensaje(AppLocalizations t, Object error) =>
    error is DemasiadosIntentosFailure
    ? t.asistenteLimite
    : mensajeDeError(t, error);

/// Rutas del técnico para ASI-02 a ASI-06. Protegidas por omisión. Todavía no
/// hay enlaces hacia ellas: el chat y los trabajos del técnico son de ejemplo y
/// no tienen identificadores reales (KNOCK-266).
List<RouteBase> rutasAsistente() => [
  GoRoute(
    path: 'tecnico/asistente/resumen/:id',
    builder: (c, s) => _Pantalla(
      titulo: (t) => t.asistenteResumenTitulo,
      cuerpo: ResumenReal(s.pathParameters['id']!),
    ),
  ),
  GoRoute(
    path: 'tecnico/asistente/borrador/:id',
    builder: (c, s) => _Pantalla(
      titulo: (t) => t.asistenteBorradorTitulo,
      cuerpo: BorradorReal(s.pathParameters['id']!),
    ),
  ),
  GoRoute(
    path: 'tecnico/asistente/rango/:oficio/:tipo',
    builder: (c, s) => _Pantalla(
      titulo: (t) => t.asistenteRangoTitulo,
      cuerpo: RangoReal((
        oficio: s.pathParameters['oficio']!,
        tipoTrabajo: s.pathParameters['tipo']!,
      )),
    ),
  ),
  GoRoute(
    path: 'tecnico/asistente/bitacora/:id',
    builder: (c, s) => _Pantalla(
      titulo: (t) => t.asistenteBitacoraTitulo,
      cuerpo: BitacoraReal(s.pathParameters['id']!),
    ),
  ),
];

class _Pantalla extends ConsumerWidget {
  const _Pantalla({required this.titulo, required this.cuerpo});

  final String Function(AppLocalizations) titulo;
  final Widget cuerpo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return Pg(
      title: titulo(t),
      body: ref.watch(asistenteDisponibleProvider)
          ? cuerpo
          : NoteK('amber', 'help', t.asistenteNoDisponible),
    );
  }
}

/// Carga, error (o sin conexión) con Reintentar y datos.
Widget _estados<D>(
  BuildContext context,
  AsyncValue<D> estado, {
  required VoidCallback reintentar,
  required Widget Function(D) datos,
}) {
  final t = AppLocalizations.of(context);
  return estado.when(
    skipLoadingOnRefresh: false,
    loading: () => sMut(t.asistenteCargando),
    error: (e, _) => stack([
      NoteK('red', 'help', _mensaje(t, e)),
      BtnK(t.asistenteReintentar, reintentar, kind: Bk.sec),
    ], gap: 12),
    data: datos,
  );
}

Widget _origen(AppLocalizations t, {required bool deIa}) => NoteK(
  deIa ? 'blue' : 'amber',
  deIa ? 'sparkle' : 'help',
  deIa ? t.asistenteGeneradoPorIa : t.asistenteDePlantilla,
);

Widget _campo(
  TextEditingController c,
  String etiqueta, {
  int lineas = 1,
  int? maximo,
}) => TextField(
  controller: c,
  minLines: lineas,
  maxLines: lineas == 1 ? 1 : 10,
  maxLength: maximo,
  decoration: InputDecoration(
    labelText: etiqueta,
    border: const OutlineInputBorder(),
  ),
);

/// ASI-01. Lo escrito se conserva si la llamada falla.
class AsistenteChatReal extends ConsumerStatefulWidget {
  const AsistenteChatReal({super.key, this.texto});

  final String? texto;

  @override
  ConsumerState<AsistenteChatReal> createState() => _ChatState();
}

class _ChatState extends ConsumerState<AsistenteChatReal> {
  late final _c = TextEditingController(text: widget.texto);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _enviar() {
    final mensaje = _c.text.trim();
    if (mensaje.isEmpty) return;
    unawaited(ref.read(turnoControllerProvider.notifier).enviar(mensaje));
  }

  void _armar() {
    maq.startReq(desc: _c.text.trim(), photos: const [], step: 2);
    unawaited(context.push(RM.solicitar));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final turno = ref.watch(turnoControllerProvider);
    return Pg(
      title: t.asistenteTitulo,
      body: stack([
        _campo(_c, t.asistenteEscribe, lineas: 3, maximo: 1000),
        BtnK(t.asistenteEnviar, turno.isLoading ? null : _enviar),
        _estados(
          context,
          turno,
          reintentar: _enviar,
          datos: (r) => r == null
              ? sMut(t.asistenteSinTurno)
              : stack([
                  _origen(t, deIa: r.deIa),
                  if (r.seguridad case final aviso?)
                    NoteK('red', 'flag', aviso),
                  CardK(child: Text(r.mensaje)),
                  if (r.pideFoto) sMut(t.asistentePideFoto),
                  BtnK(t.asistenteArmarSolicitud, _armar, kind: Bk.sec),
                ], gap: 10),
        ),
      ], gap: 12),
    );
  }
}

Widget _lista(String titulo, List<String> elementos) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [labT(titulo), for (final e in elementos) Text('• $e')],
);

/// ASI-02.
class ResumenReal extends ConsumerWidget {
  const ResumenReal(this.conversacionId, {super.key});

  final String conversacionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final p = resumenControllerProvider(conversacionId);
    return _estados(
      context,
      ref.watch(p),
      reintentar: () => ref.invalidate(p),
      datos: (r) => r.vacio
          ? sMut(t.asistenteResumenVacio)
          : stack([
              _origen(t, deIa: r.deIa),
              _lista(t.asistenteSabe, r.sabe),
              _lista(t.asistentePorConfirmar, r.porConfirmar),
              _lista(t.asistenteQueLlevar, r.queLlevar),
            ], gap: 12),
    );
  }
}

/// ASI-03: borrador editable; no envía ninguna cotización (spec 052, R-22).
class BorradorReal extends ConsumerWidget {
  const BorradorReal(this.conversacionId, {super.key});

  final String conversacionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = borradorControllerProvider(conversacionId);
    return _estados(
      context,
      ref.watch(p),
      reintentar: () => ref.invalidate(p),
      datos: _BorradorEditable.new,
    );
  }
}

class _BorradorEditable extends StatefulWidget {
  const _BorradorEditable(this.borrador);

  final BorradorCotizacionIa borrador;

  @override
  State<_BorradorEditable> createState() => _BorradorState();
}

class _BorradorState extends State<_BorradorEditable> {
  late final _precio = TextEditingController(
    text: '${widget.borrador.precioSugerido}',
  );
  late final _tiempo = TextEditingController(
    text: widget.borrador.tiempoEstimado,
  );
  late final _dia = TextEditingController(text: widget.borrador.dia);
  late final _nota = TextEditingController(text: widget.borrador.nota);

  @override
  void dispose() {
    for (final c in [_precio, _tiempo, _dia, _nota]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return stack([
      _origen(t, deIa: widget.borrador.deIa),
      sMut(widget.borrador.explicacion),
      _campo(_precio, t.asistentePrecio),
      _campo(_tiempo, t.asistenteTiempo),
      _campo(_dia, t.asistenteDia),
      _campo(_nota, t.asistenteNota, lineas: 3),
      sMut(t.asistenteNadaSeEnvia),
    ], gap: 12);
  }
}

/// ASI-04: referencia calculada con cotizaciones, no con un modelo de lenguaje.
class RangoReal extends ConsumerWidget {
  const RangoReal(this.consulta, {super.key});

  final ConsultaDeRango consulta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final p = rangoControllerProvider(consulta);
    return _estados(
      context,
      ref.watch(p),
      reintentar: () => ref.invalidate(p),
      datos: (r) => r == null
          ? sMut(t.asistenteRangoVacio)
          : stack([
              if (r.copiaDel case final fecha?) ...[
                NoteK(
                  'amber',
                  'help',
                  t.asistenteCopia(
                    MaterialLocalizations.of(context)
                        .formatMediumDate(fecha.toLocal()),
                  ),
                ),
                BtnK(
                  t.asistenteReintentar,
                  () => ref.invalidate(p),
                  kind: Bk.sec,
                ),
              ],
              h3(t.asistenteRango('${r.minimo}', '${r.maximo}')),
              sMut(t.asistenteMuestras('${r.muestras}', r.fuente)),
            ], gap: 12),
    );
  }
}

/// ASI-05 y ASI-06: lee la bitácora y permite guardarla.
class BitacoraReal extends ConsumerWidget {
  const BitacoraReal(this.solicitudId, {super.key});

  final String solicitudId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = bitacoraControllerProvider(solicitudId);
    return _estados(
      context,
      ref.watch(p),
      reintentar: () => ref.invalidate(p),
      datos: (b) => _BitacoraEditable(solicitudId, b),
    );
  }
}

class _BitacoraEditable extends ConsumerStatefulWidget {
  const _BitacoraEditable(this.solicitudId, this.bitacora);

  final String solicitudId;
  final Bitacora? bitacora;

  @override
  ConsumerState<_BitacoraEditable> createState() => _BitacoraState();
}

class _BitacoraState extends ConsumerState<_BitacoraEditable> {
  late final _sabe = _de(widget.bitacora?.sabe);
  late final _porConfirmar = _de(widget.bitacora?.porConfirmar);
  late final _queLlevar = _de(widget.bitacora?.queLlevar);
  Object? _error;
  bool _guardando = false, _guardada = false;

  static TextEditingController _de(List<String>? l) =>
      TextEditingController(text: l?.join('\n'));

  static List<String> _lineas(TextEditingController c) => [
    for (final l in c.text.split('\n'))
      if (l.trim().isNotEmpty) l.trim(),
  ];

  @override
  void dispose() {
    for (final c in [_sabe, _porConfirmar, _queLlevar]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() {
      _guardando = true;
      _guardada = false;
      _error = null;
    });
    final falla = await ref
        .read(bitacoraControllerProvider(widget.solicitudId).notifier)
        .guardar(
          Bitacora(
            sabe: _lineas(_sabe),
            porConfirmar: _lineas(_porConfirmar),
            queLlevar: _lineas(_queLlevar),
          ),
        );
    if (!mounted) return;
    setState(() {
      _guardando = false;
      _guardada = falla == null;
      _error = falla;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return stack([
      if (widget.bitacora == null) sMut(t.asistenteBitacoraVacia),
      sMut(t.asistenteUnoPorLinea),
      _campo(_sabe, t.asistenteSabe, lineas: 3),
      _campo(_porConfirmar, t.asistentePorConfirmar, lineas: 3),
      _campo(_queLlevar, t.asistenteQueLlevar, lineas: 3),
      if (_error case final error?) NoteK('red', 'help', _mensaje(t, error)),
      if (_guardada) NoteK('blue', 'check', t.asistenteGuardada),
      BtnK(t.asistenteGuardar, _guardando ? null : _guardar),
    ], gap: 12);
  }
}
