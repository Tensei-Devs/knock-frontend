// Spec 045, §12.8: la pantalla de inicio de la maqueta no desborda en
// teléfonos angostos ni con letra grande. 364 dp es un teléfono real donde se
// vio «OVERFLOWED BY 3.7 PIXELS» en la fila de la zona del panel.
import 'package:app/core/config/modo_maqueta.dart';
import 'package:app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

const _escenarios = <(String, Size, double)>[
  ('320×640', Size(320, 640), 1),
  ('360×740', Size(360, 740), 1),
  ('364×810', Size(364, 810), 1),
  ('412×892', Size(412, 892), 1),
  ('360×740 con letra grande 1.3', Size(360, 740), 1.3),
];

void main() {
  prepararPruebasDeMaqueta();

  for (final (nombre, tamano, escala) in _escenarios) {
    testWidgets('CA_045_13 inicio $nombre: el panel no desborda', (
      tester,
    ) async {
      fijarPantalla(tester, tamano: tamano, escalaDeTexto: escala);
      final container = await montarApp(
        tester,
        esTecnico: false,
        extra: [modoMaquetaProvider.overrideWithValue(true)],
      );
      container.read(appRouterProvider).go('/inicio');
      await asentarMaqueta(tester);
      expect(find.textContaining('expertos cerca de ti'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }
}
