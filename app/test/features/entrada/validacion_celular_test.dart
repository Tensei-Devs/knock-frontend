import 'package:app/features/entrada/domain/validacion_entrada.dart';
import 'package:flutter_test/flutter_test.dart';

/// Solo números ficticios (spec §2, datos de prueba).
void main() {
  group('TC-HU-001-02 validación del celular (unitarias)', () {
    test('TC-HU-001-02 10 dígitos son un celular válido', () {
      expect(esCelularValido('5512345678'), isTrue);
      expect(esCelularValido('5500000000'), isTrue);
    });

    test('TC-HU-001-02 menos o más de 10 dígitos no son válidos', () {
      for (final celular in ['', '5', '551234567', '55123456789']) {
        expect(esCelularValido(celular), isFalse, reason: celular);
      }
    });

    test('TC-HU-001-02 caracteres que no son números no son válidos', () {
      for (final celular in [
        '55 1234 5678',
        '+525512345678',
        '55123456a8',
        '55-1234-567',
        '５５１２３４５６７８',
        ' 5512345678',
      ]) {
        expect(esCelularValido(celular), isFalse, reason: celular);
      }
    });
  });

  group('TC-HU-001-01 formato del celular', () {
    test('TC-HU-001-01 10 dígitos se muestran como 55 1234 5678', () {
      expect(formatearCelular('5512345678'), '55 1234 5678');
      expect(formatearCelular('5500000000'), '55 0000 0000');
    });

    test('TC-HU-001-01 un celular inválido se devuelve sin cambios', () {
      expect(formatearCelular('55123'), '55123');
    });
  });

  group('TC-HU-001-04 validación del código (unitarias)', () {
    test('TC-HU-001-04 solo 6 dígitos son un código válido', () {
      expect(esCodigoValido('123456'), isTrue);
      for (final codigo in ['', '12345', '1234567', '12345a', '123 45']) {
        expect(esCodigoValido(codigo), isFalse, reason: codigo);
      }
    });
  });
}
