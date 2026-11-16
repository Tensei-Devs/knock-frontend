import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Spec 015, R-16 y CA-19: el borrador (`knock.*` en `shared_preferences`) y
/// la carpeta privada de fotos no entran en la copia de seguridad de Android.
/// Se cumple con `android:allowBackup="false"` en la aplicación.
/// `flutter test` corre desde `app/`.
void main() {
  test('CA_015_19 el manifiesto excluye la app de la copia de seguridad', () {
    final manifiesto = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    final aplicacion = RegExp(
      r'<application\b[^>]*>',
      dotAll: true,
    ).firstMatch(manifiesto)?.group(0);

    expect(aplicacion, isNotNull, reason: 'falta <application>');
    expect(aplicacion, contains('android:allowBackup="false"'));
    expect(aplicacion, contains('android:fullBackupContent="false"'));
  });
}
