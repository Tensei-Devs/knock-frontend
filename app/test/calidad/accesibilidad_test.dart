// Spec 008 · CA-02 y R-06: la prueba de accesibilidad falla ante un control
// sin etiqueta semántica o con un área táctil menor a 48 dp.
//
// Convención de nombres (spec 008 R-03): `CA_NNN_KK descripción` con el id del
// criterio al inicio, para que `python scripts/sdd_lint.py --trace NNN` lo
// encuentre.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../soporte/accesibilidad.dart';

Widget _pantalla(Widget hijo) => MaterialApp(
  home: Scaffold(body: Center(child: hijo)),
);

void main() {
  testWidgets('CA_008_02 un botón sin etiqueta semántica falla', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(
      _pantalla(
        GestureDetector(
          onTap: () {},
          child: const SizedBox(width: 56, height: 56, child: Icon(Icons.add)),
        ),
      ),
    );

    await expectLater(expectAccesible(tester), throwsA(isA<TestFailure>()));
    semantica.dispose();
  });

  testWidgets('CA_008_02 un botón menor a 48 dp falla', (tester) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(
      _pantalla(
        Semantics(
          button: true,
          label: 'Agregar',
          child: GestureDetector(
            onTap: () {},
            child: const SizedBox(width: 24, height: 24),
          ),
        ),
      ),
    );

    await expectLater(expectAccesible(tester), throwsA(isA<TestFailure>()));
    semantica.dispose();
  });

  testWidgets('CA_008_02 un botón con etiqueta y 48 dp pasa', (tester) async {
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(
      _pantalla(
        IconButton(
          tooltip: 'Agregar',
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
      ),
    );

    await expectAccesible(tester);
    semantica.dispose();
  });
}
