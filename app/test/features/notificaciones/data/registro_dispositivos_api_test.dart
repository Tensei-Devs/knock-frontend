import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:app/features/notificaciones/data/registro_dispositivos_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _url = 'http://127.0.0.1:5000';

RegistroDispositivosApi _api(
  Future<http.Response> Function(http.Request) responder, {
  List<http.Request>? pedidas,
}) => RegistroDispositivosApi(
  transporte: MockClient((p) {
    pedidas?.add(p);
    return responder(p);
  }),
  url: _url,
  plataforma: 'android',
);

http.Response _json(int estado, [String cuerpo = '{"id":"d-1"}']) =>
    http.Response(
      cuerpo,
      estado,
      headers: {'content-type': 'application/json'},
    );

void main() {
  group('POST /api/v1/dispositivos', () {
    test(
      'CA_012_01 envía identificador y plataforma y lee el id (201)',
      () async {
        final pedidas = <http.Request>[];
        final id = await _api(
          (_) async => _json(201),
          pedidas: pedidas,
        ).registrar('tok-abc');

        expect(id, 'd-1');
        expect(pedidas.single.method, 'POST');
        expect(pedidas.single.url.path, '/api/v1/dispositivos');
        expect(jsonDecode(pedidas.single.body), {
          'identificador': 'tok-abc',
          'plataforma': 'android',
        });
      },
    );

    test('CA_012_01 200 (ya existía) también devuelve el id', () async {
      expect(await _api((_) async => _json(200)).registrar('tok'), 'd-1');
    });

    test(
      'CA_012_01 503 lanza NotificacionesNoDisponibles, una sola llamada',
      () async {
        final pedidas = <http.Request>[];
        final api = _api((_) async => _json(503, ''), pedidas: pedidas);

        await expectLater(
          api.registrar('tok'),
          throwsA(isA<NotificacionesNoDisponiblesException>()),
        );
        expect(pedidas, hasLength(1));
      },
    );

    test(
      'CA_012_01 409, 422, 429, 401 y 500 llegan como Failure tipado',
      () async {
        final casos = <int, Matcher>{
          409: isA<ConflictoFailure>(),
          422: isA<DatosRechazadosFailure>(),
          429: isA<DemasiadosIntentosFailure>(),
          401: isA<NoAutorizadoFailure>(),
          500: isA<ServicioNoDisponibleFailure>(),
        };
        for (final MapEntry(:key, :value) in casos.entries) {
          await expectLater(
            _api((_) async => _json(key, '{"code":"x"}')).registrar('tok'),
            throwsA(value),
            reason: '$key',
          );
        }
      },
    );

    test('CA_012_01 sin red es ServicioNoDisponible', () async {
      await expectLater(
        _api((_) async => throw http.ClientException('sin red'))
            .registrar('tok'),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    });

    test('CA_012_01 respuesta sin id es DatosInvalidos', () async {
      await expectLater(
        _api((_) async => _json(201, '{}')).registrar('tok'),
        throwsA(isA<DatosInvalidosFailure>()),
      );
    });

    test(
      'seguridad negativa: identificador inválido no sale al servidor',
      () async {
        final pedidas = <http.Request>[];
        final api = _api((_) async => _json(201), pedidas: pedidas);
        for (final malo in ['', 'a\nb', 'a\x00b', 'x' * 4097]) {
          await expectLater(
            api.registrar(malo),
            throwsA(isA<DatosRechazadosFailure>()),
          );
        }
        expect(pedidas, isEmpty);
        // El límite exacto sí se envía.
        await api.registrar('x' * 4096);
        expect(pedidas, hasLength(1));
      },
    );

    test('seguridad negativa: el error no lleva el identificador', () async {
      try {
        await _api((_) async => _json(409, '{"detail":"tok-secreto"}'))
            .registrar('tok-secreto');
        fail('debía lanzar');
      } on Failure catch (e) {
        expect('$e', isNot(contains('tok-secreto')));
      }
    });
  });

  group('DELETE /api/v1/dispositivos/{id}', () {
    test('CA_012_02 llama al id y acepta 204', () async {
      final pedidas = <http.Request>[];
      await _api(
        (_) async => http.Response('', 204),
        pedidas: pedidas,
      ).desregistrar('d-1');

      expect(pedidas.single.method, 'DELETE');
      expect(pedidas.single.url.path, '/api/v1/dispositivos/d-1');
    });

    test('CA_012_02 503 lanza NotificacionesNoDisponibles', () async {
      await expectLater(
        _api((_) async => _json(503, '')).desregistrar('d-1'),
        throwsA(isA<NotificacionesNoDisponiblesException>()),
      );
    });

    test('seguridad negativa: un id con barras no arma otra ruta', () async {
      final pedidas = <http.Request>[];
      await expectLater(
        _api(
          (_) async => http.Response('', 204),
          pedidas: pedidas,
        ).desregistrar('../me'),
        throwsA(isA<DatosRechazadosFailure>()),
      );
      expect(pedidas, isEmpty);
    });
  });
}
