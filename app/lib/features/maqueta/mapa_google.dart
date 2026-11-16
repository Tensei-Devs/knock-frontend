import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/inicio/presentation/mapa/mi_ubicacion_controller.dart';
import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Mapa REAL de Google para Inicio (y el mapa de Buscar). Los expertos de la
/// maqueta son simulados: se colocan alrededor del centro con un
/// desplazamiento fijo en metros (ver [posicionDeExperto]), no aleatorio.

/// Centro por defecto (Col. Centro de Tula de Allende, CP 42800) cuando no
/// hay permiso de ubicación.
const centroPorDefecto = LatLng(20.0527, -99.3427);

/// Metros por unidad del mundo dibujado de la maqueta (1200 x 1600 unidades).
const _metrosPorUnidad = 7.0;

/// Punto «Tú estás aquí» del mundo dibujado (origen de los desplazamientos).
const _origenX = 583.0;
const _origenY = 700.0;

/// Convierte la posición (x, y) del mundo dibujado de la maqueta en lat/lng
/// con un desplazamiento en metros respecto de [centro]. Estable.
LatLng posicionDeMundo(LatLng centro, double x, double y) {
  final dx = (x - _origenX) * _metrosPorUnidad;
  final dy = (y - _origenY) * _metrosPorUnidad;
  final lat = centro.latitude - dy / 111320;
  final lng =
      centro.longitude +
      dx / (111320 * math.cos(centro.latitude * math.pi / 180));
  return LatLng(lat, lng);
}

LatLng posicionDeExperto(LatLng centro, Prov p) {
  final pos = mapPos[p.id] ?? (580.0, 700.0);
  return posicionDeMundo(centro, pos.$1, pos.$2);
}

/// Marcador extra del técnico (visita con hora o solicitud nueva).
class MarcadorAgenda {
  const MarcadorAgenda({
    required this.id,
    required this.x,
    required this.y,
    required this.texto,
    required this.icono,
    required this.alTocar,
    this.seleccionado = false,
  });
  final String id, texto;
  final double x, y;
  final IconData? icono;
  final VoidCallback alTocar;
  final bool seleccionado;
}

/// Control de la cámara que usan los botones de acercar, alejar y «mi
/// ubicación».
class ControlMapaGoogle extends ChangeNotifier implements CamaraMapa {
  GoogleMapController? _c;
  bool get listo => _c != null;

  void _asignar(GoogleMapController c) {
    _c = c;
    notifyListeners();
  }

  Future<void> acercar() async => _c?.animateCamera(CameraUpdate.zoomIn());
  Future<void> alejar() async => _c?.animateCamera(CameraUpdate.zoomOut());

  @override
  Future<void> moverA({
    required double latitud,
    required double longitud,
  }) async => _c?.animateCamera(
    CameraUpdate.newLatLngZoom(LatLng(latitud, longitud), 15),
  );

  Future<void> ir(LatLng p, {double zoom = 15}) async =>
      _c?.animateCamera(CameraUpdate.newLatLngZoom(p, zoom));

  Future<void> ajustar(List<LatLng> puntos) async {
    if (_c == null || puntos.isEmpty) return;
    if (puntos.length == 1) return ir(puntos.first);
    final lats = puntos.map((e) => e.latitude),
        lngs = puntos.map((e) => e.longitude);
    await _c!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(lats.reduce(math.min), lngs.reduce(math.min)),
          northeast: LatLng(lats.reduce(math.max), lngs.reduce(math.max)),
        ),
        80,
      ),
    );
  }
}

/// En pruebas de widgets la vista nativa de Google no existe: se pone en
/// `false` y se dibuja un marcador de posición.
bool usarMapaReal = true;

/// Oculta comercios, lugares de interés y transporte; deja calles, nombres
/// de calles y colonias, agua y parques (sin etiqueta).
const _ocultarPoi = '''
{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},
{"featureType":"poi.business","stylers":[{"visibility":"off"}]},
{"featureType":"poi.park","elementType":"labels","stylers":[{"visibility":"off"}]},
{"featureType":"transit","stylers":[{"visibility":"off"}]},
{"featureType":"road","elementType":"labels.icon","stylers":[{"visibility":"off"}]}''';

