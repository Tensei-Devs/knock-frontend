// Spec 031 y spec 045 (enmienda 1): «Mi casa y mi auto» en la maqueta con los
// datos reales: carga, vacío, error con Reintentar, lista, y el formulario que
// conserva lo escrito cuando el servidor rechaza.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/maqueta/casa_y_auto_real.dart';
import 'package:app/features/mi/data/casa_y_auto_repository_simulado.dart';
import 'package:app/features/mi/mi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/preparar_maqueta.dart';

class _Repo extends CasaYAutoRepositorySimulado {
  _Repo({this.fallaLista = false, this.falloAlta});

  bool fallaLista;
  final Failure? falloAlta;
  int listados = 0;

  @override
  Future<List<ElementoCasa>> listar() async {
    listados++;
    if (fallaLista) throw const ServicioNoDisponibleFailure();
    return super.listar();
  }

  @override
  Future<ElementoCasa> agregar({
    required TipoElemento tipo,
    required String nombre,
    int? anio,
  }) async {
    if (falloAlta != null) throw falloAlta!;
    return super.agregar(tipo: tipo, nombre: nombre, anio: anio);
  }
}

Future<void> _montar(WidgetTester tester, _Repo repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [casaYAutoRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: CasaYAutoReal())),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_031_16 sin elementos muestra el vacío y el botón Agregar', (
    tester,
  ) async {
    await _montar(tester, _Repo());
    expect(find.textContaining('Agrega tu auto'), findsOneWidget);
    expect(find.text('Agregar'), findsOneWidget);
  });

  testWidgets(
    'CA_031_16 si falla muestra el error y Reintentar vuelve a pedir',
    (tester) async {
      final repo = _Repo(fallaLista: true);
      await _montar(tester, repo);
      expect(
        find.text('No pudimos cargar tus cosas registradas.'),
        findsOneWidget,
      );

      repo.fallaLista = false;
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(repo.listados, 2);
      expect(find.textContaining('Agrega tu auto'), findsOneWidget);
    },
  );

  testWidgets('CA_031_03 agregar un auto lo muestra en la lista', (
    tester,
  ) async {
    await _montar(tester, _Repo());
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Nissan Versa');
    await tester.enterText(find.byType(TextField).at(1), '2018');
    await tester.pump();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Nissan Versa'), findsOneWidget);
    expect(find.text('Auto · 2018'), findsOneWidget);
  });

  testWidgets(
    'CA_031_05 si el servidor rechaza, el formulario sigue abierto con lo escrito',
    (tester) async {
      await _montar(tester, _Repo(falloAlta: const ConflictoFailure()));
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'Nissan Versa');
      await tester.enterText(find.byType(TextField).at(1), '2018');
      await tester.pump();
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Llegaste al máximo de 20'), findsOneWidget);
      expect(find.text('Nissan Versa'), findsOneWidget);
      expect(find.text('2018'), findsOneWidget);
    },
  );

  test('CA_031_08 los errores tienen texto sin detalles técnicos', () {
    expect(
      textoDeErrorCasa(const NoEncontradoFailure()),
      'Eso ya no está disponible.',
    );
    expect(
      textoDeErrorCasa(const AccesoDenegadoFailure()),
      'Eso ya no está disponible.',
    );
    expect(
      textoDeErrorCasa(const ConflictoFailure(), alta: true),
      contains('máximo de 20'),
    );
    expect(
      textoDeErrorCasa(const ServicioNoDisponibleFailure()),
      contains('No pudimos conectar'),
    );
  });

  testWidgets(
    'CA_031_18 cada fila mide al menos 48 y se anuncia con nombre y tipo',
    (tester) async {
      final repo = _Repo();
      await repo.agregar(
        tipo: TipoElemento.auto,
        nombre: 'Nissan Versa',
        anio: 2018,
      );
      final semantica = tester.ensureSemantics();
      await _montar(tester, repo);

      expect(find.bySemanticsLabel('Nissan Versa, Auto'), findsOneWidget);
      expect(
        tester.getSize(find.byType(InkWell).first).height,
        greaterThanOrEqualTo(48),
      );
      semantica.dispose();
    },
  );
}
