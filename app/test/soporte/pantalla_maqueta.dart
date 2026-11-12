import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Teléfono angosto de la spec 014 (CA-04): 320 × 640 dp.
const Size telefonoAngosto = Size(320, 640);

/// Fija el tamaño de la pantalla y la escala del texto de la prueba y los
/// restablece al terminar. Llamar **antes** de montar.
void fijarPantalla(
  WidgetTester tester, {
  Size tamano = telefonoAngosto,
  double escalaDeTexto = 1,
}) {
  tester.view.physicalSize = tamano;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = escalaDeTexto;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);
}

/// Cambia el tema de la app montada y espera a que se asiente.
Future<void> usarTema(
  WidgetTester tester,
  ProviderContainer container,
  ThemeMode modo,
) async {
  container.read(preferenciasProvider.notifier).cambiarTema(modo);
  await tester.pumpAndSettle();
}

/// Monta [hijo] con los temas de Knock, sin router ni sesión, en [modo].
Future<void> montarSuelto(
  WidgetTester tester,
  Widget hijo, {
  required ThemeData claro,
  required ThemeData oscuro,
  ThemeMode modo = ThemeMode.light,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: claro,
      darkTheme: oscuro,
      themeMode: modo,
      home: Scaffold(body: hijo),
    ),
  );
  await tester.pumpAndSettle();
}
