// Spec 002 (KNOCK-216), CA-01 y CA-04: renovación del token y caché vacía al
// cerrar sesión. El servidor es simulado en 127.0.0.1; el endpoint de
// renovación es un doble (la renovación real se prueba en
// `cliente_autenticado_test.dart`). Spec 026 cambió las reglas: el Bearer solo
// va a las rutas protegidas de la API y un fallo transitorio no cierra sesión.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cache_respuestas.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/renovador_sesion_api.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class _Renovador implements RenovadorSesion {
  _Renovador(this.resultado);

  TokensSesion? resultado;
  var llamadas = 0;
  var lanza = false;

  @override
  Future<TokensSesion?> renovar(String refreshToken) async {
    llamadas++;
    await Future<void>.delayed(const Duration(milliseconds: 20));
    if (lanza) throw StateError('falla de red');
    return resultado;
  }
}

class _Servidor {
  _Servidor._(this._http);

  final HttpServer _http;
  final peticiones = <({String ruta, Map<String, String> encabezados})>[];
  final tokensValidos = <String>{};
  String? etag;
  var cuerpo = 'catalogo-v1';

  String get url => 'http://127.0.0.1:${_http.port}';

  static Future<_Servidor> iniciar() async {
    final s = _Servidor._(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    s._http.listen((p) async {
      final h = <String, String>{};
      p.headers.forEach((k, v) => h[k] = v.join(','));
      s.peticiones.add((ruta: p.uri.path, encabezados: h));
      final token = h['authorization']?.replaceFirst('Bearer ', '');
      final r = p.response;
      if (p.uri.path == '/api/v1/me' && !s.tokensValidos.contains(token)) {
        r.statusCode = 401;
      } else if (s.etag != null && h['if-none-match'] == s.etag) {
        r.statusCode = 304;
      } else {
        r.statusCode = 200;
        if (s.etag != null) r.headers.set('etag', s.etag!);
        r.write(s.cuerpo);
      }
      await r.close();
    });
    return s;
  }

  Future<void> cerrar() => _http.close(force: true);
}

const _vencido = TokensSesion(accessToken: 'vencido', refreshToken: 'r1');

void main() {
  late _Servidor servidor;
  late _Renovador renovador;
  late ProviderContainer c;
  late AlmacenSeguroEnMemoria almacen;

  setUp(() async {
    servidor = await _Servidor.iniciar();
    almacen = AlmacenSeguroEnMemoria();
    renovador = _Renovador(
      const TokensSesion(accessToken: 'nuevo', refreshToken: 'r2'),
    );
    c = ProviderContainer(
      overrides: [
        renovadorSesionProvider.overrideWithValue(renovador),
        urlApiProvider.overrideWithValue(servidor.url),
        almacenSeguroProvider.overrideWithValue(almacen),
      ],
    );
  });

  tearDown(() async {
    c.dispose();
    await servidor.cerrar();
  });

  Future<http.Response> pedir(String ruta) async => http.Response.fromStream(
    await c
        .read(transporteApiProvider)
        .send(http.Request('GET', Uri.parse('${servidor.url}$ruta'))),
  );

  group('CA-002-01 token vencido', () {
    test('CA-002-01 renueva el token y repite la petición', () async {
      servidor.tokensValidos.add('nuevo');
      await c.read(sesionProvider.notifier).iniciar(_vencido);

      final r = await pedir('/api/v1/me');

      expect(r.statusCode, 200);
      expect(renovador.llamadas, 1);
      expect(servidor.peticiones.map((p) => p.encabezados['authorization']), [
        'Bearer vencido',
        'Bearer nuevo',
      ]);
      expect(c.read(sesionProvider)!.accessToken, 'nuevo');
    });

    test('CA-002-01 peticiones simultáneas comparten una renovación', () async {
      servidor.tokensValidos.add('nuevo');
      await c.read(sesionProvider.notifier).iniciar(_vencido);

      final rs = await Future.wait([pedir('/api/v1/me'), pedir('/api/v1/me')]);

      expect(rs.map((r) => r.statusCode), [200, 200]);
      expect(renovador.llamadas, 1);
    });

    test('CA-002-01 sin token no sale la petición ni se renueva', () async {
      await expectLater(
        pedir('/api/v1/me'),
        throwsA(isA<NoAutorizadoFailure>()),
      );
      expect(renovador.llamadas, 0);
      expect(servidor.peticiones, isEmpty);
    });
  });

  group('CA-002-01 seguridad negativa', () {
    test(
      'CA-002-01 si ya no es válido cierra sesión y entrega el 401',
      () async {
        renovador.resultado = null;
        await c.read(sesionProvider.notifier).iniciar(_vencido);

        final r = await pedir('/api/v1/me');

        expect(r.statusCode, 401);
        expect(c.read(sesionProvider), isNull);
        expect(almacen.contenido, isEmpty);
        expect(servidor.peticiones, hasLength(1));
      },
    );

    test(
      'CA-002-01 si la renovación falla por red conserva la sesión',
      () async {
        renovador.lanza = true;
        await c.read(sesionProvider.notifier).iniciar(_vencido);
        await expectLater(
          pedir('/api/v1/me'),
          throwsA(isA<ServicioNoDisponibleFailure>()),
        );
        expect(c.read(sesionProvider), _vencido);
      },
    );

    test(
      'CA-002-01 repite solo una vez si el token nuevo también falla',
      () async {
        await c.read(sesionProvider.notifier).iniciar(_vencido);
        final r = await pedir('/api/v1/me');
        expect(r.statusCode, 401);
        expect(servidor.peticiones, hasLength(2));
      },
    );

    test('CA-002-01 los tokens no salen en toString', () {
      const t = TokensSesion(accessToken: 'secreto', refreshToken: 'otro');
      expect(t.toString(), isNot(contains('secreto')));
      expect(t.toString(), isNot(contains('otro')));
    });
  });

  group('CA-002-04 caché', () {
    test('CA-002-04 revalida con ETag y usa lo guardado ante 304', () async {
      servidor.etag = '"v1"';
      expect(utf8.decode((await pedir('/catalogo')).bodyBytes), 'catalogo-v1');
      expect(c.read(cacheRespuestasProvider).estaVacia, isFalse);

      servidor.cuerpo = 'no-debe-bajar';
      final r = await pedir('/catalogo');

      expect(r.body, 'catalogo-v1');
      expect(servidor.peticiones.last.encabezados['if-none-match'], '"v1"');
    });

    test('CA-002-04 al cerrar sesión la caché queda vacía', () async {
      servidor.etag = '"v1"';
      await c.read(sesionProvider.notifier).iniciar(_vencido);
      await pedir('/catalogo');
      expect(c.read(cacheRespuestasProvider).estaVacia, isFalse);

      await c.read(sesionProvider.notifier).cerrar();

      expect(c.read(cacheRespuestasProvider).estaVacia, isTrue);
      expect(c.read(sesionProvider), isNull);
      expect(almacen.contenido, isEmpty);
    });

    test(
      'CA-002-04 al iniciar otra sesión no queda nada de la anterior',
      () async {
        servidor.etag = '"v1"';
        await pedir('/catalogo');
        await c.read(sesionProvider.notifier).iniciar(_vencido);
        expect(c.read(cacheRespuestasProvider).estaVacia, isTrue);
      },
    );

    test('CA-002-04 una entrada vencida se descarta', () {
      var ahora = DateTime(2026);
      final cache = CacheRespuestas(
        vigencia: const Duration(minutes: 1),
        ahora: () => ahora,
      );
      cache.guardar('k', etag: 'e', cuerpo: Uint8List(0), encabezados: {});
      expect(cache.obtener('k'), isNotNull);
      ahora = ahora.add(const Duration(minutes: 2));
      expect(cache.obtener('k'), isNull);
      expect(cache.estaVacia, isTrue);
    });

    test('CA-002-04 no guarda respuestas sin ETag', () async {
      await pedir('/catalogo');
      expect(c.read(cacheRespuestasProvider).estaVacia, isTrue);
    });
  });
}
