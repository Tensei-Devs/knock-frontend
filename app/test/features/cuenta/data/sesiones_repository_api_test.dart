// Spec 026 (KNOCK-248), P-5: `SesionesRepositoryApi` (`GET` y `DELETE`
// /me/sesiones) sobre el transporte real de la app, con una API falsa.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/domain/sesion_dispositivo.dart';
import 'package:app/features/cuenta/domain/sesiones_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../soporte/api_falsa.dart';

void main() {
  late ApiFalsa api;
  late ProviderContainer c;

  SesionesRepository repo() => c.read(sesionesRepositoryProvider);

  setUp(() {
    api = ApiFalsa();
    c = contenedorConApi(api);
    addTearDown(c.dispose);
  });

  test('CA_026_20 GET /me/sesiones lleva el Bearer y respeta el orden del servidor', () async {
    api.responder = (_) => jsonOk(
      [
        {
          'id': 's-2',
          'dispositivo': 'Android',
          'ultimaActividad': '2026-11-10T12:00:00Z',
          'actual': true,
        },
        {
          'id': 's-1',
          'dispositivo': 'iOS',
          'ultimaActividad': '2026-11-09T08:30:00Z',
          'actual': false,
        },
      ],
      h: {'cache-control': 'private, no-store'},
    );

    final sesiones = await repo().listar();

    expect(api.peticiones.single.llamadaCompleta, 'GET /api/v1/me/sesiones');
    expect(api.peticiones.single.autorizacion, 'Bearer acc-A');
    expect(sesiones.map((s) => s.id), ['s-2', 's-1']);
    expect(sesiones.first, isA<SesionDispositivo>());
    expect(sesiones.first.dispositivo, 'Android');
    expect(sesiones.first.actual, isTrue);
    expect(sesiones.last.actual, isFalse);
    expect(sesiones.first.ultimaActividad, DateTime.utc(2026, 11, 10, 12));
  });

  test('CA_026_20 una lista vacía o con una sola sesión es válida', () async {
    api.responder = (_) => jsonOk(<Object?>[]);
    expect(await repo().listar(), isEmpty);
    api.responder = (_) => jsonOk([
      {
        'id': 's-1',
        'dispositivo': 'Android',
        'ultimaActividad': '2026-11-10T12:00:00Z',
        'actual': true,
      },
    ]);
    expect(await repo().listar(), hasLength(1));
  });

  test(
    'CA_026_20 un cuerpo que no cumple el contrato es DatosInvalidosFailure',
    () async {
      for (final malo in <Object>[
        {'id': 's-1'},
        [
          {
            'id': 's-1',
            'dispositivo': 'A',
            'ultimaActividad': 'ayer',
            'actual': true,
          },
        ],
        [
          {
            'id': '',
            'dispositivo': 'A',
            'ultimaActividad': '2026-11-10T12:00:00Z',
            'actual': true,
          },
        ],
        [
          {
            'id': 's',
            'dispositivo': 'A',
            'ultimaActividad': '2026-11-10T12:00:00Z',
            'actual': 'si',
          },
        ],
        ['no es un objeto'],
      ]) {
        api.responder = (_) => jsonOk(malo);
        await expectLater(
          repo().listar(),
          throwsA(isA<DatosInvalidosFailure>()),
        );
      }
    },
  );

  test('CA_026_21 DELETE con 204 termina bien y manda el Bearer', () async {
    api.responder = (_) => http.Response('', 204);
    await repo().cerrar('s-1');
    expect(
      api.peticiones.single.llamadaCompleta,
      'DELETE /api/v1/me/sesiones/s-1',
    );
    expect(api.peticiones.single.autorizacion, 'Bearer acc-A');
  });

  test('CA_026_21 un 404 se trata como una sesión ya cerrada', () async {
    api.responder = (_) => http.Response('', 404);
    await repo().cerrar('s-9');
    expect(api.peticiones, hasLength(1));
  });

  test(
    'CA_026_21 un 409 (es la sesión actual) falla con ConflictoFailure',
    () async {
      api.responder = (_) => http.Response('', 409);
      await expectLater(repo().cerrar('s-2'), throwsA(isA<ConflictoFailure>()));
    },
  );

  test('CA_026_21 un 400 falla con DatosRechazadosFailure y un 5xx con ServicioNoDisponibleFailure', () async {
    api.responder = (_) => http.Response('', 400);
    await expectLater(
      repo().cerrar('x'),
      throwsA(isA<DatosRechazadosFailure>()),
    );
    api.responder = (_) => http.Response('', 500);
    await expectLater(
      repo().cerrar('x'),
      throwsA(isA<ServicioNoDisponibleFailure>()),
    );
  });

  test(
    'CA_026_21 un 401 sigue el flujo de renovación y repite una vez',
    () async {
      api.responder = (p) {
        if (p.ruta == 'auth/refresh') {
          return jsonOk(tokensJson('acc-B', 'ref-B'));
        }
        return p.autorizacion == 'Bearer acc-B'
            ? http.Response('', 204)
            : http.Response('', 401);
      };

      await repo().cerrar('s-1');

      expect(api.llamadas, [
        'DELETE me/sesiones/s-1',
        'POST auth/refresh',
        'DELETE me/sesiones/s-1',
      ]);
    },
  );

  test('CA_026_21 el identificador viaja codificado en la ruta', () async {
    api.responder = (_) => http.Response('', 204);
    await repo().cerrar('a/b c');
    expect(api.peticiones.single.url.path, '/api/v1/me/sesiones/a%2Fb%20c');
  });

  test('CA_026_05 sin sesión no sale ninguna petición', () async {
    api = ApiFalsa();
    c.dispose();
    c = contenedorConApi(api, tokens: null);
    addTearDown(c.dispose);
    await expectLater(repo().listar(), throwsA(isA<NoAutorizadoFailure>()));
    expect(api.peticiones, isEmpty);
  });
}
