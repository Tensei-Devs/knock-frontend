import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pasa por las pantallas de entrada de HU-001 con datos ficticios.
///
/// Sin sesión la app real arranca en la previa (spec 027) y desde ahí se entra; los E2E de las
/// pestañas (TT-MOB-01) y de Configuración (HU-052) entran primero.
Future<void> entrarConCelularFicticio(WidgetTester tester) async {
  // Desde la spec 027, sin sesión la app abre en la previa (explorar sin cuenta):
  // se toca «Entrar» para llegar a la pantalla del celular.
  if (find.byType(TextField).evaluate().isEmpty) {
    await tester.tap(find.text('Entrar').first);
    await tester.pumpAndSettle();
  }
  await tester.enterText(find.byType(TextField), '5512345678');
  await tester.tap(find.byType(Checkbox));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continuar'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), '123456');
  await tester.tap(find.text('Entrar'));
  await tester.pumpAndSettle();
}
