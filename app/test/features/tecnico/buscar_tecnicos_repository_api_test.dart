import 'package:app/features/tecnico/data/buscar_tecnicos_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('envía los filtros admitidos de lista y límites del mapa', () async {
    final cliente = MockClient((r) async {
      if (r.url.path.endsWith('/mapa/tecnicos')) {
        expect(r.url.queryParameters, {
          'norte': '21',
          'sur': '20',
          'este': '-98',
          'oeste': '-99',
          'oficio': 'plo',
          'zoom': '12',
        });
        return http.Response('{"grupos":[]}', 200);
      }
      expect(r.url.queryParameters, {
        'oficio': 'plo',
        'colonia': 'col',
        'lat': '20',
        'lng': '-99',
        'radioKm': '5',
        'disponibleHoy': 'true',
        'soloVerificados': 'true',
        'orden': 'distancia',
        'cursor': 'c1',
        'limite': '10',
      });
      return http.Response('{"tecnicos":[],"nextCursor":null}', 200);
    });
    final repo = BuscarTecnicosRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    await repo.listar(
      oficio: 'plo',
      colonia: 'col',
      lat: '20',
      lng: '-99',
      radioKm: '5',
      disponibleHoy: true,
      soloVerificados: true,
      orden: 'distancia',
      cursor: 'c1',
      limite: 10,
    );
    await repo.mapa(
      norte: '21',
      sur: '20',
      este: '-98',
      oeste: '-99',
      oficio: 'plo',
      zoom: '12',
    );
  });
  test('CA_036_01 consulta técnicos con filtros y cursor', () async {
    final cliente = MockClient((r) async {
      expect(r.url.path, '/api/v1/tecnicos');
      expect(r.url.queryParameters, {'oficio': 'plo', 'cursor': 'c1'});
      return http.Response(
        '{"tecnicos":[{"id":"t1","nombre":"Ana","verificacion":"basica",'
        '"nombreNegocio":null,"fotoUrl":null,"calificacion":null,"anios":null,'
        '"descripcionCorta":null,"detalle":null,"oficios":["plo"]}],"nextCursor":null}',
        200,
      );
    });
    final repo = BuscarTecnicosRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    final pagina = await repo.listar(oficio: 'plo', cursor: 'c1');
    expect(pagina.items.single.nombre, 'Ana');
    expect(pagina.siguiente, isNull);
  });

  test('CA_036_13 lee grupos del mapa, no posiciones de personas', () async {
    final cliente = MockClient((r) async {
      expect(r.url.path, '/api/v1/mapa/tecnicos');
      expect(r.url.queryParameters['zoom'], '12');
      return http.Response(
        '{"grupos":[{"latitud":20.0,"longitud":-99.0,"cantidad":3,"tecnicoId":null}]}',
        200,
      );
    });
    final repo = BuscarTecnicosRepositoryApi(
      transporte: cliente,
      url: 'https://example.test',
    );
    final grupos = await repo.mapa(zoom: '12');
    expect(grupos.single.cantidad, 3);
    expect(grupos.single.tecnicoId, isNull);
  });
}
