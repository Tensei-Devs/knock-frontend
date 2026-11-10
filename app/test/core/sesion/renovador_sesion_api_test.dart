// Spec 026 (KNOCK-248), P-2: `RenovadorSesionApi` contra `POST /auth/refresh`.
// 400 y 401 son «rechazada»; red, 429, 5xx y respuestas ilegibles no cierran.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/renovador_sesion_api.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

void main() {
  RenovadorSesionApi renovador(ApiFalsa api) =>
      RenovadorSesionApi(transporte: api.transporte, url: urlApiPrueba);

  test(
    'CA_026_13 renueva con el token de renovación y sin Authorization',
    () async {
      final api = ApiFalsa((_) => jsonOk(tokensJson('acc-B', 'ref-B')));

      final nuevos = await renovador(api).renovar('ref-A');

      expect(
        nuevos,
        const TokensSesion(accessToken: 'acc-B', refreshToken: 'ref-B'),
      );
      final p = api.peticiones.single;
      expect(p.llamadaCompleta, 'POST /api/v1/auth/refresh');
      expect(p.json, {'refreshToken': 'ref-A'});
      expect(p.cabeceras, isNot(contains('authorization')));
    },
  );

  test('CA_026_16 un 400 o un 401 es una renovación rechazada', () async {
    for (final estado in [400, 401]) {
      final api = ApiFalsa((_) => http.Response('', estado));
      expect(await renovador(api).renovar('ref-A'), isNull, reason: '$estado');
    }
  });

  test(
    'CA_026_17 red, 429 y 5xx lanzan un Failure y no cierran la sesión',
    () async {
      final casos = <Failure, http.Response Function()>{
        const ServicioNoDisponibleFailure(): () => http.Response('', 500),
        const DemasiadosIntentosFailure(): () =>
            http.Response('', 429, headers: {'retry-after': '30'}),
      };
      for (final MapEntry(key: esperado, value: respuesta) in casos.entries) {
        final api = ApiFalsa((_) => respuesta());
        await expectLater(
          renovador(api).renovar('ref-A'),
          throwsA(
            isA<Failure>().having(
              (f) => f.runtimeType,
              'tipo',
              esperado.runtimeType,
            ),
          ),
        );
      }
      final sinRed = ApiFalsa((_) => throw http.ClientException('sin red'));
      await expectLater(
        renovador(sinRed).renovar('ref-A'),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    },
  );

  test('CA_026_17 una respuesta 200 ilegible o con tokens vacíos es DatosInvalidosFailure', () async {
    final malas = <http.Response>[
      http.Response('no es json', 200),
      jsonOk(<String, Object?>{}),
      jsonOk(tokensJson('', 'ref-B')),
      jsonOk(tokensJson('acc-B', '')),
      jsonOk(<Object?>[]),
    ];
    for (final mala in malas) {
      final api = ApiFalsa((_) => mala);
      await expectLater(
        renovador(api).renovar('ref-A'),
        throwsA(isA<DatosInvalidosFailure>()),
      );
    }
  });
}
