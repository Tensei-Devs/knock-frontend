// Spec 045, R-01 (con la excepción acotada de `core/router`): el estado, los
// datos y la lógica simulada viven en `features/maqueta/`. Fuera de esa
// carpeta solo se importa su fachada, y solo la piden el router y la raíz.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _importaMaqueta = RegExp(
  r'''^\s*(?:import|export)\s+['"]package:app/features/maqueta/([^'"]+)['"]''',
  multiLine: true,
);

void main() {
  test('CA_045_04 fuera de features/maqueta solo se importa la fachada, y solo '
      'el router y la raíz', () {
    const permitidos = {'lib/core/router/app_router.dart', 'lib/app.dart'};
    final infracciones = <String>[];
    var importadores = 0;
    for (final f in Directory('lib').listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      final ruta = f.path.replaceAll(r'\', '/');
      if (ruta.startsWith('lib/features/maqueta/')) continue;
      for (final m in _importaMaqueta.allMatches(f.readAsStringSync())) {
        importadores++;
        if (m.group(1) != 'fachada_maqueta.dart' ||
            !permitidos.contains(ruta)) {
          infracciones.add('$ruta importa maqueta/${m.group(1)}');
        }
      }
    }
    expect(importadores, greaterThan(0), reason: 'la prueba no está vacía');
    expect(infracciones, isEmpty);
  });

  test('CA_045_04 el cascarón de la barra y el tema no conocen la maqueta', () {
    for (final ruta in [
      'lib/core/router/app_shell.dart',
      'lib/core/tema/tema.dart',
    ]) {
      expect(
        File(ruta).readAsStringSync(),
        isNot(contains('features/maqueta')),
      );
    }
  });
}
