// Spec 026 (KNOCK-248), P-7: integración con un servidor falso de la API
// (`HttpServer` en 127.0.0.1, sin red real, datos ficticios) y seguridad
// negativa: el token nunca aparece en registros, `toString` ni mensajes.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensaje_failure.dart';
import 'package:app/core/red/cache_respuestas.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:app/core/sesion/identificador_dispositivo.dart';
import 'package:app/core/sesion/canje_sesion.dart';
import 'package:app/core/sesion/servicio_entrada.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/l10n/generado/app_localizations_es.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servidor falso con los endpoints de la spec 026. Un token de acceso solo
/// sirve si está en [validos]; cada renovación entrega el siguiente par.
class _Servidor {
  _Servidor._(this._http);

  final HttpServer _http;
  final llamadas = <String>[];
  final autorizaciones = <String?>[];
  final validos = <String>{};
  var generacion = 1;
  var refrescos = 0;
  var rechazarRefresh = false;
  var tokensNuevosInvalidos = false;

  String get url => 'http://127.0.0.1:${_http.port}';

  static Future<_Servidor> iniciar() async {
    final s = _Servidor._(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    s._http.listen(s._atender);
    return s;
  }

  Future<void> _atender(HttpRequest p) async {
    final cuerpo = await utf8.decoder.bind(p).join();
    final ruta = p.uri.path.replaceFirst('/api/v1/', '');
    llamadas.add('${p.method} $ruta');
    final auth = p.headers.value('authorization');
    autorizaciones.add(auth);
    final r = p.response;
    final token = auth?.replaceFirst('Bearer ', '');

    void json(int estado, Object? datos) {
      r.statusCode = estado;
      r.headers.contentType = ContentType.json;
      r.write(jsonEncode(datos));
    }

    switch ('${p.method} $ruta') {
      case 'POST auth/firebase':
        validos.add('acc-SECRETO-$generacion');
        json(200, {
          'accessToken': 'acc-SECRETO-$generacion',
          'refreshToken': 'ref-SECRETO-$generacion',
          'esNuevo': false,
          'perfilCompleto': true,
        });
      case 'POST auth/refresh':
        refrescos++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        if (rechazarRefresh) {
          r.statusCode = 401;
        } else {
          generacion++;
          if (!tokensNuevosInvalidos) validos.add('acc-SECRETO-$generacion');
          json(200, {
            'accessToken': 'acc-SECRETO-$generacion',
            'expiresIn': 900,
            'refreshToken': 'ref-SECRETO-$generacion',
          });
        }
      case _ when !validos.contains(token):
        r.statusCode = 401;
      case 'GET me':
        json(200, _perfil('Ana López'));
      case 'PUT me':
        json(200, _perfil((jsonDecode(cuerpo) as Map)['nombre']! as String));
      case 'GET colonias/en-punto':
        json(200, {
          'enCobertura': true,
          'colonia': {
            'id': '1',
            'nombre': 'Centro',
            'cp': '42500',
            'municipio': 'Actopan',
          },
        });
      case 'POST auth/logout':
        r.statusCode = 204;
      default:
        r.statusCode = 404;
    }
    await r.close();
  }

  static Map<String, Object?> _perfil(String nombre) => {
    'id': 'u-1',
    'nombre': nombre,
    'fotoUrl': null,
    'colonia': 'Centro',
    'codigoPostal': '42500',
    'esTecnico': false,
    'estado': 'activo',
    'perfilCompleto': true,
    'creadoEn': '2026-11-01T10:00:00Z',
  };

  Future<void> cerrar() => _http.close(force: true);
}

class _VerificadorFalso implements VerificadorCelular {
  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) async => SolicitudCodigo(celular: celular, idVerificacion: 'v-1');

  @override
  Future<String> tokenDeId(SolicitudCodigo solicitud, String codigo) async =>
      'firebase-ficticio';

  @override
  Future<void> cerrarSesion() async {}
}

