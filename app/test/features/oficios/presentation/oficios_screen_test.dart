import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/oficios/domain/modalidad.dart';
import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/domain/oficios_repository.dart';
import 'package:app/features/oficios/oficios_providers.dart';
import 'package:app/features/oficios/presentation/oficios_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _electricidad = Oficio(
  clave: 'ele',
  nombre: 'Electricidad',
  modalidad: Modalidad.domicilio,
);
const _mecanica = Oficio(
  clave: 'mec',
  nombre: 'Mecánica',
  modalidad: Modalidad.taller,
);
const _plomeria = Oficio(
  clave: 'plo',
  nombre: 'Plomería',
  modalidad: Modalidad.domicilio,
);

/// Los tres oficios del contrato de TT-PRU-01, en el orden en que los entrega.
const _delContrato = [_electricidad, _mecanica, _plomeria];

/// Repositorio falso: cada petición toma el siguiente comportamiento.
class _RepositorioFalso implements OficiosRepository {
  _RepositorioFalso(this._respuestas);

  final List<Future<List<Oficio>> Function()> _respuestas;
  int llamadas = 0;

  @override
  Future<List<Oficio>> listar() {
    final indice = llamadas < _respuestas.length
        ? llamadas
        : _respuestas.length - 1;
    llamadas++;
    return _respuestas[indice]();
  }
}

Future<List<Oficio>> Function() _con(List<Oficio> oficios) =>
    () async => oficios;

Future<List<Oficio>> Function() _falla() =>
    () async => throw const ServicioNoDisponibleFailure();

Future<void> _montar(
  WidgetTester tester,
  OficiosRepository repositorio, {
  double escalaDeTexto = 1,
  Size? tamano,
}) async {
  if (tamano != null) {
    tester.view.physicalSize = tamano;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }
  await tester.pumpWidget(
    ProviderScope(
      overrides: [oficiosRepositoryProvider.overrideWithValue(repositorio)],
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(escalaDeTexto)),
          child: child!,
        ),
        home: const OficiosScreen(),
      ),
    ),
  );
}

/// El ícono de la fila: desde la spec 014 va dentro del cuadro de `FilaKnock`,
/// ya no es el `leading` directo (cambia el buscador, no la aserción).
Icon _iconoDe(WidgetTester tester, ListTile fila) => tester.widget<Icon>(
  find.descendant(
    of: find.byWidget(fila.leading!),
    matching: find.byType(Icon),
  ),
);

Finder get _indicadorDeCarga => find.byType(CircularProgressIndicator);
Finder get _reintentar => find.widgetWithText(FilledButton, 'Reintentar');
Finder get _mensajeDeError => find.text('No pudimos cargar los oficios');
Finder get _mensajeVacio => find.text('Todavía no hay oficios disponibles');

