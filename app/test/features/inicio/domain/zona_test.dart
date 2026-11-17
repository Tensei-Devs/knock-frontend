import 'package:app/features/inicio/domain/colonia.dart';
import 'package:app/features/inicio/domain/zona.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CA_017_08 valida cinco dígitos ASCII exactos', () {
    expect(esCodigoPostalValido('00001'), isTrue);
    for (final valor in [
      '',
      '1234',
      '123456',
      '12a45',
      '１２３４５',
      '12345\n',
      ' 12345',
    ]) {
      expect(esCodigoPostalValido(valor), isFalse, reason: valor);
    }
  });

  test('CA_017_12 conserva cobertura del servidor sin decidir por CP', () {
    const colonia = Colonia(
      id: '1',
      nombre: 'Ejemplo',
      cp: '42000',
      municipio: 'Ejemplo',
    );
    const resultado = ResultadoZona(
      enCobertura: false,
      ciudadPiloto: true,
      colonias: [colonia],
    );
    expect(resultado.enCobertura, isFalse);
    expect(resultado.ciudadPiloto, isTrue);
    expect(resultado.colonias, [colonia]);
  });

  test('CA_017_05 conserva los datos del registro', () {
    const registro = RegistroListaEspera(
      cp: '00001',
      yaRegistrado: true,
    );
    expect(registro.cp, '00001');
    expect(registro.yaRegistrado, isTrue);
  });
}
