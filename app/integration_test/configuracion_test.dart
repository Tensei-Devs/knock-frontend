import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/main.dart' as knock;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'soporte/entrada_ficticia.dart';
import 'soporte/entrar.dart';

/// E2E mínimo de HU-052 en emulador Android, con el plugin real:
/// `cd app && flutter test integration_test/configuracion_test.dart`.
/// El cierre y la apertura reales de la app se comprueban a mano (spec §8).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TC-HU-052-05 guarda idioma y tema en el dispositivo', (
    tester,
  ) async {
    final guardado = await SharedPreferences.getInstance();
    await guardado.clear();
    addTearDown(guardado.clear);

    await knock.arrancar(overrides: entradaFicticia);
    await tester.pumpAndSettle();
    // HU-001: la app abre en la entrada; se entra con datos ficticios.
    await entrarConCelularFicticio(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Mi cuenta'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Configuración'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(AppBar))).brightness,
      Brightness.dark,
    );

    // Lo que quedó en el almacenamiento del teléfono.
    await guardado.reload();
    expect(guardado.getKeys(), {
      AlmacenPreferenciasShared.claveTema,
      AlmacenPreferenciasShared.claveIdioma,
    });
    expect(guardado.get(AlmacenPreferenciasShared.claveIdioma), 'en');
    expect(guardado.get(AlmacenPreferenciasShared.claveTema), 'oscuro');
  });
}
