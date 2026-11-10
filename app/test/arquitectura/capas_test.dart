import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Spec 001, R-03 y R-06: reglas de dependencia entre capas, leyendo los
/// `import`/`export` de `lib/features/*`. `flutter test` corre desde `app/`.

final _directiva = RegExp(
  r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

/// Lo que `domain/` no puede importar: Flutter, estado de Flutter y red.
const _prohibidoEnDomain = [
  'package:flutter/',
  'package:flutter_riverpod',
  'package:riverpod',
  'package:dio',
  'package:http/',
  'package:knock_api',
  'dart:ui',
  'dart:io',
  'dart:html',
];

const _features = ['inicio', 'explorar', 'actividad', 'trabajo', 'cuenta'];

String _norm(String ruta) => ruta.replaceAll(r'\', '/');

/// Imports de [codigo] que rompen la regla de `domain/` (sin Flutter ni red).
List<String> importsProhibidosEnDomain(String codigo) => [
  for (final m in _directiva.allMatches(codigo))
    if (_prohibidoEnDomain.any(m.group(1)!.startsWith)) m.group(1)!,
];

/// Imports de [codigo] que llegan a `data/` desde `presentation/`.
List<String> importsDeDataEnPresentation(String codigo) => [
  for (final m in _directiva.allMatches(codigo))
    if (RegExp(r'(^|/)data/').hasMatch(m.group(1)!)) m.group(1)!,
];

List<File> _dart(String carpeta) {
  final dir = Directory(carpeta);
  if (!dir.existsSync()) return const [];
  return dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}

/// Carpetas `lib/features/<f>/<capa>` de todas las funciones que existan.
List<String> _capas(String capa) => [
  for (final f in Directory('lib/features').listSync().whereType<Directory>())
    '${_norm(f.path)}/$capa',
];

void main() {
  test('CA_001_01 las cinco funciones existen con sus tres capas', () {
    for (final f in _features) {
      for (final capa in ['presentation', 'domain', 'data']) {
        expect(
          Directory('lib/features/$f/$capa').existsSync(),
          isTrue,
          reason: 'falta lib/features/$f/$capa',
        );
      }
    }
  });

  test('CA_001_02 domain no importa Flutter ni paquetes de red', () {
    final archivos = [for (final c in _capas('domain')) ..._dart(c)];
    expect(archivos, isNotEmpty, reason: 'la prueba debe encontrar archivos');
    for (final a in archivos) {
      expect(
        importsProhibidosEnDomain(a.readAsStringSync()),
        isEmpty,
        reason: _norm(a.path),
      );
    }
  });

  test('CA_001_02 la regla detecta un domain que importa Flutter', () {
    const malo = "import 'package:flutter/material.dart';\nclass A {}";
    const bueno = "import 'dart:async';\nclass A {}";
    expect(importsProhibidosEnDomain(malo), ['package:flutter/material.dart']);
    expect(importsProhibidosEnDomain(bueno), isEmpty);
  });

  test('CA_001_02 presentation no importa data', () {
    final archivos = [for (final c in _capas('presentation')) ..._dart(c)];
    expect(archivos, isNotEmpty, reason: 'la prueba debe encontrar archivos');
    for (final a in archivos) {
      expect(
        importsDeDataEnPresentation(a.readAsStringSync()),
        isEmpty,
        reason: _norm(a.path),
      );
    }
  });

  test('CA_001_02 la regla detecta una presentation que importa data', () {
    expect(
      importsDeDataEnPresentation(
        "import 'package:app/features/inicio/data/x.dart';",
      ),
      isNotEmpty,
    );
    expect(importsDeDataEnPresentation("import '../data/x.dart';"), isNotEmpty);
    expect(
      importsDeDataEnPresentation("import 'package:app/core/red/x.dart';"),
      isEmpty,
    );
  });
}
