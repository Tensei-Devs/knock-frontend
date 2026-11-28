// Spec 038, CA-04 a CA-06 y enmienda 2026-11-27: `GET
// /api/v1/cotizaciones/referencia-mercado` (COT-03). Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/trabajo/data/cotizar_repository_api.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/cotizar_json.dart';

CotizarRepositoryApi _repo(ApiFalsa api) =>
    CotizarRepositoryApi(transporte: api.cliente, url: urlApiPrueba);

void main() {
  test('CA_038_04 pide la referencia del oficio y el tipo de precio', () async {
    final api = ApiFalsa((_) => jsonOk(referenciaJson()));

    final r = await _repo(api)
        .referenciaDeMercado(oficio: 'plomeria', tipo: TipoPrecio.rango);

    final p = api.peticiones.single;
    expect(p.metodo, 'GET');
    expect(p.ruta, 'cotizaciones/referencia-mercado');
    expect(p.url.queryParameters, {
      'oficio': 'plomeria',
      'tipoTrabajo': 'rango',
    });
    expect(r.origen, OrigenReferencia.mercado);
    expect((r.p25, r.mediana, r.p75), (300, 450, 600));
    expect(r.tieneRango, isTrue);
  });

  test('CA_038_04 lee los tres orígenes y sin datos no trae montos', () async {
    Future<ReferenciaDeMercado> con(Map<String, Object?> json) =>
        _repo(ApiFalsa((_) => jsonOk(json)))
            .referenciaDeMercado(oficio: 'plomeria', tipo: TipoPrecio.fijo);

    expect(
      (await con(referenciaJson(origen: 'categoria'))).origen,
      OrigenReferencia.categoria,
    );
    final sin = await con({'origen': 'sin_datos'});
    expect(sin.origen, OrigenReferencia.sinDatos);
    expect((sin.p25, sin.mediana, sin.p75), (null, null, null));
    expect(sin.tieneRango, isFalse);
  });

  test('un rango sin amplitud no se ofrece para usar', () async {
    final r = await _repo(
      ApiFalsa((_) => jsonOk(referenciaJson(p25: 400, p75: 400))),
    ).referenciaDeMercado(oficio: 'plomeria', tipo: TipoPrecio.fijo);

    expect(r.tieneRango, isFalse);
  });

  test('CA_038_04 un origen desconocido no cumple el contrato', () async {
    final api = ApiFalsa((_) => jsonOk({'origen': 'otro'}));

    await expectLater(
      _repo(api).referenciaDeMercado(oficio: 'plomeria', tipo: TipoPrecio.fijo),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });

  test('CA_038_05 CA_038_06 los errores llegan como Failure', () async {
    Future<ReferenciaDeMercado> con(int estado) =>
        _repo(ApiFalsa((_) => http.Response('', estado)))
            .referenciaDeMercado(oficio: 'plomeria', tipo: TipoPrecio.fijo);

    await expectLater(con(401), throwsA(isA<NoAutorizadoFailure>()));
    await expectLater(con(403), throwsA(isA<AccesoDenegadoFailure>()));
    await expectLater(con(422), throwsA(isA<DatosRechazadosFailure>()));
  });
}
