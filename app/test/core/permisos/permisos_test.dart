import 'dart:io';

import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:flutter_test/flutter_test.dart';

/// `flutter test` corre desde `app/`.
void main() {
  group('R-08 no se pide el permiso de contactos', () {
    test('R_012_08 la app no tiene un permiso de contactos', () {
      expect(
        PermisoApp.values.map((p) => p.name),
        isNot(anyElement(contains('contact'))),
      );
      expect(PermisoApp.values, hasLength(2));
    });

    test('R_012_08 ni el manifiesto ni el código lo mencionan', () {
      for (final manifiesto in [
        'android/app/src/main/AndroidManifest.xml',
        'android/app/src/debug/AndroidManifest.xml',
        'android/app/src/profile/AndroidManifest.xml',
      ]) {
        expect(
          File(manifiesto).readAsStringSync(),
          isNot(contains('READ_CONTACTS')),
          reason: manifiesto,
        );
      }
      final usan = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .where(
            (f) => RegExp(
              r'READ_CONTACTS|Permission\.contacts|package:(flutter_)?contacts',
            ).hasMatch(f.readAsStringSync()),
          );
      expect(usan, isEmpty);
    });
  });

  test('R_012_07 el gestor por defecto nunca concede un permiso', () async {
    const gestor = GestorPermisosNoDisponible();
    for (final permiso in PermisoApp.values) {
      expect((await gestor.estado(permiso)).concedida, isFalse);
      expect((await gestor.pedir(permiso)).concedida, isFalse);
    }
  });
}
