// Spec 006 (KNOCK-220), integración: el cliente generado, conectado por
// `clienteApiProvider`, contra un servidor HTTP simulado en 127.0.0.1.
// Sin red real: el servidor vive dentro de la prueba y solo usa datos ficticios.
import 'dart:convert';
import 'dart:io';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/red/errores_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;
import 'package:flutter_test/flutter_test.dart';
import 'package:knock_api/api.dart';

typedef _Respuesta = ({int estado, Object? cuerpo});

class _ServidorSimulado {
  _ServidorSimulado._(this._servidor);

  final HttpServer _servidor;
  _Respuesta respuesta = (estado: 200, cuerpo: null);
  final peticiones = <({String metodo, String ruta, String cuerpo})>[];

  String get url => 'http://127.0.0.1:${_servidor.port}';

  static Future<_ServidorSimulado> iniciar() async {
    final servidor = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final simulado = _ServidorSimulado._(servidor);
    servidor.listen((peticion) async {
      final cuerpo = await utf8.decoder.bind(peticion).join();
      simulado.peticiones.add((
        metodo: peticion.method,
        ruta: peticion.uri.path,
        cuerpo: cuerpo,
      ));
      final r = simulado.respuesta;
      peticion.response.statusCode = r.estado;
      if (r.cuerpo != null) {
        peticion.response.headers.contentType = ContentType.json;
        peticion.response.write(jsonEncode(r.cuerpo));
      }
      await peticion.response.close();
    });
    return simulado;
  }

  Future<void> cerrar() => _servidor.close(force: true);
}

FirebaseExchangeRequest _canje() => FirebaseExchangeRequest(
  firebaseIdToken: 'token-firebase-ficticio',
  deviceId: '00000000-0000-4000-8000-000000000000',
  aceptaAviso: true,
  dispositivo: 'Telefono de prueba',
);

void main() {
  late _ServidorSimulado servidor;
  late ProviderContainer contenedor;

  setUp(() async {
    servidor = await _ServidorSimulado.iniciar();
    contenedor = ProviderContainer(
      overrides: [urlApiProvider.overrideWithValue(servidor.url)],
    );
  });

  tearDown(() async {
    contenedor.dispose();
    await servidor.cerrar();
  });

  Future<SessionResponse?> canjear() => llamarApi(
    () => contenedor
        .read(authApiProvider)
        .apiVversionAuthFirebasePost(versionApi, _canje()),
  );

  test('CA-006-01 el cliente generado manda el canje al contrato y lee la '
      'sesión 201', () async {
    servidor.respuesta = (
      estado: 201,
      cuerpo: {
        'accessToken': 'acceso-ficticio',
        'refreshToken': 'renovacion-ficticia',
        'esNuevo': true,
        'perfilCompleto': false,
      },
    );

    final sesion = await canjear();

    expect(sesion!.esNuevo, isTrue);
    expect(sesion.perfilCompleto, isFalse);
    expect(sesion.accessToken, 'acceso-ficticio');
    final peticion = servidor.peticiones.single;
    expect(peticion.metodo, 'POST');
    expect(peticion.ruta, '/api/v1/auth/firebase');
    expect(jsonDecode(peticion.cuerpo), {
      'firebaseIdToken': 'token-firebase-ficticio',
      'deviceId': '00000000-0000-4000-8000-000000000000',
      'aceptaAviso': true,
      'dispositivo': 'Telefono de prueba',
    });
  });

  test('CA-006-01 GET /health responde con el cliente generado', () async {
    await KnockIdentityApiApi(contenedor.read(clienteApiProvider)).healthGet();
    expect(servidor.peticiones.single.metodo, 'GET');
    expect(servidor.peticiones.single.ruta, '/health');
  });

  final casos = <(int, Object?, Type)>[
    (401, {'title': 'Unauthorized'}, NoAutorizadoFailure),
    (403, {'code': 'account_suspended'}, CuentaSuspendidaFailure),
    (403, {'title': 'Forbidden'}, AccesoDenegadoFailure),
    (409, {'code': 'account_conflict'}, ConflictoFailure),
    (422, {'errors': <String, Object?>{}}, DatosRechazadosFailure),
    (429, {'title': 'Too Many Requests'}, DemasiadosIntentosFailure),
    (500, null, ServicioNoDisponibleFailure),
  ];
  for (final (estado, cuerpo, tipo) in casos) {
    test('los errores $estado ${cuerpo ?? ''} llegan como $tipo', () async {
      servidor.respuesta = (estado: estado, cuerpo: cuerpo);
      await expectLater(
        canjear(),
        throwsA(isA<Failure>().having((f) => f.runtimeType, 'tipo', tipo)),
      );
    });
  }

  test('sin servidor la llamada falla como ServicioNoDisponible', () async {
    await servidor.cerrar();
    await expectLater(canjear(), throwsA(isA<ServicioNoDisponibleFailure>()));
  });

  test('sin KNOCK_API_URL el cliente no se crea', () {
    final sinUrl = ProviderContainer(
      overrides: [urlApiProvider.overrideWithValue('')],
    );
    addTearDown(sinUrl.dispose);
    expect(
      () => sinUrl.read(clienteApiProvider),
      throwsA(
        anyOf(
          isA<ApiNoConfiguradaFailure>(),
          isA<ProviderException>().having(
            (e) => e.exception,
            'causa',
            isA<ApiNoConfiguradaFailure>(),
          ),
        ),
      ),
    );
  });
}
