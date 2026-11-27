import 'package:app/features/visita/data/agenda_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('CA_040_01 lee la agenda autenticada y conserva el cursor', () async {
    final cliente = MockClient((r) async {
      expect(r.method, 'GET');
      expect(r.url.path, '/api/v1/agenda');
      expect(r.url.queryParameters['Cursor'], 'c1');
      return http.Response(
        '{"items":[{"id":"v1","estado":"confirmada","modalidad":"domicilio",'
        '"fechaHora":"2026-11-27T12:00:00Z","dia":"2026-11-27",'
        '"hora":"12:00","precio":100}],"nextCursor":"c2"}',
        200,
      );
    });
    final repo = AgendaRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    final pagina = await repo.listar(cursor: 'c1');
    expect(pagina.items.single.id, 'v1');
    expect(pagina.items.single.precio, 100);
    expect(pagina.siguiente, 'c2');
  });
}
