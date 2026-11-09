import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Un `import` o `export` de `shared_preferences`.
final _usaSharedPreferences = RegExp(
  r'''^\s*(import|export)\s+['"]package:shared_preferences/''',
  multiLine: true,
);

/// Solo `core/preferencias/` (y la caché de solo lectura `core/cache/`, spec 010)
/// toca `shared_preferences` (HU-052 TC-06): el
/// almacenamiento no está cifrado y no debe usarse para nada más. Mismo
/// método que `features/oficios/arquitectura_test.dart` (leer los `import`).
/// `flutter test` corre desde `app/`.
void main() {
  test('TC-HU-052-06 solo core/preferencias importa shared_preferences', () {
    final usan = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => _usaSharedPreferences.hasMatch(f.readAsStringSync()))
        .map((f) => f.path.replaceAll(r'\', '/'))
        .toList();

    // La prueba debe encontrar el uso permitido (no pasa por estar vacía).
    expect(usan, isNotEmpty);
    for (final ruta in usan) {
      expect(
        ruta.startsWith('lib/core/preferencias/') ||
            ruta.startsWith('lib/core/cache/'),
        isTrue,
        reason: ruta,
      );
    }
  });
}
