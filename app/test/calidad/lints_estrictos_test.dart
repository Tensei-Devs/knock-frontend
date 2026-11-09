// Spec 008 · CA-01 y R-01: un hallazgo del analizador hace fallar el CI, y la
// configuración estricta no se debilita en silencio.
//
// El análisis lo corre `flutter analyze --fatal-infos --fatal-warnings` en el
// job de la app (ci-pr.yml); esta prueba vigila que la configuración que lo
// vuelve estricto siga ahí (amenaza «reglas debilitadas», spec §6).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final opciones = File('analysis_options.yaml').readAsStringSync();
  final workflow = File('../.github/workflows/ci-pr.yml').readAsStringSync();

  test('CA_008_01 el analizador usa flutter_lints y tipos estrictos', () {
    expect(opciones, contains('include: package:flutter_lints/flutter.yaml'));
    for (final ajuste in [
      'strict-casts: true',
      'strict-inference: true',
      'strict-raw-types: true',
    ]) {
      expect(opciones, contains(ajuste), reason: ajuste);
    }
  });

  test('CA_008_01 las reglas estrictas están activas', () {
    final reglas = RegExp(
      r'^\s{4}(\w+): true\s*$',
      multiLine: true,
    ).allMatches(opciones).map((m) => m.group(1)!).toSet();
    for (final regla in [
      'avoid_print',
      'avoid_dynamic_calls',
      'unawaited_futures',
      'discarded_futures',
      'use_build_context_synchronously',
      'avoid_catches_without_on_clauses',
      'only_throw_errors',
      'prefer_final_fields',
      'use_super_parameters',
    ]) {
      expect(reglas, contains(regla), reason: regla);
    }
  });

  test('CA_008_01 ninguna regla se apaga y los errores no se rebajan', () {
    expect(opciones, isNot(contains(': false')));
    expect(opciones, isNot(contains(': ignore')));
    expect(opciones, contains('missing_required_param: error'));
    expect(opciones, contains('missing_return: error'));
  });

  test('CA_008_01 el CI falla ante cualquier hallazgo del analizador', () {
    expect(
      workflow,
      contains('flutter analyze --fatal-infos --fatal-warnings'),
    );
    expect(workflow, isNot(contains('continue-on-error: true')));
  });
}
