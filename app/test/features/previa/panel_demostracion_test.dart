// Spec 027: el panel del modo demostración (datos de ejemplo rotulados).
import 'package:app/core/router/rutas.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:app/features/previa/presentation/panel_demostracion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/accesibilidad.dart';
import '../../soporte/montar_previa.dart';

Future<PreviaMontada> _montarDemo(
  WidgetTester tester, {
  Locale idioma = const Locale('es'),
  double escala = 1,
  Size? tamano,
}) => montarPrevia(
  tester,
  catalogo: CatalogoFalso.con([ele, mec, plo]),
  panel: const PanelDemostracion(),
  idioma: idioma,
  escalaDeTexto: escala,
  tamano: tamano,
);

void main() {
  testWidgets(
    'CA_027_26 muestra N expertos, la colonia, Ver lista, tarjetas y mapa',
    (tester) async {
      await _montarDemo(tester);
      expect(find.text('3 expertos cerca de ti'), findsOneWidget);
      expect(find.text(coloniaDeEjemplo), findsOneWidget);
      expect(find.text('Ver lista'), findsOneWidget);
      for (final e in expertosDeEjemplo) {
        expect(find.text(e.nombre), findsOneWidget, reason: e.nombre);
      }
      expect(find.byIcon(Icons.location_on), findsNWidgets(3));
      expect(find.text('Datos de ejemplo'), findsWidgets);
      expect(find.text('Muy pronto: expertos cerca de ti'), findsNothing);
    },
  );

  testWidgets(
    'CA_027_26 el rótulo «Datos de ejemplo» está en el panel y en el mapa',
    (tester) async {
      await _montarDemo(tester);
      // Uno junto al encabezado y otro dentro del mapa.
      expect(find.text('Datos de ejemplo'), findsNWidgets(2));
    },
  );

  testWidgets('CA_027_32 en inglés el panel sale del ARB inglés', (
    tester,
  ) async {
    await _montarDemo(tester, idioma: const Locale('en'));
    expect(find.text('3 experts near you'), findsOneWidget);
    expect(find.text('See list'), findsOneWidget);
    expect(find.text('Sample data'), findsNWidgets(2));
    expect(find.text('Datos de ejemplo'), findsNothing);
  });

  testWidgets('CA_027_28 tocar una tarjeta pide cuenta y no muestra contacto', (
    tester,
  ) async {
    final previa = await _montarDemo(tester);
    await tester.ensureVisible(find.text(expertosDeEjemplo.first.nombre));
    await tester.tap(find.text(expertosDeEjemplo.first.nombre));
    await tester.pumpAndSettle();
    expect(previa.ubicacion, Rutas.entrar);
    expect(find.text(textoEntrar), findsOneWidget);
    expect(find.textContaining(RegExp(r'\d{8,}')), findsNothing);
  });

  testWidgets('CA_027_28 tocar un pin pide cuenta con el destino válido', (
    tester,
  ) async {
    final previa = await _montarDemo(tester);
    await tester.ensureVisible(find.byIcon(Icons.location_on).first);
    await tester.tap(find.byIcon(Icons.location_on).first);
    await tester.pumpAndSettle();
    expect(previa.ubicacion, Rutas.entrar);
    expect(previa.consulta[Rutas.parametroVolver], Rutas.explorar);
  });

  testWidgets('CA_027_28 «Ver lista» pide cuenta', (tester) async {
    final previa = await _montarDemo(tester);
    await tester.tap(find.text('Ver lista'));
    await tester.pumpAndSettle();
    expect(previa.ubicacion, Rutas.entrar);
  });

  testWidgets('CA_027_29 el lector de pantalla anuncia «Datos de ejemplo»', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await _montarDemo(tester);
    expect(
      find.bySemanticsLabel(RegExp('Mapa de ejemplo.*Datos de ejemplo')),
      findsOneWidget,
    );
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

  testWidgets('CA_027_06 el panel de demostración cumple 48 dp y etiquetas', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await _montarDemo(tester);
    await expectAccesible(tester);
    semantica.dispose();
  });

  testWidgets('CA_027_31 el panel de demostración al 200 % no se desborda', (
    tester,
  ) async {
    await _montarDemo(tester, escala: 2, tamano: const Size(320, 640));
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text(expertosDeEjemplo.last.nombre),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);
  });
}
