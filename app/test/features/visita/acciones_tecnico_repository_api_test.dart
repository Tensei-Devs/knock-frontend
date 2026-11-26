import 'dart:convert';

import 'package:app/features/visita/data/acciones_visita_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('CA_040_14 envía ausencia sin cuerpo', () async {
    final cliente = MockClient((r) async {
      expect(r.method, 'POST');
      expect(r.url.path, '/api/v1/visitas/v1/cliente-ausente');
      expect(r.body, isEmpty);
      return http.Response(
        '{"visitaId":"v1","estado":"no_presentado","quienFalto":"cliente"}',
        200,
      );
    });
    final repo = AccionesVisitaRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    expect(await repo.clienteAusente('v1'), 'no_presentado');
  });

  test('CA_040_17 termina con identificadores de fotos', () async {
    const foto = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
    final cliente = MockClient((r) async {
      expect(r.url.path, '/api/v1/visitas/v1/terminar');
      expect(jsonDecode(r.body), {
        'descripcion': 'Trabajo realizado',
        'recomendacion': null,
        'fotos': [foto],
      });
      return http.Response(
        '{"visitaId":"v1","estado":"terminada","terminadaEn":"2026-11-27T12:00:00Z"}',
        200,
      );
    });
    final repo = AccionesVisitaRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    expect(
      await repo.terminar(
        'v1',
        descripcion: 'Trabajo realizado',
        fotos: [foto],
      ),
      'terminada',
    );
  });
}
