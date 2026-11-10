// Spec 026 (KNOCK-248), P-2: Bearer solo en rutas protegidas de la API,
// renovación con un solo vuelo, un reintento por petición y cierre de sesión
// según el motivo del fallo. La API es falsa (MockClient), sin red.
import 'dart:typed_data';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cache_respuestas.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

void main() {
  late ApiFalsa api;
  late AlmacenSeguroEnMemoria almacen;
  late ProviderContainer c;
  late Set<String> validos;
  late int refrescos;
  late http.Response Function() respuestaRefresh;
  late List<Map<String, String>> almacenAlReintentar;

  String? token(PeticionApi p) => p.autorizacion?.replaceFirst('Bearer ', '');

  Future<http.Response> pedir(String ruta, {String metodo = 'GET'}) async {
    final cliente = c.read(transporteApiProvider);
    final uri = Uri.parse('$urlApiPrueba/api/v1/$ruta');
    return http.Response.fromStream(
      await cliente.send(http.Request(metodo, uri)),
    );
  }

  Future<void> montar({TokensSesion? tokens = tokensA}) async {
    c = contenedorConApi(api, tokens: tokens, almacen: almacen);
    addTearDown(c.dispose);
    if (tokens != null) {
      await AlmacenSesion(almacen)
          .guardar(acceso: tokens.accessToken, refresco: tokens.refreshToken);
    }
    // Mantiene vivo el estado de la bandera de sesión durante la prueba.
    c.listen(sesionIniciadaProvider, (_, _) {});
  }

  setUp(() {
    almacen = AlmacenSeguroEnMemoria();
    validos = {'acc-A'};
    refrescos = 0;
    almacenAlReintentar = [];
    respuestaRefresh = () => jsonOk(tokensJson('acc-B', 'ref-B'));
    api = ApiFalsa((p) async {
      if (p.ruta == 'auth/refresh') {
        refrescos++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return respuestaRefresh();
      }
      if (!validos.contains(token(p))) return http.Response('', 401);
      if (token(p) == 'acc-B') {
        almacenAlReintentar.add({...almacen.contenido});
      }
      return jsonOk({'ok': true});
    });
  });

  group('Bearer solo en rutas protegidas de la API', () {
    test(
      'CA_026_11 auth/firebase, auth/refresh y oficios salen sin Authorization',
      () async {
        await montar();
        validos.add('');
        await pedir('auth/firebase', metodo: 'POST');
        await pedir('oficios');
        await pedir('auth/refresh', metodo: 'POST');
        expect(api.peticiones, hasLength(3));
        for (final p in api.peticiones) {
          expect(p.cabeceras, isNot(contains('authorization')), reason: '$p');
        }
      },
    );

    test('CA_026_11 el Bearer no sale hacia otro servidor', () async {
      await montar();
      await c
          .read(transporteApiProvider)
          .get(Uri.parse('https://otro.test/api/v1/me'));
      await c
          .read(transporteApiProvider)
          .get(Uri.parse('$urlApiPrueba/otra-ruta/me'));
      expect(api.peticiones, hasLength(2));
      for (final p in api.peticiones) {
        expect(p.cabeceras, isNot(contains('authorization')), reason: '$p');
      }
    });

    test('CA_026_09 me, me/sesiones, auth/logout y colonias/en-punto llevan el Bearer', () async {
      await montar();
      for (final ruta in [
        'me',
        'me/sesiones',
        'colonias/en-punto?lat=1&lon=2',
      ]) {
        expect((await pedir(ruta)).statusCode, 200, reason: ruta);
      }
      expect((await pedir('auth/logout', metodo: 'POST')).statusCode, 200);
      expect(api.peticiones, hasLength(4));
      for (final p in api.peticiones) {
        expect(p.autorizacion, 'Bearer acc-A', reason: '$p');
      }
    });

    test('CA_026_10 una app que arranca con tokens guardados usa el Bearer guardado', () async {
      // `main()` lee los tokens del almacenamiento seguro y los fija como
      // iniciales; la primera llamada protegida ya los lleva.
      await montar();
      await pedir('me');
      expect(api.peticiones.single.autorizacion, 'Bearer acc-A');
    });

    test(
      'CA_026_12 los tokens del canje se usan sin reiniciar la app',
      () async {
        await montar(tokens: null);
        validos.add('acc-canje');
        await c
            .read(sesionProvider.notifier)
            .iniciar(
              const TokensSesion(accessToken: 'acc-canje', refreshToken: 'r'),
            );
        expect((await pedir('me')).statusCode, 200);
        expect(api.peticiones.single.autorizacion, 'Bearer acc-canje');
        expect(almacen.contenido[AlmacenSesion.claveAcceso], 'acc-canje');
      },
    );

    test('CA_026_05 sin sesión no sale ninguna petición protegida', () async {
      await montar(tokens: null);
      await expectLater(pedir('me'), throwsA(isA<NoAutorizadoFailure>()));
      expect(api.peticiones, isEmpty);
    });
  });

  group('401 con renovación', () {
    // El token guardado ya venció; solo el que entrega la renovación sirve.
    setUp(() => validos = {'acc-B'});

    test('CA_026_13 renueva, guarda los tokens antes del reintento y repite una vez', () async {
      await montar();
      final r = await pedir('me');

      expect(r.statusCode, 200);
      expect(api.llamadas, ['GET me', 'POST auth/refresh', 'GET me']);
      expect(api.peticiones[1].json, {'refreshToken': 'ref-A'});
      expect(api.peticiones[2].autorizacion, 'Bearer acc-B');
      // En el instante del reintento el almacén seguro ya tenía los nuevos.
      expect(almacenAlReintentar.single, {
        AlmacenSesion.claveAcceso: 'acc-B',
        AlmacenSesion.claveRefresco: 'ref-B',
      });
      expect(c.read(sesionProvider)!.accessToken, 'acc-B');
    });

    test(
      'CA_026_14 cinco llamadas simultáneas con 401 comparten una renovación',
      () async {
        await montar();
        final rs = await Future.wait([for (var i = 0; i < 5; i++) pedir('me')]);

        expect(rs.map((r) => r.statusCode), everyElement(200));
        expect(refrescos, 1);
        final reintentos = api.peticiones.where((p) => token(p) == 'acc-B');
        expect(reintentos, hasLength(5));
      },
    );

    test(
      'CA_026_15 un segundo 401 tras renovar no dispara otra renovación',
      () async {
        await montar();
        validos.clear();
        final r = await pedir('me');

        expect(r.statusCode, 401);
        expect(api.llamadas, ['GET me', 'POST auth/refresh', 'GET me']);
        expect(c.read(sesionProvider), isNull);
        expect(c.read(sesionIniciadaProvider), isFalse);
      },
    );

    test('CA_026_16 un refresh rechazado (400 o 401) cierra la sesión y limpia todo', () async {
      for (final estado in [400, 401]) {
        api.peticiones.clear();
        almacen = AlmacenSeguroEnMemoria();
        respuestaRefresh = () => http.Response('', estado);
        await montar();
        c
            .read(cacheRespuestasProvider)
            .guardar(
              'k',
              etag: 'e',
              cuerpo: Uint8List(0),
              encabezados: const {},
            );

        final r = await pedir('me');

        expect(r.statusCode, 401, reason: '$estado');
        expect(c.read(sesionProvider), isNull);
        expect(c.read(sesionIniciadaProvider), isFalse);
        expect(almacen.contenido, isEmpty);
        expect(c.read(cacheRespuestasProvider).estaVacia, isTrue);

        // El token vencido no se vuelve a enviar.
        api.peticiones.clear();
        await expectLater(pedir('me'), throwsA(isA<NoAutorizadoFailure>()));
        expect(api.peticiones, isEmpty);
      }
    });

    test(
      'CA_026_17 un refresh que falla por 5xx conserva la sesión y los tokens',
      () async {
        respuestaRefresh = () => http.Response('', 503);
        await montar();
        await expectLater(
          pedir('me'),
          throwsA(isA<ServicioNoDisponibleFailure>()),
        );
        expect(c.read(sesionProvider), tokensA);
        expect(c.read(sesionIniciadaProvider), isTrue);
        expect(almacen.contenido[AlmacenSesion.claveRefresco], 'ref-A');
      },
    );

    test(
      'CA_026_17 un refresh con 429 conserva la sesión y trae la espera',
      () async {
        respuestaRefresh = () =>
            http.Response('', 429, headers: {'retry-after': '30'});
        await montar();
        await expectLater(
          pedir('me'),
          throwsA(
            isA<DemasiadosIntentosFailure>().having(
              (f) => f.espera,
              'espera',
              const Duration(seconds: 30),
            ),
          ),
        );
        expect(c.read(sesionProvider), tokensA);
        expect(c.read(sesionIniciadaProvider), isTrue);
      },
    );

    test('CA_026_17 un refresh sin red conserva la sesión', () async {
      respuestaRefresh = () => throw http.ClientException('sin red');
      await montar();
      await expectLater(
        pedir('me'),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
      expect(c.read(sesionProvider), tokensA);
      expect(almacen.contenido[AlmacenSesion.claveAcceso], 'acc-A');
    });

    test('cerrar la sesión durante la renovación no la reabre', () async {
      await montar();
      final pendiente = pedir('me');
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await c.read(sesionProvider.notifier).cerrar();
      final r = await pedir('me')
          .then<Object>((x) => x, onError: (Object e) => e);

      await pendiente.then<void>((_) {}, onError: (Object _) {});
      expect(r, isA<NoAutorizadoFailure>());
      expect(c.read(sesionProvider), isNull);
      expect(almacen.contenido, isEmpty);
    });
  });

  group('Escrituras y cierre de sesión', () {
    test(
      'CA_026_25 un PUT que falla por red o 5xx sale una sola vez',
      () async {
        await montar();
        api.responder = (_) => throw http.ClientException('sin red');
        await expectLater(
          enviarJson(
            c.read(transporteApiProvider),
            urlApiPrueba,
            'PUT',
            'me',
            cuerpo: {'nombre': 'Ana'},
          ),
          throwsA(isA<ServicioNoDisponibleFailure>()),
        );
        expect(api.peticiones, hasLength(1));

        api.peticiones.clear();
        api.responder = (_) => http.Response('', 503);
        await expectLater(
          enviarJson(
            c.read(transporteApiProvider),
            urlApiPrueba,
            'PUT',
            'me',
            cuerpo: {'nombre': 'Ana'},
          ),
          throwsA(isA<ServicioNoDisponibleFailure>()),
        );
        expect(api.peticiones, hasLength(1));
      },
    );

    test(
      'CA_026_13 un PUT solo se repite tras un 401 con renovación exitosa',
      () async {
        await montar();
        api.responder = (p) async {
          if (p.ruta == 'auth/refresh') {
            return jsonOk(tokensJson('acc-B', 'ref-B'));
          }
          return token(p) == 'acc-B'
              ? jsonOk(perfilJson())
              : http.Response('', 401);
        };
        await enviarJson(
          c.read(transporteApiProvider),
          urlApiPrueba,
          'PUT',
          'me',
          cuerpo: {'nombre': 'Ana'},
        );
        expect(api.llamadas, ['PUT me', 'POST auth/refresh', 'PUT me']);
        expect(api.peticiones.last.json, {'nombre': 'Ana'});
      },
    );

    test('CA_026_08 el logout con 401 no renueva ni se repite', () async {
      await montar();
      validos.clear();
      final r = await pedir('auth/logout', metodo: 'POST');
      expect(r.statusCode, 401);
      expect(api.llamadas, ['POST auth/logout']);
      expect(refrescos, 0);
      // La sesión no se cierra por el transporte: lo hace quien cierra sesión.
      expect(c.read(sesionProvider), tokensA);
    });
  });

  test(
    'CA_026_26 al cerrar no queda ningún token en el almacén ni en la caché',
    () async {
      await montar();
      c
          .read(cacheRespuestasProvider)
          .guardar(
            'k',
            etag: 'e',
            cuerpo: Uint8List.fromList([1]),
            encabezados: const {},
          );
      await c.read(sesionProvider.notifier).cerrar();
      expect(almacen.contenido, isEmpty);
      expect(c.read(cacheRespuestasProvider).estaVacia, isTrue);
      expect(c.read(sesionProvider), isNull);
      expect(c.read(sesionIniciadaProvider), isFalse);
    },
  );
}
