import 'package:app/core/errores/failure.dart';
import 'package:app/features/tecnico/data/reputacion_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('CA_036_40 lee la reputación propia del contrato', () async {
    final cliente = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/tecnicos/me/reputacion');
      return http.Response(
        '{"promedio":4.5,"total":2,"distribucion":{"5":1,"4":1},'
        '"nivel":"confiable"}',
        200,
      );
    });
    final repo = ReputacionRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    final resultado = await repo.obtener();
    expect(resultado.promedio, 4.5);
    expect(resultado.total, 2);
    expect(resultado.distribucion[5], 1);
    expect(resultado.nivel, 'confiable');
  });

  test('CA_036_40 rechaza una respuesta incompleta', () async {
    final cliente = MockClient((_) async => http.Response('{"total":1}', 200));
    final repo = ReputacionRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    await expectLater(repo.obtener(), throwsA(isA<DatosInvalidosFailure>()));
  });

  test('propaga el rechazo de sesión', () async {
    final cliente = MockClient((_) async => http.Response('', 401));
    final repo = ReputacionRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    await expectLater(repo.obtener(), throwsA(isA<NoAutorizadoFailure>()));
  });
}
