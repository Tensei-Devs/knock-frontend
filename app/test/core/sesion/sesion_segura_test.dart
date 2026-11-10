// Spec 009 (KNOCK-223): sesión en almacenamiento seguro, deviceId estable y
// aviso de privacidad. Almacenamiento seguro simulado en memoria y servidor
// HTTP simulado en 127.0.0.1; solo datos ficticios.
import 'dart:convert';
import 'dart:io';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/red/errores_api.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:app/core/sesion/identificador_dispositivo.dart';
import 'package:app/core/sesion/preparar_canje.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _tokenAcceso = 'acceso-ficticio-abc123';
const _tokenRefresco = 'refresco-ficticio-xyz789';
final _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

class _Servidor {
  _Servidor._(this._servidor);

  final HttpServer _servidor;
  final cuerpos = <Map<String, Object?>>[];

  String get url => 'http://127.0.0.1:${_servidor.port}';

  static Future<_Servidor> iniciar() async {
    final servidor = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final simulado = _Servidor._(servidor);
    servidor.listen((peticion) async {
      final texto = await utf8.decoder.bind(peticion).join();
      simulado.cuerpos.add(jsonDecode(texto) as Map<String, Object?>);
      peticion.response.statusCode = 200;
      peticion.response.headers.contentType = ContentType.json;
      peticion.response.write(
        jsonEncode({
          'accessToken': _tokenAcceso,
          'refreshToken': _tokenRefresco,
          'esNuevo': false,
          'perfilCompleto': true,
        }),
      );
      await peticion.response.close();
    });
    return simulado;
  }

  Future<void> cerrar() => _servidor.close(force: true);
}

/// Almacén en memoria que anota el orden de cada operación y puede fallar en
/// claves concretas. Los textos de error llevan el valor a propósito: no deben
/// llegar a ninguna parte.
class _AlmacenQueAnota extends AlmacenSeguroEnMemoria {
  final eventos = <String>[];
  final fallanAlEscribir = <String>{};
  final fallanAlBorrar = <String>{};

  @override
  Future<void> escribir(String clave, String valor) async {
    eventos.add('escribir $clave');
    if (fallanAlEscribir.contains(clave)) {
      throw Exception('fallo al escribir $clave=$valor');
    }
    await super.escribir(clave, valor);
  }

  @override
  Future<void> borrar(String clave) async {
    eventos.add('borrar $clave');
    if (fallanAlBorrar.contains(clave)) {
      throw Exception('fallo al borrar $clave');
    }
    await super.borrar(clave);
  }
}

