// Spec 017 (R-04, R-05, R-08, R-11, R-15): zona por código postal y lista de
// espera contra `GET /api/v1/zonas/cp/{cp}` y `POST /api/v1/zonas/lista-espera`.
import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/inicio/data/zonas_repository_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _base = 'https://api.ejemplo.invalid';

const _enCobertura =
    '{"enCobertura":true,"ciudadPiloto":true,"colonias":['
    '{"id":"1","nombre":"Centro","cp":"42800","municipio":"Tula de Allende"},'
    '{"id":"2","nombre":"La Malinche","cp":"42800","municipio":"Tula de Allende"}'
    ']}';

const _fuera = '{"enCobertura":false,"ciudadPiloto":false,"colonias":[]}';

http.Response _json(String cuerpo, [int estado = 200]) => http.Response(
  cuerpo,
  estado,
  headers: {'content-type': 'application/json'},
);

ZonasRepositoryHttp _zonas(MockClient cliente) =>
    ZonasRepositoryHttp(transporte: cliente, url: _base);

ListaEsperaRepositoryHttp _espera(MockClient cliente) =>
    ListaEsperaRepositoryHttp(transporte: cliente, url: _base);

void main() {
  group('GET /zonas/cp/{cp}', () {
    test('CP_EnCobertura_DevuelveSusColoniasYElMunicipioDelServidor', () async {
      Uri? recibida;
      final repo = _zonas(
        MockClient((p) async {
          recibida = p.url;
          return _json(_enCobertura);
        }),
      );

      final zona = await repo.porCodigoPostal('42800');

      expect(recibida!.path, '/api/v1/zonas/cp/42800');
      expect(zona.enCobertura, isTrue);
      expect(zona.ciudadPiloto, isTrue);
      expect(zona.colonias.map((c) => c.nombre), ['Centro', 'La Malinche']);
      expect(zona.colonias.first.municipio, 'Tula de Allende');
    });

    test('CP_FueraDeCobertura_NoTraeColonias', () async {
      final repo = _zonas(MockClient((_) async => _json(_fuera)));

      final zona = await repo.porCodigoPostal('99999');

      expect(zona.enCobertura, isFalse);
      expect(zona.colonias, isEmpty);
    });

    test('Cuerpo_SinLosCamposDelContrato_EsDatosInvalidos', () async {
      final repo = _zonas(
        MockClient((_) async => _json('{"enCobertura":true}')),
      );

      expect(
        repo.porCodigoPostal('42800'),
        throwsA(isA<DatosInvalidosFailure>()),
      );
    });

    test('Una_ColoniaSinNombre_EsDatosInvalidos', () async {
      final repo = _zonas(
        MockClient(
          (_) async => _json(
            '{"enCobertura":true,"ciudadPiloto":true,"colonias":'
            '[{"id":"1","nombre":"","cp":"42800","municipio":"Tula"}]}',
          ),
        ),
      );

      expect(
        repo.porCodigoPostal('42800'),
        throwsA(isA<DatosInvalidosFailure>()),
      );
    });

    test('Sin_Sesion_401_EsNoAutorizado', () async {
      final repo = _zonas(MockClient((_) async => http.Response('', 401)));

      expect(
        repo.porCodigoPostal('42800'),
        throwsA(isA<NoAutorizadoFailure>()),
      );
    });

    test('Servidor_5xx_EsServicioNoDisponible', () async {
      final repo = _zonas(MockClient((_) async => http.Response('', 503)));

      expect(
        repo.porCodigoPostal('42800'),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    });
  });

  group('POST /zonas/lista-espera', () {
    test('Envia_SoloElCodigoPostal_SinCoordenadasNiIdempotencyKey', () async {
      http.Request? recibida;
      final repo = _espera(
        MockClient((p) async {
          recibida = p;
          return _json(
            '{"id":"x","cp":"99999","creadoEn":"2026-11-17T00:00:00Z",'
            '"yaRegistrado":false}',
            201,
          );
        }),
      );

      final r = await repo.registrar(cp: '99999');

      expect(recibida!.method, 'POST');
      expect(recibida!.url.path, '/api/v1/zonas/lista-espera');
      expect(jsonDecode(recibida!.body), {'cp': '99999'});
      expect(
        recibida!.headers.keys.map((k) => k.toLowerCase()),
        isNot(contains('idempotency-key')),
      );
      expect(r.cp, '99999');
      expect(r.yaRegistrado, isFalse);
    });

    test('ConMunicipio_LoEnviaSinEspacios', () async {
      http.Request? recibida;
      final repo = _espera(
        MockClient((p) async {
          recibida = p;
          return _json('{"cp":"99999","yaRegistrado":false}', 201);
        }),
      );

      await repo.registrar(cp: '99999', municipio: '  Actopan ');

      expect(jsonDecode(recibida!.body), {
        'cp': '99999',
        'municipio': 'Actopan',
      });
    });

    test('Repetido_200_DiceYaRegistrado', () async {
      final repo = _espera(
        MockClient((_) async => _json('{"cp":"99999","yaRegistrado":true}')),
      );

      final r = await repo.registrar(cp: '99999');

      expect(r.yaRegistrado, isTrue);
    });

    test('Limite_429_NoSeReintenta', () async {
      var llamadas = 0;
      final repo = _espera(
        MockClient((_) async {
          llamadas++;
          return http.Response('', 429, headers: {'retry-after': '1'});
        }),
      );

      await expectLater(repo.registrar(cp: '99999'), throwsA(isA<Failure>()));
      expect(llamadas, 1);
    });
  });
}
