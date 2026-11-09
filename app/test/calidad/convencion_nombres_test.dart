// Spec 008 · R-02 y R-03: convenciones de nombres de las pruebas.
//
// - Los archivos de prueba terminan en `_test.dart`; lo que no es una prueba
//   (dobles, montadores) vive en `test/soporte/` o se llama `fakes_*.dart`.
// - El nombre de una prueba de criterio empieza con su id: `CA_NNN_KK ...`
//   (NNN = número de la spec, KK = criterio), que es lo que busca
//   `python scripts/sdd_lint.py --trace NNN`. Las pruebas de historias usan
//   `TC-HU-NNN-KK ...` o `TC-TT-XXX-NN ...`.
// - El código y los comentarios técnicos van en inglés cuando los escribe una
//   herramienta; los textos de la interfaz y las specs, en español.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final archivos = Directory('test')
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.path.replaceAll(r'\', '/'))
      .where((p) => p.endsWith('.dart'))
      .toList();

  test('R_008_03 los archivos de prueba terminan en _test.dart', () {
    final ajenos = archivos.where((p) {
      final nombre = p.split('/').last;
      return !nombre.endsWith('_test.dart') &&
          !p.startsWith('test/soporte/') &&
          !nombre.startsWith('fakes_');
    });
    expect(ajenos, isEmpty);
  });

  test('R_008_03 las pruebas de test/calidad citan el id del criterio', () {
    final abre = RegExp(r"(?:test|testWidgets)\(\s*'([^']*)'");
    final propias = archivos.where(
      (p) =>
          p.startsWith('test/calidad/') &&
          !p.endsWith('convencion_nombres_test.dart'),
    );
    for (final ruta in propias) {
      final nombres = abre
          .allMatches(File(ruta).readAsStringSync())
          .map((m) => m.group(1)!);
      expect(nombres, isNotEmpty, reason: ruta);
      for (final nombre in nombres) {
        expect(nombre, matches(RegExp(r'^CA_\d{3}_\d{2} ')), reason: ruta);
      }
    }
  });
}
