// Spec 009 (KNOCK-223), R-09: la app obedece Retry-After de un 429.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/red/errores_api.dart';
import 'package:app/core/red/espera_por_limite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knock_api/api.dart';

void main() {
  late DateTime reloj;
  late int llamadas;
  late int estado;
  late Map<String, String> cabeceras;
  late ClienteConEspera cliente;

  setUp(() {
    reloj = DateTime.utc(2026, 11, 5, 12);
    llamadas = 0;
    estado = 429;
    cabeceras = {'retry-after': '30'};
    cliente = ClienteConEspera(
      MockClient((_) async {
        llamadas++;
        return http.Response('{}', estado, headers: cabeceras);
      }),
      ahora: () => reloj,
    );
  });

  Future<Object?> llamar() async {
    try {
      await cliente.get(Uri.parse('https://api.ejemplo.test/x'));
      return null;
    } on Object catch (error) {
      return error;
    }
  }

  test(
    'CA_009_06 un 429 con Retry-After 30 avisa y no llama hasta pasar 30 s',
    () async {
      final primero = await llamar();
      expect(primero, isA<DemasiadosIntentosFailure>());
      expect(
        (primero! as DemasiadosIntentosFailure).espera,
        const Duration(seconds: 30),
      );
      expect(llamadas, 1);

      reloj = reloj.add(const Duration(seconds: 29));
      final durante = await llamar();
      expect(durante, isA<DemasiadosIntentosFailure>());
      expect(
        (durante! as DemasiadosIntentosFailure).espera,
        const Duration(seconds: 1),
      );
      expect(llamadas, 1, reason: 'no salió otra petición durante la espera');

      reloj = reloj.add(const Duration(seconds: 1));
      estado = 200;
      expect(await llamar(), isNull);
      expect(llamadas, 2, reason: 'pasados los 30 s ya puede volver a llamar');
    },
  );

  test(
    'CA_009_06 no hay reintentos automáticos: un 429 es una sola petición',
    () async {
      await llamar();
      expect(llamadas, 1);
    },
  );

  test('CA_009_06 sin Retry-After válido usa una espera prudente', () async {
    cabeceras = {};
    final error = await llamar();
    expect(
      (error! as DemasiadosIntentosFailure).espera,
      const Duration(seconds: 30),
    );

    reloj = reloj.add(const Duration(minutes: 1));
    cabeceras = {'retry-after': 'cuando-puedas'};
    final raro = await llamar();
    expect(
      (raro! as DemasiadosIntentosFailure).espera,
      const Duration(seconds: 30),
    );
  });

  test(
    'CA_009_06 acepta Retry-After como fecha HTTP y limita valores enormes',
    () async {
      cabeceras = {'retry-after': 'Thu, 05 Nov 2026 12:01:00 GMT'};
      final fecha = await llamar();
      expect(
        (fecha! as DemasiadosIntentosFailure).espera,
        const Duration(minutes: 1),
      );

      reloj = reloj.add(const Duration(minutes: 2));
      cabeceras = {'retry-after': '99999999'};
      final enorme = await llamar();
      expect(
        (enorme! as DemasiadosIntentosFailure).espera,
        const Duration(hours: 1),
      );
    },
  );

  test(
    'CA_009_06 el cliente generado entrega el tiempo de espera como Failure',
    () async {
      final contenedor = ProviderContainer(
        overrides: [
          urlApiProvider.overrideWithValue('https://api.ejemplo.test'),
          transporteHttpProvider.overrideWithValue(cliente),
        ],
      );
      addTearDown(contenedor.dispose);

      Future<Object?> canjear() async {
        try {
          await llamarApi(
            () => contenedor
                .read(authApiProvider)
                .apiVversionAuthFirebasePost(
                  versionApi,
                  FirebaseExchangeRequest(),
                ),
          );
          return null;
        } on Object catch (error) {
          return error;
        }
      }

      final error = await canjear();
      expect(error, isA<DemasiadosIntentosFailure>());
      expect(
        (error! as DemasiadosIntentosFailure).espera,
        const Duration(seconds: 30),
      );
      await canjear();
      expect(llamadas, 1);
    },
  );
}
