import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/features/inicio/inicio.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/maqueta/campo_buscar.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/oficios_reales.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart';
import 'package:app/features/maqueta/pantallas_tecnico.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/maqueta/cobertura.dart';
import 'package:app/features/maqueta/mapa_google.dart';
import 'package:app/features/previa/presentation/panel_expertos.dart'
    show TamanosPanel;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String _catIcon(String id) => id == 'mec'
    ? 'car'
    : id == 'plo'
    ? 'drop'
    : 'bolt';

/// Inicio con mapa y panel de expertos (`S.inicioMapa` de la maqueta). Sirve
/// con sesión y sin ella (sin sesión: «Entrar» en lugar de los avisos).
class InicioMaqueta extends ConsumerStatefulWidget {
  const InicioMaqueta({super.key, required this.conCuenta});
  final bool conCuenta;
  @override
  ConsumerState<InicioMaqueta> createState() => _InicioMaquetaState();
}

class _InicioMaquetaState extends ConsumerState<InicioMaqueta> {
  final _mapa = ControlMapaGoogle();
  String? _sel;
  LatLng _centroMapa = centroPorDefecto;
  final _ext = ValueNotifier<double>(TamanosPanel.mitad);
  final _panel = DraggableScrollableController();
  String? _cat;
  bool _full = false;
  bool _work = false;
  String? _selV;
  double _panelSize = TamanosPanel.mitad;
  static const double _maxPanel = .8;
  static const _cpos = {
    'ml': (500.0, 720.0),
    'ap': (420.0, 640.0),
    'jr': (640.0, 680.0),
    'lc': (690.0, 770.0),
    'rg': (560.0, 620.0),
    'cv': (520.0, 750.0),
    'yo': (600.0, 700.0),
  };

  List<MarcadorAgenda> _agenda() {
    if (!_work) return const [];
    final out = <MarcadorAgenda>[];
    for (final v in maq.pv.visits.where((x) => !x.done)) {
      final p = _cpos[v.cid] ?? (580.0, 700.0);
      out.add(
        MarcadorAgenda(
          id: v.id,
          x: p.$1,
          y: p.$2,
          texto: v.time,
          icono: null,
          seleccionado: _selV == v.id,
          alTocar: () {
            setState(() => _selV = v.id);
            _snap(TamanosPanel.mitad);
          },
        ),
      );
    }
    for (final r in maq.pv.myReqs.where((x) => x.k == 'nuevas')) {
      final p = _cpos[r.cid] ?? (580.0, 700.0);
      out.add(
        MarcadorAgenda(
          id: r.id,
          x: p.$1 + 18,
          y: p.$2 + 22,
          texto: tr('Nueva'),
          icono: icn(_catIcon(r.cat)),
          alTocar: () {
            maq.pv.ensureThread(r);
            unawaited(context.push(RT.chat(r.cid, r.id)));
          },
        ),
      );
    }
    return out;
  }

  bool _fuera = false;
  String? _ultimaEvaluada;

  /// Ubicación de la persona (real o simulada): si cae fuera de las zonas
  /// de Knock se muestra «¡Pronto estaremos cerca de ti!»; si cae dentro, la
  /// colonia se toma de la zona más cercana.
  LatLng? _pendienteUbic;
  LatLng? _zonaElegida;

  void _irAZona(ZonaKnock z) {
    final p = LatLng(z.lat, z.lng);
    setState(() => _zonaElegida = p);
    _centroMapa = p;
    unawaited(_mapa.ir(p, zoom: 13.5));
  }

