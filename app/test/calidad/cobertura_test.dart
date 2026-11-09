// Spec 008 · CA-03 y R-04: un PR que baja la cobertura del mínimo (50 % de
// líneas en la app) hace fallar el CI, y el umbral no se baja.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _script = '../scripts/check_coverage.py';

/// Ejecuta `check_coverage.py` sobre un lcov con `cubiertas` de 10 líneas.
/// Devuelve null si no hay Python disponible (la prueba se omite).
Future<int?> _correr(Directory tmp, int cubiertas) async {
  final lcov = File('${tmp.path}/lcov.info')
    ..writeAsStringSync('SF:lib/a.dart\nLF:10\nLH:$cubiertas\nend_of_record\n');
  for (final python in ['python3', 'python']) {
    try {
      final r = await Process.run(python, [
        _script,
        '--lcov',
        lcov.path,
        '--min',
        '50',
      ]);
      if (r.exitCode == 9009) continue; // «python» no existe en Windows
      return r.exitCode;
    } on ProcessException {
      continue;
    }
  }
  return null;
}

void main() {
  late Directory tmp;
  setUp(() => tmp = Directory.systemTemp.createTempSync('knock_cov'));
  tearDown(() => tmp.deleteSync(recursive: true));

  test('CA_008_03 el umbral rechaza una cobertura bajo el mínimo', () async {
    final codigo = await _correr(tmp, 4); // 40 % < 50 %
    if (codigo == null) {
      markTestSkipped('No hay Python en el PATH.');
      return;
    }
    expect(codigo, isNot(0));
  });

  test('CA_008_03 el umbral acepta una cobertura igual al mínimo', () async {
    final codigo = await _correr(tmp, 5); // 50 %
    if (codigo == null) {
      markTestSkipped('No hay Python en el PATH.');
      return;
    }
    expect(codigo, 0);
  });

  test('CA_008_03 el CI mide la cobertura y exige al menos 50 %', () {
    final workflow = File('../.github/workflows/ci-pr.yml').readAsStringSync();
    expect(workflow, contains('flutter test --coverage'));
    final umbral = RegExp(
      r'check_coverage\.py --lcov coverage/lcov\.info --min (\d+)',
    ).firstMatch(workflow);
    expect(umbral, isNotNull, reason: 'falta el paso del umbral de cobertura');
    expect(int.parse(umbral!.group(1)!), greaterThanOrEqualTo(50));
  });
}
