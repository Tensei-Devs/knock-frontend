// Spec 026, D-01: piezas comunes para leer el JSON del contrato.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../soporte/api_falsa.dart';

void main() {
  test('CA_026_18 lo que no cumple el contrato es DatosInvalidos', () {
    expect(() => objetoDelContrato([]), throwsA(isA<DatosInvalidosFailure>()));
    expect(() => listaDelContrato({}), throwsA(isA<DatosInvalidosFailure>()));
    expect(() => textoObligatorio(' '), throwsA(isA<DatosInvalidosFailure>()));
    expect(() => textoOpcional(3), throwsA(isA<DatosInvalidosFailure>()));
    expect(
      () => booleanoObligatorio('x'),
      throwsA(isA<DatosInvalidosFailure>()),
    );
    expect(() => enteroObligatorio(1.5), throwsA(isA<DatosInvalidosFailure>()));
    expect(
      () => fechaHoraObligatoria('ayer'),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });

  test('CA_026_18 los valores correctos pasan', () {
    expect(textoOpcional(null), isNull);
    expect(textoObligatorio('a'), 'a');
    expect(enteroObligatorio(2), 2);
    expect(
      fechaHoraObligatoria('2026-11-01T10:00:00Z'),
      DateTime.utc(2026, 11, 1, 10),
    );
  });

  test('CA_026_18 un 404 es NoEncontrado y no lleva el cuerpo', () async {
    final cliente = MockClient(
      (_) async => http.Response('{"secreto":"x"}', 404),
    );
    await expectLater(
      enviarJsonONoEncontrado(cliente, urlApiPrueba, 'GET', 'me/direcciones/x'),
      throwsA(isA<NoEncontradoFailure>()),
    );
  });
}
