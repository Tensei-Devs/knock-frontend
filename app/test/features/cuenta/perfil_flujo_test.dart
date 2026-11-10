import 'package:app/app.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/data/perfil_repository_simulado.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/inicio/presentation/colonia_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';
import '../inicio/presentation/mapa/fakes_ubicacion.dart';

Future<ProviderContainer> _montar(
  WidgetTester tester, {
  required PerfilRepositorySimulado perfil,
}) async {
  final container = ProviderContainer(
    overrides: [
      conSesion(),
      perfilRepositoryProvider.overrideWithValue(perfil),
      ubicacionRepositoryProvider.overrideWithValue(
        UbicacionFalsa(const Concedida(latitud: 20.27, longitud: -98.94)),
      ),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const KnockApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  test('TC-HU-002-01 un nombre de 2 a 60 letras es válido', () {
    expect(validarNombre('Ana'), isNull);
    expect(validarNombre('María José Pérez'), isNull);
    expect(validarNombre('A' * 60), isNull);
  });

  test('TC-HU-002-02 menos de 2, números o símbolos se rechazan', () {
    for (final malo in ['', 'A', 'Ana1', 'Ana!', '123', 'A' * 61, '   ']) {
      expect(
        validarNombre(malo),
        'Escribe tu nombre (solo letras)',
        reason: malo,
      );
    }
  });

  test('TC-HU-002-05 sin foto el avatar usa las iniciales', () {
    expect(const Perfil(nombre: 'Ana López Ruiz').iniciales, 'AL');
    expect(const Perfil(nombre: 'ana').iniciales, 'A');
    expect(Perfil.nuevo.completo, isFalse);
  });

  testWidgets('TC-HU-002-01 cuenta nueva: pide el nombre y da la bienvenida', (
    tester,
  ) async {
    final container = await _montar(
      tester,
      perfil: PerfilRepositorySimulado(inicial: Perfil.nuevo),
    );
    expect(ubicacion(container), Rutas.completarPerfil);

    await tester.enterText(find.byType(TextFormField), 'Ana López');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    // TC-HU-002-05: termina con «¡Listo, ya entraste!».
    expect(find.text('¡Listo, ya entraste!'), findsOneWidget);
    expect(find.text('AL'), findsOneWidget);

    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();
    expect(ubicacion(container), Rutas.inicio);
    expect(find.text('Ana López'), findsOneWidget);
  });

  testWidgets('TC-HU-002-02 un nombre inválido no avanza', (tester) async {
    final container = await _montar(
      tester,
      perfil: PerfilRepositorySimulado(inicial: Perfil.nuevo),
    );
    await tester.enterText(find.byType(TextFormField), 'A1');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe tu nombre (solo letras)'), findsOneWidget);
    expect(ubicacion(container), Rutas.completarPerfil);
  });

  testWidgets('TC-HU-002-06 con el perfil completo no se vuelve a pedir', (
    tester,
  ) async {
    final container = await _montar(tester, perfil: PerfilRepositorySimulado());
    expect(ubicacion(container), Rutas.inicio);
    expect(find.text('Persona Demo'), findsOneWidget);
  });

  testWidgets(
    'TC-HU-004-01 pide confirmación y TC-HU-004-03 cancelar conserva',
    (tester) async {
      final repo = PerfilRepositorySimulado();
      final container = await _montar(tester, perfil: repo);
      await tester.tap(enLaBarra('Mi cuenta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('¿Cerrar sesión?'), findsOneWidget);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.text('¿Cerrar sesión?'), findsNothing);
      expect(repo.cierres, 0);
      expect(container.read(perfilControllerProvider).value!.completo, isTrue);
    },
  );

  testWidgets(
    'TC-HU-004-02 confirmar cierra y CA-002-04 no quedan datos (CA_026_06)',
    (tester) async {
      final repo = PerfilRepositorySimulado();
      final container = await _montar(tester, perfil: repo);
      // La colonia consultada pertenece a la sesión que se cierra.
      await container.read(coloniaControllerProvider.notifier).consultar();
      expect(
        container.read(coloniaControllerProvider),
        isA<ColoniaEncontrada>(),
      );

      await tester.tap(enLaBarra('Mi cuenta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesión'));
      await tester.pumpAndSettle();

      expect(repo.cierres, 1);
      expect(container.read(coloniaControllerProvider), isA<ColoniaSinPedir>());
      expect(container.read(perfilControllerProvider).value, Perfil.nuevo);
      expect(find.text('Persona Demo'), findsNothing);
      // CA_026_06: cerrar sesión lleva al login (la siguiente persona entra de
      // nuevo y su perfil sale de su propia cuenta, TC-HU-004-04).
      expect(container.read(sesionIniciadaProvider), isFalse);
      expect(ubicacion(container), Rutas.previa);
    },
  );
}
