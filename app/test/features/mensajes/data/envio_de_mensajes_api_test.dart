// Spec 020, enmienda 2026-11-26: POST /api/v1/conversaciones/{id}/mensajes.
// Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/mensajes/data/conversaciones_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../soporte/api_falsa.dart';

Map<String, Object?> _mensajeJson({
  String texto = 'Hola',
  bool contactoOculto = false,
}) => {
  'mensajeId': 'm-1',
  'autorRol': 'cliente',
  'texto': texto,
  'contactoOculto': contactoOculto,
  'enviadoEn': '2026-11-27T12:00:00Z',
};

http.Response _problema(int estado, String code, {Map<String, String>? h}) =>
    jsonOk({'status': estado, 'code': code}, estado: estado, h: h);

void main() {
  late ApiFalsa api;
  late ConversacionesRepositoryApi repo;

  setUp(() {
    api = ApiFalsa();
    repo = ConversacionesRepositoryApi(
      transporte: api.transporte,
      url: urlApiPrueba,
    );
  });

  test('CA_020_E02 201 envía un solo POST con el texto y mapea la '
      'respuesta', () async {
    api.responder = (_) =>
        jsonOk(_mensajeJson(texto: 'Mi número es ***'), estado: 201);
    final m = await repo.enviar('c 1', '  Mi número es 5550000000  ');
    expect(api.llamadas, ['POST conversaciones/c%201/mensajes']);
    expect(api.peticiones.single.json, {'texto': 'Mi número es 5550000000'});
    expect(m.id, 'm-1');
    expect(m.autorRol, 'cliente');
    expect(m.texto, 'Mi número es ***');
    expect(m.enviadoEn, DateTime.utc(2026, 11, 27, 12));
  });

  test('CA_020_E02 respeta contactoOculto del servidor', () async {
    api.responder = (_) =>
        jsonOk(_mensajeJson(contactoOculto: true), estado: 201);
    expect((await repo.enviar('c1', 'Hola')).contactoOculto, isTrue);
  });

  test('CA_020_E02 una respuesta 201 fuera de contrato es dato '
      'inválido', () async {
    api.responder = (_) => jsonOk({'mensajeId': 'm-1'}, estado: 201);
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });

  test('CA_020_E02 texto inválido no sale a la red', () async {
    for (final texto in ['', '   ', 'a' * 1001, 'a\u0000b']) {
      await expectLater(
        repo.enviar('c1', texto),
        throwsA(isA<DatosRechazadosFailure>()),
      );
    }
    expect(api.peticiones, isEmpty);
  });

  test('CA_020_E02 404 es conversación no disponible', () async {
    api.responder = (_) => _problema(404, 'not_found');
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<NoEncontradoFailure>()),
    );
  });

  test('CA_020_E02 409 conversation_closed es conflicto', () async {
    api.responder = (_) => _problema(409, 'conversation_closed');
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<ConflictoFailure>()),
    );
  });

  test('CA_020_E02 422 content_rejected y 422 de validación', () async {
    api.responder = (_) => _problema(422, 'content_rejected');
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<ContenidoRechazadoFailure>()),
    );
    api.responder = (_) => jsonOk({
      'status': 422,
      'errors': {
        'texto': ['x'],
      },
    }, estado: 422);
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<DatosRechazadosFailure>()),
    );
  });

  test('CA_020_E02 400 es datos rechazados', () async {
    api.responder = (_) => _problema(400, 'bad_request');
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<DatosRechazadosFailure>()),
    );
  });

  test('CA_020_E02 401 es sesión vencida', () async {
    api.responder = (_) => http.Response('', 401);
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test('CA_020_E02 429 message_limit espera lo que dice Retry-After y no '
      'reintenta', () async {
    api.responder = (_) =>
        _problema(429, 'message_limit', h: {'retry-after': '42'});
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(
        isA<DemasiadosIntentosFailure>().having(
          (f) => f.espera,
          'espera',
          const Duration(seconds: 42),
        ),
      ),
    );
    // Durante la espera el siguiente envío falla sin salir a la red.
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<DemasiadosIntentosFailure>()),
    );
    expect(api.peticiones, hasLength(1));
  });

  test('CA_020_E02 503 por code', () async {
    api.responder = (_) => _problema(503, 'moderation_unavailable');
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<ModeracionNoDisponibleFailure>()),
    );
    api.responder = (_) => _problema(503, 'market_unavailable');
    await expectLater(
      repo.enviar('c1', 'Hola'),
      throwsA(isA<ServicioNoDisponibleFailure>()),
    );
    expect(api.peticiones, hasLength(2));
  });

  test('CA_020_E03 la falla no lleva el texto del mensaje', () async {
    api.responder = (_) => _problema(422, 'content_rejected');
    try {
      await repo.enviar('c1', 'texto-secreto');
      fail('debió fallar');
    } on Failure catch (f) {
      expect(f.toString(), isNot(contains('texto-secreto')));
    }
  });
}