void main() {
  testWidgets('TC-TT-PRU-02-01 muestra los oficios en el orden del contrato', (
    tester,
  ) async {
    await _montar(tester, _RepositorioFalso([_con(_delContrato)]));
    await tester.pumpAndSettle();

    final nombres = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((fila) => (fila.title! as Text).data)
        .toList();
    expect(nombres, ['Electricidad', 'Mecánica', 'Plomería']);
    expect(_indicadorDeCarga, findsNothing);
    expect(_mensajeDeError, findsNothing);
    expect(_reintentar, findsNothing);
    expect(_mensajeVacio, findsNothing);
  });

  testWidgets('TC-TT-PRU-02-01 no reordena lo que recibe', (tester) async {
    await _montar(
      tester,
      _RepositorioFalso([
        _con([_plomeria, _electricidad]),
      ]),
    );
    await tester.pumpAndSettle();

    final nombres = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((fila) => (fila.title! as Text).data)
        .toList();
    expect(nombres, ['Plomería', 'Electricidad']);
  });

  testWidgets('TC-TT-PRU-02-02 muestra el ícono y el texto de cada modalidad', (
    tester,
  ) async {
    await _montar(tester, _RepositorioFalso([_con(_delContrato)]));
    await tester.pumpAndSettle();

    final filas = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    final iconos = [for (final f in filas) _iconoDe(tester, f)];
    expect(iconos[0].icon, Icons.home_repair_service_outlined);
    expect(iconos[1].icon, Icons.build_outlined);
    expect(iconos[2].icon, Icons.home_repair_service_outlined);
    expect(iconos[0].icon, isNot(iconos[1].icon));
    expect(
      [for (final i in iconos) i.semanticLabel],
      ['A domicilio', 'En taller', 'A domicilio'],
    );
    expect(find.text('A domicilio'), findsNWidgets(2));
    expect(find.text('En taller'), findsOneWidget);
  });

  testWidgets('TC-TT-PRU-02-03 muestra la carga y luego la lista', (
    tester,
  ) async {
    final respuesta = Completer<List<Oficio>>();
    await _montar(tester, _RepositorioFalso([() => respuesta.future]));
    await tester.pump();

    expect(_indicadorDeCarga, findsOneWidget);
    expect(
      tester
          .widget<CircularProgressIndicator>(_indicadorDeCarga)
          .semanticsLabel,
      'Cargando oficios',
    );
    expect(find.byType(ListTile), findsNothing);

    respuesta.complete(_delContrato);
    await tester.pumpAndSettle();

    expect(_indicadorDeCarga, findsNothing);
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('TC-TT-PRU-02-04 el error ofrece Reintentar y vuelve a pedir', (
    tester,
  ) async {
    final segunda = Completer<List<Oficio>>();
    final repositorio = _RepositorioFalso([_falla(), () => segunda.future]);
    await _montar(tester, repositorio);
    await tester.pumpAndSettle();

    expect(_mensajeDeError, findsOneWidget);
    expect(_reintentar, findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
    // Mensaje genérico: nada de nombres de excepción ni detalles técnicos.
    expect(find.textContaining('Failure'), findsNothing);
    expect(find.textContaining('Exception'), findsNothing);
    expect(tester.getSize(_reintentar).height, greaterThanOrEqualTo(48));
    expect(repositorio.llamadas, 1);

    await tester.tap(_reintentar);
    await tester.pump();

    expect(repositorio.llamadas, 2);
    expect(_indicadorDeCarga, findsOneWidget);
    expect(_mensajeDeError, findsNothing);

    segunda.complete(_delContrato);
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNWidgets(3));
    expect(_mensajeDeError, findsNothing);
  });

  testWidgets(
    'TC-TT-PRU-02-05 muestra el estado vacío sin tratarlo como error',
    (tester) async {
      await _montar(tester, _RepositorioFalso([_con(const [])]));
      await tester.pumpAndSettle();

      expect(_mensajeVacio, findsOneWidget);
      expect(_mensajeDeError, findsNothing);
      expect(_reintentar, findsNothing);
      expect(find.byType(ListTile), findsNothing);
      expect(_indicadorDeCarga, findsNothing);
    },
  );

  testWidgets('TC-TT-PRU-02-06 tolera una modalidad desconocida', (
    tester,
  ) async {
    await _montar(
      tester,
      _RepositorioFalso([
        _con([
          _electricidad,
          Oficio(
            clave: 'tel',
            nombre: 'Telefonía',
            modalidad: Modalidad.desdeTexto('remoto'),
          ),
        ]),
      ]),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Telefonía'), findsOneWidget);
    expect(find.text('remoto'), findsOneWidget);
    final filas = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    final icono = _iconoDe(tester, filas[1]);
    expect(icono.icon, Icons.category_outlined);
    expect(_mensajeDeError, findsNothing);
  });

  group('TC-TT-PRU-02-09 texto al 200 %', () {
    const angosto = Size(320, 640);

    testWidgets(
      'TC-TT-PRU-02-09 los datos no se desbordan y las filas miden 48 dp',
      (tester) async {
        await _montar(
          tester,
          _RepositorioFalso([_con(_delContrato)]),
          escalaDeTexto: 2,
          tamano: angosto,
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        for (final fila in tester.widgetList(find.byType(ListTile))) {
          expect(
            tester.getSize(find.byWidget(fila)).height,
            greaterThanOrEqualTo(48),
          );
        }
      },
    );

    testWidgets(
      'TC-TT-PRU-02-09 el error no se desborda y Reintentar mide 48 dp',
      (tester) async {
        await _montar(
          tester,
          _RepositorioFalso([_falla()]),
          escalaDeTexto: 2,
          tamano: angosto,
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(tester.getSize(_reintentar).height, greaterThanOrEqualTo(48));
      },
    );

    testWidgets('TC-TT-PRU-02-09 el estado vacío no se desborda', (
      tester,
    ) async {
      await _montar(
        tester,
        _RepositorioFalso([_con(const [])]),
        escalaDeTexto: 2,
        tamano: angosto,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(_mensajeVacio, findsOneWidget);
    });
  });
}
