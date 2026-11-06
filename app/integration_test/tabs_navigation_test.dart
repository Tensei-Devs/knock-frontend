import 'package:app/main.dart' as knock;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'soporte/entrada_ficticia.dart';
import 'soporte/entrar.dart';

/// Humo E2E de TT-MOB-01 en emulador Android:
/// `cd app && flutter test integration_test`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder enBarra(String etiqueta) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(etiqueta),
  );
  Finder enTitulo(String etiqueta) =>
      find.descendant(of: find.byType(AppBar), matching: find.text(etiqueta));

  testWidgets('TC-TT-MOB-01-01 abre la app y navega entre las 5 pestañas', (
    tester,
  ) async {
    await knock.arrancar(overrides: entradaFicticia);
    await tester.pumpAndSettle();
    // HU-001: la app abre en la entrada; se entra con datos ficticios.
    await entrarConCelularFicticio(tester);

    // Cuenta de cliente por defecto: 4 pestañas, sin Trabajo.
    expect(find.byType(NavigationDestination), findsNWidgets(4));
    expect(enBarra('Trabajo'), findsNothing);
    expect(enTitulo('Inicio'), findsOneWidget);

    // Interruptor de prueba (solo fuera de release) para ganar Trabajo.
    await tester.tap(enBarra('Mi cuenta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Modo técnico (prueba)'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationDestination), findsNWidgets(5));

    for (final etiqueta in [
      'Inicio',
      'Explorar',
      'Actividad',
      'Trabajo',
      'Mi cuenta',
    ]) {
      await tester.tap(enBarra(etiqueta));
      await tester.pumpAndSettle();
      expect(enTitulo(etiqueta), findsOneWidget, reason: etiqueta);
    }
  });
}
