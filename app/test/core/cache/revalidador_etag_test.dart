// Spec 010 (KNOCK-224): caché con ETag, vigencias, sin conexión y borrado.
import 'dart:io';

import 'package:app/core/cache/almacen_cache.dart';
import 'package:app/core/cache/revalidador_etag.dart';
import 'package:app/core/errores/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _url = Uri.parse('https://api.ejemplo.test/api/v1/oficios');
const _vigencia = Duration(minutes: 10);
const _clave = 'catalogo/oficios';

class _Reloj {
  DateTime ahora = DateTime.utc(2026, 11, 5, 12);
  DateTime call() => ahora;
}

void main() {
  late _Reloj reloj;
  late AlmacenCacheEnMemoria almacen;
  late List<String?> ifNoneMatch;
  late http.Response Function(http.Request) servidor;

  RevalidadorEtag crear() => RevalidadorEtag(
    cliente: MockClient((peticion) async {
      ifNoneMatch.add(peticion.headers['If-None-Match']);
      return servidor(peticion);
    }),
    almacen: almacen,
    ahora: reloj.call,
  );

  setUp(() {
    reloj = _Reloj();
    almacen = AlmacenCacheEnMemoria();
    ifNoneMatch = [];
    servidor = (_) => http.Response('[1]', 200, headers: {'etag': '"v1"'});
  });

  Future<RespuestaCache> pedir(RevalidadorEtag r) =>
      r.obtener(_url, clave: _clave, vigencia: _vigencia);

  test('CA_010_01 con el dato sin cambios el servidor responde 304 y se usa '
      'lo guardado', () async {
    final r = crear();
    expect((await pedir(r)).origen, OrigenCache.red);
    expect(ifNoneMatch.single, isNull);

    reloj.ahora = reloj.ahora.add(const Duration(minutes: 11));
    servidor = (_) => http.Response('', 304);
    final segunda = await pedir(r);

    expect(ifNoneMatch.last, '"v1"');
    expect(segunda.origen, OrigenCache.cacheRevalidada);
    expect(segunda.cuerpo, '[1]');
    // El 304 renueva la vigencia: otra lectura inmediata no pregunta.
    expect((await pedir(r)).origen, OrigenCache.cache);
    expect(ifNoneMatch, hasLength(2));
  });

  test(
    'CA_010_01 un 200 con datos nuevos reemplaza lo guardado y su ETag',
    () async {
      final r = crear();
      await pedir(r);
      reloj.ahora = reloj.ahora.add(const Duration(minutes: 11));
      servidor = (_) => http.Response('[2]', 200, headers: {'etag': '"v2"'});
      expect((await pedir(r)).cuerpo, '[2]');
      expect((await almacen.leer(_clave))!.etag, '"v2"');
    },
  );

  test('CA_010_01 dentro de la vigencia no hay petición', () async {
    final r = crear();
    await pedir(r);
    reloj.ahora = reloj.ahora.add(const Duration(minutes: 9));
    expect((await pedir(r)).origen, OrigenCache.cache);
    expect(ifNoneMatch, hasLength(1));
  });

  test(
    'R_010_SC sin conexión se muestra lo guardado aunque haya vencido',
    () async {
      final r = crear();
      await pedir(r);
      reloj.ahora = reloj.ahora.add(const Duration(hours: 3));
      servidor = (_) => throw const SocketException('sin red');
      final respuesta = await pedir(r);
      expect(respuesta.origen, OrigenCache.cacheSinConexion);
      expect(respuesta.sinConexion, isTrue);
      expect(respuesta.cuerpo, '[1]');
    },
  );

  test('R_010_SC un 503 también cae a lo guardado', () async {
    final r = crear();
    await pedir(r);
    reloj.ahora = reloj.ahora.add(const Duration(hours: 3));
    servidor = (_) => http.Response('', 503);
    expect((await pedir(r)).sinConexion, isTrue);
  });

  test(
    'R_010_SC sin conexión y sin nada guardado es un fallo tipado',
    () async {
      servidor = (_) => throw http.ClientException('sin red');
      await expectLater(
        pedir(crear()),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    },
  );

  test('R_010_SC el 429 no se oculta con lo guardado', () async {
    final r = crear();
    await pedir(r);
    reloj.ahora = reloj.ahora.add(const Duration(hours: 3));
    servidor = (_) => http.Response('', 429);
    await expectLater(pedir(r), throwsA(isA<DemasiadosIntentosFailure>()));
  });

  test('CA_010_01 un cuerpo inválido no se guarda en la caché', () async {
    servidor = (_) => http.Response('basura', 200);
    await expectLater(
      crear().obtener(
        _url,
        clave: _clave,
        vigencia: _vigencia,
        validar: (_) => throw const DatosInvalidosFailure(),
      ),
      throwsA(isA<DatosInvalidosFailure>()),
    );
    expect(await almacen.leer(_clave), isNull);
  });

  test('R_010_04 las listas personales no se guardan en caché', () async {
    for (final clave in ['mis-solicitudes', 'solicitudes/mias', 'sesion/x']) {
      expect(esClaveCacheable(clave), isFalse);
      await expectLater(
        almacen.guardar(
          clave,
          EntradaCache(cuerpo: 'x', guardadoEn: reloj.ahora),
        ),
        throwsArgumentError,
      );
    }
    expect(esClaveCacheable('catalogo/oficios'), isTrue);
  });

  group('almacén persistente', () {
    test('CA_010_03 al cerrar sesión no queda caché y las preferencias '
        'ajenas se conservan', () async {
      SharedPreferences.setMockInitialValues({
        'knock.preferencias.tema': 'oscuro',
      });
      final preferencias = await SharedPreferences.getInstance();
      final persistente = AlmacenCacheShared(preferencias);
      await persistente.guardar(
        _clave,
        EntradaCache(cuerpo: '[1]', etag: '"v1"', guardadoEn: reloj.ahora),
      );
      await persistente.guardar(
        'perfil/abc',
        EntradaCache(cuerpo: '{}', guardadoEn: reloj.ahora),
      );
      // Sobrevive a reabrir la app: otra instancia sobre las mismas prefs.
      final leida = await AlmacenCacheShared(preferencias).leer(_clave);
      expect(leida!.etag, '"v1"');
      expect(leida.guardadoEn, reloj.ahora);

      await persistente.borrarTodo();

      expect(await persistente.leer(_clave), isNull);
      expect(await persistente.leer('perfil/abc'), isNull);
      expect(
        preferencias.getKeys().where((k) => k.startsWith('knock.cache.')),
        isEmpty,
      );
      expect(preferencias.getString('knock.preferencias.tema'), 'oscuro');
    });

    test('un valor dañado se trata como ausente', () async {
      SharedPreferences.setMockInitialValues({'knock.cache.$_clave': '{no'});
      final persistente = AlmacenCacheShared(
        await SharedPreferences.getInstance(),
      );
      expect(await persistente.leer(_clave), isNull);
    });
  });
}
