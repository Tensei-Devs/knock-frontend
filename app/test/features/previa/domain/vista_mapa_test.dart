// Spec 027, R-18: la vista del mapa dibujado (pan y zoom) es pura y acotada.
import 'package:app/features/previa/domain/vista_mapa.dart';
import 'package:flutter_test/flutter_test.dart';

const _w = 390.0;
const _h = 700.0;

void main() {
  test('CA_027_27 la vista inicial centra el punto «Tú estás aquí»', () {
    final v = VistaMapa.inicial(_w, _h);
    final yo = v.pantallaDe(VistaMapa.yo.x, VistaMapa.yo.y);
    expect(v.k, 1);
    expect(yo.x, closeTo(_w / 2, 0.001));
    expect(yo.y, closeTo(_h * .34, 0.001));
  });

  test('CA_027_27 acercar y alejar cambian el zoom y respetan los límites', () {
    var v = VistaMapa.inicial(_w, _h);
    final antes = v.k;
    v = v.zoomEn(VistaMapa.pasoDeZoom, _w / 2, _h * .34, _w, _h);
    expect(v.k, greaterThan(antes));

    for (var i = 0; i < 20; i++) {
      v = v.zoomEn(VistaMapa.pasoDeZoom, _w / 2, _h * .34, _w, _h);
    }
    expect(v.k, VistaMapa.kMax, reason: 'no pasa del zoom máximo');

    for (var i = 0; i < 40; i++) {
      v = v.zoomEn(1 / VistaMapa.pasoDeZoom, _w / 2, _h * .34, _w, _h);
    }
    expect(
      v.k,
      closeTo(VistaMapa.kMin(_w, _h), 1e-9),
      reason: 'el mundo siempre cubre la caja',
    );
  });

  test('CA_027_27 el zoom mantiene quieto el punto bajo los dedos', () {
    final v = VistaMapa.inicial(_w, _h);
    final mundo = ((150 - v.x) / v.k, (300 - v.y) / v.k);
    final z = v.zoomEn(1.5, 150, 300, _w, _h);
    final despues = z.pantallaDe(mundo.$1, mundo.$2);
    expect(despues.x, closeTo(150, 0.001));
    expect(despues.y, closeTo(300, 0.001));
  });

  test('CA_027_27 arrastrar mueve la vista pero nunca sale del mundo', () {
    final v = VistaMapa.inicial(_w, _h);
    final movida = v.desplazada(-30, -40, _w, _h);
    expect(movida.x, v.x - 30);
    expect(movida.y, v.y - 40);

    final lejos = v.desplazada(100000, 100000, _w, _h);
    expect(lejos.x, 0);
    expect(lejos.y, 0);
    final otroLado = v.desplazada(-100000, -100000, _w, _h);
    expect(otroLado.x, _w - VistaMapa.ancho * v.k);
    expect(otroLado.y, _h - VistaMapa.alto * v.k);
  });

  test('CA_027_27 «volver a mi ubicación» regresa a la vista inicial', () {
    final inicial = VistaMapa.inicial(_w, _h);
    final lejos = inicial
        .zoomEn(2.5, 10, 10, _w, _h)
        .desplazada(-200, -200, _w, _h);
    expect(lejos, isNot(inicial));
    expect(VistaMapa.inicial(_w, _h), inicial);
  });

  test('CA_027_27 una caja cambiada vuelve a acotar la vista', () {
    final v = VistaMapa.inicial(_w, _h).desplazada(-100000, 0, _w, _h);
    final acotada = v.acotada(800, 700);
    expect(acotada.k, greaterThanOrEqualTo(VistaMapa.kMin(800, 700)));
    expect(acotada.x, greaterThanOrEqualTo(800 - VistaMapa.ancho * acotada.k));
  });
}
