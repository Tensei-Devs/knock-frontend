import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/accesibilidad.dart';
import '../../../soporte/montar_solicitud.dart';

ProviderContainer _contenedor(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

Future<void> _escribir(
  WidgetTester tester,
  String texto, {
  int campo = 0,
}) async {
  await tester.enterText(find.byType(TextField).at(campo), texto);
  await tester.pump();
}

void main() {
  testWidgets('CA_015_01 los tres pasos completos envían y abren el detalle', (
    tester,
  ) async {
    await montarFormulario(tester);

    await tester.tap(find.text('Mecánica'));
    await tester.pumpAndSettle();
    await _escribir(tester, 'Mi auto no enciende por las mañanas');
    await tester.tap(find.text('Agregar foto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ChoiceChip).first);
    await tester.pump();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Tarde'));
    await tester.pump();
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();

    expect(find.text('Tu solicitud'), findsOneWidget);
    expect(find.text('Enviada'), findsOneWidget);
  });

  testWidgets('CA_015_02 con descripción corta muestra el error en línea', (
    tester,
  ) async {
    await montarFormulario(tester, oficioClave: 'mec');
    await _escribir(tester, 'corta');
    await tester.tap(find.text('Siguiente'));
    await tester.pump();

    expect(find.text('Escribe al menos 8 caracteres.'), findsOneWidget);
    expect(find.text('5/500'), findsOneWidget, reason: 'contador visible');
  });

  testWidgets('CA_015_03 sin fotos explica que falta al menos una', (
    tester,
  ) async {
    await montarFormulario(tester, oficioClave: 'mec');
    await _escribir(tester, 'Descripción suficiente');
    await tester.tap(find.text('Siguiente'));
    await tester.pump();

    expect(
      find.text('Agrega al menos una foto: le dice al técnico qué llevar'),
      findsOneWidget,
    );
  });

  testWidgets('CA_015_03 con 5 fotos ya no se puede agregar otra', (
    tester,
  ) async {
    await montarFormulario(tester, oficioClave: 'mec');
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.text('Agregar foto'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Foto 5 de 5'), findsOneWidget);
    await tester.tap(find.text('Agregar foto'));
    await tester.pump();
    expect(find.text('Puedes agregar hasta 5 fotos.'), findsOneWidget);
    expect(
      _contenedor(tester).read(solicitudControllerProvider).rutasDeFotos,
      hasLength(5),
    );
  });

  testWidgets('CA_015_04 solo se ofrecen seis días', (tester) async {
    await montarFormulario(tester, oficioClave: 'mec');
    _contenedor(tester).read(solicitudControllerProvider.notifier)
      ..cambiarDescripcion('Descripción suficiente')
      ..siguiente();
    await tester.tap(find.text('Agregar foto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    // Seis días y tres franjas, todos chips.
    expect(find.byType(ChoiceChip), findsNWidgets(9));
  });

  testWidgets('CA_015_05 en taller no se pide dirección y se avisa', (
    tester,
  ) async {
    await montarFormulario(tester, oficioClave: 'mec');
    await tester.tap(find.text('Agregar foto'));
    await tester.pumpAndSettle();
    await _escribir(tester, 'Descripción suficiente');
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    expect(find.text('Llevarás tu auto al taller'), findsOneWidget);
    expect(find.text('Calle y número'), findsNothing);
  });

  testWidgets('CA_015_17 a domicilio pide calle y número', (tester) async {
    await montarFormulario(tester, oficioClave: 'ele');
    await tester.tap(find.text('Agregar foto'));
    await tester.pumpAndSettle();
    await _escribir(tester, 'Se botó la luz en la sala');
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    expect(find.text('Calle y número'), findsOneWidget);
    await tester.tap(find.byType(ChoiceChip).first);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Noche'));
    await tester.pump();
    await _escribir(tester, '1234567');
    await tester.tap(find.text('Enviar'));
    await tester.pump();
    expect(find.text('Escribe al menos 8 caracteres.'), findsOneWidget);
  });

  testWidgets('CA_015_24 desde un oficio concreto no se muestra el paso 1', (
    tester,
  ) async {
    await montarFormulario(tester, oficioClave: 'mec');
    expect(find.text('Paso 2 de 3: qué pasa'), findsOneWidget);
    expect(find.text('¿Qué oficio necesitas?'), findsNothing);
  });

  testWidgets('CA_015_16 los controles tienen etiqueta y 48 dp', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await montarFormulario(tester, oficioClave: 'ele');
    await tester.tap(find.text('Agregar foto'));
    await tester.pumpAndSettle();
    await expectAccesible(tester);

    await _escribir(tester, 'Se botó la luz en la sala');
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    await expectAccesible(tester);
    semantica.dispose();
  });

  testWidgets('CA_015_16 con el texto al 200 % no se corta el contenido', (
    tester,
  ) async {
    await montarFormulario(tester, oficioClave: 'ele', escalaDeTexto: 2);
    await tester.tap(find.text('Agregar foto'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Siguiente'), findsOneWidget);
  });

  testWidgets('CA_015_01 sin zona guardada avisa y no envía', (tester) async {
    await montarFormulario(tester, oficioClave: 'mec', colonia: null);
    await tester.tap(find.text('Agregar foto'));
    await tester.pumpAndSettle();
    await _escribir(tester, 'Descripción suficiente');
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ChoiceChip).first);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Tarde'));
    await tester.pump();
    await tester.tap(find.text('Enviar'));
    await tester.pump();
    expect(
      find.text('Elige tu zona para pedir una cotización.'),
      findsOneWidget,
    );
  });
}
