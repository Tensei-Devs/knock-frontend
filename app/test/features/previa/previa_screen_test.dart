// Spec 027: la previa sin sesión, por estado (widget).
import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/domain/resultado_oficios.dart';
import 'package:app/features/previa/presentation/panel_expertos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/accesibilidad.dart';
import '../../soporte/montar_previa.dart';

CatalogoFalso _tres() => CatalogoFalso.con([ele, mec, plo]);

final _panel = find.descendant(
  of: find.byType(PanelExpertos),
  matching: find.byType(Scrollable),
);

Finder _chip(String texto) => find.widgetWithText(ChoiceChip, texto);

Finder _fila(String nombre) =>
    find.descendant(of: find.byType(ListTile), matching: find.text(nombre));

Finder _enLaHoja(String texto) =>
    find.descendant(of: find.byType(BottomSheet), matching: find.text(texto));

void main() {
  group('barra de marca', () {
    testWidgets('CA_027_06 muestra el logo, Entrar y Registrarme de 48 dp', (
      tester,
    ) async {
      await montarPrevia(tester, catalogo: _tres());
      expect(find.text('Knock'), findsOneWidget);
      for (final texto in ['Entrar', 'Registrarme']) {
        final boton = find.ancestor(
          of: find.text(texto),
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        );
        expect(boton, findsOneWidget, reason: texto);
        final tamano = tester.getSize(boton);
        expect(tamano.height, greaterThanOrEqualTo(48), reason: texto);
        expect(tamano.width, greaterThanOrEqualTo(48), reason: texto);
      }
    });

    for (final texto in ['Entrar', 'Registrarme']) {
      testWidgets('CA_027_07 «$texto» abre /entrar', (tester) async {
        final previa = await montarPrevia(tester, catalogo: _tres());
        await tester.tap(find.text(texto));
        await tester.pumpAndSettle();
        expect(previa.ubicacion, Rutas.entrar);
        expect(find.text(textoEntrar), findsOneWidget);
      });
    }
  });

  group('buscador y hoja de invitación', () {
    testWidgets('CA_027_08 el buscador dice lo de la maqueta', (tester) async {
      await montarPrevia(tester, catalogo: _tres());
      expect(find.text('Busca un experto cerca de ti'), findsOneWidget);
      expect(find.text('Mecánica · Plomería · Electricidad'), findsOneWidget);
    });

    testWidgets('CA_027_09 tocarlo abre la hoja y no hace ninguna petición', (
      tester,
    ) async {
      final catalogo = _tres();
      await montarPrevia(tester, catalogo: catalogo);
      final antes = catalogo.consultas;

      await tester.tap(find.text('Busca un experto cerca de ti'));
      await tester.pumpAndSettle();

      expect(find.text('Entra para continuar'), findsOneWidget);
      expect(_enLaHoja('Entrar'), findsOneWidget);
      expect(_enLaHoja('Registrarme'), findsOneWidget);
      expect(_enLaHoja('Ahora no'), findsOneWidget);
      expect(catalogo.consultas, antes, reason: 'no se pidió nada más');
    });

    testWidgets('CA_027_10 «Ahora no» cierra la hoja y la previa queda igual', (
      tester,
    ) async {
      final previa = await montarPrevia(tester, catalogo: _tres());
      await tester.tap(find.text('Busca un experto cerca de ti'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ahora no'));
      await tester.pumpAndSettle();
      expect(find.text('Entra para continuar'), findsNothing);
      expect(previa.ubicacion, Rutas.previa);
    });

    testWidgets('CA_027_10 deslizar la hoja hacia abajo la cierra', (
      tester,
    ) async {
      final previa = await montarPrevia(tester, catalogo: _tres());
      await tester.tap(find.text('Busca un experto cerca de ti'));
      await tester.pumpAndSettle();
      await tester.drag(
        find.text('Entra para continuar'),
        const Offset(0, 600),
      );
      await tester.pumpAndSettle();
      expect(find.text('Entra para continuar'), findsNothing);
      expect(previa.ubicacion, Rutas.previa);
    });

    testWidgets('CA_027_07 «Entrar» de la hoja abre /entrar', (tester) async {
      final previa = await montarPrevia(tester, catalogo: _tres());
      await tester.tap(find.text('Busca un experto cerca de ti'));
      await tester.pumpAndSettle();
      await tester.tap(_enLaHoja('Entrar'));
      await tester.pumpAndSettle();
      expect(previa.ubicacion, Rutas.entrar);
    });
  });

  group('chips y catálogo', () {
    testWidgets(
      'CA_027_11 están Todos (seleccionado), cada oficio y No sé cuál',
      (tester) async {
        await montarPrevia(tester, catalogo: _tres());
        expect(tester.widget<ChoiceChip>(_chip('Todos')).selected, isTrue);
        for (final nombre in ['Electricidad', 'Mecánica', 'Plomería']) {
          expect(_chip(nombre), findsOneWidget, reason: nombre);
        }
        expect(find.widgetWithText(ActionChip, 'No sé cuál'), findsOneWidget);
      },
    );

    testWidgets(
      'CA_027_12 elegir un oficio lo deja seleccionado y filtra la lista; Todos la restaura',
      (tester) async {
        final semantica = tester.ensureSemantics();
        await montarPrevia(tester, catalogo: _tres());
        expect(_fila('Electricidad'), findsOneWidget);
        expect(_fila('Mecánica'), findsOneWidget);

        await tester.ensureVisible(_chip('Mecánica'));
        await tester.tap(_chip('Mecánica'));
        await tester.pumpAndSettle();
        expect(tester.widget<ChoiceChip>(_chip('Mecánica')).selected, isTrue);
        expect(tester.widget<ChoiceChip>(_chip('Todos')).selected, isFalse);
        expect(
          tester.getSemantics(_chip('Mecánica')),
          matchesSemantics(
            label: 'Mecánica',
            isButton: true,
            isSelected: true,
            hasSelectedState: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
            isFocusable: true,
            hasFocusAction: true,
          ),
        );
        expect(_fila('Mecánica'), findsOneWidget);
        expect(_fila('Electricidad'), findsNothing);
        expect(_fila('Plomería'), findsNothing);

        await tester.ensureVisible(_chip('Todos'));
        await tester.tap(_chip('Todos'));
        await tester.pumpAndSettle();
        expect(_fila('Electricidad'), findsOneWidget);
        expect(_fila('Plomería'), findsOneWidget);
        semantica.dispose();
      },
    );

    testWidgets('CA_027_13 «No sé cuál» abre la invitación a entrar', (
      tester,
    ) async {
      await montarPrevia(tester, catalogo: _tres());
      await tester.ensureVisible(find.text('No sé cuál'));
      await tester.tap(find.text('No sé cuál'));
      await tester.pumpAndSettle();
      expect(find.text('Entra para continuar'), findsOneWidget);
      expect(tester.widget<ChoiceChip>(_chip('Todos')).selected, isTrue);
    });

    testWidgets('CA_027_15 mientras carga se ve el indicador con su etiqueta', (
      tester,
    ) async {
      final semantica = tester.ensureSemantics();
      final espera = Completer<List<Oficio>>();
      await montarPrevia(
        tester,
        catalogo: CatalogoFalso([() => espera.future]),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.bySemanticsLabel('Cargando oficios'), findsOneWidget);
      espera.complete([ele]);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      semantica.dispose();
    });

    testWidgets('CA_027_16 un catálogo vacío no ofrece un reintento falso', (
      tester,
    ) async {
      await montarPrevia(tester, catalogo: CatalogoFalso.con(const []));
      await tester.pumpAndSettle();
      expect(find.text('Todavía no hay oficios disponibles'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });

    testWidgets(
      'CA_027_17 un fallo muestra el error y Reintentar vuelve a pedir',
      (tester) async {
        final catalogo = CatalogoFalso([
          () async => throw const ServicioNoDisponibleFailure(),
          () async => [ele],
        ]);
        await montarPrevia(tester, catalogo: catalogo);
        await tester.pumpAndSettle();
        expect(find.text('No pudimos cargar los oficios'), findsOneWidget);
        await tester.ensureVisible(find.text('Reintentar'));
        await tester.tap(find.text('Reintentar'));
        await tester.pumpAndSettle();
        expect(catalogo.consultas, 2);
        expect(find.text('No pudimos cargar los oficios'), findsNothing);
        expect(_fila('Electricidad'), findsOneWidget);
      },
    );

    testWidgets(
      'CA_027_18 sin red y con caché muestra lo guardado con el aviso',
      (tester) async {
        await montarPrevia(
          tester,
          catalogo: CatalogoConCacheFalso(
            const ResultadoOficios([ele, mec], sinConexion: true),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text('Sin conexión. Se muestra lo último guardado.'),
          findsOneWidget,
        );
        expect(_fila('Mecánica'), findsOneWidget);
      },
    );

    testWidgets('CA_027_18 sin red y sin caché sale el error con Reintentar', (
      tester,
    ) async {
      await montarPrevia(
        tester,
        catalogo: CatalogoFalso([
          () async => throw const ServicioNoDisponibleFailure(),
        ]),
      );
      await tester.pumpAndSettle();
      expect(find.text('No pudimos cargar los oficios'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets(
      'CA_027_19 la tarjeta Explorar abre el catálogo y atrás regresa',
      (tester) async {
        final previa = await montarPrevia(tester, catalogo: _tres());
        await tester.ensureVisible(find.text('Explorar servicios y trabajos'));
        await tester.tap(find.text('Explorar servicios y trabajos'));
        await tester.pumpAndSettle();
        expect(previa.ubicacion, Rutas.previaOficios);
        expect(find.text('Electricidad'), findsOneWidget);

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(previa.ubicacion, Rutas.previa);
      },
    );
  });

  group('idioma', () {
    testWidgets('CA_027_32 en inglés todos los textos salen del ARB inglés', (
      tester,
    ) async {
      await montarPrevia(tester, catalogo: _tres(), idioma: const Locale('en'));
      for (final texto in [
        'Sign in',
        'Sign up',
        'Find an expert near you',
        'Mechanics · Plumbing · Electrical',
        'All',
        "I'm not sure which",
        'Explore services and jobs',
        '6 experts near you',
        'See list',
        'Available trades',
      ]) {
        expect(find.text(texto), findsOneWidget, reason: texto);
      }
      for (final es in ['Entrar', 'Registrarme', 'Todos', 'Ver lista']) {
        expect(find.textContaining(es), findsNothing, reason: es);
      }
    });
  });

  group('accesibilidad', () {
    for (final brillo in [Brightness.light, Brightness.dark]) {
      testWidgets('CA_027_06 la previa cumple 48 dp y etiquetas ($brillo)', (
        tester,
      ) async {
        final semantica = tester.ensureSemantics();
        await montarPrevia(tester, catalogo: _tres(), brillo: brillo);
        await expectAccesible(tester);
        semantica.dispose();
      });
    }

    testWidgets(
      'CA_027_31 con texto al 200 % nada se desborda y todo se alcanza',
      (tester) async {
        await montarPrevia(
          tester,
          catalogo: _tres(),
          escalaDeTexto: 2,
          tamano: const Size(320, 640),
        );
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Oficios disponibles'),
          200,
          scrollable: _panel,
        );
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Explorar servicios y trabajos'),
          -300,
          scrollable: _panel,
        );
        await tester.ensureVisible(find.text('Explorar servicios y trabajos'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Explorar servicios y trabajos'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  });
}
