import 'package:app/features/actividad/domain/fotos_permitidas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const dominios = {'archivos.knock.example'};

  group('CA_015_21 solo se pintan fotos https de dominios de Knock', () {
    test('CA_015_21 acepta https del dominio y de sus subdominios', () {
      expect(
        esFotoPermitida('https://archivos.knock.example/f/a1?sig=x', dominios),
        isTrue,
      );
      expect(
        esFotoPermitida('https://cdn.archivos.knock.example/f/a1', dominios),
        isTrue,
      );
    });

    test('CA_015_21 descarta http, otro dominio y dominios parecidos', () {
      for (final mala in [
        'http://archivos.knock.example/f/a1',
        'https://otro.example/f/a1',
        'https://archivos.knock.example.malo.example/f/a1',
        'https://malarchivos.knock.example/f/a1',
        'https://usuario@archivos.knock.example/f/a1',
        'https://archivos.knock.example:8443/f/a1',
        'file:///sdcard/a1.jpg',
        'javascript:alert(1)',
        '',
      ]) {
        expect(esFotoPermitida(mala, dominios), isFalse, reason: mala);
      }
    });

    test('CA_015_21 filtra una lista y conserva el orden', () {
      expect(
        fotosPermitidas([
          'https://archivos.knock.example/1',
          'https://otro.example/2',
          'https://archivos.knock.example/3',
        ], dominios),
        [
          'https://archivos.knock.example/1',
          'https://archivos.knock.example/3',
        ],
      );
    });

    test('CA_015_21 sin dominios configurados no se pinta nada', () {
      expect(esFotoPermitida('https://archivos.knock.example/1', {}), isFalse);
    });
  });
}