void main() {
  late _Servidor servidor;
  late AlmacenSeguroEnMemoria almacen;
  late ProviderContainer c;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    servidor = await _Servidor.iniciar();
    almacen = AlmacenSeguroEnMemoria();
    c = ProviderContainer(
      overrides: [
        urlApiProvider.overrideWithValue(servidor.url),
        almacenSeguroProvider.overrideWithValue(almacen),
      ],
    );
    c.listen(sesionIniciadaProvider, (_, _) {});
  });

  tearDown(() async {
    c.dispose();
    await servidor.cerrar();
  });

  ServicioEntrada entrada() => ServicioEntradaReal(
    verificador: _VerificadorFalso(),
    canje: c.read(canjeSesionProvider),
    iniciarSesion: (t) => c.read(sesionProvider.notifier).iniciar(t),
    identificador: c.read(identificadorDispositivoProvider),
    dispositivo: 'Android',
  );

  Future<void> entrar() async {
    await entrada().verificarCodigo(
      const SolicitudCodigo(celular: '5512345678', idVerificacion: 'v-1'),
      '123456',
    );
    c.read(sesionIniciadaProvider.notifier).iniciar();
  }

  test('CA_026_27 entrar, leer perfil, guardar nombre, 401 con renovación, colonia y cerrar sesión', () async {
    await entrar();
    expect(c.read(sesionIniciadaProvider), isTrue);

    final repo = c.read(perfilRepositoryProvider);
    expect((await repo.obtener()).nombre, 'Ana López');
    expect((await repo.guardarNombre('Ana María')).nombre, 'Ana María');

    // El token de acceso vence (15 min): la siguiente llamada renueva.
    servidor.validos.remove('acc-SECRETO-1');
    final colonia = await c
        .read(coloniasRepositoryProvider)
        .enPunto(latitud: 20.27, longitud: -98.94);
    expect(colonia.colonia!.nombre, 'Centro');
    expect(c.read(sesionProvider)!.accessToken, 'acc-SECRETO-2');

    await repo.cerrarSesion();

    expect(servidor.llamadas, [
      'POST auth/firebase',
      'GET me',
      'PUT me',
      'GET colonias/en-punto',
      'POST auth/refresh',
      'GET colonias/en-punto',
      'POST auth/logout',
    ]);
    expect(servidor.autorizaciones.first, isNull);
    expect(servidor.autorizaciones[1], 'Bearer acc-SECRETO-1');
    expect(servidor.autorizaciones[5], 'Bearer acc-SECRETO-2');
    expect(servidor.autorizaciones.last, 'Bearer acc-SECRETO-2');
    expect(c.read(sesionIniciadaProvider), isFalse);
    expect(almacen.contenido.keys, isNot(contains(AlmacenSesion.claveAcceso)));
    expect(
      almacen.contenido.keys,
      isNot(contains(AlmacenSesion.claveRefresco)),
    );
    expect(c.read(cacheRespuestasProvider).estaVacia, isTrue);
  });

  test('CA_026_14 cinco llamadas con 401 contra el servidor comparten un POST /auth/refresh', () async {
    await entrar();
    servidor.validos.remove('acc-SECRETO-1');
    servidor.llamadas.clear();
    servidor.autorizaciones.clear();
    final repo = c.read(perfilRepositoryProvider);

    final perfiles = await Future.wait([
      for (var i = 0; i < 5; i++) repo.obtener(),
    ]);

    expect(perfiles, hasLength(5));
    expect(servidor.refrescos, 1);
    expect(
      servidor.llamadas.where((l) => l == 'POST auth/refresh'),
      hasLength(1),
    );
    final reintentos = servidor.autorizaciones.where(
      (a) => a == 'Bearer acc-SECRETO-2',
    );
    expect(reintentos, hasLength(5));
  });

  test('CA_026_16 con el refresh rechazado la sesión queda cerrada y el token vencido no se reenvía', () async {
    await entrar();
    servidor.validos.clear();
    servidor.rechazarRefresh = true;
    final repo = c.read(perfilRepositoryProvider);

    await expectLater(repo.obtener(), throwsA(isA<NoAutorizadoFailure>()));
    expect(c.read(sesionIniciadaProvider), isFalse);
    expect(almacen.contenido.keys, isNot(contains(AlmacenSesion.claveAcceso)));
    expect(
      almacen.contenido.keys,
      isNot(contains(AlmacenSesion.claveRefresco)),
    );

    servidor.llamadas.clear();
    await expectLater(
      c.read(perfilRepositoryProvider).obtener(),
      throwsA(isA<NoAutorizadoFailure>()),
    );
    expect(servidor.llamadas, isEmpty);
  });

  test('CA_026_15 un segundo 401 tras renovar cierra la sesión sin segunda renovación', () async {
    await entrar();
    servidor.validos.clear();
    servidor.tokensNuevosInvalidos = true;
    servidor.llamadas.clear();

    await expectLater(
      c.read(perfilRepositoryProvider).obtener(),
      throwsA(isA<NoAutorizadoFailure>()),
    );

    expect(servidor.llamadas, ['GET me', 'POST auth/refresh', 'GET me']);
    expect(c.read(sesionIniciadaProvider), isFalse);
    expect(almacen.contenido.keys, isNot(contains(AlmacenSesion.claveAcceso)));
    expect(
      almacen.contenido.keys,
      isNot(contains(AlmacenSesion.claveRefresco)),
    );
  });

  test('CA_026_26 al cerrar no quedan tokens en el almacén, la caché ni las preferencias', () async {
    await entrar();
    await c.read(perfilRepositoryProvider).obtener();
    expect(almacen.contenido[AlmacenSesion.claveAcceso], isNotNull);

    await c.read(perfilRepositoryProvider).cerrarSesion();

    expect(almacen.contenido.values.join(), isNot(contains('SECRETO')));
    expect(c.read(cacheRespuestasProvider).estaVacia, isTrue);
    final preferencias = await SharedPreferences.getInstance();
    expect(preferencias.getKeys(), isEmpty);
  });

  group('seguridad negativa', () {
    const secretos = ['acc-SECRETO', 'ref-SECRETO'];

    Future<(List<String>, List<Object>)> recorrer() async {
      final registros = <String>[];
      final errores = <Object>[];
      final impresion = debugPrint;
      debugPrint = (mensaje, {wrapWidth}) => registros.add(mensaje ?? '');
      addTearDown(() => debugPrint = impresion);
      await runZoned(
        () async {
          await entrar();
          final repo = c.read(perfilRepositoryProvider);
          await repo.obtener();
          servidor.validos.remove('acc-SECRETO-1');
          await repo.guardarNombre('Ana');
          servidor.rechazarRefresh = true;
          servidor.validos.clear();
          try {
            await repo.obtener();
          } on Object catch (e) {
            errores.add(e);
          }
          try {
            await c
                .read(coloniasRepositoryProvider)
                .enPunto(latitud: 1, longitud: 2);
          } on Object catch (e) {
            errores.add(e);
          }
          await repo.cerrarSesion();
        },
        zoneSpecification: ZoneSpecification(
          print: (_, _, _, linea) => registros.add(linea),
        ),
      );
      return (registros, errores);
    }

    test('CA_026_24 el token no aparece en registros, toString ni mensajes', () async {
      final (registros, errores) = await recorrer();
      final es = AppLocalizationsEs();

      expect(errores, isNotEmpty);
      final textos = <String>[
        ...registros,
        for (final e in errores) '$e',
        for (final e in errores) mensajeDeError(es, e),
        '${c.read(sesionProvider)}',
        '${const TokensSesion(accessToken: 'acc-SECRETO-1', refreshToken: 'ref-SECRETO-1')}',
        '${const SesionEmitida(acceso: 'acc-SECRETO-1', renovacion: 'ref-SECRETO-1', esNuevo: true, perfilCompleto: false)}',
        '${const NoAutorizadoFailure()}',
      ];
      for (final texto in textos) {
        for (final secreto in secretos) {
          expect(texto, isNot(contains(secreto)));
        }
        expect(texto, isNot(contains(servidor.url)));
      }
    });

    test(
      'CA_026_24 el código de la capa de sesión y de datos no imprime nada',
      () {
        final carpetas = [
          'lib/core/sesion',
          'lib/core/red',
          'lib/features/cuenta/data',
          'lib/features/inicio/data',
        ];
        final impresion = RegExp(r'\b(print|debugPrint|log|developer\.log)\(');
        for (final carpeta in carpetas) {
          for (final f in Directory(carpeta).listSync(recursive: true)) {
            if (f is! File || !f.path.endsWith('.dart')) continue;
            expect(
              impresion.hasMatch(f.readAsStringSync()),
              isFalse,
              reason: f.path,
            );
          }
        }
      },
    );
  });
}
