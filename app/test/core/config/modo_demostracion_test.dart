// Spec 027, R-11: la bandera de demostración solo vale fuera de `release`.
import 'package:app/core/config/modo_demostracion.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CA_027_25 sin la bandera la demostración nunca está activa', () {
    expect(demoActivo(bandera: false, esRelease: false), isFalse);
    expect(demoActivo(bandera: false, esRelease: true), isFalse);
  });

  test('CA_027_27 en release la bandera se ignora siempre', () {
    expect(demoActivo(bandera: true, esRelease: true), isFalse);
  });

  test('CA_027_26 fuera de release la bandera activa la demostración', () {
    expect(demoActivo(bandera: true, esRelease: false), isTrue);
  });

  test('CA_027_25 sin --dart-define la constante de compilación es falsa', () {
    expect(demoDatosActivo, isFalse);
  });

  test('CA_027_28 los datos de ejemplo no traen celular ni dirección', () {
    final campos = [
      coloniaDeEjemplo,
      for (final e in expertosDeEjemplo) ...[e.nombre, e.oficio],
    ].join(' ');
    expect(campos, isNot(matches(RegExp(r'\d{7,}'))));
    expect(campos.toLowerCase(), isNot(contains('calle')));
    expect(campos.toLowerCase(), isNot(contains('@')));
    for (final e in expertosDeEjemplo) {
      expect(
        e.nombre,
        contains('Muestra'),
        reason: 'nombre claramente ficticio',
      );
      expect(e.x, inInclusiveRange(0, 1), reason: 'fracción, no coordenada');
      expect(e.y, inInclusiveRange(0, 1));
    }
  });
}
