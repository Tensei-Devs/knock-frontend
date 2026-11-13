// Spec 028 (KNOCK-260): la dirección del aviso de privacidad que abre la app.
import 'package:app/core/config/aviso_de_privacidad.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dirección del aviso de privacidad', () {
    test('CA_028_03 por defecto es la página https de la landing', () {
      expect(
        avisoDePrivacidadPorDefecto,
        'https://knock-frontend-production.up.railway.app/privacidad/',
      );
      expect(direccionDelAvisoDePrivacidad(), avisoDePrivacidadPorDefecto);
      expect(urlDelAvisoDePrivacidad.scheme, 'https');
      expect(urlDelAvisoDePrivacidad.path, '/privacidad/');
    });

    test('CA_028_03 una dirección https sustituida se respeta', () {
      expect(
        direccionDelAvisoDePrivacidad('https://knock.example/privacidad/'),
        'https://knock.example/privacidad/',
      );
    });

    test(
      'CA_028_03 lo que no es https se ignora y se usa la de por defecto',
      () {
        for (final mala in [
          '',
          '   ',
          'http://knock.example/privacidad/',
          'ftp://knock.example/privacidad/',
          'javascript:alert(1)',
          'file:///sdcard/privacidad.html',
          'knock.example/privacidad/',
          'https://',
          'https://usuario:clave@knock.example/privacidad/',
          '%%%',
        ]) {
          expect(
            direccionDelAvisoDePrivacidad(mala),
            avisoDePrivacidadPorDefecto,
            reason: 'debía ignorar «$mala»',
          );
        }
      },
    );

    test(
      'CA_028_05 la dirección no lleva celular, token ni identificadores',
      () {
        final direccion = urlDelAvisoDePrivacidad;
        expect(direccion.hasQuery, isFalse);
        expect(direccion.hasFragment, isFalse);
        expect(direccion.userInfo, isEmpty);
        expect(direccion.hasPort, isFalse);
        // Solo dominio y ruta fija: nada que dependa de la persona.
        expect(
          direccion.toString(),
          isNot(matches(RegExp(r'\d{10}|token|id=|uid|celular|phone'))),
        );
      },
    );
  });
}
