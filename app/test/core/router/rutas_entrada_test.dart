import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';

void main() {
  group('TC-HU-001-05 redirección por sesión (unitarias)', () {
    test('TC-HU-001-05 sin sesión toda pestaña lleva a /entrar', () {
      for (final ruta in [
        Rutas.inicio,
        Rutas.explorar,
        Rutas.actividad,
        Rutas.trabajo,
        Rutas.cuenta,
        Rutas.configuracion,
        Rutas.oficios,
        '/entrarx',
      ]) {
        expect(
          redireccionPorSesion(sesionIniciada: false, ubicacion: ruta),
          Rutas.entrar,
          reason: ruta,
        );
      }
    });

    test('TC-HU-001-05 sin sesión /entrar y su subruta no redirigen', () {
      for (final ruta in [Rutas.entrar, Rutas.codigo]) {
        expect(
          redireccionPorSesion(sesionIniciada: false, ubicacion: ruta),
          isNull,
          reason: ruta,
        );
      }
    });

    test('TC-HU-001-05 con sesión /entrar y su subruta llevan a /inicio', () {
      for (final ruta in [Rutas.entrar, Rutas.codigo]) {
        expect(
          redireccionPorSesion(sesionIniciada: true, ubicacion: ruta),
          Rutas.inicio,
          reason: ruta,
        );
      }
      expect(
        redireccionPorSesion(sesionIniciada: true, ubicacion: Rutas.cuenta),
        isNull,
      );
    });

    test('TC-HU-001-05 la sesión empieza en falso y solo en memoria', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(sesionIniciadaProvider), isFalse);
      container.read(sesionIniciadaProvider.notifier).iniciar();
      expect(container.read(sesionIniciadaProvider), isTrue);

      // Un contenedor nuevo (la app abierta otra vez) no recuerda la sesión.
      final otro = ProviderContainer();
      addTearDown(otro.dispose);
      expect(otro.read(sesionIniciadaProvider), isFalse);
    });
  });

  group('TC-HU-001-05 router con y sin sesión', () {
    testWidgets('TC-HU-001-05 sin sesión la app arranca en /entrar sin barra', (
      tester,
    ) async {
      final container = await montarApp(
        tester,
        esTecnico: true,
        sesionIniciada: false,
      );

      expect(ubicacion(container), Rutas.entrar);
      expect(find.text('Entra con tu celular'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      for (final ruta in [
        Rutas.inicio,
        Rutas.cuenta,
        Rutas.configuracion,
        Rutas.trabajo,
      ]) {
        container.read(appRouterProvider).go(ruta);
        await tester.pumpAndSettle();
        expect(ubicacion(container), Rutas.entrar, reason: ruta);
      }
    });

    testWidgets('TC-HU-001-05 /entrar/codigo sin celular regresa a /entrar', (
      tester,
    ) async {
      final container = await montarApp(
        tester,
        esTecnico: false,
        sesionIniciada: false,
      );

      container.read(appRouterProvider).go(Rutas.codigo);
      await tester.pumpAndSettle();

      expect(ubicacion(container), Rutas.entrar);
    });

    testWidgets('TC-HU-001-05 con sesión /entrar lleva a /inicio', (
      tester,
    ) async {
      final container = await montarApp(tester, esTecnico: false);
      expect(ubicacion(container), Rutas.inicio);

      container.read(appRouterProvider).go(Rutas.entrar);
      await tester.pumpAndSettle();

      expect(ubicacion(container), Rutas.inicio);
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });
}