  Future<void> _alUbicar(LatLng p) async {
    // Con otra pestaña a la vista se espera a que Inicio vuelva a mostrarse.
    if (!TickerMode.valuesOf(context).enabled) {
      _pendienteUbic = p;
      return;
    }
    final clave =
        '${p.latitude.toStringAsFixed(4)},${p.longitude.toStringAsFixed(4)}';
    if (_ultimaEvaluada == clave) return;
    _ultimaEvaluada = clave;
    _zonaElegida = null;
    // La cobertura la decide el servidor (`GET /colonias/en-punto`, spec 017,
    // R-05); las coordenadas solo salen en esta petición y se descartan (R-03).
    final ResultadoColonia r;
    try {
      r = await ref
          .read(coloniasRepositoryProvider)
          .enPunto(latitud: p.latitude, longitud: p.longitude);
    } on Failure {
      // Sin respuesta no se asume nada: se conserva la zona y se podrá reintentar.
      _ultimaEvaluada = null;
      return;
    }
    if (!mounted) return;
    final c = r.colonia;
    if (r.enCobertura && c != null) {
      maq.user.col = c.nombre;
      maq.user.cp = c.cp;
      setState(() => _fuera = false);
      maq.refresh();
      return;
    }
    setState(() => _fuera = true);
    final z = await mostrarFueraDeCobertura(context);
    if (z != null && mounted) {
      setState(() => _fuera = false);
      _irAZona(z);
    }
  }

