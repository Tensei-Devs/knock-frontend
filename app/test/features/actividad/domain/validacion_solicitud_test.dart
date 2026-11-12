import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Descripción (R-02)', () {
    test('CA_015_02 con menos de 8 caracteres no es válida', () {
      expect(validarDescripcion('1234567'), ErrorDescripcion.corta);
      expect(validarDescripcion('        '), ErrorDescripcion.corta);
      expect(validarDescripcion(''), ErrorDescripcion.corta);
    });

    test('CA_015_02 con más de 500 caracteres no es válida', () {
      expect(validarDescripcion('a' * 501), ErrorDescripcion.larga);
    });

    test('CA_015_02 de 8 a 500 caracteres sí es válida', () {
      expect(validarDescripcion('a' * 8), isNull);
      expect(validarDescripcion('a' * 500), isNull);
    });

    test('CA_015_02 los espacios de los extremos no cuentan', () {
      expect(validarDescripcion('  1234567  '), ErrorDescripcion.corta);
      expect(validarDescripcion('  12345678  '), isNull);
    });
  });

  group('Día (R-04)', () {
    final hoy = DateTime(2026, 11, 11, 15, 30);

    test('CA_015_04 solo se ofrecen 6 días: hoy y los 5 siguientes', () {
      final dias = diasDisponibles(hoy);
      expect(dias, hasLength(6));
      expect(dias.first, DateTime(2026, 11, 11));
      expect(dias.last, DateTime(2026, 11, 16));
    });

    test('CA_015_04 un día anterior a hoy no se puede elegir', () {
      expect(diaPermitido(DateTime(2026, 11, 10), hoy), isFalse);
    });

    test('CA_015_04 un día posterior a hoy más 5 no se puede elegir', () {
      expect(diaPermitido(DateTime(2026, 11, 17), hoy), isFalse);
    });

    test('CA_015_04 hoy y hoy más 5 sí se pueden elegir', () {
      expect(diaPermitido(DateTime(2026, 11, 11, 23, 59), hoy), isTrue);
      expect(diaPermitido(DateTime(2026, 11, 16), hoy), isTrue);
    });

    test('CA_015_04 el día se manda como AAAA-MM-DD', () {
      expect(diaParaContrato(DateTime(2026, 3, 5, 18)), '2026-03-05');
    });
  });

  group('Dirección (R-05)', () {
    test('CA_015_17 con 7 caracteres no avanza', () {
      expect(validarDireccion('a' * 7), ErrorDireccion.corta);
    });

    test('CA_015_17 con 201 caracteres no avanza', () {
      expect(validarDireccion('a' * 201), ErrorDireccion.larga);
    });

    test('CA_015_17 de 8 a 200 caracteres sí avanza', () {
      expect(validarDireccion('a' * 8), isNull);
      expect(validarDireccion('a' * 200), isNull);
    });
  });

  group('Fotos (R-03)', () {
    test('CA_015_03 sin fotos falta al menos una', () {
      expect(validarCantidadDeFotos(0), ErrorFotos.falta);
    });

    test('CA_015_03 el máximo es 5 y la sexta se rechaza', () {
      expect(validarCantidadDeFotos(1), isNull);
      expect(validarCantidadDeFotos(5), isNull);
      expect(validarCantidadDeFotos(6), ErrorFotos.maximo);
      expect(puedeAgregarFoto(4), isTrue);
      expect(puedeAgregarFoto(5), isFalse);
    });
  });

  group('Franja (R-04)', () {
    test(
      'CA_015_23 la franja viaja con el valor del contrato en minúsculas',
      () {
        expect(Franja.manana.valor, 'manana');
        expect(Franja.tarde.valor, 'tarde');
        expect(Franja.noche.valor, 'noche');
        expect(Franja.desdeValor('tarde'), Franja.tarde);
        expect(Franja.desdeValor('otra'), isNull);
      },
    );
  });
}
