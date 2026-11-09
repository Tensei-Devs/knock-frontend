import 'package:flutter_test/flutter_test.dart';

/// Comprueba las guías de accesibilidad de la spec 008 (R-06) sobre lo que
/// hay montado: etiqueta semántica en cada control y área táctil de al menos
/// 48 dp. Falla con el control culpable si alguna no se cumple.
///
/// Uso en una prueba de pantalla:
/// ```dart
/// final semantica = tester.ensureSemantics();
/// ... // montar la pantalla
/// await expectAccesible(tester);
/// semantica.dispose();
/// ```
Future<void> expectAccesible(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
}
