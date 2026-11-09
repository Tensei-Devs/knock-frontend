import 'package:app/core/red/configuracion_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('acepta https y quita la diagonal final', () {
    expect(
      normalizarUrlApi('https://api.ejemplo.test/'),
      'https://api.ejemplo.test',
    );
    expect(
      normalizarUrlApi(' https://api.ejemplo.test '),
      'https://api.ejemplo.test',
    );
  });

  test('acepta http solo hacia la máquina local o el emulador', () {
    expect(normalizarUrlApi('http://10.0.2.2:5000'), 'http://10.0.2.2:5000');
    expect(normalizarUrlApi('http://localhost:5000'), 'http://localhost:5000');
    expect(normalizarUrlApi('http://api.ejemplo.test'), isNull);
  });

  test('rechaza vacío, sin host, con credenciales, consulta o fragmento', () {
    for (final url in [
      '',
      'api.ejemplo.test',
      'https://usuario:clave@api.ejemplo.test',
      'https://api.ejemplo.test?x=1',
      'https://api.ejemplo.test#a',
      'ftp://api.ejemplo.test',
    ]) {
      expect(normalizarUrlApi(url), isNull, reason: url);
    }
  });
}
