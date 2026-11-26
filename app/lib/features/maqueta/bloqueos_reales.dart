import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/lista_paginada_real.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/reportes/reportes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Texto de un fallo al bloquear o desbloquear (CA-03, CA-06): 404 tiene su
/// propio aviso para no confundirlo con «no hay conexión».
String _errorDeBloqueo(
  AppLocalizations t,
  Failure falla, {
  required bool alBloquear,
}) {
  if (falla is NoEncontradoFailure) {
    return alBloquear ? t.bloqueosNoEncontrada : t.bloqueosErrorYaNoBloqueada;
  }
  return mensajeDeError(t, falla);
}

/// «Personas bloqueadas» (spec 033, BLO-03) con «Desbloquear» (BLO-02). Se
/// muestra en el Centro de ayuda; solo con sesión y API.
class PersonasBloqueadasReales extends ListaPaginadaReal<PaginaBloqueados> {
  const PersonasBloqueadasReales({super.key});

  @override
  TextosDeLista textosDeLista(AppLocalizations t) => (
    titulo: t.bloqueosPersonasTitulo,
    cargando: t.bloqueosPersonasCargando,
    error: t.bloqueosPersonasError,
    vacio: t.bloqueosPersonasVacio,
  );

  @override
  AsyncValue<PaginaBloqueados> observar(WidgetRef ref) =>
      ref.watch(bloqueosControllerProvider);

  @override
  List<Widget> filas(PaginaBloqueados pagina) => [
    for (final p in pagina.items) _FilaBloqueada(p, key: ValueKey(p.usuarioId)),
  ];

  @override
  bool hayMas(PaginaBloqueados pagina) => pagina.siguiente != null;

  @override
  void reintentar(WidgetRef ref) =>
      ref.read(bloqueosControllerProvider.notifier).reintentar();

  @override
  Future<Failure?> cargarMas(WidgetRef ref) =>
      ref.read(bloqueosControllerProvider.notifier).cargarMas();
}

class _FilaBloqueada extends StatelessWidget {
  const _FilaBloqueada(this.persona, {super.key});

  final PersonaBloqueada persona;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final fecha = MaterialLocalizations.of(context)
        .formatMediumDate(persona.bloqueadoEn.toLocal());
    return CardK(
      child: stack([
        T(persona.nombre, w: FontWeight.w900),
        sMut('${textos.bloqueosBloqueadaEl} $fecha'),
        DesbloquearReal(usuarioId: persona.usuarioId, nombre: persona.nombre),
      ], gap: 8),
    );
  }
}

/// «Chat (Desbloquear)» (spec 033, BLO-02): deshace un bloqueo y avisa del
/// resultado. Un error deja el botón listo para reintentar.
class DesbloquearReal extends ConsumerStatefulWidget {
  const DesbloquearReal({
    super.key,
    required this.usuarioId,
    required this.nombre,
  });

  final String usuarioId;
  final String nombre;

  @override
  ConsumerState<DesbloquearReal> createState() => _DesbloquearRealState();
}

class _DesbloquearRealState extends ConsumerState<DesbloquearReal> {
  bool _enviando = false;
  String? _error;

