import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:app/core/tema/colores_mapa.dart';
import 'package:app/features/previa/domain/vista_mapa.dart';
import 'package:flutter/material.dart';

/// Pinta el mundo de la maqueta (ciudad ficticia con dos barrios, parques,
/// río y avenidas) aplicando la [vista] actual. Se vuelve a pintar solo
/// cuando cambia la vista.
///
/// El mundo se dibuja una sola vez en una imagen vectorial (`Picture`) por
/// paleta; cada cuadro solo la traslada y la escala.
class LienzoMapa extends CustomPainter {
  LienzoMapa({required this.vista, required this.paleta})
    : super(repaint: vista);

  final ValueNotifier<VistaMapa?> vista;
  final PaletaMapa paleta;

  static final _cache = <PaletaMapa, ui.Picture>{};

  @override
  void paint(Canvas canvas, Size size) {
    final v = vista.value;
    if (v == null) return;
    canvas
      ..clipRect(Offset.zero & size)
      ..save()
      ..translate(v.x, v.y)
      ..scale(v.k)
      ..drawPicture(_cache.putIfAbsent(paleta, () => _dibujarMundo(paleta)))
      ..restore();
  }

  @override
  bool shouldRepaint(LienzoMapa anterior) => anterior.paleta != paleta;
}

/// Número pseudoaleatorio estable (`mrnd` de la maqueta): el mapa se ve igual
/// en cada arranque.
double _mrnd(num i) {
  final x = math.sin(i * 127.1 + 311.7) * 43758.5453;
  return x - x.floorToDouble();
}

ui.Picture _dibujarMundo(PaletaMapa p) {
  final grabador = ui.PictureRecorder();
  final c =
      Canvas(
        grabador,
        const Rect.fromLTWH(0, 0, VistaMapa.ancho, VistaMapa.alto),
      )..drawRect(
        const Rect.fromLTWH(0, 0, VistaMapa.ancho, VistaMapa.alto),
        Paint()..color = p.fondo,
      );

  // Dos barrios con cuadrícula distinta: bloques y calles.
  _barrio(
    c,
    p,
    poligono: const [
      Offset(-10, -10),
      Offset(780, -10),
      Offset(520, 1610),
      Offset(-10, 1610),
    ],
    centro: const Offset(380, 800),
    grados: -11,
    cw: 76,
    ch: 84,
    semilla: 1,
  );
  _barrio(
    c,
    p,
    poligono: const [
      Offset(780, -10),
      Offset(1210, -10),
      Offset(1210, 1610),
      Offset(520, 1610),
    ],
    centro: const Offset(900, 800),
    grados: 16,
    cw: 88,
    ch: 72,
    semilla: 2,
  );

  // Parques.
  final relleno = Paint()..color = p.parque;
  final borde = Paint()
    ..color = p.parqueBorde
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  for (final r in [
    RRect.fromLTRBR(150, 260, 340, 400, const Radius.circular(26)),
    RRect.fromLTRBR(760, 880, 930, 1010, const Radius.circular(24)),
    RRect.fromLTRBR(428, 880, 622, 1014, const Radius.circular(22)),
  ]) {
    c
      ..drawRRect(r, relleno)
      ..drawRRect(r, borde);
  }
  final sendero = Paint()
    ..color = p.parqueSendero
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;
  c
    ..drawLine(const Offset(165, 330), const Offset(325, 330), sendero)
    ..drawLine(const Offset(245, 275), const Offset(245, 385), sendero)
    ..drawLine(const Offset(780, 945), const Offset(910, 945), sendero)
    ..drawLine(const Offset(845, 895), const Offset(845, 995), sendero)
    ..drawLine(const Offset(445, 940), const Offset(605, 940), sendero);

  // Río con orillas.
  final rio = Path()
    ..moveTo(-60, 1230)
    ..cubicTo(240, 1140, 420, 1310, 650, 1220)
    ..cubicTo(880, 1130, 1010, 1090, 1270, 1170);
  c
    ..drawPath(rio, _trazo(p.rio, 44))
    ..drawPath(rio, _trazo(p.rioBorde, 28));

  // Avenidas (pasan por encima del río: son puentes).
  final avenidas = <_Avenida>[
    _Avenida(
      Path()
        ..moveTo(-60, 430)
        ..cubicTo(300, 360, 700, 560, 1260, 470),
      22,
      'Av. Melchor Ocampo',
      .18,
    ),
    _Avenida(
      Path()
        ..moveTo(300, -60)
        ..cubicTo(350, 400, 250, 900, 370, 1660),
      19,
      'Av. Revolución',
      .34,
    ),
    _Avenida(
      Path()
        ..moveTo(900, -60)
        ..cubicTo(830, 500, 960, 1000, 880, 1660),
      19,
      'Av. Juárez',
      .34,
    ),
    _Avenida(
      Path()
        ..moveTo(-60, 930)
        ..cubicTo(400, 850, 800, 990, 1260, 890),
      17,
      'Calle Hidalgo',
      .18,
    ),
    _Avenida(
      Path()
        ..moveTo(1260, 130)
        ..cubicTo(1010, 410, 700, 560, 520, 770),
      17,
      'Carretera a Tepeji',
      .18,
    ),
  ];
  for (final a in avenidas) {
    c.drawPath(a.trazo, _trazo(p.avenidaBorde, a.ancho + 5));
  }
  for (final a in avenidas) {
    c.drawPath(a.trazo, _trazo(p.avenida, a.ancho));
  }
  for (final a in avenidas) {
    _textoSobreTrazo(c, a, p);
  }

  // Nombres de colonias, parques y río.
  for (final e in const [
    ('CENTRO', Offset(760, 585)),
    ('LA MALINCHE', Offset(560, 820)),
    ('TOLTECA', Offset(190, 700)),
    ('CRUZ AZUL', Offset(1000, 760)),
  ]) {
    _texto(
      c,
      e.$1,
      e.$2,
      TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w900,
        letterSpacing: 5,
        color: p.textoColonia.withValues(alpha: .85),
      ),
      p.fondo,
    );
  }
  for (final e in const [
    ('Parque Tolteca', Offset(245, 338)),
    ('Plaza Independencia', Offset(845, 948)),
  ]) {
    _texto(
      c,
      e.$1,
      e.$2,
      TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: p.textoParque,
      ),
      p.parque,
    );
  }
  _texto(
    c,
    'Río Tula',
    const Offset(520, 1285),
    TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.italic,
      color: p.textoRio,
    ),
    p.rioBorde,
  );
  return grabador.endRecording();
}

