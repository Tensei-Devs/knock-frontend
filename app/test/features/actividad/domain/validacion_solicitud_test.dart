import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CA_015_02 descripción de 8 a 500 caracteres', () {
    test('CA_015_02 acepta los límites exactos 8 y 500', () {
      expect(validarDescripcion('a' * 8), isNull);
      expect(validarDescripcion('a' * 500), isNull);
    });

    test('CA_015_02 rechaza 7 por corta y 501 por larga', () {
      expect(validarDescripcion('a' * 7), ErrorDeLargo.corto);
      expect(validarDescripcion('a' * 501), ErrorDeLargo.largo);
    });

    test('CA_015_02 no cuenta los espacios de los extremos', () {
      expect(validarDescripcion('   gotea    '), ErrorDeLargo.corto);
      expect(validarDescripcion('  ${'a' * 8}  '), isNull);
    });

    test('CA_015_02 cuenta un emoji como un solo carácter', () {
      // 7 letras + 1 emoji = 8 caracteres visibles (9 unidades UTF-16).
      expect(validarDescripcion('fuga ok💧'), isNull);
      expect(largoVisible('💧'), 1);
    });
  });

  group('CA_015_04 día de hoy a hoy + 5', () {
    final hoy = DateTime(2026, 11, 10, 23, 59);

    test('CA_015_04 ofrece exactamente seis días, empezando hoy', () {
      final dias = diasPermitidos(hoy);

      expect(dias, hasLength(6));
      expect(dias.first, DateTime(2026, 11, 10));
      expect(dias.last, DateTime(2026, 11, 15));
    });

    test('CA_015_04 acepta hoy y hoy + 5, rechaza ayer y hoy + 6', () {
      expect(esDiaPermitido(DateTime(2026, 11, 10, 8), hoy), isTrue);
      expect(esDiaPermitido(DateTime(2026, 11, 15), hoy), isTrue);
      expect(esDiaPermitido(DateTime(2026, 11, 9), hoy), isFalse);
      expect(esDiaPermitido(DateTime(2026, 11, 16), hoy), isFalse);
    });

    test('CA_015_04 cruza el fin de mes y de año sin saltar días', () {
      final dias = diasPermitidos(DateTime(2026, 12, 29));

      expect(dias.last, DateTime(2027, 1, 3));
      expect(dias.map(diaDelContrato), [
        '2026-12-29',
        '2026-12-30',
        '2026-12-31',
        '2027-01-01',
        '2027-01-02',
        '2027-01-03',
      ]);
    });
  });

  group('CA_015_17 dirección a domicilio de 8 a 200 caracteres', () {
    test('CA_015_17 acepta 8 y 200', () {
      expect(validarDireccion('a' * 8), isNull);
      expect(validarDireccion('a' * 200), isNull);
    });

    test('CA_015_17 rechaza 7 y 201', () {
      expect(validarDireccion('a' * 7), ErrorDeLargo.corto);
      expect(validarDireccion('a' * 201), ErrorDeLargo.largo);
    });
  });

  group('CA_015_03 de 1 a 5 fotos', () {
    test('CA_015_03 sin fotos faltan; con 6 sobran; de 1 a 5 está bien', () {
      expect(validarCantidadDeFotos(0), ErrorDeFotos.faltan);
      expect(validarCantidadDeFotos(1), isNull);
      expect(validarCantidadDeFotos(5), isNull);
      expect(validarCantidadDeFotos(6), ErrorDeFotos.sobran);
    });

    test('CA_015_03 no deja agregar una sexta', () {
      expect(puedeAgregarFoto(4), isTrue);
      expect(puedeAgregarFoto(5), isFalse);
    });
  });
}