const _estiloClaro = '[$_ocultarPoi]';

const _estiloOscuro =
    '''[
{"elementType":"geometry","stylers":[{"color":"#1e1b18"}]},
{"elementType":"labels.text.fill","stylers":[{"color":"#b5a798"}]},
{"elementType":"labels.text.stroke","stylers":[{"color":"#14110f"}]},
{"featureType":"road","elementType":"geometry","stylers":[{"color":"#3a332d"}]},
{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#5a4a36"}]},
{"featureType":"water","elementType":"geometry","stylers":[{"color":"#0f2a36"}]},
{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#1d2a20"}]},
$_ocultarPoi
]''';

Color _colorOficio(String cat) => switch (cat) {
  'plo' => const Color(0xFF1D5B85),
  'ele' => const Color(0xFFA8741A),
  _ => const Color(0xFF1C3A4C),
};

IconData _iconoOficio(String cat) => switch (cat) {
  'plo' => Icons.water_drop_outlined,
  'ele' => Icons.bolt,
  _ => Icons.directions_car_outlined,
};

/// Dibuja un pin de la maqueta (píldora con icono y texto y una punta) como
/// imagen para usarla de marcador.
Future<BitmapDescriptor> dibujarPin({
  required String texto,
  required Color color,
  IconData? icono,
  Color? borde,
  Color textoColor = Colors.white,
  bool grande = false,
}) async {
  const r = 3.0;
  final esc = grande ? 1.15 : 1.0;
  final tp = TextPainter(
    text: TextSpan(
      text: texto,
      style: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w900,
        fontSize: 13 * esc * r,
        color: textoColor,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  TextPainter? ip;
  if (icono != null) {
    ip = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icono.codePoint),
        style: TextStyle(
          fontFamily: icono.fontFamily,
          package: icono.fontPackage,
          fontSize: 15 * esc * r,
          color: textoColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }
  final padX = 10 * esc * r, gap = 4 * r, h = 30 * esc * r, punta = 8 * r;
  final w =
      padX * 2 +
      (ip != null ? ip.width + (texto.isEmpty ? 0 : gap) : 0) +
      tp.width;
  final rec = ui.PictureRecorder();
  final c = Canvas(rec);
  final cuerpo = RRect.fromRectAndRadius(
    Rect.fromLTWH(3 * r, 3 * r, w, h),
    Radius.circular(h / 2),
  );
  final sombra = Paint()
    ..color = const Color(0x40000000)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
  c.drawRRect(cuerpo.shift(const Offset(0, 4)), sombra);
  final path = Path()
    ..addRRect(cuerpo)
    ..moveTo(3 * r + w / 2 - 6 * r, 3 * r + h - 1)
    ..lineTo(3 * r + w / 2, 3 * r + h + punta)
    ..lineTo(3 * r + w / 2 + 6 * r, 3 * r + h - 1)
    ..close();
  c.drawPath(path, Paint()..color = color);
  if (borde != null) {
    c.drawPath(
      path,
      Paint()
        ..color = borde
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * r,
    );
  }
  var x = 3 * r + padX;
  if (ip != null) {
    ip.paint(c, Offset(x, 3 * r + (h - ip.height) / 2));
    x += ip.width + (texto.isEmpty ? 0 : gap);
  }
  tp.paint(c, Offset(x, 3 * r + (h - tp.height) / 2));
  final img = await rec.endRecording().toImage(
    (w + 6 * r).ceil(),
    (h + punta + 6 * r + 4).ceil(),
  );
  final bytes = (await img.toByteData(format: ui.ImageByteFormat.png))!.buffer
      .asUint8List();
  return BytesMapBitmap(bytes, imagePixelRatio: r);
}

class MapaGoogleKnock extends ConsumerStatefulWidget {
  const MapaGoogleKnock({
    super.key,
    required this.expertos,
    required this.alTocarExperto,
    required this.control,
    this.seleccionado,
    this.agenda = const [],
    this.alTocarFondo,
    this.padInferior = 0,
    this.centroAlCrear,
    this.simulada,
    this.alUbicar,
    this.centroForzado,
  });
  final LatLng? centroForzado;
  final List<Prov> expertos;
  final ValueChanged<Prov> alTocarExperto;
  final ControlMapaGoogle control;
  final String? seleccionado;
  final List<MarcadorAgenda> agenda;
  final VoidCallback? alTocarFondo;

  /// Espacio que tapa el panel inferior (para no centrar bajo él).
  final double padInferior;

  /// Se llama con el centro usado (real o por defecto).
  final ValueChanged<LatLng>? centroAlCrear;

  /// Ubicación de prueba que sustituye a la real.
  final ({double lat, double lng})? simulada;

  /// Se llama con la ubicación (real o simulada) de la persona.
  final ValueChanged<LatLng>? alUbicar;

  @override
  ConsumerState<MapaGoogleKnock> createState() => _MapaGoogleState();
}

class _MapaGoogleState extends ConsumerState<MapaGoogleKnock> {
  LatLng _centro = centroPorDefecto;
  final _iconos = <String, BitmapDescriptor>{};
  final _pendientes = <String>{};
  bool _oscuro = false;
  double _pulso = 0;
  Timer? _tPulso;

  @override
  void initState() {
    super.initState();
    unawaited(_ubicar());
    // Pulso del pin seleccionado (círculo que se expande y se desvanece).
    _tPulso = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted || widget.seleccionado == null || sinMovimiento(context)) {
        return;
      }
      setState(() => _pulso = (_pulso + 0.05) % 1);
    });
  }

  @override
  void dispose() {
    _tPulso?.cancel();
    super.dispose();
  }

  Set<Circle> _circulos() {
    final id = widget.seleccionado;
    if (id == null || sinMovimiento(context)) return const {};
    final p = widget.expertos.where((e) => e.id == id).firstOrNull;
    if (p == null) return const {};
    final t = Curves.easeOut.transform(_pulso);
    return {
      Circle(
        circleId: const CircleId('pulso'),
        center: posicionDeExperto(_centro, p),
        radius: 40 + 220 * t,
        fillColor: const Color(0xFFE9682D).withValues(alpha: 0.30 * (1 - t)),
        strokeWidth: 0,
      ),
    };
  }

  /// Centra en la ubicación real si el permiso ya se concedió o se concede
  /// con el flujo existente; si no, queda el centro por defecto.
  Future<void> _ubicar() async {
    try {
      LatLng? p;
      final sim = widget.simulada;
      if (sim != null) {
        p = LatLng(sim.lat, sim.lng);
      } else {
        final r = await ref.read(ubicacionRepositoryProvider).obtenerUnaVez();
        if (r is Concedida) p = LatLng(r.latitud, r.longitud);
      }
      if (!mounted || p == null) return;
      setState(() => _centro = p!);
      widget.centroAlCrear?.call(p);
      unawaited(widget.control.ir(p, zoom: 13.5));
      widget.alUbicar?.call(p);
    } on Object {
      // Sin ubicación: se queda el centro por defecto.
    }
  }

  @override
  void didUpdateWidget(MapaGoogleKnock old) {
    super.didUpdateWidget(old);
    if (old.simulada != widget.simulada) unawaited(_ubicar());
    final f = widget.centroForzado;
    if (f != null && f != old.centroForzado) setState(() => _centro = f);
  }

  Future<void> _pedirIcono(
    String clave,
    Future<BitmapDescriptor> Function() hacer,
  ) async {
    if (_iconos.containsKey(clave) || !_pendientes.add(clave)) return;
    final d = await hacer();
    if (!mounted) return;
    setState(() => _iconos[clave] = d);
  }

  String _claveExperto(Prov p, bool sel) =>
      'e:${p.id}:${p.n > 0 ? p.rate.toStringAsFixed(1) : 'N'}:$sel';

  Set<Marker> _marcadores() {
    final out = <Marker>{};
    for (final p in widget.expertos) {
      final sel = widget.seleccionado == p.id;
      final clave = _claveExperto(p, sel);
      unawaited(
        _pedirIcono(
          clave,
          () => dibujarPin(
            texto: p.n > 0 ? p.rate.toStringAsFixed(1) : tr('Nuevo'),
            color: sel ? const Color(0xFFE9682D) : _colorOficio(p.cat),
            icono: _iconoOficio(p.cat),
            grande: sel,
          ),
        ),
      );
      final icono = _iconos[clave];
      if (icono == null) continue;
      out.add(
        Marker(
          markerId: MarkerId(p.id),
          position: posicionDeExperto(_centro, p),
          icon: icono,
          anchor: const Offset(.5, 1),
          zIndexInt: sel ? 3 : 1,
          onTap: () => widget.alTocarExperto(p),
        ),
      );
    }
    for (final a in widget.agenda) {
      final clave =
          'a:${a.id}:${a.texto}:${a.seleccionado}:${a.icono?.codePoint}';
      final esVisita = a.icono == null;
      unawaited(
        _pedirIcono(
          clave,
          () => dibujarPin(
            texto: a.texto,
            color: esVisita
                ? (a.seleccionado
                      ? const Color(0xFFE9682D)
                      : const Color(0xFFB4501F))
                : Colors.white,
            icono: a.icono,
            borde: const Color(0xFFE9682D),
            textoColor: esVisita ? Colors.white : const Color(0xFF1C3A4C),
          ),
        ),
      );
      final icono = _iconos[clave];
      if (icono == null) continue;
      out.add(
        Marker(
          markerId: MarkerId('agenda_${a.id}'),
          position: posicionDeMundo(_centro, a.x, a.y),
          icon: icono,
          anchor: const Offset(.5, 1),
          zIndexInt: 4,
          onTap: a.alTocar,
        ),
      );
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    if (!usarMapaReal) {
      return ColoredBox(
        color: kc(context).surface2,
        child: const SizedBox.expand(),
      );
    }
    if (oscuro != _oscuro) {
      _oscuro = oscuro;
      _iconos.clear();
      _pendientes.clear();
    }
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _centro, zoom: 13.5),
      style: oscuro ? _estiloOscuro : _estiloClaro,
      buildingsEnabled: false,
      trafficEnabled: false,
      indoorViewEnabled: false,
      markers: _marcadores(),
      circles: _circulos(),
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      padding: EdgeInsets.only(bottom: widget.padInferior),
      onTap: (_) => widget.alTocarFondo?.call(),
      onMapCreated: (c) {
        widget.control._asignar(c);
        widget.centroAlCrear?.call(_centro);
      },
    );
  }
}

