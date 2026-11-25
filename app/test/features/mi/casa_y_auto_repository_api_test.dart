// Spec 031 (backend 041): el repositorio de «Mi casa y mi auto» lee solo los
// campos del contrato, manda solo tipo, nombre y año, y traduce cada estado.
import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/mi/data/casa_y_auto_repository_api.dart';
import 'package:app/features/mi/domain/casa_y_auto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _url = 'https://api.knock.test';

Map<String, Object?> _item({
  String id = 'e1',
  String tipo = 'auto',
  Object? anio = 2018,
}) => {
  'id': id,
  'tipo': tipo,
  'nombre': 'Nissan Versa',
  'anio': anio,
  'creadoEn': '2026-11-20T18:00:00Z',
  'campoQueNoDeclaraElContrato': 'x',
};

({CasaYAutoRepositoryApi repo, List<http.Request> peticiones}) _crear(
  int estado, [
  Object? cuerpo,
]) {
  final peticiones = <http.Request>[];
  final cliente = MockClient((peticion) async {
    peticiones.add(peticion);
    return http.Response(
      cuerpo == null ? '' : jsonEncode(cuerpo),
      estado,
      headers: {'content-type': 'application/json'},
    );
  });
  return (
    repo: CasaYAutoRepositoryApi(transporte: cliente, url: _url),
    peticiones: peticiones,
  );
}

void main() {
  test(
    'CA_031_01 lista los elementos con solo los campos del contrato',
    () async {
      final (:repo, :peticiones) = _crear(200, [
        _item(),
        _item(id: 'e2', tipo: 'instalacion', anio: null),
      ]);

      final lista = await repo.listar();

      expect(peticiones.single.method, 'GET');
      expect(peticiones.single.url.path, '/api/v1/me/casa-y-auto');
      expect(lista.map((e) => e.id), ['e1', 'e2']);
      expect(lista.first.tipo, TipoElemento.auto);
      expect(lista.first.anio, 2018);
      expect(lista.last.anio, isNull);
    },
  );

  test('CA_031_02 un 401 de la lista llega como sesión vencida', () async {
    final (:repo, peticiones: _) = _crear(401);
    await expectLater(repo.listar(), throwsA(isA<NoAutorizadoFailure>()));
  });

  test(
    'CA_031_03 el alta manda tipo, nombre y año, y el año solo en autos',
    () async {
      final auto = _crear(201, _item());
      final boiler = _crear(201, _item(tipo: 'instalacion', anio: null));

      final creado = await auto.repo.agregar(
        tipo: TipoElemento.auto,
        nombre: '  Nissan Versa ',
        anio: 2018,
      );
      await boiler.repo.agregar(
        tipo: TipoElemento.instalacion,
        nombre: 'Boiler de gas',
        anio: 2010,
      );

      expect(creado.id, 'e1');
      expect(jsonDecode(auto.peticiones.single.body), {
        'tipo': 'auto',
        'nombre': 'Nissan Versa',
        'anio': 2018,
      });
      expect(jsonDecode(boiler.peticiones.single.body), {
        'tipo': 'instalacion',
        'nombre': 'Boiler de gas',
      });
    },
  );

  test('CA_031_04 un 401 del alta llega como sesión vencida', () async {
    final (:repo, peticiones: _) = _crear(401);
    await expectLater(
      repo.agregar(tipo: TipoElemento.otro, nombre: 'Bomba'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test(
    'CA_031_05 un 422 del alta es dato rechazado y el 409 es el límite',
    () async {
      final rechazado = _crear(422, {
        'errors': {
          'nombre': ['The value is not valid.'],
        },
      });
      final limite = _crear(409, {'code': 'item_limit_reached'});
      await expectLater(
        rechazado.repo.agregar(tipo: TipoElemento.otro, nombre: 'x'),
        throwsA(isA<DatosRechazadosFailure>()),
      );
      await expectLater(
        limite.repo.agregar(tipo: TipoElemento.otro, nombre: 'Bomba'),
        throwsA(isA<ConflictoFailure>()),
      );
    },
  );

  test('CA_031_06 la edición va por PUT al elemento', () async {
    final (:repo, :peticiones) = _crear(200, _item(id: 'e9'));
    final editado = await repo.editar(
      'e9',
      tipo: TipoElemento.auto,
      nombre: 'Nissan Versa',
      anio: 2019,
    );
    expect(peticiones.single.method, 'PUT');
    expect(peticiones.single.url.path, '/api/v1/me/casa-y-auto/e9');
    expect(editado.id, 'e9');
  });

  test('CA_031_07 un 401 de la edición llega como sesión vencida', () async {
    final (:repo, peticiones: _) = _crear(401);
    await expectLater(
      repo.editar('e1', tipo: TipoElemento.otro, nombre: 'Bomba'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test('CA_031_08 un 404 o 403 de la edición es «no disponible»', () async {
    final noEsta = _crear(404);
    final ajeno = _crear(403);
    await expectLater(
      noEsta.repo.editar('e1', tipo: TipoElemento.otro, nombre: 'Bomba'),
      throwsA(isA<NoEncontradoFailure>()),
    );
    await expectLater(
      ajeno.repo.editar('e1', tipo: TipoElemento.otro, nombre: 'Bomba'),
      throwsA(isA<AccesoDenegadoFailure>()),
    );
  });

  test('CA_031_09 quitar va por DELETE y acepta 204 sin cuerpo', () async {
    final (:repo, :peticiones) = _crear(204);
    await repo.quitar('e3');
    expect(peticiones.single.method, 'DELETE');
    expect(peticiones.single.url.path, '/api/v1/me/casa-y-auto/e3');
  });

  test('CA_031_10 un 401 al quitar llega como sesión vencida', () async {
    final (:repo, peticiones: _) = _crear(401);
    await expectLater(repo.quitar('e3'), throwsA(isA<NoAutorizadoFailure>()));
  });

  test('CA_031_11 un 404 al quitar es «no disponible»', () async {
    final (:repo, peticiones: _) = _crear(404);
    await expectLater(repo.quitar('e3'), throwsA(isA<NoEncontradoFailure>()));
  });

  test(
    'CA_031_12 el historial lee la página y pide la siguiente con el cursor',
    () async {
      final (:repo, :peticiones) = _crear(200, {
        'items': [
          {
            'fecha': '2026-09-12T10:00:00Z',
            'oficio': 'Mecánica',
            'tecnico': 'Taller Demo',
          },
        ],
        'nextCursor': 'abc',
      });
      final pagina = await repo.historial('e1', cursor: 'xyz');
      expect(peticiones.single.url.path, '/api/v1/me/casa-y-auto/e1/historial');
      expect(peticiones.single.url.queryParameters['cursor'], 'xyz');
      expect(pagina.trabajos.single.oficio, 'Mecánica');
      expect(pagina.siguiente, 'abc');
    },
  );

  test('CA_031_13 un 401 del historial llega como sesión vencida', () async {
    final (:repo, peticiones: _) = _crear(401);
    await expectLater(
      repo.historial('e1'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test('CA_031_14 un 404 del historial es «no disponible»', () async {
    final (:repo, peticiones: _) = _crear(404);
    await expectLater(
      repo.historial('e1'),
      throwsA(isA<NoEncontradoFailure>()),
    );
  });

  test(
    'CA_031_01 una respuesta sin un campo obligatorio es dato inválido',
    () async {
      final (:repo, peticiones: _) = _crear(200, [
        {'id': 'e1', 'tipo': 'auto'},
      ]);
      await expectLater(repo.listar(), throwsA(isA<DatosInvalidosFailure>()));
    },
  );
}
