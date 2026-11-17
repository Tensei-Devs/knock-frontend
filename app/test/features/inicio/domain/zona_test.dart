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

  test('CA_017_05 valida municipio opcional y caracteres permitidos', () {
    expect(esMunicipioValido(null), isTrue);
    for (final valor in ['Á', "San José. O'Connor-Norte", 'a' * 100]) {
      expect(esMunicipioValido(valor), isTrue, reason: valor);
    }
    for (final valor in ['', 'a' * 101, 'Zona1', 'Lugar\n', 'Lugar/otro']) {
      expect(esMunicipioValido(valor), isFalse, reason: valor);
    }
  });

  test('CA_017_12 conserva cobertura del servidor sin decidir por CP', () {
    final colonias = <Colonia>[];
    final resultado = ResultadoZona(
      enCobertura: false,
      ciudadPiloto: 'Ciudad piloto',
      colonias: colonias,
    );
    colonias.add(
      const Colonia(
        id: '1',
        nombre: 'Ejemplo',
        cp: '42000',
        municipio: 'Ejemplo',
      ),
    );
    expect(resultado.enCobertura, isFalse);
    expect(resultado.ciudadPiloto, 'Ciudad piloto');
    expect(resultado.colonias, isEmpty);
    expect(
      () => resultado.colonias.add(colonias.first),
      throwsUnsupportedError,
    );
  });

  test('CA_017_05 conserva solo los datos del registro y la zona', () {
    const zona = Zona(
      coloniaId: '1',
      nombre: 'Ejemplo',
      cp: '00001',
      municipio: 'Ejemplo',
    );
    final fecha = DateTime.utc(2026);
    final registro = RegistroListaEspera(
      cp: zona.cp,
      creadoEn: fecha,
      yaRegistrado: true,
    );
    expect(
      [zona.coloniaId, zona.nombre, zona.cp, zona.municipio],
      ['1', 'Ejemplo', '00001', 'Ejemplo'],
    );
    expect(registro.cp, '00001');
    expect(registro.municipio, isNull);
    expect(registro.creadoEn, fecha);
    expect(registro.yaRegistrado, isTrue);
  });
}
