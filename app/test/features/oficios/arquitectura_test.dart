import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Los `import` de un archivo Dart.
final _importacion = RegExp(
  r'''^\s*import\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

List<String> _importsDe(File archivo) => [
  for (final m in _importacion.allMatches(archivo.readAsStringSync()))
    m.group(1)!,
];

List<File> _archivosDe(String carpeta) {
  final directorio = Directory(carpeta);
  if (!directorio.existsSync()) {
    return const [];
  }
  return directorio
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}

String _normalizada(String ruta) => ruta.replaceAll(r'\', '/');

/// Reglas de capas de la feature `oficios` (constitución y skill
/// `flutter-clean-architecture`). `flutter test` corre desde `app/`.
void main() {
  const base = 'lib/features/oficios';

  test(
    'TC-TT-PRU-02-08 domain no importa flutter, dio, riverpod ni knock_api',
    () {
      final archivos = _archivosDe('$base/domain');
      expect(archivos, isNotEmpty, reason: 'la prueba debe encontrar archivos');

      for (final archivo in archivos) {
        for (final import in _importsDe(archivo)) {
          for (final prohibido in [
            'package:flutter/',
            'package:flutter_riverpod',
            'package:riverpod',
            'package:dio',
            'package:knock_api',
            'dart:ui',
          ]) {
            expect(
              import.startsWith(prohibido),
              isFalse,
              reason: '${_normalizada(archivo.path)} importa $import',
            );
          }
        }
      }
    },
  );

  test('TC-TT-PRU-02-08 presentation no importa dio, knock_api ni data', () {
    final archivos = _archivosDe('$base/presentation');
    expect(archivos, isNotEmpty, reason: 'la prueba debe encontrar archivos');

    for (final archivo in archivos) {
      for (final import in _importsDe(archivo)) {
        expect(
          import.startsWith('package:dio') ||
              import.startsWith('package:knock_api') ||
              import.contains('oficios/data/') ||
              import.startsWith('../data/') ||
              import.startsWith('data/'),
          isFalse,
          reason: '${_normalizada(archivo.path)} importa $import',
        );
      }
    }
  });

  test(
    'TC-TT-PRU-02-08 ninguna otra feature usa domain ni data de oficios',
    () {
      final otras = Directory('lib/features')
          .listSync()
          .whereType<Directory>()
          .where((d) => !_normalizada(d.path).endsWith('/oficios'));

      for (final feature in otras) {
        for (final archivo in _archivosDe(feature.path)) {
          for (final import in _importsDe(archivo)) {
            expect(
              import.contains('features/oficios/domain/') ||
                  import.contains('features/oficios/data/'),
              isFalse,
              reason: '${_normalizada(archivo.path)} importa $import',
            );
          }
        }
      }
    },
  );
}
