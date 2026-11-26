// Spec 032 (KNOCK-288): `TecnicosConfianzaRepositoryApi` con una API falsa.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/tecnicos_confianza/domain/tecnicos_confianza_repository.dart';
import 'package:app/features/tecnicos_confianza/tecnicos_confianza_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

Map<String, Object?> _t({String id = 't-1'}) => {
  'tecnicoId': id,
  'nombre': 'Luis Pérez',
  'fotoUrl': null,
  'nivelVerificacion': 'verificado',
  'guardadoEn': '2026-11-01T10:00:00Z',
};

void main() {
  late ApiFalsa api;
  late ProviderContainer c;

  TecnicosConfianzaRepository repo() =>
      c.read(tecnicosConfianzaRepositoryProvider);

  setUp(() {
    api = ApiFalsa();
    c = contenedorConApi(api);
    addTearDown(c.dispose);
  });

  test('CA_032_01 GET lista con cursor y Bearer', () async {
    api.responder = (_) => jsonOk({
      'items': [_t(), _t(id: 't-2')],
      'nextCursor': 'c2',
    });
    final p = await repo().listar(cursor: 'c1', limite: 10);
    final q = api.peticiones.single;
    expect(q.url.path, '/api/v1/me/tecnicos-confianza');
    expect(q.url.queryParameters, {'cursor': 'c1', 'limite': '10'});
    expect(q.autorizacion, 'Bearer acc-A');
    expect(p.items.map((t) => t.tecnicoId), ['t-1', 't-2']);
    expect(p.items.first.fotoUrl, isNull);
    expect(p.siguiente, 'c2');
  });

  test('CA_032_01 una página fuera del contrato es DatosInvalidos', () async {
    api.responder = (_) => jsonOk([_t()]);
    await expectLater(repo().listar(), throwsA(isA<DatosInvalidosFailure>()));
    api.responder = (_) => jsonOk({
      'items': [
        {'tecnicoId': 't-1'},
      ],
      'nextCursor': null,
    });
    await expectLater(repo().listar(), throwsA(isA<DatosInvalidosFailure>()));
  });

  test('CA_032_02 GET con 400 o 422 es DatosRechazados', () async {
    api.responder = (_) => http.Response('', 422);
    await expectLater(
      repo().listar(cursor: 'mal'),
      throwsA(isA<DatosRechazadosFailure>()),
    );
  });

  test('CA_032_03 PUT distingue 201 nuevo y 200 ya guardado', () async {
    api.responder = (_) => jsonOk(_t(), estado: 201);
    final nuevo = await repo().guardar('t-1');
    expect(nuevo.yaEstaba, isFalse);
    expect(
      api.peticiones.single.llamadaCompleta,
      'PUT /api/v1/me/tecnicos-confianza/t-1',
    );
    api.responder = (_) => jsonOk(_t());
    expect((await repo().guardar('t-1')).yaEstaba, isTrue);
  });

  test(
    'CA_032_04 PUT con 404 es NoEncontrado y con 401 NoAutorizado',
    () async {
      api.responder = (_) => http.Response('', 404);
      await expectLater(
        repo().guardar('t-9'),
        throwsA(isA<NoEncontradoFailure>()),
      );
      api.responder = (_) => http.Response('', 401);
      await expectLater(
        repo().guardar('t-9'),
        throwsA(isA<NoAutorizadoFailure>()),
      );
    },
  );

  test('CA_032_05 PUT sin id no sale a la red', () async {
    await expectLater(
      repo().guardar(' '),
      throwsA(isA<DatosRechazadosFailure>()),
    );
    await expectLater(
      repo().quitar(''),
      throwsA(isA<DatosRechazadosFailure>()),
    );
    expect(api.peticiones, isEmpty);
  });

  test('CA_032_06 DELETE con 204; 404 y 401 se distinguen', () async {
    api.responder = (_) => http.Response('', 204);
    await repo().quitar('t-1');
    expect(
      api.peticiones.single.llamadaCompleta,
      'DELETE /api/v1/me/tecnicos-confianza/t-1',
    );
    api.responder = (_) => http.Response('', 404);
    await expectLater(
      repo().quitar('t-1'),
      throwsA(isA<NoEncontradoFailure>()),
    );
    api.responder = (_) => http.Response('', 401);
    await expectLater(
      repo().quitar('t-1'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test('CA_032_09 el nombre no sale en toString ni en errores', () async {
    api.responder = (_) => jsonOk({
      'items': [_t()],
      'nextCursor': null,
    });
    final t = (await repo().listar()).items.single;
    expect('$t', isNot(contains('Pérez')));
    api.responder = (_) => http.Response('{"detail":"Luis Pérez"}', 422);
    try {
      await repo().listar();
      fail('debía fallar');
    } on Failure catch (e) {
      expect('$e', isNot(contains('Pérez')));
    }
  });
}
