import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/features/busqueda/busqueda.dart';
import 'package:app/features/maqueta/cobertura.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/solicitudes_reales.dart'
    show coloniaIdDeLaPersona;
import 'package:app/features/maqueta/ui.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// El mensaje de cada error de la búsqueda (spec 021, §7).
String _textoDeFalla(AppLocalizations l, Object falla) => switch (falla) {
  BusquedaNoDisponible() => l.busquedaNoDisponible,
  ServicioNoDisponibleFailure() => l.busquedaSinConexion,
  DatosRechazadosFailure() => l.busquedaOtrasPalabras,
  DemasiadosIntentosFailure(:final espera?) => l.busquedaEspera(
    espera.inSeconds,
  ),
  _ => mensajeDeError(l, falla),
};

/// Pide la cotización con el oficio ya elegido, sin contacto directo con el
/// experto (CA-09, R-08).
void _pedir(BuildContext context, String? clave) {
  maq.startReq(cat: cats.containsKey(clave) ? clave : null);
  unawaited(context.push(RM.solicitar));
}

/// «Buscar» con sesión y servidor (spec 021 y TEC-03 de la spec 036). El texto
/// escrito no se guarda en `maq` ni en el teléfono (R-05).
class BusquedaReal extends ConsumerStatefulWidget {
  const BusquedaReal({super.key, this.enfocar = false});

  final bool enfocar;

  @override
  ConsumerState<BusquedaReal> createState() => _BusquedaRealState();
}

class _BusquedaRealState extends ConsumerState<BusquedaReal> {
  final _texto = TextEditingController();

  /// El `coloniaId` de la persona; sin él no se busca (R-06).
  String? _coloniaId;
  Object? _fallaDeZona;

  @override
  void initState() {
    super.initState();
    unawaited(_resolverZona());
  }

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _resolverZona() async {
    setState(() => _fallaDeZona = null);
    try {
      final id = await coloniaIdDeLaPersona(ref, maq.user);
      if (mounted) setState(() => _coloniaId = id);
    } on Failure catch (falla) {
      if (mounted) setState(() => _fallaDeZona = falla);
    }
  }

  Future<void> _elegirZona() async {
    final zona = await elegirZonaDisponible(context);
    if (zona == null || !mounted) return;
    maq.user.col = zona.colonia;
    maq.user.cp = zona.cp;
    maq.refresh();
    setState(() => _coloniaId = null);
    await _resolverZona();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // La consulta vive mientras la pantalla está abierta.
    final consulta = ref.watch(consultaBusquedaProvider);
    final control = ref.read(consultaBusquedaProvider.notifier);
    final largo = _texto.text.trim().length;
    return Pg(
      title: l.busquedaTitulo,
      body: stack([
        Semantics(
          label: l.busquedaEtiqueta,
          child: TextField(
            controller: _texto,
            autofocus: widget.enfocar,
            maxLength: largoMaximoBusqueda,
            textInputAction: TextInputAction.search,
            onChanged: (v) {
              control.escribir(v);
              setState(() {});
            },
            onSubmitted: control.buscarYa,
            decoration: InputDecoration(
              hintText: l.busquedaPlaceholder,
              prefixIcon: const Icon(Icons.search),
              counterText: l.busquedaContador(_texto.text.length),
            ),
          ),
        ),
        chipsWrap([
          ChipK(
            consulta.soloVerificados
                ? l.busquedaSoloVerificadosActivo
                : l.busquedaSoloVerificados,
            on: consulta.soloVerificados,
            onTap: () =>
                control.soloVerificados(activo: !consulta.soloVerificados),
          ),
          for (final id in maq.oficios)
            ChipK(
              cats[id]!.short,
              on: consulta.oficio == id,
              onTap: () =>
                  control.filtrarOficio(consulta.oficio == id ? null : id),
            ),
        ]),
        if (largo < largoMinimoBusqueda)
          sMut(l.busquedaMinimo)
        else
          _resultadosOZona(l),
      ], gap: 12),
    );
  }

  Widget _resultadosOZona(AppLocalizations l) {
    final falla = _fallaDeZona;
    if (falla is OpcionNoDisponibleFailure) return _SinZona(_elegirZona);
    if (falla != null) {
      return _Error(_textoDeFalla(l, falla), _resolverZona);
    }
    final coloniaId = _coloniaId;
    if (coloniaId == null) return sMut(l.busquedaCargando);
    return stack([
      _Sugerencias((s) {
        _texto.text = s.texto;
        final control = ref.read(consultaBusquedaProvider.notifier)
          ..buscarYa(s.texto);
        if (s.id == null && s.clave != null) control.filtrarOficio(s.clave);
        setState(() {});
      }),
      _Resultados(coloniaId: coloniaId, alElegirZona: _elegirZona),
    ], gap: 12);
  }
}

class _SinZona extends StatelessWidget {
  const _SinZona(this.alElegir);

  final VoidCallback alElegir;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return stack([
      NoteK('blue', 'pin', l.busquedaSinZona),
      BtnK(l.busquedaElegirZona, alElegir),
    ], gap: 12);
  }
}

