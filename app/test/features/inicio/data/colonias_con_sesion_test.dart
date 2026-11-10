// Spec 026 (KNOCK-248), P-4: `colonias/en-punto` con Bearer por el transporte
// con sesión, sin guardar coordenadas en la caché, y regresión de oficios.
import 'package:app/core/cache/revalidador_etag.dart';
import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/red/cache_respuestas.dart';
import 'package:app/features/inicio/domain/colonia.dart';
import 'package:app/features/inicio/domain/colonias_repository.dart';
import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/inicio/presentation/colonia_controller.dart';
import 'package:app/features/oficios/oficios_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../soporte/api_falsa.dart';
import '../presentation/mapa/fakes_ubicacion.dart';

const _enPunto =
    '{"enCobertura":true,"colonia":{"id":"1","nombre":"Centro",'
    '"cp":"42500","municipio":"Actopan"}}';

void main() {
  late ApiFalsa api;
  late ProviderContainer c;

  void montar({bool conSesion = true}) {
    c = contenedorConApi(
      api,
      tokens: conSesion ? tokensA : null,
      extra: [
        ubicacionRepositoryProvider.overrideWithValue(
          UbicacionFalsa(const Concedida(latitud: 20.2712, longitud: -98.9411)),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(coloniaControllerProvider, (_, _) {});
  }

  setUp(() {
    api = ApiFalsa(
      (_) => http.Response(
        _enPunto,
        200,
        headers: {'content-type': 'application/json', 'etag': '"c1"'},
      ),
    );
  });

  test('CA_026_09 la consulta de colonia lleva el Bearer y la colonia llega al estado de Tu zona', () async {
    montar();
    await c.read(coloniaControllerProvider.notifier).consultar();

    final p = api.peticiones.single;
    expect(p.url.path, '/api/v1/colonias/en-punto');
    expect(p.url.queryParameters, {'lat': '20.2712', 'lon': '-98.9411'});
    expect(p.autorizacion, 'Bearer acc-A');
    final estado = c.read(coloniaControllerProvider);
    expect(estado, isA<ColoniaEncontrada>());
    expect((estado as ColoniaEncontrada).colonia.nombre, 'Centro');
  });

  test('CA_026_09 un 401 renueva la sesión y repite la consulta con el token nuevo', () async {
    montar();
    api.responder = (p) {
      if (p.ruta == 'auth/refresh') return jsonOk(tokensJson('acc-B', 'ref-B'));
      return p.autorizacion == 'Bearer acc-B'
          ? http.Response(_enPunto, 200)
          : http.Response('', 401);
    };

    await c.read(coloniaControllerProvider.notifier).consultar();

    expect(c.read(coloniaControllerProvider), isA<ColoniaEncontrada>());
    expect(api.llamadas, [
      'GET colonias/en-punto',
      'POST auth/refresh',
      'GET colonias/en-punto',
    ]);
  });

  test('CA_026_05 sin sesión la consulta no sale y el estado es un error de sesión', () async {
    montar(conSesion: false);
    await c.read(coloniaControllerProvider.notifier).consultar();
    expect(api.peticiones, isEmpty);
    final estado = c.read(coloniaControllerProvider);
    expect(estado, isA<ColoniaConError>());
    expect((estado as ColoniaConError).falla, isA<NoAutorizadoFailure>());
  });

  test('CA_026_26 las coordenadas no se guardan en la caché aunque el servidor mande ETag', () async {
    montar();
    await c.read(coloniaControllerProvider.notifier).consultar();
    await c.read(coloniaControllerProvider.notifier).consultar();

    expect(c.read(cacheRespuestasProvider).estaVacia, isTrue);
    // Segunda consulta: sin If-None-Match, porque no hay nada guardado.
    expect(api.peticiones.last.cabeceras, isNot(contains('if-none-match')));
  });

  test(
    'CA_026_24 la colonia de una cuenta no queda para la siguiente',
    () async {
      montar();
      await c.read(coloniaControllerProvider.notifier).consultar();
      expect(c.read(coloniaControllerProvider), isA<ColoniaEncontrada>());

      await c.read(sesionProvider.notifier).cerrar();

      expect(c.read(coloniaControllerProvider), isA<ColoniaSinPedir>());
    },
  );

  test(
    'CA_026_28 oficios sigue siendo público: sin Authorization y con ETag',
    () async {
      montar();
      api.responder = (_) => http.Response(
        '[{"clave":"ele","nombre":"Electricidad","modalidad":"domicilio"}]',
        200,
        headers: {'etag': '"o1"'},
      );

      final oficios = await c.read(oficiosRepositoryProvider).listar();

      expect(oficios.single.nombre, 'Electricidad');
      expect(api.peticiones.single.url.path, '/api/v1/oficios');
      expect(api.peticiones.single.cabeceras, isNot(contains('authorization')));
      expect(c.read(revalidadorEtagProvider), isNotNull);
    },
  );

  test('CA_026_28 el repositorio de colonias real responde sin colonia fuera de cobertura', () async {
    montar();
    api.responder = (_) =>
        http.Response('{"enCobertura":false,"colonia":null}', 200);
    final ColoniasRepository repo = c.read(coloniasRepositoryProvider);
    final ResultadoColonia r = await repo.enPunto(latitud: 0, longitud: 0);
    expect(r.enCobertura, isFalse);
  });
}
