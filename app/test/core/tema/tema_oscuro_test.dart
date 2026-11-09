// Spec 002 (KNOCK-216), CA-03 y R-05: en modo oscuro la app usa los tokens del
// tema oscuro, y los widgets toman el color del tema (no colores fijos).
import 'dart:io';

import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/tema/colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';

void main() {
  testWidgets('CA-002-03 con tema oscuro la app usa los tokens oscuros', (
    tester,
  ) async {
    final c = await montarApp(tester, esTecnico: false);
    c.read(preferenciasProvider.notifier).cambiarTema(ThemeMode.dark);
    await tester.pumpAndSettle();

    final tema = Theme.of(tester.element(find.byType(Scaffold).first));
    expect(tema.brightness, Brightness.dark);
    expect(tema.colorScheme, esquemaOscuro);
    expect(tema.scaffoldBackgroundColor, esquemaOscuro.surface);
  });

  testWidgets('CA-002-03 con tema claro la app usa los tokens claros', (
    tester,
  ) async {
    final c = await montarApp(tester, esTecnico: false);
    c.read(preferenciasProvider.notifier).cambiarTema(ThemeMode.light);
    await tester.pumpAndSettle();

    final tema = Theme.of(tester.element(find.byType(Scaffold).first));
    expect(tema.colorScheme, esquemaClaro);
  });

  test('CA-002-03 R-05 ningún widget de lib usa colores fijos', () {
    final infractores = <String>[];
    final fijo = RegExp(r'Color\(0x|Colors\.(?!transparent)');
    // La pantalla de prueba del mapa (spike) es temporal y queda fuera.
    for (final f in Directory('lib').listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      final ruta = f.path.replaceAll(r'\', '/');
      if (ruta.contains('lib/core/tema/') ||
          ruta.contains('/generado/') ||
          ruta.contains('/presentation/spike/')) {
        continue;
      }
      if (fijo.hasMatch(f.readAsStringSync())) infractores.add(ruta);
    }
    expect(infractores, isEmpty, reason: 'colores fijos fuera del tema');
  });
}
