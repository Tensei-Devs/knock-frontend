// Spec 028 (KNOCK-260), R-07: el manifiesto declara la consulta de `https` para
// abrir el aviso de privacidad y no agrega permisos al teléfono. `flutter test`
// corre desde `app/`.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final manifiesto = File('android/app/src/main/AndroidManifest.xml')
      .readAsStringSync();

  test('CA_028_09 declara la consulta de https dentro de queries', () {
    final queries = RegExp(
      r'<queries>(.*?)</queries>',
      dotAll: true,
    ).firstMatch(manifiesto);
    expect(queries, isNotNull, reason: 'debe haber un bloque <queries>');

    final vistas = RegExp(
      r'<intent>(?:(?!</intent>).)*?android\.intent\.action\.VIEW'
      r'(?:(?!</intent>).)*?android:scheme="https"(?:(?!</intent>).)*?</intent>',
      dotAll: true,
    );
    expect(vistas.hasMatch(queries!.group(1)!), isTrue);
  });

  test('CA_028_09 no agrega permisos nuevos al teléfono', () {
    final permisos = RegExp(r'<uses-permission\s+android:name="([^"]+)"')
        .allMatches(manifiesto)
        .map((m) => m.group(1))
        .toSet();

    expect(permisos, {
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.INTERNET',
    });
  });
}
