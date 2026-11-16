// Spec 045, CA-03: el rótulo «Datos de ejemplo» es una franja superior con su
// propio espacio. En ninguna ruta, tamaño de pantalla ni altura de barra de
// estado puede cubrir un texto o un elemento tocable de la pantalla.
import 'package:app/core/config/modo_maqueta.dart';
import 'package:app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';
import '../../soporte/rutas_maqueta.dart';

/// Tamaño de pantalla, alto de la barra de estado (con y sin muesca) y si se
/// registran sin fallar los desbordamientos de la propia maqueta.
///
/// A 320 y 360 dp algunas pantallas de la maqueta desbordan (inicio, explorar,
/// código de la visita, cotización y verificación del técnico, y los campos con
/// etiqueta): no es del rótulo, que no cambia el ancho, y está abierto en la
/// spec 045 (§12.8). Esta prueba solo exige que la franja no tape nada.
const _escenarios = <(String, Size, double, bool)>[
  ('320×640 con barra de 24', Size(320, 640), 24, true),
  ('360×740 con barra de 32', Size(360, 740), 32, true),
  ('412×892 con muesca de 48', Size(412, 892), 48, false),
  ('412×892 sin barra', Size(412, 892), 0, false),
  ('800×1280 (tableta) con barra de 24', Size(800, 1280), 24, false),
];

Rect _rect(Element e) {
  final rb = e.renderObject! as RenderBox;
  return rb.localToGlobal(Offset.zero) & rb.size;
}

void main() {
  prepararPruebasDeMaqueta();

  final rotulo = leerArb('es')['previaDatosDeEjemplo']!;

  for (final (nombre, tamano, barra, tolerar) in _escenarios) {
    testWidgets('CA_045_03 $nombre: el rótulo no tapa nada en las 45 rutas', (
      tester,
    ) async {
      fijarPantalla(tester, tamano: tamano);
      tester.view.padding = FakeViewPadding(top: barra);
      tester.view.viewPadding = FakeViewPadding(top: barra);
      var desbordes = 0;
      final previo = FlutterError.onError;
      FlutterError.onError = (detalles) {
        if (tolerar && detalles.exceptionAsString().contains('overflowed')) {
          desbordes++;
          return;
        }
        previo?.call(detalles);
      };
      addTearDown(() => FlutterError.onError = previo);
      final container = await montarApp(
        tester,
        esTecnico: true,
        extra: [modoMaquetaProvider.overrideWithValue(true)],
      );
      final router = container.read(appRouterProvider);
      final fallos = <String>[];
      for (final (ruta, _) in pantallasMaqueta) {
        router.go(ruta);
        await asentarMaqueta(tester);
        final texto = find.text(rotulo);
        expect(texto, findsOneWidget, reason: ruta);
        // La franja es la caja de color que envuelve al rótulo: de arriba de
        // la pantalla (barra de estado incluida) hasta el final del rótulo.
        final franja = _rect(
          find
              .ancestor(of: texto, matching: find.byType(ColoredBox))
              .evaluate()
              .first,
        );
        expect(franja.top, 0, reason: '$ruta: la franja empieza arriba');
        expect(franja.width, tamano.width, reason: '$ruta: a lo ancho');
        expect(
          franja.height,
          greaterThanOrEqualTo(barra),
          reason: '$ruta: cubre la barra de estado',
        );
        final cuerpo = franja.bottom;
        final tapa = <String>[];
        for (final e in find.byType(Text).evaluate()) {
          final t = e.widget as Text;
          if ((t.data ?? '') == rotulo || !e.renderObject!.attached) continue;
          if (_rect(e).top < cuerpo - 0.5 && _rect(e).bottom > 0) {
            tapa.add('texto «${t.data}»');
          }
        }
        for (final tipo in [
          InkResponse,
          GestureDetector,
          IconButton,
          TextButton,
          FilledButton,
        ]) {
          for (final e in find.byType(tipo).evaluate()) {
            final r = _rect(e);
            if (r.width < tamano.width &&
                r.top < cuerpo - 0.5 &&
                r.bottom > 0) {
              tapa.add('$tipo $r');
            }
          }
        }
        if (tapa.isNotEmpty) fallos.add('$ruta → ${tapa.take(3)}');
      }
      expect(fallos, isEmpty, reason: 'bajo la franja: $fallos');
      if (!tolerar) expect(desbordes, 0);
    });
  }
}
