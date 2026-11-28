// Spec 036, enmienda 2026-11-27 (perfil propio): `GET` y `PUT
// /api/v1/tecnicos/me` (TEC-15 y TEC-08). Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/tecnico/data/mi_perfil_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/mi_perfil_json.dart';

MiPerfilRepositoryApi _repo(ApiFalsa api) =>
    MiPerfilRepositoryApi(transporte: api.cliente, url: urlApiPrueba);

void main() {
  test('CA_036_G01 lee el perfil propio con lo que la edición usa', () async {
    final api = ApiFalsa((_) => jsonOk(miPerfilJson()));

    final perfil = await _repo(api).leer();

    expect(api.llamadas, ['GET tecnicos/me']);
    expect(perfil.id, '64b7f0c2a1b2c3d4e5f60718');
    expect(perfil.nombre, 'Ana Ficticia Pérez');
    expect(perfil.atencion, 'domicilio');
    expect(perfil.radioKm, 8);
    expect(perfil.nombreNegocio, 'Plomería Ficticia');
    expect(perfil.anios, 6);
    expect(perfil.descripcion, 'Reparo fugas y calentadores.');
    expect(perfil.direccionTaller, isNull);
  });

  test('CA_036_G02 sin perfil de técnico la lectura falla con 404', () async {
    final api = ApiFalsa((_) => http.Response('', 404));

    await expectLater(_repo(api).leer(), throwsA(isA<NoEncontradoFailure>()));
  });

  test('CA_036_31 un 401 llega como NoAutorizadoFailure', () async {
    final api = ApiFalsa((_) => http.Response('', 401));

    await expectLater(_repo(api).leer(), throwsA(isA<NoAutorizadoFailure>()));
    await expectLater(
      _repo(api).guardar(const {'nombre': 'Ana Ficticia'}),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test('CA_036_30 CA_036_G01 guarda solo el cuerpo que recibe', () async {
    final api = ApiFalsa((_) => jsonOk(miPerfilJson()));

    await _repo(api).guardar(const {'anios': 7});

    expect(api.llamadas, ['PUT tecnicos/me']);
    expect(api.peticiones.single.json, {'anios': 7});
  });

  test('CA_036_32 un 422 se distingue de un oficio retirado', () async {
    MiPerfilRepositoryApi con(String code) => _repo(
      ApiFalsa(
        (_) => jsonOk({
          'code': code,
          'errors': {
            'oficios': [code],
          },
        }, estado: 422),
      ),
    );

    await expectLater(
      con('validation_failed').guardar(const {'anios': 99}),
      throwsA(isA<DatosRechazadosFailure>()),
    );
    await expectLater(
      con('trade_invalid').guardar(const {'oficios': <String>[]}),
      throwsA(isA<OpcionNoDisponibleFailure>()),
    );
  });

  group('CA_036_G01 cambiosDelPerfil lleva solo lo que cambió', () {
    final original = miPerfilDesdeJson(miPerfilJson());
    EdicionPerfil igual() => EdicionPerfil.desde(original);

    test('sin cambios el cuerpo queda vacío', () {
      expect(cambiosDelPerfil(original, igual()), isEmpty);
    });

    test('los espacios de más no cuentan como cambio', () {
      final e = igual()..nombre = '  Ana Ficticia Pérez ';
      expect(cambiosDelPerfil(original, e), isEmpty);
    });

    test('cada campo cambiado va con su nombre del contrato', () {
      final e = igual()
        ..nombre = 'Ana Ficticia López'
        ..nombreNegocio = 'Fugas Ficticias'
        ..anios = '7'
        ..descripcion = 'Reparo fugas.'
        ..radioKm = 12;
      expect(cambiosDelPerfil(original, e), {
        'nombre': 'Ana Ficticia López',
        'nombreNegocio': 'Fugas Ficticias',
        'anios': 7,
        'descripcion': 'Reparo fugas.',
        'radioKm': 12,
      });
    });

    test('a domicilio no envía dirección de taller', () {
      final e = igual()..direccionTaller = 'Calle Ficticia 12, Centro';
      expect(cambiosDelPerfil(original, e), isEmpty);
    });

    test('en taller envía la dirección y nunca el radio', () {
      final taller = miPerfilDesdeJson(
        miPerfilJson(atencion: 'taller', radioKm: null),
      );
      final e = EdicionPerfil.desde(taller)
        ..direccionTaller = 'Calle Ficticia 12, Centro'
        ..radioKm = 5;
      expect(cambiosDelPerfil(taller, e), {
        'direccionTaller': 'Calle Ficticia 12, Centro',
      });
    });
  });

  group('CA_036_32 erroresDeEdicion valida antes de enviar', () {
    final original = miPerfilDesdeJson(miPerfilJson());

    test('sin errores con los datos guardados', () {
      expect(erroresDeEdicion(EdicionPerfil.desde(original)), isEmpty);
    });

    test('marca cada campo fuera de las reglas del servidor', () {
      final e = EdicionPerfil.desde(original)
        ..nombre = 'A'
        ..anios = '61'
        ..nombreNegocio = 'x' * 61
        ..descripcion = 'x' * 301;
      expect(erroresDeEdicion(e).keys, {
        CampoPerfil.nombre,
        CampoPerfil.anios,
        CampoPerfil.nombreNegocio,
        CampoPerfil.descripcion,
      });
    });

    test('años que no son número también se marcan', () {
      final e = EdicionPerfil.desde(original)..anios = 'seis';
      expect(erroresDeEdicion(e).keys, {CampoPerfil.anios});
    });
  });
}