void main() {
  group('orden de escritura y de borrado de los tokens (spec 026, CA-13)', () {
    late _AlmacenQueAnota almacen;
    late AlmacenSesion sesion;

    setUp(() {
      almacen = _AlmacenQueAnota();
      sesion = AlmacenSesion(almacen);
    });

    test('CA_026_13 guardar escribe primero el token de renovación', () async {
      await sesion.guardar(acceso: 'acc-A', refresco: 'ref-A');

      expect(almacen.eventos, [
        'escribir ${AlmacenSesion.claveRefresco}',
        'escribir ${AlmacenSesion.claveAcceso}',
      ]);
    });

    test('CA_026_13 si el proceso muere tras la primera escritura queda el '
        'refresco nuevo con el acceso viejo', () async {
      await sesion.guardar(acceso: 'acc-A', refresco: 'ref-A');
      almacen.fallanAlEscribir.add(AlmacenSesion.claveAcceso);

      // La segunda escritura no llega a ocurrir (cierre forzado, batería).
      await expectLater(
        sesion.guardar(acceso: 'acc-B', refresco: 'ref-B'),
        throwsException,
      );

      expect(await sesion.leerRefresco(), 'ref-B');
      expect(await sesion.leerAcceso(), 'acc-A');
    });

    test(
      'CA_026_13 cerrarSesion borra primero el token de renovación',
      () async {
        await sesion.guardar(acceso: 'acc-A', refresco: 'ref-A');
        almacen.eventos.clear();

        await sesion.cerrarSesion();

        expect(almacen.eventos, [
          'borrar ${AlmacenSesion.claveRefresco}',
          'borrar ${AlmacenSesion.claveAcceso}',
        ]);
        expect(almacen.contenido, isEmpty);
      },
    );

    test('CA_026_13 cerrarSesion intenta los dos borrados aunque falle el '
        'primero y después relanza el error', () async {
      await sesion.guardar(acceso: 'acc-A', refresco: 'ref-A');
      almacen.eventos.clear();
      almacen.fallanAlBorrar.add(AlmacenSesion.claveRefresco);

      await expectLater(sesion.cerrarSesion(), throwsException);

      expect(almacen.eventos, [
        'borrar ${AlmacenSesion.claveRefresco}',
        'borrar ${AlmacenSesion.claveAcceso}',
      ]);
      expect(await sesion.leerAcceso(), isNull);
      expect(await sesion.leerRefresco(), 'ref-A');
    });

    test('CA_026_13 si falla el borrado del acceso, el de renovación ya se '
        'borró', () async {
      await sesion.guardar(acceso: 'acc-A', refresco: 'ref-A');
      almacen.fallanAlBorrar.add(AlmacenSesion.claveAcceso);

      await expectLater(sesion.cerrarSesion(), throwsException);

      expect(await sesion.leerRefresco(), isNull);
    });
  });

  group('almacenamiento seguro de la sesión', () {
    test(
      'CA_009_02 al cerrar sesión no queda el token en el almacén',
      () async {
        final almacen = AlmacenSeguroEnMemoria();
        final sesion = AlmacenSesion(almacen);
        await sesion.guardar(acceso: _tokenAcceso, refresco: _tokenRefresco);
        expect(await sesion.leerAcceso(), _tokenAcceso);

        await sesion.cerrarSesion();

        expect(await sesion.leerAcceso(), isNull);
        expect(await sesion.leerRefresco(), isNull);
        final restos = almacen.contenido.values.join('|');
        expect(restos, isNot(contains(_tokenAcceso)));
        expect(restos, isNot(contains(_tokenRefresco)));
      },
    );

    test(
      'CA_009_02 los tokens nunca llegan a las preferencias legibles',
      () async {
        SharedPreferences.setMockInitialValues({});
        final preferencias = await SharedPreferences.getInstance();
        final sesion = AlmacenSesion(AlmacenSeguroEnMemoria());

        await sesion.guardar(acceso: _tokenAcceso, refresco: _tokenRefresco);

        expect(preferencias.getKeys(), isEmpty);
      },
    );

    test(
      'CA_009_02 cerrar sesión conserva el identificador del dispositivo',
      () async {
        final almacen = AlmacenSeguroEnMemoria();
        final id = await IdentificadorDispositivo(almacen).obtener();
        await AlmacenSesion(almacen).cerrarSesion();

        expect(await IdentificadorDispositivo(almacen).obtener(), id);
      },
    );
  });

  group('deviceId y aviso de privacidad', () {
    late _Servidor servidor;
    late AlmacenSeguroEnMemoria almacen;
    late ProviderContainer contenedor;

    setUp(() async {
      servidor = await _Servidor.iniciar();
      almacen = AlmacenSeguroEnMemoria();
      contenedor = ProviderContainer(
        overrides: [
          urlApiProvider.overrideWithValue(servidor.url),
          almacenSeguroProvider.overrideWithValue(almacen),
        ],
      );
    });

    tearDown(() async {
      contenedor.dispose();
      await servidor.cerrar();
    });

    Future<void> iniciarSesion({bool avisoAceptado = true}) async {
      final solicitud = await contenedor
          .read(prepararCanjeProvider)
          .preparar(
            firebaseIdToken: 'token-firebase-ficticio',
            avisoAceptado: avisoAceptado,
          );
      await llamarApi(
        () => contenedor
            .read(authApiProvider)
            .apiVversionAuthFirebasePost(versionApi, solicitud),
      );
    }

    test(
      'CA_009_04 dos inicios de sesión envían el mismo deviceId aleatorio',
      () async {
        await iniciarSesion();
        await iniciarSesion();

        final ids = servidor.cuerpos.map((c) => c['deviceId']).toList();
        expect(ids, hasLength(2));
        expect(ids[0], ids[1]);
        expect(ids[0], matches(_uuidV4));
        expect(almacen.contenido[IdentificadorDispositivo.clave], ids[0]);
      },
    );

    test('CA_009_04 otra instalación genera otro identificador', () async {
      final a = await IdentificadorDispositivo(AlmacenSeguroEnMemoria())
          .obtener();
      final b = await IdentificadorDispositivo(AlmacenSeguroEnMemoria())
          .obtener();
      expect(a, isNot(b));
    });

    test('CA_009_04 un valor guardado que no es UUID se reemplaza', () async {
      await almacen.escribir(IdentificadorDispositivo.clave, 'IMEI-123456');
      final id = await IdentificadorDispositivo(almacen).obtener();
      expect(id, matches(_uuidV4));
    });

    test(
      'CA_009_05 sin aceptar el aviso no hay llamada y se explica el motivo',
      () async {
        await expectLater(
          iniciarSesion(avisoAceptado: false),
          throwsA(isA<AvisoNoAceptadoFailure>()),
        );
        expect(servidor.cuerpos, isEmpty, reason: 'no salió ninguna petición');
        expect(
          almacen.contenido,
          isEmpty,
          reason: 'ni siquiera se generó el identificador',
        );
      },
    );

    test('CA_009_05 aceptado el aviso se envía aceptaAviso = true', () async {
      await iniciarSesion();
      expect(servidor.cuerpos.single['aceptaAviso'], isTrue);
    });
  });
}
