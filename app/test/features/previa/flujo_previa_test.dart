// Spec 027: flujos de la previa con la app completa (router real) y el
// servicio de entrada simulado: previa -> entrar -> app, destino de regreso,
// cuenta nueva y cierre de sesión.
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/data/perfil_repository_simulado.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';

const _celular = '5512345678';
const _codigo = '123456';

Future<ProviderContainer> _montar(
  WidgetTester tester, {
  bool sesion = false,
  PerfilRepositorySimulado? perfil,
}) async {
  tester.view.physicalSize = const Size(400, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  return montarApp(
    tester,
    esTecnico: false,
    sesionIniciada: sesion,
    abrirEnEntrada: false,
    extra: [
      perfilRepositoryProvider.overrideWithValue(
        perfil ?? PerfilRepositorySimulado(),
      ),
    ],
  );
}

/// Escribe el celular, acepta el aviso, pide el código y lo verifica.
Future<void> _entrarConCelular(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField), _celular);
  await tester.tap(find.byType(Checkbox));
  await tester.pumpAndSettle();
  await tocarTexto(tester, 'Continuar');
  await tester.enterText(find.byType(TextField), _codigo);
  await tocarTexto(tester, 'Entrar');
}

void main() {
  testWidgets('CA_027_01 sin sesión la app arranca en la previa', (
    tester,
  ) async {
    final container = await _montar(tester);
    expect(ubicacion(container), Rutas.previa);
    expect(find.text('Busca un experto cerca de ti'), findsOneWidget);
    expect(find.text('Entra con tu celular'), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('CA_027_02 sin sesión una ruta protegida lleva a la previa', (
    tester,
  ) async {
    final container = await _montar(tester);
    for (final ruta in [Rutas.cuenta, Rutas.actividad, Rutas.inicio]) {
      container.read(appRouterProvider).go(ruta);
      await tester.pumpAndSettle();
      expect(ubicacion(container), Rutas.previa, reason: ruta);
    }
  });

  testWidgets('CA_027_03 sin sesión /entrar se muestra y la subruta regresa', (
    tester,
  ) async {
    final container = await _montar(tester);
    container.read(appRouterProvider).go(Rutas.entrar);
    await tester.pumpAndSettle();
    expect(ubicacion(container), Rutas.entrar);
    expect(find.text('Entra con tu celular'), findsOneWidget);

    container.read(appRouterProvider).go(Rutas.codigo);
    await tester.pumpAndSettle();
    expect(ubicacion(container), Rutas.entrar);
  });

  testWidgets('CA_027_04 con sesión la previa lleva a Inicio', (tester) async {
    final container = await _montar(tester, sesion: true);
    expect(ubicacion(container), Rutas.inicio);
    for (final ruta in [Rutas.previa, Rutas.previaOficios, Rutas.entrar]) {
      container.read(appRouterProvider).go(ruta);
      await tester.pumpAndSettle();
      expect(ubicacion(container), Rutas.inicio, reason: ruta);
    }
  });

  testWidgets('CA_027_05 cerrar sesión desde Mi cuenta termina en la previa', (
    tester,
  ) async {
    final container = await _montar(tester, sesion: true);
    await tester.tap(enLaBarra('Mi cuenta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesión'));
    await tester.pumpAndSettle();

    expect(container.read(sesionIniciadaProvider), isFalse);
    expect(ubicacion(container), Rutas.previa);
    expect(find.text('Busca un experto cerca de ti'), findsOneWidget);
  });

  testWidgets('CA_027_34 previa -> Entrar -> celular -> código -> Inicio', (
    tester,
  ) async {
    final container = await _montar(tester);
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();
    expect(ubicacion(container), Rutas.entrar);

    await _entrarConCelular(tester);

    expect(container.read(sesionIniciadaProvider), isTrue);
    expect(ubicacion(container), Rutas.inicio);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets(
    'CA_027_24 tras entrar se ve la app normal y la previa deja de ser accesible',
    (tester) async {
      final container = await _montar(tester);
      await tester.tap(find.text('Registrarme'));
      await tester.pumpAndSettle();
      await _entrarConCelular(tester);
      expect(find.byType(NavigationBar), findsOneWidget);

      container.read(appRouterProvider).go(Rutas.previa);
      await tester.pumpAndSettle();
      expect(ubicacion(container), Rutas.inicio);
      expect(find.byType(NavigationBar), findsOneWidget);
    },
  );

  testWidgets('CA_027_20 una acción protegida abre /entrar con el destino', (
    tester,
  ) async {
    final container = await _montar(tester);
    container.read(appRouterProvider).go(rutaDeEntrada(Rutas.explorar));
    await tester.pumpAndSettle();
    expect(ubicacion(container), Rutas.entrar);
    expect(container.read(appRouterProvider).state.uri.queryParameters, {
      Rutas.parametroVolver: Rutas.explorar,
    });
  });

  testWidgets('CA_027_21 al entrar con destino va a ese destino', (
    tester,
  ) async {
    final container = await _montar(tester);
    container.read(appRouterProvider).go(rutaDeEntrada(Rutas.explorar));
    await tester.pumpAndSettle();

    await _entrarConCelular(tester);

    expect(ubicacion(container), Rutas.explorar);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('CA_027_21 al entrar sin destino va a Inicio', (tester) async {
    final container = await _montar(tester);
    container.read(appRouterProvider).go(Rutas.entrar);
    await tester.pumpAndSettle();
    await _entrarConCelular(tester);
    expect(ubicacion(container), Rutas.inicio);
  });

  for (final hostil in [
    'https%3A%2F%2Fotro.sitio',
    '%2F%2Fotro',
    '%2Fcuenta%2F..%2F..%2Fx',
  ]) {
    testWidgets(
      'CA_027_22 un destino hostil ($hostil) se ignora y va a Inicio',
      (tester) async {
        final container = await _montar(tester);
        container.read(appRouterProvider).go('/entrar?volver=$hostil');
        await tester.pumpAndSettle();
        await _entrarConCelular(tester);
        expect(ubicacion(container), Rutas.inicio);
      },
    );
  }

  testWidgets(
    'CA_027_23 una cuenta nueva completa el perfil y luego llega al destino',
    (tester) async {
      final container = await _montar(
        tester,
        perfil: PerfilRepositorySimulado(inicial: Perfil.nuevo),
      );
      container.read(appRouterProvider).go(rutaDeEntrada(Rutas.explorar));
      await tester.pumpAndSettle();

      await _entrarConCelular(tester);
      expect(ubicacion(container), Rutas.completarPerfil);

      await tester.enterText(find.byType(TextFormField), 'Ana');
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Empezar'));
      await tester.pumpAndSettle();

      expect(ubicacion(container), Rutas.explorar);
      expect(find.byType(NavigationBar), findsOneWidget);
    },
  );
}
