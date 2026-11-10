// Spec 026 (KNOCK-248), P-3: `PerfilRepositoryApi` sobre el transporte real de
// la app (Bearer, ETag, renovación) con una API falsa, sin red.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/domain/perfil_repository.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/l10n/generado/app_localizations_es.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../soporte/api_falsa.dart';

void main() {
  late ApiFalsa api;
  late AlmacenSeguroEnMemoria almacen;
  late ProviderContainer c;
  var perfilServidor = <String, Object?>{};

  PerfilRepository repo() => c.read(perfilRepositoryProvider);

  void montar({TokensSesion? tokens = tokensA}) {
    almacen = AlmacenSeguroEnMemoria();
    c = contenedorConApi(api, tokens: tokens, almacen: almacen);
    addTearDown(c.dispose);
    c.listen(sesionIniciadaProvider, (_, _) {});
  }

  setUp(() {
    perfilServidor = perfilJson(
      colonia: 'Centro',
      codigoPostal: '42500',
      fotoUrl: 'https://cdn.knock.test/f.png',
    );
    api = ApiFalsa((p) {
      if (p.metodo == 'PUT') {
        return jsonOk({...perfilServidor, 'nombre': p.json['nombre']});
      }
      if (p.ruta == 'auth/logout') return http.Response('', 204);
      return jsonOk(perfilServidor, h: {'etag': 'W/"v1"'});
    });
  });

  group('lectura', () {
    test(
      'CA_026_01 GET /me lleva el Bearer y entrega el perfil del servidor',
      () async {
        montar();
        final perfil = await repo().obtener();

        final p = api.peticiones.single;
        expect(p.llamadaCompleta, 'GET /api/v1/me');
        expect(p.autorizacion, 'Bearer acc-A');
        expect(perfil.nombre, 'Ana López');
        expect(perfil.fotoUrl, 'https://cdn.knock.test/f.png');
        expect(perfil.colonia, 'Centro');
        expect(perfil.codigoPostal, '42500');
        expect(perfil.perfilCompleto, isTrue);
        expect(perfil.esTecnico, isFalse);
        expect(perfil.estado, 'activo');
      },
    );

    test('CA_026_02 con un ETag guardado manda If-None-Match y un 304 entrega el mismo perfil', () async {
      montar();
      final primero = await repo().obtener();
      api.responder = (p) => http.Response('', 304);

      final segundo = await repo().obtener();

      expect(api.peticiones.last.cabeceras['if-none-match'], 'W/"v1"');
      expect(segundo, primero);
    });

    test(
      'un 304 sin ETag guardado es un error de datos, no un perfil vacío',
      () async {
        montar();
        api.responder = (_) => http.Response('', 304);
        await expectLater(
          repo().obtener(),
          throwsA(isA<DatosInvalidosFailure>()),
        );
      },
    );

    test('CA_026_01 un cuerpo sin los campos del contrato es DatosInvalidosFailure', () async {
      montar();
      for (final malo in <Object>[
        <Object?>[],
        {...perfilJson(), 'perfilCompleto': 'si'},
        {...perfilJson(), 'esTecnico': null},
        {...perfilJson(), 'estado': ''},
        {...perfilJson(), 'colonia': 3},
      ]) {
        api.responder = (_) => jsonOk(malo);
        await expectLater(
          repo().obtener(),
          throwsA(isA<DatosInvalidosFailure>()),
        );
      }
    });

    test('CA_026_05 sin sesión no sale ninguna petición y falla con NoAutorizadoFailure', () async {
      montar(tokens: null);
      await expectLater(repo().obtener(), throwsA(isA<NoAutorizadoFailure>()));
      await expectLater(
        repo().guardarNombre('Ana'),
        throwsA(isA<NoAutorizadoFailure>()),
      );
      expect(api.peticiones, isEmpty);
    });
  });

  group('escritura', () {
    test('CA_026_03 el PUT reenvía foto, colonia y código postal y su respuesta reemplaza lo guardado', () async {
      montar();
      await repo().obtener();

      final guardado = await repo().guardarNombre('  Ana María ');

      final put = api.peticiones.last;
      expect(put.llamadaCompleta, 'PUT /api/v1/me');
      expect(put.autorizacion, 'Bearer acc-A');
      expect(put.json, {
        'nombre': 'Ana María',
        'fotoUrl': 'https://cdn.knock.test/f.png',
        'colonia': 'Centro',
        'codigoPostal': '42500',
      });
      expect(guardado.nombre, 'Ana María');

      // El servidor respondió otra colonia: el siguiente PUT usa la nueva.
      api.responder = (p) => jsonOk({
        ...perfilServidor,
        'nombre': p.json['nombre'],
        'colonia': 'Reforma',
      });
      await repo().guardarNombre('Ana');
      await repo().guardarNombre('Ana B');
      expect(api.peticiones.last.json['colonia'], 'Reforma');
    });

    test('CA_026_03 un perfil sin opcionales no manda opcionales', () async {
      perfilServidor = perfilJson();
      montar();
      await repo().obtener();
      await repo().guardarNombre('Ana');
      expect(api.peticiones.last.json, {'nombre': 'Ana'});
    });

    test(
      'CA_026_03 si aún no se leyó el perfil, lo lee antes de guardar',
      () async {
        montar();
        await repo().guardarNombre('Ana');
        expect(api.llamadas, ['GET me', 'PUT me']);
        expect(api.peticiones.last.json['colonia'], 'Centro');
      },
    );

    test('CA_026_04 un PUT rechazado falla con el Failure esperado y no cambia lo guardado', () async {
      final casos = <int, TypeMatcher<Failure>>{
        400: isA<DatosRechazadosFailure>(),
        413: isA<DatosRechazadosFailure>(),
        422: isA<DatosRechazadosFailure>(),
        409: isA<ConflictoFailure>(),
        503: isA<ServicioNoDisponibleFailure>(),
      };
      for (final MapEntry(key: estado, value: falla) in casos.entries) {
        montar();
        await repo().obtener();
        final antes = api.peticiones.length;
        api.responder = (_) => http.Response('{"detail":"x"}', estado);

        await expectLater(
          repo().guardarNombre('Otro'),
          throwsA(falla),
          reason: '$estado',
        );
        // Una sola petición: no se reintentó (CA_026_25).
        expect(api.peticiones.length - antes, 1, reason: '$estado');

        // Lo guardado no cambió: el siguiente PUT reenvía lo del último GET.
        api.responder = (p) => jsonOk(perfilServidor);
        await repo().guardarNombre('Ana');
        expect(api.peticiones.last.json['colonia'], 'Centro');
      }
    });

    test('CA_026_04 el controlador conserva el perfil mostrado si el guardado falla', () async {
      montar();
      await c.read(perfilControllerProvider.future);
      final antes = c.read(perfilControllerProvider).value;
      api.responder = (_) => http.Response('', 422);

      final error = await c
          .read(perfilControllerProvider.notifier)
          .guardarNombre('Otro');

      expect(error, isA<DatosRechazadosFailure>());
      expect(c.read(perfilControllerProvider).value, antes);
      expect(c.read(perfilControllerProvider).hasError, isFalse);
    });

    test('CA_026_25 un PUT que falla por red sale una sola vez', () async {
      montar();
      await repo().obtener();
      final antes = api.peticiones.length;
      api.responder = (_) => throw http.ClientException('sin red');

      await expectLater(
        repo().guardarNombre('Ana'),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
      expect(api.peticiones.length - antes, 1);
    });
  });

  group('errores de la interfaz', () {
    test('CA_026_18 cada error llega con su mensaje en español, sin URL, cuerpo ni token', () async {
      final es = AppLocalizationsEs();
      final casos = <String, ({http.Response Function() r, String texto})>{
        '400': (
          r: () => http.Response('x', 400),
          texto: es.errorDatosRechazados,
        ),
        '401': (r: () => http.Response('x', 401), texto: es.errorSesionVencida),
        '409': (r: () => http.Response('x', 409), texto: es.errorConflicto),
        '413': (
          r: () => http.Response('x', 413),
          texto: es.errorDatosRechazados,
        ),
        '422': (
          r: () => http.Response('x', 422),
          texto: es.errorDatosRechazados,
        ),
        '429': (
          r: () => http.Response('x', 429, headers: {'retry-after': '30'}),
          texto: es.errorDemasiadosIntentos,
        ),
        '503': (r: () => http.Response('x', 503), texto: es.errorSinConexion),
        'sin red': (
          r: () => throw http.ClientException('http://secreto/acc-A'),
          texto: es.errorSinConexion,
        ),
      };
      for (final MapEntry(key: nombre, value: caso) in casos.entries) {
        montar();
        // Un 401 del PUT pasa antes por la renovación, que aquí se rechaza.
        api.responder = (p) {
          if (p.ruta == 'auth/refresh') return http.Response('', 401);
          if (p.metodo == 'GET') return jsonOk(perfilServidor);
          return caso.r();
        };
        await repo().obtener();
        Object? error;
        try {
          await repo().guardarNombre('Ana');
        } on Object catch (e) {
          error = e;
        }
        expect(error, isA<Failure>(), reason: nombre);
        final mensaje = mensajeDeError(es, error!);
        expect(mensaje, caso.texto, reason: nombre);
        for (final nunca in [
          'http',
          'acc-A',
          'ref-A',
          'secreto',
          '{',
          'Exception',
        ]) {
          expect(mensaje, isNot(contains(nunca)), reason: '$nombre $nunca');
          expect('$error', isNot(contains(nunca)), reason: '$nombre $nunca');
        }
      }
    });

    test('CA_026_18 un 429 conserva el Retry-After de 30 segundos', () async {
      montar();
      api.responder = (_) =>
          http.Response('', 429, headers: {'retry-after': '30'});
      await expectLater(
        repo().obtener(),
        throwsA(
          isA<DemasiadosIntentosFailure>().having(
            (f) => f.espera,
            'espera',
            const Duration(seconds: 30),
          ),
        ),
      );
    });
  });

  group('cierre de sesión', () {
    test(
      'CA_026_06 con 204 hace POST /auth/logout con Bearer y deja todo cerrado',
      () async {
        montar();
        await c.read(sesionProvider.notifier).iniciar(tokensA);
        await repo().obtener();

        await repo().cerrarSesion();

        final logout = api.peticiones.last;
        expect(logout.llamadaCompleta, 'POST /api/v1/auth/logout');
        expect(logout.autorizacion, 'Bearer acc-A');
        expect(almacen.contenido, isEmpty);
        expect(c.read(sesionProvider), isNull);
        expect(c.read(sesionIniciadaProvider), isFalse);
      },
    );

    test('CA_026_07 sin red, con 401 o con 5xx igual se cierra en el teléfono y no hay error', () async {
      final fallos = <http.Response Function()>[
        () => throw http.ClientException('sin red'),
        () => http.Response('', 401),
        () => http.Response('', 500),
        () => http.Response('', 503),
      ];
      for (final fallo in fallos) {
        montar();
        await c.read(sesionProvider.notifier).iniciar(tokensA);
        api.responder = (_) => fallo();

        await repo().cerrarSesion();

        expect(almacen.contenido, isEmpty);
        expect(c.read(sesionProvider), isNull);
        expect(c.read(sesionIniciadaProvider), isFalse);
      }
    });

    test('CA_026_08 un logout con 401 es una sola petición, sin renovar ni repetir', () async {
      montar();
      api.responder = (_) => http.Response('', 401);
      await repo().cerrarSesion();
      expect(api.llamadas, ['POST auth/logout']);
    });

    test('CA_026_07 sin sesión también se cierra sin salir a la red', () async {
      montar(tokens: null);
      await repo().cerrarSesion();
      expect(api.peticiones, isEmpty);
      expect(c.read(sesionIniciadaProvider), isFalse);
    });

    test('CA_026_26 el perfil de una cuenta no pasa a la siguiente', () async {
      montar();
      await c.read(sesionProvider.notifier).iniciar(tokensA);
      await c.read(perfilControllerProvider.future);
      await c.read(perfilControllerProvider.notifier).cerrarSesion();

      // Sin sesión no hay perfil: el estado es un error, no el perfil anterior.
      expect(perfilCargado(c.read(perfilControllerProvider)), isNull);

      // Otra cuenta entra y se vuelve a pedir su perfil con su propio token.
      perfilServidor = perfilJson(nombre: 'Luis');
      await c
          .read(sesionProvider.notifier)
          .iniciar(
            const TokensSesion(accessToken: 'acc-L', refreshToken: 'r-L'),
          );
      final luis = await c.read(perfilControllerProvider.future);
      expect(luis.nombre, 'Luis');
      expect(api.peticiones.last.autorizacion, 'Bearer acc-L');
      expect(luis.colonia, isNull);
    });
  });
}
