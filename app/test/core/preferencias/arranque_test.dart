import 'package:app/app.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/core/preferencias/arranque.dart';
import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/tema/colores.dart';
import 'package:app/main.dart' as knock;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../soporte/montar_app.dart';

const _inglesYOscuro = <String, Object>{
  AlmacenPreferenciasShared.claveTema: 'oscuro',
  AlmacenPreferenciasShared.claveIdioma: 'en',
};

/// Comprueba que el cuadro actual ya está en inglés y en oscuro.
void _esperarInglesYOscuro(WidgetTester tester) {
  final pantalla = tester.element(find.byType(AppBar));
  expect(Localizations.localeOf(pantalla), const Locale('en'));
  expect(Theme.of(pantalla).brightness, Brightness.dark);
  expect(Theme.of(pantalla).scaffoldBackgroundColor, ColoresOscuro.bg);
  expect(enElTitulo('Home'), findsOneWidget);
  expect(etiquetasDeLaBarra(tester), [
    'Home',
    'Explore',
    'Activity',
    'My account',
  ]);
}

/// Igual que [_esperarInglesYOscuro], pero en la pantalla de entrada: desde
/// HU-001 la app real arranca sin sesión en la previa (spec 027) (sin barra ni AppBar).
void _esperarEntradaEnInglesYOscuro(WidgetTester tester) {
  final pantalla = tester.element(find.byType(Scaffold));
  expect(Localizations.localeOf(pantalla), const Locale('en'));
  expect(Theme.of(pantalla).brightness, Brightness.dark);
  expect(Theme.of(pantalla).scaffoldBackgroundColor, ColoresOscuro.bg);
  // Spec 027: sin sesión la app abre en la previa.
  expect(find.text('Sign in'), findsOneWidget);
}

void main() {
  setUp(() {
    // El teléfono en claro: si la app abriera con el valor por defecto se
    // vería claro y en español.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'TC-HU-052-05 se conservan idioma y tema al reiniciar desde el primer cuadro',
    (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      // Primera apertura: se elige English y Oscuro.
      final primera = ProviderContainer(
        overrides: [
          almacenPreferenciasProvider.overrideWithValue(
            await crearAlmacenDeArranque(),
          ),
        ],
      );
      primera.read(preferenciasProvider.notifier)
        ..cambiarIdioma(const Locale('en'))
        ..cambiarTema(ThemeMode.dark);
      await tester.pump();
      primera.dispose();

      // «Reinicio»: lo que quedó guardado, contenedor nuevo y KnockApp desde
      // cero. Solo `pumpWidget` (un cuadro), sin `pumpAndSettle`.
      final guardado = await SharedPreferences.getInstance();
      await guardado.reload();
      expect(guardado.get(AlmacenPreferenciasShared.claveIdioma), 'en');
      expect(guardado.get(AlmacenPreferenciasShared.claveTema), 'oscuro');
      SharedPreferences.setMockInitialValues({
        for (final clave in guardado.getKeys()) clave: guardado.get(clave)!,
      });

      final almacen = await crearAlmacenDeArranque();
      await tester.pumpWidget(
        ProviderScope(
          // HU-001: arranca con sesión para abrir en Inicio.
          overrides: [
            almacenPreferenciasProvider.overrideWithValue(almacen),
            conSesion(),
          ],
          child: const KnockApp(),
        ),
      );
      _esperarInglesYOscuro(tester);
    },
  );

  testWidgets(
    'TC-HU-052-05 main entrega lo guardado a la app antes del primer cuadro',
    (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      SharedPreferences.setMockInitialValues(_inglesYOscuro);

      await knock.main();
      await tester.pump();

      _esperarEntradaEnInglesYOscuro(tester);
    },
  );

  test(
    'TC-HU-052-05 sin preferencias guardadas arranca en español y Automático',
    () async {
      final almacen = await crearAlmacenDeArranque();
      expect(almacen, isA<AlmacenPreferenciasShared>());
      final container = ProviderContainer(
        overrides: [almacenPreferenciasProvider.overrideWithValue(almacen)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(preferenciasProvider),
        const Preferencias(modoTema: ThemeMode.system, idioma: Locale('es')),
      );
    },
  );

  test(
    'TC-HU-052-08 si falla leer al arrancar se usan los valores por defecto',
    () async {
      final registros = <String>[];
      final original = debugPrint;
      debugPrint = (mensaje, {wrapWidth}) => registros.add('$mensaje');
      addTearDown(() => debugPrint = original);

      final fallos = <String, Future<SharedPreferences> Function()>{
        'el futuro falla': () =>
            Future.error(PlatformException(code: 'sin-disco')),
        'lanza al llamar': () => throw StateError('sin plugin'),
      };
      for (final MapEntry(key: fallo, value: obtener) in fallos.entries) {
        final almacen = await crearAlmacenDeArranque(obtener: obtener);
        expect(almacen, isA<AlmacenPreferenciasEnMemoria>(), reason: fallo);

        final container = ProviderContainer(
          overrides: [almacenPreferenciasProvider.overrideWithValue(almacen)],
        );
        addTearDown(container.dispose);
        expect(container.read(preferenciasProvider), Preferencias.inicial);

        // Cambiar sigue funcionando con el respaldo en memoria.
        container
            .read(preferenciasProvider.notifier)
            .cambiarTema(ThemeMode.dark);
        await pumpEventQueue();
        expect(container.read(preferenciasProvider).modoTema, ThemeMode.dark);
      }
      expect(registros, isEmpty);
    },
  );
}
