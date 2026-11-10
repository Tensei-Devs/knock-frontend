// Spec 027, decisión D-12: la previa es un mapa a pantalla completa con
// expertos de ejemplo siempre visibles y rotulados, y un panel plegable.
import 'dart:io';

import 'package:app/core/router/rutas.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:app/features/previa/presentation/mapa/mapa_previa.dart';
import 'package:app/features/previa/presentation/mapa/pin_experto.dart';
import 'package:app/features/previa/presentation/panel_expertos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_previa.dart';

Future<PreviaMontada> _montar(
  WidgetTester tester, {
  Locale idioma = const Locale('es'),
  double escala = 1,
  Size? tamano,
}) => montarPrevia(
  tester,
  catalogo: CatalogoFalso.con([ele, mec, plo]),
  idioma: idioma,
  escalaDeTexto: escala,
  tamano: tamano,
);

final _pines = find.byType(PinExperto);

Finder _pinDe(String nombre) => find.byWidgetPredicate(
  (w) => w is PinExperto && w.experto.nombre == nombre,
);

void main() {
  testWidgets(
    'CA_027_26 la previa trae el mapa, tu punto, los pines y el panel',
    (tester) async {
      final semantica = tester.ensureSemantics();
      await _montar(tester);
      expect(find.byType(MapaPrevia), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          'Mapa de ejemplo con expertos. Datos de ejemplo.',
        ),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Tú estás aquí'), findsOneWidget);
      expect(_pines, findsNWidgets(expertosDeEjemplo.length));
      for (final e in expertosDeEjemplo) {
        expect(
          find.descendant(
            of: _pinDe(e.nombre),
            matching: find.text(e.calificacion),
          ),
          findsOneWidget,
        );
        expect(find.text(e.nombre), findsOneWidget, reason: e.nombre);
      }
      expect(find.text('6 expertos cerca de ti'), findsOneWidget);
      expect(find.text(coloniaDeEjemplo), findsOneWidget);
      expect(find.text('Ver lista'), findsOneWidget);
      expect(find.text('Explorar servicios y trabajos'), findsOneWidget);
      expect(find.byType(PanelExpertos), findsOneWidget);
      semantica.dispose();
    },
  );

  testWidgets('CA_027_26 los pines son del color de su oficio', (tester) async {
    await _montar(tester);
    Color colorDe(String nombre) {
      final caja = find.descendant(
        of: _pinDe(nombre),
        matching: find.byType(DecoratedBox),
      );
      final deco = tester.widget<DecoratedBox>(caja.first).decoration;
      return (deco as BoxDecoration).color!;
    }

    expect(colorDe('Beto Muestra Lara'), colorDeOficio('mec'));
    expect(colorDe('Tania Muestra Cruz'), colorDeOficio('plo'));
    expect(colorDe('Elena Muestra Ríos'), colorDeOficio('ele'));
    expect({
      colorDeOficio('mec'),
      colorDeOficio('plo'),
      colorDeOficio('ele'),
    }, hasLength(3));
  });

  testWidgets(
    'CA_027_25 los ejemplos salen siempre con el rótulo y sin «Muy pronto»',
    (tester) async {
      await _montar(tester);
      // Uno sobre el mapa y otro en el panel.
      expect(find.text('Datos de ejemplo'), findsNWidgets(2));
      expect(find.textContaining('Muy pronto'), findsNothing);
    },
  );

  test(
    'CA_027_25 los ejemplos no dependen de ninguna bandera de compilación',
    () {
      List<File> fuentes(String ruta) =>
          Directory(ruta)
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .toList();
      final bandera = RegExp(
        r'KNOCK_DEMO_DATOS|demoDatosActivo|demoActivo|PanelProximamente',
      );
      for (final archivo in fuentes('lib')) {
        expect(
          archivo.readAsStringSync(),
          isNot(contains(bandera)),
          reason: archivo.path,
        );
      }
      for (final archivo in fuentes('lib/features/previa')) {
        expect(
          archivo.readAsStringSync(),
          isNot(contains('kReleaseMode')),
          reason: archivo.path,
        );
      }
    },
  );

  testWidgets('CA_027_32 en inglés el rótulo y el panel salen del ARB inglés', (
    tester,
  ) async {
    await _montar(tester, idioma: const Locale('en'));
    expect(find.text('Sample data'), findsNWidgets(2));
    expect(find.text('Datos de ejemplo'), findsNothing);
    expect(find.text('6 experts near you'), findsOneWidget);
    expect(find.text('See list'), findsOneWidget);
    expect(find.text('1.2 km away'), findsNothing);
    expect(find.textContaining('km away'), findsWidgets);
  });

  group('zoom y desplazamiento', () {
    double separacion(WidgetTester tester) =>
        (tester.getCenter(_pinDe('Tania Muestra Cruz')) -
                tester.getCenter(_pinDe('Taller Muestra Centro')))
            .distance;

    testWidgets('CA_027_27 acercar separa los pines y alejar los junta', (
      tester,
    ) async {
      await _montar(tester);
      final base = separacion(tester);
      await tester.tap(find.byTooltip('Acercar'));
      await tester.pump();
      final cerca = separacion(tester);
      expect(cerca, greaterThan(base));
      await tester.tap(find.byTooltip('Alejar'));
      await tester.pump();
      expect(separacion(tester), lessThan(cerca));
    });

    testWidgets(
      'CA_027_27 «Volver a mi ubicación» regresa a la vista inicial',
      (tester) async {
        await _montar(tester);
        final inicio = tester.getCenter(_pinDe('Tania Muestra Cruz'));
        await tester.tap(find.byTooltip('Acercar'));
        await tester.tap(find.byTooltip('Acercar'));
        await tester.pump();
        expect(tester.getCenter(_pinDe('Tania Muestra Cruz')), isNot(inicio));
        await tester.tap(find.byTooltip('Volver a mi ubicación'));
        await tester.pump();
        final vuelta = tester.getCenter(_pinDe('Tania Muestra Cruz'));
        expect(vuelta.dx, closeTo(inicio.dx, 0.01));
        expect(vuelta.dy, closeTo(inicio.dy, 0.01));
      },
    );

    testWidgets('CA_027_27 arrastrar el mapa mueve los pines con él', (
      tester,
    ) async {
      await _montar(tester);
      final antes = tester.getCenter(_pinDe('Tania Muestra Cruz'));
      await tester.dragFrom(const Offset(200, 330), const Offset(-60, 0));
      await tester.pump();
      final despues = tester.getCenter(_pinDe('Tania Muestra Cruz'));
      expect(despues.dx, lessThan(antes.dx - 30));
      expect(despues.dy, closeTo(antes.dy, 1));
    });

    testWidgets('CA_027_27 los pines no cambian de tamaño con el zoom', (
      tester,
    ) async {
      await _montar(tester);
      final antes = tester.getSize(_pinDe('Tania Muestra Cruz'));
      await tester.tap(find.byTooltip('Acercar'));
      await tester.pump();
      expect(tester.getSize(_pinDe('Tania Muestra Cruz')), antes);
    });
  });

  group('pedir cuenta', () {
    testWidgets('CA_027_28 tocar un pin pide cuenta con el destino válido', (
      tester,
    ) async {
      final previa = await _montar(tester);
      await tester.tap(_pinDe('Beto Muestra Lara'));
      await tester.pumpAndSettle();
      expect(previa.ubicacion, Rutas.entrar);
      expect(previa.consulta[Rutas.parametroVolver], Rutas.explorar);
      expect(find.textContaining(RegExp(r'\d{8,}')), findsNothing);
    });

    testWidgets(
      'CA_027_28 tocar una tarjeta pide cuenta y no muestra contacto',
      (tester) async {
        final previa = await _montar(tester);
        await tester.ensureVisible(find.text('Tania Muestra Cruz'));
        await tester.tap(find.text('Tania Muestra Cruz'));
        await tester.pumpAndSettle();
        expect(previa.ubicacion, Rutas.entrar);
        expect(find.text(textoEntrar), findsOneWidget);
        expect(find.textContaining(RegExp(r'\d{8,}')), findsNothing);
      },
    );

    testWidgets('CA_027_28 «Ver lista» no pide cuenta', (tester) async {
      final previa = await _montar(tester);
      await tester.tap(find.text('Ver lista'));
      await tester.pumpAndSettle();
      expect(previa.ubicacion, Rutas.previa);
    });
  });

  group('chips', () {
    testWidgets('CA_027_35 elegir un oficio deja solo sus pines y tarjetas', (
      tester,
    ) async {
      await _montar(tester);
      await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Mecánica'));
      await tester.tap(find.widgetWithText(ChoiceChip, 'Mecánica'));
      await tester.pumpAndSettle();
      final mecanica = expertosDeEjemplo.where((e) => e.claveOficio == 'mec');
      expect(_pines, findsNWidgets(mecanica.length));
      expect(
        find.text('${mecanica.length} expertos cerca de ti'),
        findsOneWidget,
      );
      expect(find.text('Tania Muestra Cruz'), findsNothing);
      expect(find.text('Beto Muestra Lara'), findsOneWidget);

      await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Todos'));
      await tester.tap(find.widgetWithText(ChoiceChip, 'Todos'));
      await tester.pumpAndSettle();
      expect(_pines, findsNWidgets(expertosDeEjemplo.length));
    });
  });

  group('panel plegable', () {
    double cima(WidgetTester tester) =>
        tester.getTopLeft(find.byType(PanelExpertos)).dy +
        tester
            .getTopLeft(
              find
                  .descendant(
                    of: find.byType(PanelExpertos),
                    matching: find.byType(Material),
                  )
                  .first,
            )
            .dy;

    testWidgets('CA_027_36 «Ver lista» sube el panel y «Ver mapa» lo baja', (
      tester,
    ) async {
      await _montar(tester);
      final mitad = cima(tester);
      await tester.tap(find.text('Ver lista'));
      await tester.pumpAndSettle();
      expect(find.text('Ver mapa'), findsOneWidget);
      expect(find.text('Ver lista'), findsNothing);
      expect(cima(tester), lessThan(mitad));

      await tester.tap(find.text('Ver mapa'));
      await tester.pumpAndSettle();
      expect(find.text('Ver lista'), findsOneWidget);
      expect(cima(tester), closeTo(mitad, 1));
    });

    testWidgets('CA_027_36 arrastrar el panel hacia abajo lo deja asomado', (
      tester,
    ) async {
      await _montar(tester);
      final mitad = cima(tester);
      await tester.drag(
        find.text('6 expertos cerca de ti'),
        const Offset(0, 900),
      );
      await tester.pumpAndSettle();
      expect(cima(tester), greaterThan(mitad + 100));
      expect(find.text('6 expertos cerca de ti'), findsOneWidget);
    });
  });

  group('accesibilidad', () {
    testWidgets('CA_027_29 el lector de pantalla anuncia «Datos de ejemplo»', (
      tester,
    ) async {
      final semantica = tester.ensureSemantics();
      await _montar(tester);
      for (final e in expertosDeEjemplo) {
        expect(
          find.bySemanticsLabel(RegExp('${e.nombre}.*Datos de ejemplo')),
          findsWidgets,
          reason: e.nombre,
        );
      }
      expect(find.bySemanticsLabel('Datos de ejemplo'), findsWidgets);
      semantica.dispose();
    });

    testWidgets('CA_027_06 pines y botones del mapa miden al menos 48 dp', (
      tester,
    ) async {
      await _montar(tester);
      for (final e in expertosDeEjemplo) {
        final t = tester.getSize(_pinDe(e.nombre));
        expect(t.width, greaterThanOrEqualTo(48), reason: e.nombre);
        expect(t.height, greaterThanOrEqualTo(48), reason: e.nombre);
      }
      for (final etiqueta in ['Acercar', 'Alejar', 'Volver a mi ubicación']) {
        final t = tester.getSize(find.byTooltip(etiqueta));
        expect(t.width, greaterThanOrEqualTo(48), reason: etiqueta);
        expect(t.height, greaterThanOrEqualTo(48), reason: etiqueta);
      }
    });

    testWidgets('CA_027_31 el mapa y el panel al 200 % no se desbordan', (
      tester,
    ) async {
      await _montar(tester, escala: 2, tamano: const Size(320, 640));
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Ver lista'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.text(expertosDeEjemplo.last.nombre),
        200,
        scrollable: find.descendant(
          of: find.byType(PanelExpertos),
          matching: find.byType(Scrollable),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  test('CA_027_33 los datos de ejemplo no traen celular ni dirección', () {
    final campos = [
      coloniaDeEjemplo,
      for (final e in expertosDeEjemplo) ...[e.nombre, e.oficio],
    ].join(' ');
    expect(campos, isNot(matches(RegExp(r'\d{7,}'))));
    expect(campos.toLowerCase(), isNot(contains('calle')));
    expect(campos.toLowerCase(), isNot(contains('@')));
    for (final e in expertosDeEjemplo) {
      expect(
        e.nombre,
        contains('Muestra'),
        reason: 'nombre claramente ficticio',
      );
      expect(e.x, inInclusiveRange(0, 1200), reason: 'punto del dibujo');
      expect(e.y, inInclusiveRange(0, 1600));
    }
  });
}
