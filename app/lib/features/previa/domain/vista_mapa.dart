import 'dart:math' as math;

/// Vista (desplazamiento y zoom) del mapa dibujado de la previa (spec 027,
/// R-12 y R-18). Es la misma cuenta que la maqueta (`js/mapa.js`): el mundo
/// mide [ancho] por [alto] unidades, la vista lo traslada ([x], [y]) y lo
/// escala ([k]), y nunca deja ver fuera del mundo.
///
/// Es inmutable y pura: no depende de Flutter, así que se prueba sin pantalla.
/// Las unidades del mundo no son coordenadas geográficas.
final class VistaMapa {
  const VistaMapa({required this.k, required this.x, required this.y});

  /// Ancho del mundo dibujado.
  static const double ancho = 1200;

  /// Alto del mundo dibujado.
  static const double alto = 1600;

  /// Punto «Tú estás aquí» en unidades del mundo (ejemplo fijo, sin GPS).
  static const math.Point<double> yo = math.Point(583, 700);

  /// Zoom máximo.
  static const double kMax = 3.2;

  /// Factor de los botones acercar y alejar.
  static const double pasoDeZoom = 1.35;

  final double k;
  final double x;
  final double y;

  /// Zoom mínimo: el mundo siempre cubre toda la caja visible.
  static double kMin(double w, double h) => math.max(w / ancho, h / alto);

  /// La misma vista con el zoom y el desplazamiento dentro de los límites
  /// de una caja visible de [w] por [h].
  VistaMapa acotada(double w, double h) {
    final k2 = k.clamp(kMin(w, h), kMax).toDouble();
    return VistaMapa(
      k: k2,
      x: x.clamp(w - ancho * k2, 0).toDouble(),
      y: y.clamp(h - alto * k2, 0).toDouble(),
    );
  }

  /// Vista inicial: centrada en [yo], a un tercio de la altura (arriba del
  /// panel inferior), como la maqueta.
  static VistaMapa inicial(double w, double h) =>
      VistaMapa(k: 1, x: w / 2 - yo.x, y: h * .34 - yo.y).acotada(w, h);

  /// Acerca o aleja [factor] veces alrededor del punto de pantalla
  /// ([px], [py]).
  VistaMapa zoomEn(double factor, double px, double py, double w, double h) {
    final k2 = (k * factor).clamp(kMin(w, h), kMax).toDouble();
    final f = k2 / k;
    return VistaMapa(
      k: k2,
      x: px - (px - x) * f,
      y: py - (py - y) * f,
    ).acotada(w, h);
  }

  /// Arrastra la vista [dx], [dy] píxeles.
  VistaMapa desplazada(double dx, double dy, double w, double h) =>
      VistaMapa(k: k, x: x + dx, y: y + dy).acotada(w, h);

  /// Dónde cae en pantalla un punto del mundo.
  math.Point<double> pantallaDe(double mundoX, double mundoY) =>
      math.Point(x + mundoX * k, y + mundoY * k);

  @override
  bool operator ==(Object other) =>
      other is VistaMapa && other.k == k && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(k, x, y);

  @override
  String toString() => 'VistaMapa(k: $k, x: $x, y: $y)';
}
