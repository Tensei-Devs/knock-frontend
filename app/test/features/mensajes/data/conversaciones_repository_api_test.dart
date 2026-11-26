import 'dart:convert';

import 'package:app/features/mensajes/data/conversaciones_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('envía el cursor de la siguiente página', () async {
    final cliente = MockClient((r) async {
      expect(r.url.queryParameters, {'cursor': 'pagina-2', 'limit': '20'});
      return http.Response(
        '{"items":[],"totalNoLeidos":1,"nextCursor":null}',
        200,
      );
    });
    final repo = ConversacionesRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    expect((await repo.consultar(cursor: 'pagina-2')).siguiente, isNull);
  });
  test('CA_020_09 consulta conversaciones y contador', () async {
    final cliente = MockClient((r) async {
      expect(r.url.path, '/api/v1/conversaciones');
      return http.Response(
        '{"items":[{"conversacionId":"c1","solicitudId":"s1","rol":"cliente",'
        '"contraparte":{"nombre":"Ana","fotoUrl":null},"servicio":"Plomeria",'
        '"estado":"abierta","ultimoMensaje":null,"noLeidos":2}],'
        '"totalNoLeidos":2,"nextCursor":null}',
        200,
      );
    });
    final repo = ConversacionesRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    final resultado = await repo.consultar();
    expect(resultado.totalNoLeidos, 2);
    expect(resultado.conversaciones.single.contraparte.nombre, 'Ana');
  });

  test('CA_020_10 marca como leído hasta la fecha confirmada', () async {
    final cliente = MockClient((r) async {
      expect(r.method, 'POST');
      expect(r.url.path, '/api/v1/conversaciones/c1/leido');
      expect(jsonDecode(r.body), {'hasta': '2026-11-27T12:00:00.000Z'});
      return http.Response('', 204);
    });
    final repo = ConversacionesRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    await repo.marcarLeido('c1', DateTime.utc(2026, 11, 27, 12));
  });
}
