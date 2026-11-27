// Spec 036 (TEC-14) y spec 045 (enmienda 1): Explorar en la maqueta con los
// bloques reales: carga, error con Reintentar, vacío, la copia sin conexión
// con su fecha, el filtro de los chips y las tarjetas de técnicos.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/explorar/explorar.dart';
import 'package:app/features/maqueta/explorar_real.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/preparar_maqueta.dart';

class _Repo implements ExplorarRepository {
  _Repo({this.datos});

  Explorar? datos;
  bool falla = false;
  final filtros = <FiltroExplorar>[];

  @override
  Future<Explorar> cargar(FiltroExplorar filtro) async {
    filtros.add(filtro);
    if (falla) throw const ServicioNoDisponibleFailure();
    return datos ??
        Explorar(
          filtro: filtro,
          serviciosPopulares: const [],
          mejorCalificados: const [],
          ideas: const [],
        );
  }
}

const _tecnico = TecnicoDestacado(
  id: 't1',
  nombre: 'Taller Demo',
  verificacion: 'completa',
  oficios: ['mec'],
  calificacion: 4.8,
  anios: 12,
);

const _lleno = Explorar(
  filtro: FiltroExplorar.todo,
  serviciosPopulares: [
    ServicioPopular(clave: 'mec', nombre: 'Mecánica', tecnicos: 3),
  ],
  mejorCalificados: [_tecnico],
  ideas: [IdeaExplorar(clave: 'ele', nombre: 'Electricidad')],
);

Future<List<String>> _montar(
  WidgetTester tester,
  _Repo repo, {
  String? oficio,
}) async {
  final pedidos = <String>[];
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        explorarRepositoryProvider.overrideWithValue(repo),
        relojExplorarProvider.overrideWithValue(
          () => DateTime(2026, 11, 25, 9, 5),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ExplorarReal(oficio: oficio, alPedir: pedidos.add),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return pedidos;
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_036_49 muestra los bloques que mandó el servidor', (
    tester,
  ) async {
    final pedidos = await _montar(tester, _Repo(datos: _lleno));

    expect(find.text('Servicios populares'), findsOneWidget);
    expect(find.text('3 expertos'), findsOneWidget);
    expect(find.text('Mejor calificados'), findsOneWidget);
    expect(find.text('Taller Demo'), findsOneWidget);
    expect(find.text('★ 4.8 · 12 años'), findsOneWidget);
    // Sin sesión no llegan estos bloques: no se inventan.
    expect(find.text('Trabajos reales'), findsNothing);
    expect(find.text('Cerca de ti'), findsNothing);

    await tester.tap(find.text('Pedir cotización'));
    await tester.tap(find.text('3 expertos'));
    expect(pedidos, ['ele', 'mec']);
  });

  testWidgets('CA_036_49 el chip elegido manda su filtro', (tester) async {
    final repo = _Repo();
    await _montar(tester, repo, oficio: 'plo');
    expect(repo.filtros, [FiltroExplorar.agua]);
  });

  testWidgets('CA_036_49 sin nada que mostrar, lo dice', (tester) async {
    await _montar(tester, _Repo());
    expect(
      find.text('Todavía no hay expertos para mostrar aquí.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'CA_036_49 si falla, muestra el error y Reintentar vuelve a pedir',
    (tester) async {
      final repo = _Repo()..falla = true;
      await _montar(tester, repo);
      expect(find.textContaining('No pudimos cargar Explorar'), findsOneWidget);

      repo
        ..falla = false
        ..datos = _lleno;
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(repo.filtros, hasLength(2));
      expect(find.text('Servicios populares'), findsOneWidget);
    },
  );

  testWidgets(
    'CA_036_45 sin conexión muestra la última copia con su fecha y aviso',
    (tester) async {
      final repo = _Repo(datos: _lleno);
      await _montar(tester, repo);

      repo.falla = true;
      final contenedor = ProviderScope.containerOf(
        tester.element(find.byType(ExplorarReal)),
      );
      contenedor.invalidate(explorarProvider(FiltroExplorar.todo));
      await tester.pumpAndSettle();

      expect(find.textContaining('Sin conexión'), findsOneWidget);
      expect(find.textContaining('25/11 a las 09:05'), findsOneWidget);
      expect(find.text('Taller Demo'), findsOneWidget);
    },
  );

  testWidgets(
    'CA_036_59 las tarjetas miden al menos 48 y se anuncian con nombre',
    (tester) async {
      final semantica = tester.ensureSemantics();
      await _montar(tester, _Repo(datos: _lleno));

      expect(
        find.bySemanticsLabel('Taller Demo, verificado, ★ 4.8'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Mecánica, 3 expertos'), findsOneWidget);
      for (final texto in ['Taller Demo', '3 expertos']) {
        final tarjeta = find.ancestor(
          of: find.text(texto),
          matching: find.byType(InkWell),
        );
        expect(tester.getSize(tarjeta).height, greaterThanOrEqualTo(48));
      }
      semantica.dispose();
    },
  );
}
