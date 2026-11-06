import 'package:app/app.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';

Future<ProviderContainer> _montarApp(WidgetTester tester) async {
  // HU-001: arranca con sesión para abrir en las pestañas.
  final container = ProviderContainer(overrides: [conSesion()]);
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const KnockApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

int _indiceSeleccionado(WidgetTester tester) =>
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

Finder _tituloDeLaBarra(String texto) =>
    find.descendant(of: find.byType(AppBar), matching: find.text(texto));

String _ubicacion(ProviderContainer container) => container
    .read(appRouterProvider)
    .routerDelegate
    .currentConfiguration
    .uri
    .path;

void main() {
  testWidgets('TC-TT-PRU-02-10 la ruta de oficios cuelga de Explorar', (
    tester,
  ) async {
    final container = await _montarApp(tester);
    expect(Rutas.oficios, '/explorar/oficios');

    container.read(appRouterProvider).go(Rutas.oficios);
    await tester.pumpAndSettle();

    expect(_ubicacion(container), Rutas.oficios);
    expect(_tituloDeLaBarra('Oficios'), findsOneWidget);
    expect(find.text('Electricidad'), findsOneWidget);
    // Dentro de la barra inferior, con Explorar seleccionada.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(_indiceSeleccionado(tester), 1);

    // Se puede regresar a Explorar. Se toca el BackButton en lugar de
    // `pageBack()`, que lo busca por el tooltip en inglés («Back») y la app
    // está en español desde TT-MOB-02 («Atrás»).
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(_ubicacion(container), Rutas.explorar);
    expect(_tituloDeLaBarra('Explorar'), findsOneWidget);
    expect(_indiceSeleccionado(tester), 1);
  });

  testWidgets(
    'TC-TT-PRU-02-10 el acceso de Explorar abre la pantalla de oficios',
    (tester) async {
      final container = await _montarApp(tester);
      container.read(appRouterProvider).go(Rutas.explorar);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ListTile, 'Oficios'));
      await tester.pumpAndSettle();

      expect(_ubicacion(container), Rutas.oficios);
      expect(_tituloDeLaBarra('Oficios'), findsOneWidget);
      expect(find.text('Plomería'), findsOneWidget);
    },
  );
}
