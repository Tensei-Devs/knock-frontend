// Spec 026, R-04 (KNOCK-288): las rutas protegidas llevan el Bearer; las
// públicas salen del backend ([AllowAnonymous] y rutas `anonymous` del
// gateway).
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

const _id = '64b7f3a2c9e77a1d2f3b4c5d';

void main() {
  test(
    'CA_026_11 las rutas protegidas llevan Bearer y las públicas no',
    () async {
      final api = ApiFalsa((_) => http.Response('{}', 200));
      final c = contenedorConApi(api);
      addTearDown(c.dispose);
      final cliente = c.read(transporteApiProvider);

      final protegidas = [
        'solicitudes',
        'busqueda',
        'zonas/cp/42800',
        'tecnicos/me/trabajo',
        'me/direcciones',
        // Subrutas y rutas parecidas de técnicos: siguen exigiendo sesión.
        'tecnicos',
        'tecnicos/me',
        'tecnicos/$_id/llega-a-mi-colonia',
        'tecnicos/$_id/servicios',
        'tecnicos/$_id/contacto',
        'tecnicos/autocompletar/otra',
        'tecnicos/xyz',
        'me/tecnicos-confianza',
        'health',
      ];
      for (final ruta in protegidas) {
        await cliente.get(Uri.parse('$urlApiPrueba/api/v1/$ruta'));
      }
      // `tecnicos/{id}` con sesión pide el detalle (spec 036, TEC-05).
      await cliente.get(Uri.parse('$urlApiPrueba/api/v1/tecnicos/$_id'));
      protegidas.add('tecnicos/$_id');
      final publicas = ['oficios', 'tecnicos/autocompletar'];
      for (final ruta in publicas) {
        await cliente.get(Uri.parse('$urlApiPrueba/api/v1/$ruta'));
      }

      expect(
        api.peticiones.where((p) => p.autorizacion != null).map((p) => p.ruta),
        protegidas,
      );
      expect(
        api.peticiones.where((p) => p.autorizacion == null).map((p) => p.ruta),
        publicas,
      );
    },
  );

  test('CA_026_05 una ruta protegida sin sesión no sale a la red', () async {
    final api = ApiFalsa((_) => http.Response('{}', 200));
    final c = contenedorConApi(api, tokens: null);
    addTearDown(c.dispose);
    final cliente = c.read(transporteApiProvider);

    for (final ruta in ['tecnicos/me', 'tecnicos/$_id/llega-a-mi-colonia']) {
      await expectLater(
        cliente.get(Uri.parse('$urlApiPrueba/api/v1/$ruta')),
        throwsA(isA<NoAutorizadoFailure>()),
      );
    }
    for (final ruta in ['tecnicos/$_id', 'tecnicos/autocompletar']) {
      final respuesta = await cliente.get(
        Uri.parse('$urlApiPrueba/api/v1/$ruta'),
      );
      expect(respuesta.statusCode, 200);
    }
    expect(api.peticiones.map((p) => p.ruta), [
      'tecnicos/$_id',
      'tecnicos/autocompletar',
    ]);
  });
}
