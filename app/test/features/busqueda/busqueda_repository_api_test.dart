// Spec 021 (KNOCK-288): `BusquedaRepositoryApi` con una API falsa.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cache_respuestas.dart';
import 'package:app/features/busqueda/busqueda_providers.dart';
import 'package:app/features/busqueda/domain/busqueda.dart';
import 'package:app/features/busqueda/domain/busqueda_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

Map<String, Object?> _experto({int? km = 2}) => {
  'id': 'x-1',
  'nombre': 'Taller Luis',
  'oficios': [
    {'clave': 'mecanica', 'nombre': 'Mecánica'},
  ],
  'calificacion': 4.5,
  'totalResenas': 12,
  'verificado': true,
  'nivelVerificacion': 'identidad',
  'coloniaBase': 'Centro',
  'distanciaKm': km,
  'atiendeTuColonia': false,
  'fotoUrl': null,
};

Map<String, Object?> _respuesta({
  String estado = 'detectado',
  Object? detectado = const {'clave': 'mecanica', 'nombre': 'Mecánica'},
  Object? sugeridos,
  String? siguiente,
  List<Object?>? items,
}) => {
  'interpretacion': {
    'estado': estado,
    'oficioDetectado': detectado,
    'oficiosSugeridos': sugeridos,
  },
  'items': items ?? [_experto()],
  'nextCursor': siguiente,
};

void main() {
  late ApiFalsa api;
  late ProviderContainer c;

  BusquedaRepository repo() => c.read(busquedaRepositoryProvider);
  Future<PaginaBusqueda> buscar({String q = 'frenso', String? cursor}) =>
      repo().buscar(consulta: q, coloniaId: 'col-1', cursor: cursor);

  setUp(() {
    api = ApiFalsa();
    c = contenedorConApi(api);
    addTearDown(c.dispose);
  });

  test(
    'CA_021_01 normalizarConsulta: 2 a 80 caracteres, sin espacios sobrantes',
    () {
      expect(
        normalizarConsulta('  boiler   no enciende '),
        'boiler no enciende',
      );
      expect(normalizarConsulta(' a '), isNull);
      expect(normalizarConsulta('a' * 81), isNull);
      expect(normalizarConsulta('a' * 80), isNotNull);
    },
  );

  test('CA_021_05 una consulta inválida no sale a la red', () async {
    await expectLater(buscar(q: 'a'), throwsA(isA<DatosRechazadosFailure>()));
    await expectLater(
      buscar(q: ' boiler'),
      throwsA(isA<DatosRechazadosFailure>()),
    );
    expect(api.peticiones, isEmpty);
  });

  test('CA_021_02 envía los parámetros del contrato y muestra lo que interpretó el servidor', () async {
    api.responder = (_) => jsonOk(_respuesta());
    final p = await repo().buscar(
      consulta: 'frenso',
      coloniaId: 'col-1',
      oficio: 'mecanica',
      soloVerificados: true,
      cursor: 'c1',
    );
    final q = api.peticiones.single;
    expect(q.url.path, '/api/v1/busqueda');
    expect(q.autorizacion, 'Bearer acc-A');
    expect(q.url.queryParameters, {
      'q': 'frenso',
      'coloniaId': 'col-1',
      'oficio': 'mecanica',
      'soloVerificados': 'true',
      'cursor': 'c1',
      'limit': '20',
    });
    expect(p.interpretacion.estado, EstadoInterpretacion.detectado);
    expect(p.interpretacion.oficioDetectado?.nombre, 'Mecánica');
  });

  test('CA_021_03 no_entendido y ambiguo con sugeridos', () async {
    api.responder = (_) =>
        jsonOk(_respuesta(estado: 'no_entendido', detectado: null, items: []));
    var p = await buscar();
    expect(p.interpretacion.estado, EstadoInterpretacion.noEntendido);
    expect(p.items, isEmpty);
    api.responder = (_) => jsonOk(
      _respuesta(
        estado: 'ambiguo',
        detectado: null,
        sugeridos: [
          {'clave': 'a', 'nombre': 'A'},
          {'clave': 'b', 'nombre': 'B'},
        ],
      ),
    );
    p = await buscar();
    expect(p.interpretacion.oficiosSugeridos.map((o) => o.clave), ['a', 'b']);
  });

  test(
    'CA_021_10 el resultado trae lo mostrable y no tiene campos de contacto',
    () async {
      api.responder = (_) => jsonOk(_respuesta(siguiente: 'c2'));
      final p = await buscar();
      final e = p.items.single;
      expect(e.nombre, 'Taller Luis');
      expect(e.calificacion, 4.5);
      expect(e.totalResenas, 12);
      expect(e.distanciaKm, 2);
      expect(e.atiendeTuColonia, isFalse);
      expect(e.nivelVerificacion, 'identidad');
      expect(p.siguiente, 'c2');
    },
  );

  test('CA_021_10 un resultado fuera del contrato es DatosInvalidos', () async {
    api.responder = (_) => jsonOk(
      _respuesta(
        items: [
          {'id': 'x'},
        ],
      ),
    );
    await expectLater(buscar(), throwsA(isA<DatosInvalidosFailure>()));
    api.responder = (_) => jsonOk(_respuesta(estado: 'otro'));
    await expectLater(buscar(), throwsA(isA<DatosInvalidosFailure>()));
  });

  test(
    'CA_021_17 invalid_cursor, colonia_not_found y search_unavailable',
    () async {
      api.responder = (_) => jsonOk({'code': 'invalid_cursor'}, estado: 400);
      await expectLater(
        buscar(cursor: 'mal'),
        throwsA(isA<DatosRechazadosFailure>()),
      );
      api.responder = (_) => jsonOk({'code': 'colonia_not_found'}, estado: 422);
      await expectLater(buscar(), throwsA(isA<OpcionNoDisponibleFailure>()));
      api.responder = (_) => jsonOk({'code': 'otro'}, estado: 422);
      await expectLater(buscar(), throwsA(isA<DatosRechazadosFailure>()));
      api.responder = (_) => http.Response('', 503);
      await expectLater(buscar(), throwsA(isA<ServicioNoDisponibleFailure>()));
    },
  );

  test('CA_021_13 429 es DemasiadosIntentos y no se reintenta', () async {
    api.responder = (_) => http.Response('', 429);
    await expectLater(buscar(), throwsA(isA<DemasiadosIntentosFailure>()));
    expect(api.peticiones, hasLength(1));
  });

  test(
    'CA_021_14 la respuesta no se guarda en la caché de respuestas',
    () async {
      api.responder = (_) => jsonOk(
        _respuesta(),
        h: {'etag': '"v1"', 'cache-control': 'private, max-age=30'},
      );
      await buscar(q: 'boiler');
      await buscar(q: 'boiler');
      expect(api.peticiones, hasLength(2));
      expect(
        api.peticiones.last.cabeceras.containsKey('if-none-match'),
        isFalse,
      );
      expect(
        c.read(cacheRespuestasProvider).toString(),
        isNot(contains('boiler')),
      );
    },
  );

  test('CA_021_14 el texto buscado no sale en errores', () async {
    api.responder = (_) => http.Response('{"detail":"boiler"}', 503);
    try {
      await buscar(q: 'boiler');
      fail('debía fallar');
    } on Failure catch (f) {
      expect('$f', isNot(contains('boiler')));
    }
  });
}