Paint _trazo(Color color, double ancho) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = ancho
  ..strokeCap = StrokeCap.round;

void _barrio(
  Canvas c,
  PaletaMapa p, {
  required List<Offset> poligono,
  required Offset centro,
  required double grados,
  required double cw,
  required double ch,
  required int semilla,
}) {
  c
    ..save()
    ..clipPath(Path()..addPolygon(poligono, true))
    ..translate(centro.dx, centro.dy)
    ..rotate(grados * math.pi / 180)
    ..translate(-centro.dx, -centro.dy);
  final calles = Path();
  for (var gx = -300.0; gx < 1500; gx += cw) {
    for (var gy = -300.0; gy < 1900; gy += ch) {
      final r = _mrnd(gx * 7 + gy * 13 + semilla * 101);
      final color = r < .06
          ? p.bloques[0]
          : r < .45
          ? p.bloques[1]
          : r < .8
          ? p.bloques[2]
          : p.bloques[3];
      c.drawRRect(
        RRect.fromLTRBR(
          gx + 6,
          gy + 6,
          gx + cw - 6,
          gy + ch - 6,
          const Radius.circular(3),
        ),
        Paint()..color = color,
      );
    }
    calles
      ..moveTo(gx, -300)
      ..lineTo(gx, 1900);
  }
  for (var gy = -300.0; gy < 1900; gy += ch) {
    calles
      ..moveTo(-300, gy)
      ..lineTo(1500, gy);
  }
  c
    ..drawPath(
      calles,
      Paint()
        ..color = p.calleBorde
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12,
    )
    ..drawPath(
      calles,
      Paint()
        ..color = p.calle
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    )
    ..restore();
}

class _Avenida {
  const _Avenida(this.trazo, this.ancho, this.nombre, this.inicio);

  final Path trazo;
  final double ancho;
  final String nombre;

  /// Fracción del largo donde empieza el rótulo.
  final double inicio;
}

/// Escribe el nombre de la avenida siguiendo su trazo (como `textPath`).
void _textoSobreTrazo(Canvas c, _Avenida a, PaletaMapa p) {
  final metrica = a.trazo.computeMetrics().first;
  final estilo = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    letterSpacing: .5,
    color: p.textoAvenida,
  );
  var avance = metrica.length * a.inicio;
  // Una letra a la vez, girada según la tangente.
  for (final rune in a.nombre.runes) {
    final letra = String.fromCharCode(rune);
    final tp = TextPainter(
      text: TextSpan(text: letra, style: estilo),
      textDirection: TextDirection.ltr,
    )..layout();
    final t = metrica.getTangentForOffset(avance);
    if (t == null) break;
    c
      ..save()
      ..translate(t.position.dx, t.position.dy)
      ..rotate(-t.angle);
    tp.paint(c, Offset(0, -tp.height / 2));
    c.restore();
    avance += tp.width;
  }
}

/// Texto centrado en [centro] con un halo del color del fondo (como
/// `paint-order: stroke` de la maqueta).
void _texto(
  Canvas c,
  String texto,
  Offset centro,
  TextStyle estilo,
  Color halo,
) {
  final contorno = TextPainter(
    text: TextSpan(
      text: texto,
      style: estilo.copyWith(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = halo,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final relleno = TextPainter(
    text: TextSpan(text: texto, style: estilo),
    textDirection: TextDirection.ltr,
  )..layout();
  final origen = centro - Offset(relleno.width / 2, relleno.height * .8);
  contorno.paint(c, origen);
  relleno.paint(c, origen);
}
