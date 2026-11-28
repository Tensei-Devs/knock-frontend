import 'package:app/features/mensajes/domain/mensaje.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextoDeMensaje (regla del servidor, enmienda 2026-11-26)', () {
    test('CA_020_E02 acepta de 1 a 1000 caracteres', () {
      expect(TextoDeMensaje.validar('a'), isNull);
      expect(TextoDeMensaje.validar('a' * 1000), isNull);
      expect(TextoDeMensaje.validar('a' * 1001), MotivoTextoInvalido.muyLargo);
    });

    test('CA_020_E02 vacío o solo espacios no se envía', () {
      expect(TextoDeMensaje.validar(''), MotivoTextoInvalido.vacio);
      expect(TextoDeMensaje.validar('  \n '), MotivoTextoInvalido.vacio);
    });

    test('CA_020_E02 los espacios de los extremos no cuentan', () {
      expect(TextoDeMensaje.preparar('  hola \n'), 'hola');
      expect(TextoDeMensaje.validar('   ${'a' * 1000}   '), isNull);
    });

    test('CA_020_E02 cuenta unidades UTF-16 y respeta 4096 bytes', () {
      // Como `string.Length` del servidor: un emoji vale 2 unidades y 4 bytes.
      // Con 1000 unidades el texto nunca pasa de 3000 bytes, así que el tope
      // de bytes es un respaldo de la misma regla.
      final emoji = String.fromCharCode(0x1F600);
      expect(TextoDeMensaje.validar(emoji * 500), isNull);
      expect(TextoDeMensaje.validar(emoji * 501), MotivoTextoInvalido.muyLargo);
      expect(TextoDeMensaje.validar('€' * 1000), isNull);
      expect(TextoDeMensaje.maxBytes, 4096);
    });

    test('CA_020_E02 rechaza caracteres de control salvo el salto', () {
      expect(TextoDeMensaje.validar('hola\nadiós'), isNull);
      expect(TextoDeMensaje.validar('hola\r\nadiós'), isNull);
      expect(
        TextoDeMensaje.validar('hola\tadiós'),
        MotivoTextoInvalido.caracterNoPermitido,
      );
      expect(
        TextoDeMensaje.validar('a\u0000b'),
        MotivoTextoInvalido.caracterNoPermitido,
      );
      expect(
        TextoDeMensaje.validar('a\u007Fb'),
        MotivoTextoInvalido.caracterNoPermitido,
      );
      expect(
        TextoDeMensaje.validar('a\u0085b'),
        MotivoTextoInvalido.caracterNoPermitido,
      );
      expect(
        TextoDeMensaje.validar('a\rb'),
        MotivoTextoInvalido.caracterNoPermitido,
      );
    });
  });
}