  Future<void> _desbloquear() async {
    if (_enviando) return;
    final textos = AppLocalizations.of(context);
    setState(() {
      _enviando = true;
      _error = null;
    });
    final falla = await ref
        .read(bloqueosControllerProvider.notifier)
        .desbloquear(widget.usuarioId);
    if (!mounted) return;
    if (falla == null) {
      maq.toast(textos.bloqueosDesbloqueada);
      setState(() => _enviando = false);
      return;
    }
    setState(() {
      _enviando = false;
      _error = _errorDeBloqueo(textos, falla, alBloquear: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return stack([
      if (_error case final error?) NoteK('red', 'help', error),
      BtnK(
        _enviando ? textos.bloqueosDesbloqueando : textos.bloqueosDesbloquear,
        _enviando ? null : _desbloquear,
        kind: Bk.sec,
      ),
    ], gap: 8);
  }
}

/// «Chat (menú Bloquear)» (spec 033, BLO-01): bloquea a la otra persona de una
/// visita real y ofrece «Deshacer» (D-03). La persona sale de la visita del
/// servidor, nunca de un dato local.
class BloquearReal extends ConsumerWidget {
  const BloquearReal({
    super.key,
    required this.visitaId,
    required this.trabajo,
  });

  final String visitaId;
  final String trabajo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    return ref
        .watch(destinoDeReporteProvider(visitaId))
        .when(
          skipLoadingOnRefresh: false,
          loading: () => stack([
            sMut(textos.bloqueosCargando),
            NoteK('amber', 'help', textos.bloqueosBloquearAviso),
          ], gap: 12),
          error: (e, _) => stack([
            NoteK(
              'red',
              'help',
              e is NoEncontradoFailure
                  ? textos.bloqueosNoEncontrada
                  : mensajeDeError(textos, e),
            ),
            BtnK(
              textos.bloqueosReintentar,
              () => ref.invalidate(destinoDeReporteProvider(visitaId)),
              kind: Bk.sec,
            ),
          ], gap: 8),
          data: (destino) => destino == null
              ? NoteK('amber', 'help', textos.bloqueosNoEncontrada)
              : _ConfirmarBloqueo(
                  usuarioId: destino.usuarioId,
                  nombre: destino.nombre,
                  sobre: '${destino.nombre} · $trabajo',
                ),
        );
  }
}

class _ConfirmarBloqueo extends ConsumerStatefulWidget {
  const _ConfirmarBloqueo({
    required this.usuarioId,
    required this.nombre,
    required this.sobre,
  });

  final String usuarioId;
  final String nombre;
  final String sobre;

  @override
  ConsumerState<_ConfirmarBloqueo> createState() => _ConfirmarBloqueoState();
}

class _ConfirmarBloqueoState extends ConsumerState<_ConfirmarBloqueo> {
  bool _enviando = false;
  bool _hecho = false;
  String? _error;

  Future<void> _confirmar() async {
    final textos = AppLocalizations.of(context);
    final si = await hoja<bool>(
      context,
      (ctx, _) => stack([
        sheetH(ctx, textos.bloqueosConfirmarBloqueoTitulo),
        T(widget.sobre),
        NoteK('amber', 'help', textos.bloqueosBloquearAviso),
        BtnK(
          textos.bloqueosConfirmarBloqueo,
          () => Navigator.pop(ctx, true),
          kind: Bk.danger,
        ),
        BtnK(textos.bloqueosCancelar, () => Navigator.pop(ctx), kind: Bk.ghost),
      ]),
    );
    if (si == true) await _bloquear();
  }

  Future<void> _bloquear() async {
    if (_enviando) return;
    final textos = AppLocalizations.of(context);
    setState(() {
      _enviando = true;
      _error = null;
    });
    final falla = await ref
        .read(bloqueosControllerProvider.notifier)
        .bloquear(widget.usuarioId);
    if (!mounted) return;
    if (falla == null) {
      setState(() {
        _enviando = false;
        _hecho = true;
      });
      return;
    }
    setState(() {
      _enviando = false;
      _error = _errorDeBloqueo(textos, falla, alBloquear: true);
    });
  }

  Future<void> _deshacer() async {
    final textos = AppLocalizations.of(context);
    final falla = await ref
        .read(bloqueosControllerProvider.notifier)
        .desbloquear(widget.usuarioId);
    if (!mounted) return;
    if (falla == null) {
      maq.toast(textos.bloqueosDesbloqueada);
      setState(() => _hecho = false);
      return;
    }
    setState(() => _error = _errorDeBloqueo(textos, falla, alBloquear: false));
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    if (_hecho) {
      return stack([
        NoteK('green', 'check', textos.bloqueosBloqueada),
        if (_error case final error?) NoteK('red', 'help', error),
        BtnK(textos.bloqueosDeshacer, _deshacer, kind: Bk.sec),
        BtnK(
          textos.bloqueosVolver,
          () => Navigator.of(context).maybePop(),
          kind: Bk.ghost,
        ),
      ], gap: 8);
    }
    return stack([
      T(widget.sobre, w: FontWeight.w800),
      NoteK('amber', 'help', textos.bloqueosBloquearAviso),
      if (_error case final error?) NoteK('red', 'help', error),
      BtnK(
        _enviando ? textos.bloqueosBloqueando : textos.bloqueosBloquear,
        _enviando ? null : _confirmar,
        kind: Bk.danger,
      ),
    ], gap: 10);
  }
}