class _Error extends StatelessWidget {
  const _Error(this.texto, this.reintentar);

  final String texto;
  final VoidCallback reintentar;

  @override
  Widget build(BuildContext context) => stack([
    NoteK('red', 'help', texto),
    BtnK(
      AppLocalizations.of(context).busquedaReintentar,
      reintentar,
      kind: Bk.sec,
    ),
  ], gap: 12);
}

class _Sugerencias extends ConsumerWidget {
  const _Sugerencias(this.alElegir);

  final void Function(SugerenciaBusqueda) alElegir;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(sugerenciasBusquedaProvider).value ?? const [];
    if (lista.isEmpty) return const SizedBox.shrink();
    return stack([
      labT(AppLocalizations.of(context).busquedaSugerencias),
      chipsWrap([
        for (final s in lista)
          ChipK(s.texto, on: false, onTap: () => alElegir(s)),
      ]),
    ], gap: 8);
  }
}

class _Resultados extends ConsumerWidget {
  const _Resultados({required this.coloniaId, required this.alElegirZona});

  final String coloniaId;
  final VoidCallback alElegirZona;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final control = ref.read(busquedaControllerProvider(coloniaId).notifier);
    return ref
        .watch(busquedaControllerProvider(coloniaId))
        .when(
          loading: () => sMut(l.busquedaCargando),
          // `colonia_not_found`: hay que elegir la zona otra vez (CA-17).
          error: (error, _) => error is OpcionNoDisponibleFailure
              ? _SinZona(alElegirZona)
              : _Error(_textoDeFalla(l, error), control.reintentar),
          data: (pagina) => pagina == null
              ? sMut(l.busquedaCargando)
              : _pagina(context, ref, l, pagina),
        );
  }

  Widget _pagina(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    PaginaBusqueda pagina,
  ) {
    final entendido = pagina.interpretacion;
    final detectado = entendido.oficioDetectado;
    final filtrar = ref.read(consultaBusquedaProvider.notifier).filtrarOficio;
    return stack([
      ...switch (entendido.estado) {
        EstadoInterpretacion.detectado || EstadoInterpretacion.elegido => [
          if (detectado != null) bT(l.busquedaBuscamos(detectado.nombre)),
        ],
        EstadoInterpretacion.ambiguo => [
          bT(l.busquedaAmbiguo),
          chipsWrap([
            for (final o in entendido.oficiosSugeridos.take(3))
              ChipK(o.nombre, on: false, onTap: () => filtrar(o.clave)),
          ]),
        ],
        EstadoInterpretacion.noEntendido => [
          bT(l.busquedaNoEntendimos),
          sMut(l.busquedaElegirCategoria),
          chipsWrap([
            for (final id in maq.oficios)
              ChipK(cats[id]!.plain, on: false, onTap: () => filtrar(id)),
          ]),
        ],
      },
      if (pagina.items.isEmpty &&
          entendido.estado != EstadoInterpretacion.noEntendido) ...[
        if (detectado == null)
          sMut(l.busquedaSinResultados)
        else ...[
          sMut(l.busquedaSinResultadosOficio(detectado.nombre)),
          BtnK(
            l.busquedaPedirCotizacion,
            () => _pedir(context, detectado.clave),
          ),
        ],
      ],
      if (pagina.items.isNotEmpty)
        Semantics(
          liveRegion: true,
          child: sMut(l.busquedaTotal(pagina.items.length)),
        ),
      for (final e in pagina.items)
        _Experto(
          e,
          () =>
              _pedir(context, detectado?.clave ?? e.oficios.firstOrNull?.clave),
        ),
      if (pagina.siguiente != null)
        BtnK(l.busquedaCargarMas, () async {
          final falla = await ref
              .read(busquedaControllerProvider(coloniaId).notifier)
              .verMas();
          if (falla != null && context.mounted) {
            maq.toast(_textoDeFalla(l, falla));
          }
        }, kind: Bk.ghost)
      else if (pagina.items.length >= 100)
        sMut(l.busquedaTope),
    ], gap: 12);
  }
}

class _Experto extends StatelessWidget {
  const _Experto(this.experto, this.alTocar);

  final ExpertoBuscado experto;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final km = experto.distanciaKm;
    return MergeSemantics(
      child: CardK(
        onTap: alTocar,
        child: stack([
          bT(experto.nombre),
          sMut(experto.oficios.map((o) => o.nombre).join(' · ')),
          sMut(
            [
              l.busquedaCalificacion(
                experto.calificacion.toStringAsFixed(1),
                experto.totalResenas,
              ),
              if (km != null) l.busquedaDistancia(km),
              ?experto.coloniaBase,
            ].join(' · '),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (experto.verificado)
                Pill(
                  l.busquedaVerificado(experto.nivelVerificacion),
                  kind: 'green',
                  icon: 'shield',
                ),
              if (!experto.atiendeTuColonia)
                Pill(l.busquedaNoAtiende, kind: 'amber'),
            ],
          ),
        ], gap: 4),
      ),
    );
  }
}
