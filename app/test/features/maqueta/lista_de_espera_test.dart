// Spec 017, R-08 y R-15, y spec 045 (enmienda 1): la hoja de fuera de
// cobertura ofrece la lista de espera solo cuando hay código postal escrito, y
// el botón no permite un segundo envío mientras hay uno en curso.
import 'package:app/features/maqueta/cobertura.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/preparar_maqueta.dart';

Future<void> _montar(
  WidgetTester tester, {
  VoidCallback? alAvisar,
  bool avisando = false,
  bool avisado = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PantallaFueraDeCobertura(
              enHoja: false,
              alCerrar: () {},
              alExplorar: () {},
              alAvisar: alAvisar,
              avisando: avisando,
              avisado: avisado,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_045_10 sin código postal escrito no se ofrece la lista', (
    tester,
  ) async {
    await _montar(tester);
    expect(find.text('Avisarme cuando lleguen'), findsNothing);
    expect(find.text('Explorar de todos modos'), findsOneWidget);
  });

  testWidgets('CA_045_10 con código postal se ofrece y registra al tocar', (
    tester,
  ) async {
    var toques = 0;
    await _montar(tester, alAvisar: () => toques++);
    await tester.ensureVisible(find.text('Avisarme cuando lleguen'));
    await tester.tap(find.text('Avisarme cuando lleguen'));
    expect(toques, 1);
  });

  testWidgets(
    'CA_045_10 mientras guarda, el botón no se puede tocar otra vez',
    (tester) async {
      var toques = 0;
      await _montar(tester, alAvisar: () => toques++, avisando: true);
      await tester.ensureVisible(find.text('Guardando…'));
      await tester.tap(find.text('Guardando…'), warnIfMissed: false);
      expect(toques, 0);
    },
  );

  testWidgets('CA_045_10 ya registrada, dice que está en la lista', (
    tester,
  ) async {
    await _montar(tester, avisado: true);
    expect(find.text('Ya estás en la lista de espera'), findsOneWidget);
  });
}