/// Botones acercar, alejar y «mi ubicación» del mapa (aspecto de la maqueta).
class ControlesMapaGoogle extends ConsumerWidget {
  const ControlesMapaGoogle({super.key, required this.control});
  final ControlMapaGoogle control;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AvisoUbicacion?>(miUbicacionControllerProvider, (_, aviso) {
      if (aviso == null) return;
      final m = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
      m.showSnackBar(
        SnackBar(
          content: Text(tr(aviso.texto)),
          action: aviso.ofreceAjustes
              ? SnackBarAction(
                  label: tr('Abrir ajustes'),
                  onPressed: () => unawaited(
                    ref
                        .read(miUbicacionControllerProvider.notifier)
                        .abrirAjustes(),
                  ),
                )
              : null,
        ),
      );
    });
    Widget b(IconData i, String tip, VoidCallback f) => Material(
      color: kc(context).surface,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: f,
        child: Tooltip(
          message: tr(tip),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(i, color: kc(context).ink),
          ),
        ),
      ),
    );
    return ListenableBuilder(
      listenable: control,
      builder: (context, _) => Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          b(Icons.add, 'Acercar', () => unawaited(control.acercar())),
          b(Icons.remove, 'Alejar', () => unawaited(control.alejar())),
          b(Icons.my_location, 'Mi ubicación', () {
            if (control.listo) {
              unawaited(
                ref
                    .read(miUbicacionControllerProvider.notifier)
                    .centrar(control),
              );
            }
          }),
        ],
      ),
    );
  }
}

/// Vale para pruebas: indica si hay vista nativa de mapa.
bool get hayVistaNativa => !kIsWeb;