  @override
  void initState() {
    super.initState();
    // Al volver a entrar con la eliminación programada se ofrece cancelarla.
    if (widget.conCuenta && maq.delAt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        unawaited(
          hoja<void>(
            context,
            (ctx, _) => stack([
              sheetH(ctx, 'Tu cuenta se está eliminando', big: true),
              rich(
                'Se eliminará el **${longDate(maq.delAt!)}**. Si entras ahora puedes cancelar la eliminación.',
                w: FontWeight.w400,
              ),
              BtnK('Cancelar la eliminación', () {
                maq.cancelDelete();
                Navigator.pop(ctx);
                maq.toast('Cancelaste la eliminación de tu cuenta');
              }),
              BtnK(
                'Seguir con la eliminación',
                () => Navigator.pop(ctx),
                kind: Bk.ghost,
              ),
            ]),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _mapa.dispose();
    _ext.dispose();
    _panel.dispose();
    super.dispose();
  }

  void _snap(double v) => _panel.animateTo(
    v,
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
  );

  void _colonia() {
    if (_fuera) {
      unawaited(
        mostrarFueraDeCobertura(context).then((z) {
          if (z != null && mounted) {
            setState(() => _fuera = false);
            _irAZona(z);
          }
        }),
      );
      return;
    }
    unawaited(
      hoja<void>(
        context,
        (ctx, _) => stack([
          sheetH(ctx, '¿En qué colonia estás?'),
          sMut(
            'Así te mostramos expertos cerca. Solo usamos la colonia, no tu dirección.',
          ),
          stack([
            for (final c in colores)
              ChoiceK(
                on: maq.user.col == c,
                title: c,
                sub: 'Tula de Allende, Hgo.',
                minH: 64,
                onTap: () {
                  maq.user.col = c;
                  Navigator.pop(ctx);
                  maq.refresh();
                  maq.toast('Mostrando expertos cerca de $c');
                },
              ),
          ], gap: 8),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esTecnico = ref.watch(esTecnicoProvider);
    if (_pendienteUbic != null && TickerMode.valuesOf(context).enabled) {
      final p = _pendienteUbic!;
      _pendienteUbic = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_alUbicar(p));
      });
    }
    return MaqBuilder((context) {
      final k = kc(context);
      final c = _cat != null ? cats[_cat]! : null;
      final list =
          provs.values
              .where((o) => !o.esReal && (c == null || o.cat == c.id))
              .toList()
            ..sort((a, b) => a.km.compareTo(b.km));
      if (_sel != null && list.any((o) => o.id == _sel)) {
        final s0 = list.firstWhere((o) => o.id == _sel);
        list
          ..remove(s0)
          ..insert(0, s0);
      }
      final pend = widget.conCuenta
          ? maq.jobs
                .where((j) => j.status == 'cotizando' && j.quotes.isNotEmpty)
                .firstOrNull
          : null;
      final bar = BarraMarcaK(
        title: 'Inicio',
        right: widget.conCuenta
            ? Stack(
                children: [
                  IconButton(
                    onPressed: () => context.push(RM.avisos),
                    icon: Icon(icn('bell'), color: k.ink),
                    tooltip: tr('Avisos'),
                  ),
                  if (maq.cUnread || maq.pv.notifUnread > 0)
                    Positioned(
                      top: 9,
                      right: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: k.amber,
                          shape: BoxShape.circle,
                          border: Border.all(color: k.surface, width: 2),
                        ),
                      ),
                    ),
                ],
              )
            : BtnK(
                'Entrar',
                () => context.go('/entrar'),
                kind: Bk.sec,
                sm: true,
                auto: true,
                icon: 'user',
              ),
      );
      final top = Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            CampoBuscarK(fondo: k.surface, elevacion: 4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                spacing: 8,
                children: [
                  if (esTecnico)
                    ChipK(
                      'Mi agenda',
                      icon: 'cal',
                      work: true,
                      on: _work,
                      onTap: () {
                        setState(() {
                          _work = !_work;
                          _selV = null;
                        });
                        if (_work) {
                          final pts = [
                            for (final a in _agenda())
                              posicionDeMundo(_centroMapa, a.x, a.y),
                          ];
                          unawaited(_mapa.ajustar(pts));
                        }
                      },
                    ),
                  ChipK(
                    'Todos',
                    on: _cat == null,
                    onTap: () => setState(() => _cat = null),
                  ),
                  if (maq.oficiosError && maq.oficios.isEmpty)
                    const AvisoOficios(),
                  for (final id in maq.oficios)
                    ChipK(
                      cats[id]!.plain,
                      icon: _catIcon(id),
                      on: _cat == id,
                      onTap: () => setState(() => _cat = id),
                    ),
                  ChipK(
                    'No sé cuál',
                    icon: 'sparkle',
                    onTap: () => context.push(RM.asistente),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      return Scaffold(
        backgroundColor: k.bg,
        body: SafeArea(
          child: Column(
            children: [
              bar,
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, caja) =>
                            ValueListenableBuilder<double>(
                              valueListenable: _ext,
                              builder: (context, e, _) => MapaGoogleKnock(
                                control: _mapa,
                                expertos: list,
                                seleccionado: _sel,
                                agenda: _agenda(),
                                padInferior:
                                    caja.maxHeight *
                                    e.clamp(
                                      TamanosPanel.asomado,
                                      TamanosPanel.mitad,
                                    ),
                                centroAlCrear: (c) => _centroMapa = c,
                                simulada: maq.ubicacionSimulada,
                                centroForzado: _zonaElegida,
                                alUbicar: _alUbicar,
                                alTocarFondo: () {
                                  if (_panelSize > TamanosPanel.asomado + .02) {
                                    _snap(TamanosPanel.asomado);
                                  }
                                },
                                alTocarExperto: (o) {
                                  setState(() => _sel = o.id);
                                  unawaited(context.push(RM.experto(o.id)));
                                },
                              ),
                            ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 0,
                      bottom: 0,
                      child: ValueListenableBuilder<double>(
                        valueListenable: _ext,
                        builder: (context, e, _) => LayoutBuilder(
                          builder: (context, caja) => Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    caja.maxHeight *
                                        e.clamp(0, TamanosPanel.mitad) +
                                    12,
                              ),
                              child: ControlesMapaGoogle(control: _mapa),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: NotificationListener<DraggableScrollableNotification>(
                        onNotification: (n) {
                          _ext.value = n.extent;
                          _panelSize = n.extent;
                          final f = n.extent > .65;
                          if (f != _full) setState(() => _full = f);
                          return false;
                        },
                        child: DraggableScrollableSheet(
                          controller: _panel,
                          initialChildSize: TamanosPanel.mitad,
                          minChildSize: TamanosPanel.asomado,
                          maxChildSize: _maxPanel,
                          snap: true,
                          snapSizes: const [
                            TamanosPanel.asomado,
                            TamanosPanel.mitad,
                            _maxPanel,
                          ],
                          builder: (context, scroll) => Material(
                            color: k.surface,
                            elevation: 12,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(26),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SingleChildScrollView(
                              controller: scroll,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 12,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        width: 48,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: k.line,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    spacing: 12,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            h3(
                                              '${list.length} ${c?.people ?? 'expertos'} cerca de ti',
                                            ),
                                            InkWell(
                                              onTap: _colonia,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  spacing: 4,
                                                  children: [
                                                    Icon(
                                                      icn('pin'),
                                                      size: 16,
                                                      color: k.navy,
                                                    ),
                                                    Flexible(
                                                      child: T(
                                                        _fuera
                                                            ? tr(
                                                                'Ver zonas disponibles ▾',
                                                              )
                                                            : '${maq.user.col} ▾',
                                                        size: 14,
                                                        w: FontWeight.w800,
                                                        color: k.navy,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _snap(
                                          _panelSize < .3
                                              ? TamanosPanel.mitad
                                              : TamanosPanel.asomado,
                                        ),
                                        icon: Icon(
                                          _panelSize < .3
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: k.mut,
                                        ),
                                        tooltip: tr(
                                          'Mostrar más o menos la lista',
                                        ),
                                      ),
                                      ChipK(
                                        _full ? 'Ver mapa' : 'Ver lista',
                                        icon: _full ? 'map' : 'list',
                                        onTap: () => _snap(
                                          _full
                                              ? TamanosPanel.mitad
                                              : _maxPanel,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (esTecnico && _work)
                                    AgendaEnMapaBloque(selV: _selV),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: () => context.go('/explorar'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: k.navySoft,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        spacing: 14,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: k.surface,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              icn('sparkle'),
                                              color: k.navy,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                T(
                                                  'Explorar servicios y trabajos',
                                                  w: FontWeight.w900,
                                                  color: k.navy,
                                                ),
                                                sMut(
                                                  'Ideas, precios y fotos de trabajos reales',
                                                  size: 13.5,
                                                  color: k.navy,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: k.navy,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (pend != null)
                                    InkWell(
                                      borderRadius: BorderRadius.circular(14),
                                      onTap: () =>
                                          context.push(RM.comparar(pend.id)),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: k.navyBg,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Row(
                                          spacing: 12,
                                          children: [
                                            const Icon(
                                              Icons.notifications_none,
                                              color: Colors.white,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  T(
                                                    '${pend.quotes.length} cotizaciones listas',
                                                    w: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                  T(
                                                    '«${pend.title}»',
                                                    size: 13,
                                                    w: FontWeight.w700,
                                                    color: const Color(
                                                      0xFFD5E3E8,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Pill('Ver', kind: 'amber'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (c != null)
                                    BtnK(
                                      'Pedir cotización a ${c.people} cerca',
                                      () {
                                        maq.startReq(cat: c.id);
                                        if (pedirCuenta(
                                          context,
                                          RM.solicitar,
                                        )) {
                                          unawaited(context.push(RM.solicitar));
                                        }
                                      },
                                      sm: true,
                                      icon: 'send',
                                    ),
                                  for (final o in list)
                                    InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () =>
                                          context.push(RM.experto(o.id)),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: k.surface,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(color: k.line2),
                                        ),
                                        child: Row(
                                          spacing: 12,
                                          children: [
                                            Av.prov(o, size: 46),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  T(o.name, w: FontWeight.w900),
                                                  sMut(
                                                    '${cats[o.cat]!.short} · ${whereTxt(o)}',
                                                    size: 13.5,
                                                  ),
                                                  Wrap(
                                                    spacing: 6,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      rateW(o, size: 13.5),
                                                      sMut(
                                                        '(${o.n})',
                                                        size: 13.5,
                                                      ),
                                                      sMut(
                                                        '· ${o.km} km',
                                                        size: 13.5,
                                                      ),
                                                      if (o.today)
                                                        T(
                                                          '· Hoy',
                                                          size: 13.5,
                                                          w: FontWeight.w700,
                                                          color: k.greenInk,
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: k.mut,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (widget.conCuenta && maq.remind)
                                    GroupK([
                                      LiK(
                                        'car',
                                        'Tu auto: ya toca cambio de aceite',
                                        sub: 'Pasaron 6 meses del último',
                                        onTap: () => context.push(RM.miCasa),
                                        iconBg: k.amberSoft,
                                        iconFg: k.amberInk,
                                      ),
                                    ]),
                                  InkWell(
                                    onTap: () => context.push(RM.ayuda()),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 4,
                                      ),
                                      child: Row(
                                        spacing: 14,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: k.greenSoft,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              icn('shield'),
                                              color: k.green,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const T(
                                                  'Mira cómo verificamos a los expertos',
                                                  w: FontWeight.w800,
                                                ),
                                                sMut(
                                                  'La insignia verde significa identidad verificada',
                                                  size: 13.5,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: k.mut,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(left: 0, right: 0, top: 0, child: top),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
