import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/visita/data/precio_tecnico_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('CA_039_01 envía precio y descripción de la visita', () async {
    final cliente = MockClient((solicitud) async {
      expect(solicitud.method, 'POST');
      expect(solicitud.url.path, '/api/v1/visitas/v1/cotizacion-final');
      expect(jsonDecode(solicitud.body), {
        'precio': 500,
        'descripcion': 'Trabajo completo',
      });
      return http.Response(
        '{"visitaId":"v1","precio":500,"estado":"enviada","venceEn":"2026-11-27T12:00:00Z"}',
        201,
      );
    });
    final repo = PrecioTecnicoRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    await repo.enviarFinal('v1', precio: 500, descripcion: 'Trabajo completo');
  });

  test('CA_039_07 propone monto y motivo para la cotización', () async {
    final cliente = MockClient((solicitud) async {
      expect(solicitud.method, 'POST');
      expect(solicitud.url.path, '/api/v1/cotizaciones/c1/ajuste-precio');
      expect(jsonDecode(solicitud.body), {
        'montoNuevo': 600,
        'motivo': 'Pieza adicional',
      });
      return http.Response(
        '{"id":"a1","cotizacionId":"c1","visitaId":"v1","montoNuevo":600,"estado":"pendiente","venceEn":"2026-11-27T12:00:00Z"}',
        201,
      );
    });
    final repo = PrecioTecnicoRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    await repo.proponerAjuste('c1', montoNuevo: 600, motivo: 'Pieza adicional');
  });

  test('rechaza una confirmación para otra visita', () async {
    final cliente = MockClient(
      (_) async => http.Response(
        '{"visitaId":"otra","precio":500,"estado":"enviada","venceEn":"2026-11-27T12:00:00Z"}',
        201,
      ),
    );
    final repo = PrecioTecnicoRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    await expectLater(
      repo.enviarFinal('v1', precio: 500, descripcion: 'Trabajo completo'),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });
}
