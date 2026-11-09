import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Los `import` de un archivo Dart.
final _importacion = RegExp(
  r'''^\s*import\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

/// Llamadas que escriben a la consola o al log del sistema.
final _registro = RegExp(r'\b(print|debugPrint|log|developer\.log)\s*\(');

List<File> _archivosDe(String carpeta) =>
    Directory(carpeta)
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

String _normalizada(String ruta) => ruta.replaceAll(r'\', '/');

/// Privacidad de la entrada (spec HU-001 §6). `flutter test` corre desde
/// `app/`.
void main() {
  const base = 'lib/features/entrada';

  test('TC-HU-001-07 entrada no importa red, almacenamiento ni el cliente de la API', () {
    final archivos = _archivosDe(base);
    expect(archivos, isNotEmpty, reason: 'la prueba debe encontrar archivos');

    for (final archivo in archivos) {
      final fuente = archivo.readAsStringSync();
      for (final m in _importacion.allMatches(fuente)) {
        final import = m.group(1)!;
        for (final prohibido in [
          'dart:io',
          'dart:developer',
          'package:http',
          'package:dio',
          'package:knock_api',
          'package:shared_preferences',
          'package:flutter_secure_storage',
        ]) {
          expect(
            import.startsWith(prohibido),
            isFalse,
            reason: '${_normalizada(archivo.path)} importa $import',
          );
        }
      }
      expect(
        fuente.contains('HttpClient'),
        isFalse,
        reason: '${_normalizada(archivo.path)} usa HttpClient',
      );
    }
  });

  test('TC-HU-001-07 entrada no registra nada (ni celular ni código)', () {
    for (final archivo in _archivosDe(base)) {
      final coincidencias = _registro
          .allMatches(archivo.readAsStringSync())
          .map((m) => m.group(0));
      expect(
        coincidencias,
        isEmpty,
        reason: '${_normalizada(archivo.path)} registra en consola',
      );
    }
  });

  test('TC-HU-001-07 domain es Dart puro (sin flutter ni riverpod)', () {
    final archivos = _archivosDe('$base/domain');
    expect(archivos, isNotEmpty, reason: 'la prueba debe encontrar archivos');

    for (final archivo in archivos) {
      for (final m in _importacion.allMatches(archivo.readAsStringSync())) {
        final import = m.group(1)!;
        expect(
          import.startsWith('package:') || import.startsWith('dart:ui'),
          isFalse,
          reason: '${_normalizada(archivo.path)} importa $import',
        );
      }
    }
  });

  test('TC-HU-001-07 la detección encuentra un registro si lo hubiera', () {
    // Control de la propia prueba: la expresión sí reconoce las llamadas.
    expect(_registro.hasMatch("debugPrint('x');"), isTrue);
    expect(_registro.hasMatch('print(celular);'), isTrue);
    expect(_registro.hasMatch('developer.log(codigo);'), isTrue);
    expect(_registro.hasMatch('final login = 1;'), isFalse);
  });
}
