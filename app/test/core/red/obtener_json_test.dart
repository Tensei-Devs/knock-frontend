import 'package:app/core/errores/failure.dart';
import 'package:app/features/inicio/data/colonias_repository_http.dart';
import 'package:app/features/oficios/data/oficios_repository_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _url = 'http://127.0.0.1:5000';

void main() {
  test(
    'CA-002-02 oficios llama a GET /api/v1/oficios y lee el contrato',
    () async {
      late Uri pedida;
      final cliente = MockClient((peticion) async {
        pedida = peticion.url;
        return http.Response(
          '[{"clave":"ele","nombre":"Electricidad","modalidad":"domicilio"}]',
          200,
        );
      });
      final oficios = await OficiosRepositoryHttp(
        transporte: cliente,
        url: _url,
      ).listar();
      expect(pedida.path, '/api/v1/oficios');
      expect(oficios.single.nombre, 'Electricidad');
    },
  );

  test('CA-002-02 colonias manda lat y lon y lee la colonia', () async {
    late Uri pedida;
    final cliente = MockClient((peticion) async {
      pedida = peticion.url;
      return http.Response(
        '{"enCobertura":true,"colonia":{"id":"1","nombre":"Centro",'
        '"cp":"42500","municipio":"Actopan"}}',
        200,
      );
    });
    final r = await ColoniasRepositoryHttp(
      transporte: cliente,
      url: _url,
    ).enPunto(latitud: 20.27, longitud: -98.94);
    expect(pedida.path, '/api/v1/colonias/en-punto');
    expect(pedida.queryParameters, {'lat': '20.270000', 'lon': '-98.940000'});
    expect(r.colonia!.nombre, 'Centro');
  });

  test('CA-002-02 fuera de cobertura llega sin colonia', () async {
    final cliente = MockClient(
      (_) async => http.Response('{"enCobertura":false,"colonia":null}', 200),
    );
    final r = await ColoniasRepositoryHttp(
      transporte: cliente,
      url: _url,
    ).enPunto(latitud: 0, longitud: 0);
    expect(r.enCobertura, isFalse);
    expect(r.colonia, isNull);
  });

  test(
    'CA-002-02 un 401 y un fallo de red llegan como Failure tipado',
    () async {
      final sinSesion = MockClient((_) async => http.Response('', 401));
      await expectLater(
        ColoniasRepositoryHttp(
          transporte: sinSesion,
          url: _url,
        ).enPunto(latitud: 1, longitud: 1),
        throwsA(isA<NoAutorizadoFailure>()),
      );
      final sinRed = MockClient((_) async => throw http.ClientException('x'));
      await expectLater(
        OficiosRepositoryHttp(transporte: sinRed, url: _url).listar(),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    },
  );

  test('CA-002-02 JSON roto o URL no válida no filtran detalles', () async {
    final roto = MockClient((_) async => http.Response('no es json', 200));
    await expectLater(
      OficiosRepositoryHttp(transporte: roto, url: _url).listar(),
      throwsA(isA<DatosInvalidosFailure>()),
    );
    await expectLater(
      OficiosRepositoryHttp(transporte: roto, url: 'ftp://x').listar(),
      throwsA(isA<ApiNoConfiguradaFailure>()),
    );
  });
}
