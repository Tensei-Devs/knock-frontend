// Spec 030 (KNOCK-288): `DireccionesRepositoryApi` sobre el transporte real
// de la app, con una API falsa. Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/direcciones/direcciones_providers.dart';
import 'package:app/features/direcciones/domain/direccion.dart';
import 'package:app/features/direcciones/domain/direcciones_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

Map<String, Object?> _dir({String id = 'd-1', bool principal = true}) => {
  'id': id,
  'calleNumero': 'Calle Falsa 123',
  'colonia': 'Centro',
  'referencias': null,
  'principal': principal,
  'creadoEn': '2026-11-01T10:00:00Z',
};

void main() {
  late ApiFalsa api;
  late ProviderContainer c;

  DireccionesRepository repo() => c.read(direccionesRepositoryProvider);

  setUp(() {
    api = ApiFalsa();
    c = contenedorConApi(api);
    addTearDown(c.dispose);
  });

  test('CA_030_01 GET lista las direcciones con Bearer', () async {
    api.responder = (_) => jsonOk([_dir(), _dir(id: 'd-2', principal: false)]);
    final lista = await repo().listar();
    expect(api.peticiones.single.llamadaCompleta, 'GET /api/v1/me/direcciones');
    expect(api.peticiones.single.autorizacion, 'Bearer acc-A');
    expect(lista.map((d) => d.id), ['d-1', 'd-2']);
    expect(lista.first.principal, isTrue);
    expect(lista.first.referencias, isNull);
    expect(lista.first.creadoEn, DateTime.utc(2026, 11, 1, 10));
  });

  test(
    'CA_030_01 una respuesta fuera del contrato es DatosInvalidos',
    () async {
      api.responder = (_) => jsonOk([
        {'id': 'd-1'},
      ]);
      await expectLater(repo().listar(), throwsA(isA<DatosInvalidosFailure>()));
      api.responder = (_) => jsonOk({'items': <Object?>[]});
      await expectLater(repo().listar(), throwsA(isA<DatosInvalidosFailure>()));
    },
  );

  test('CA_030_02 GET con 401 es NoAutorizado', () async {
    api.responder = (_) => http.Response('', 401);
    await expectLater(repo().listar(), throwsA(isA<NoAutorizadoFailure>()));
  });

  test('CA_030_03 POST envía solo los campos del contrato', () async {
    api.responder = (_) => jsonOk(_dir(), estado: 201);
    final d = await repo().crear(
      const DireccionNueva(
        calleNumero: ' Calle Falsa 123 ',
        colonia: 'Centro',
        referencias: 'Portón azul',
        principal: true,
      ),
    );
    final p = api.peticiones.single;
    expect(p.llamadaCompleta, 'POST /api/v1/me/direcciones');
    expect(p.json, {
      'calleNumero': 'Calle Falsa 123',
      'colonia': 'Centro',
      'referencias': 'Portón azul',
      'principal': true,
    });
    expect(d.id, 'd-1');
  });

  test('CA_030_04 POST con 401 es NoAutorizado', () async {
    api.responder = (_) => http.Response('', 401);
    await expectLater(
      repo().crear(const DireccionNueva(calleNumero: 'x', colonia: 'y')),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test(
    'CA_030_05 POST con 422 o 400 es DatosRechazados, sin reintento',
    () async {
      api.responder = (_) => http.Response('{"detail":"Calle Falsa"}', 422);
      await expectLater(
        repo().crear(const DireccionNueva(calleNumero: 'x', colonia: 'y')),
        throwsA(isA<DatosRechazadosFailure>()),
      );
      api.responder = (_) => http.Response('', 400);
      await expectLater(
        repo().crear(const DireccionNueva(calleNumero: 'x', colonia: 'y')),
        throwsA(isA<DatosRechazadosFailure>()),
      );
      expect(api.peticiones, hasLength(2));
    },
  );

  test('CA_030_06 PUT envía solo lo que cambia', () async {
    api.responder = (_) => jsonOk(_dir(principal: false));
    final d = await repo().editar(
      'd-1',
      const CambiosDireccion(principal: false, referencias: ''),
    );
    final p = api.peticiones.single;
    expect(p.llamadaCompleta, 'PUT /api/v1/me/direcciones/d-1');
    expect(p.json, {'referencias': '', 'principal': false});
    expect(d.principal, isFalse);
  });

  test('CA_030_06 PUT sin cambios o sin id no sale a la red', () async {
    await expectLater(
      repo().editar('d-1', const CambiosDireccion()),
      throwsA(isA<DatosRechazadosFailure>()),
    );
    await expectLater(
      repo().editar(' ', const CambiosDireccion(principal: true)),
      throwsA(isA<DatosRechazadosFailure>()),
    );
    expect(api.peticiones, isEmpty);
  });

  test('CA_030_07 PUT con 401 es NoAutorizado', () async {
    api.responder = (_) => http.Response('', 401);
    await expectLater(
      repo().editar('d-1', const CambiosDireccion(principal: true)),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test('CA_030_08 PUT con 403 y 404 se distinguen', () async {
    api.responder = (_) => http.Response('', 403);
    await expectLater(
      repo().editar('d-1', const CambiosDireccion(principal: true)),
      throwsA(isA<AccesoDenegadoFailure>()),
    );
    api.responder = (_) => http.Response('', 404);
    await expectLater(
      repo().editar('d-1', const CambiosDireccion(principal: true)),
      throwsA(isA<NoEncontradoFailure>()),
    );
  });

  test('CA_030_09 DELETE con 204 termina sin cuerpo', () async {
    api.responder = (_) => http.Response('', 204);
    await repo().eliminar('d-1');
    expect(
      api.peticiones.single.llamadaCompleta,
      'DELETE /api/v1/me/direcciones/d-1',
    );
  });

  test('CA_030_10 DELETE con 401 es NoAutorizado', () async {
    api.responder = (_) => http.Response('', 401);
    await expectLater(
      repo().eliminar('d-1'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test('CA_030_11 DELETE con 403 y 404 se distinguen', () async {
    api.responder = (_) => http.Response('', 403);
    await expectLater(
      repo().eliminar('d-1'),
      throwsA(isA<AccesoDenegadoFailure>()),
    );
    api.responder = (_) => http.Response('', 404);
    await expectLater(
      repo().eliminar('d-1'),
      throwsA(isA<NoEncontradoFailure>()),
    );
  });

  test(
    'CA_030_16 la dirección no sale en toString ni en los errores',
    () async {
      api.responder = (_) => jsonOk([_dir()]);
      final d = (await repo().listar()).single;
      expect('$d', isNot(contains('Calle Falsa')));
      expect('$d', isNot(contains('Centro')));
      api.responder = (_) => http.Response('{"detail":"Calle Falsa 123"}', 422);
      try {
        await repo().crear(
          const DireccionNueva(
            calleNumero: 'Calle Falsa 123',
            colonia: 'Centro',
          ),
        );
        fail('debía fallar');
      } on Failure catch (e) {
        expect('$e', isNot(contains('Calle Falsa')));
      }
    },
  );
}
