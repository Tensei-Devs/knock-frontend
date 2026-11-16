// Spec 045 (KNOCK-273): la maqueta solo existe con `MODO_MAQUETA`. Los dos
// modos se verifican por separado: encendido muestra las pantallas de
// demostración con el rótulo de datos de ejemplo; apagado, nada de eso.
import 'package:app/core/config/modo_maqueta.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/mapa_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../soporte/fuente_nunito.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/rutas_maqueta.dart';

const _tamano = Size(412, 892);

/// Una ruta raíz del router con ese `path` (p. ej. `/m`).
bool _tieneRutaRaiz(GoRouter router, String ruta) =>
    router.configuration.routes.whereType<GoRoute>().any((r) => r.path == ruta);

Future<void> _asentar(WidgetTester tester) => tester.pumpAndSettle(
  const Duration(milliseconds: 100),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 3),
);

void main() {
  setUpAll(cargarNunito);

  setUp(() {
    usarMapaReal = false;
    maq.resetAll();
    maq.loadDemo();
    maq.pv.seedDemo();
  });
  tearDown(() {
    usarMapaReal = true;
    maq.resetAll();
  });

  final rotulo = leerArb('es')['previaDatosDeEjemplo']!;

  group('CA_045_01 modo maqueta encendido', () {
    for (final (ruta, texto) in pantallasMaqueta) {
      testWidgets('CA_045_01 $ruta abre con su contenido y el rótulo', (
        tester,
      ) async {
        fijarPantalla(tester, tamano: _tamano);
        final container = await montarApp(
          tester,
          esTecnico: true,
          extra: [modoMaquetaProvider.overrideWithValue(true)],
        );
        container.read(appRouterProvider).go(ruta);
        await _asentar(tester);
        expect(find.textContaining(texto), findsWidgets, reason: ruta);
        // CA_045_03: el rótulo fijo de datos de ejemplo no se oculta.
        expect(find.text(rotulo), findsOneWidget, reason: ruta);
      });
    }

    testWidgets('CA_045_01 la barra inferior lleva a Mi cuenta de la maqueta', (
      tester,
    ) async {
      fijarPantalla(tester, tamano: _tamano);
      await montarApp(
        tester,
        esTecnico: false,
        extra: [modoMaquetaProvider.overrideWithValue(true)],
      );
      await tester.tap(find.text(leerArb('es')['tabCuenta']!));
      await _asentar(tester);
      expect(find.text('Mi casa y mi auto'), findsOneWidget);
    });
  });

  group('CA_045_02 modo maqueta apagado (por defecto)', () {
    test('CA_045_02 la bandera viene apagada de compilación', () {
      expect(modoMaquetaDeCompilacion, isFalse);
    });

    testWidgets('CA_045_02 no hay rutas de la maqueta ni rótulo de ejemplo', (
      tester,
    ) async {
      fijarPantalla(tester, tamano: _tamano);
      final container = await montarApp(tester, esTecnico: false);
      final router = container.read(appRouterProvider);
      expect(_tieneRutaRaiz(router, '/m'), isFalse);
      expect(find.text(rotulo), findsNothing);
      router.go('/m/buscar');
      await tester.pumpAndSettle();
      expect(find.textContaining('Ej.: boiler'), findsNothing);
    });

    testWidgets(
      'CA_045_02 con datos de ejemplo cargados en memoria, ninguna pantalla '
      'normal los muestra ni lleva el rótulo',
      (tester) async {
        fijarPantalla(tester, tamano: _tamano);
        final container = await montarApp(tester, esTecnico: true);
        final router = container.read(appRouterProvider);
        const ejemplo = [
          'El boiler no enciende',
          'Ricardo Mendoza',
          '7 expertos cerca de ti',
        ];
        for (final ruta in [
          Rutas.inicio,
          Rutas.explorar,
          Rutas.actividad,
          Rutas.trabajo,
          Rutas.cuenta,
          Rutas.configuracion,
        ]) {
          router.go(ruta);
          await tester.pumpAndSettle();
          expect(find.text(rotulo), findsNothing, reason: ruta);
          for (final t in ejemplo) {
            expect(find.textContaining(t), findsNothing, reason: '$ruta $t');
          }
        }
      },
    );

    testWidgets(
      'CA_045_02 las rutas /m/... no abren ninguna pantalla de la maqueta',
      (tester) async {
        fijarPantalla(tester, tamano: _tamano);
        final container = await montarApp(tester, esTecnico: true);
        final router = container.read(appRouterProvider);
        for (final (ruta, texto) in pantallasMaqueta.where(
          (p) => p.$1.startsWith('/m/'),
        )) {
          router.go(ruta);
          await tester.pumpAndSettle();
          expect(find.textContaining(texto), findsNothing, reason: ruta);
          expect(find.text(rotulo), findsNothing, reason: ruta);
        }
      },
    );

    testWidgets('CA_045_02 sin sesión, /m/... lleva a la previa de siempre', (
      tester,
    ) async {
      fijarPantalla(tester, tamano: _tamano);
      final container = await montarApp(
        tester,
        esTecnico: false,
        sesionIniciada: false,
        abrirEnEntrada: false,
      );
      final router = container.read(appRouterProvider);
      router.go('/m/buscar');
      await tester.pumpAndSettle();
      expect(router.state.matchedLocation, Rutas.previa);
      expect(find.textContaining('Ej.: boiler'), findsNothing);
    });

    testWidgets('CA_045_02 Inicio y Mi cuenta son los de siempre', (
      tester,
    ) async {
      fijarPantalla(tester, tamano: _tamano);
      final container = await montarApp(tester, esTecnico: false);
      expect(find.text('7 expertos cerca de ti'), findsNothing);
      container.read(appRouterProvider).go(Rutas.cuenta);
      await tester.pumpAndSettle();
      expect(find.text('Mi casa y mi auto'), findsNothing);
    });
  });

  group('CA_045_05 sesión y rutas protegidas en modo maqueta', () {
    testWidgets(
      'CA_045_05 sin sesión, una ruta que pide cuenta lleva a la previa y las '
      'públicas se ven',
      (tester) async {
        fijarPantalla(tester, tamano: _tamano);
        final container = await montarApp(
          tester,
          esTecnico: false,
          sesionIniciada: false,
          abrirEnEntrada: false,
          extra: [modoMaquetaProvider.overrideWithValue(true)],
        );
        final router = container.read(appRouterProvider);
        router.go('/m/solicitar');
        await _asentar(tester);
        expect(
          router.state.matchedLocation,
          Rutas.previa,
          reason: 'pedir cotización exige cuenta',
        );
        router.go('/m/buscar');
        await _asentar(tester);
        expect(router.state.matchedLocation, '/m/buscar');
      },
    );
  });

  group('CA_045_05 rutas de la maqueta en las reglas de rutas', () {
    test(
      'CA_045_05 sin la bandera, /m/... no es pública ni destino válido',
      () {
        expect(esRutaPublica('/m/buscar'), isFalse);
        expect(destinoValidoODescartar('/m/buscar'), isNull);
        expect(destinoDeRegreso('/m/buscar'), Rutas.inicio);
        expect(
          redireccionPorSesion(sesionIniciada: false, ubicacion: '/m/buscar'),
          Rutas.previa,
        );
      },
    );

    test('CA_045_05 con la bandera, solo las públicas y los destinos /m/', () {
      expect(esRutaPublica('/m/buscar', maqueta: true), isTrue);
      expect(esRutaPublica('/m/solicitar', maqueta: true), isFalse);
      expect(
        destinoValidoODescartar('/m/chat/rm', maqueta: true),
        '/m/chat/rm',
      );
      // La validación de siempre sigue: nada de `//`, `..` ni otros sitios.
      expect(destinoValidoODescartar('//otro.com', maqueta: true), isNull);
      expect(destinoValidoODescartar('/m/../x', maqueta: true), isNull);
      expect(destinoValidoODescartar('https://x.com', maqueta: true), isNull);
    });
  });
}
