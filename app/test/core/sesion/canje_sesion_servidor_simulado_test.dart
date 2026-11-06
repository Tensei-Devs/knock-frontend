// KNOCK-228: el canje con el cliente generado contra un servidor simulado.
// Datos ficticios; el servidor vive en 127.0.0.1 dentro de la prueba.
import 'dart:convert';
import 'dart:io';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/canje_sesion.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HttpServer servidor;
  late ProviderContainer contenedor;
  var estado = 200;
  Object? cuerpo;
  String? recibido;

  setUp(() async {
    servidor = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    servidor.listen((peticion) async {
      recibido = await utf8.decoder.bind(peticion).join();
      peticion.response.statusCode = estado;
      peticion.response.headers.contentType = ContentType.json;
      if (cuerpo != null) peticion.response.write(jsonEncode(cuerpo));
      await peticion.response.close();
    });
    contenedor = ProviderContainer(
      overrides: [
        urlApiProvider.overrideWithValue('http://127.0.0.1:${servidor.port}'),
      ],
    );
  });

  tearDown(() async {
    contenedor.dispose();
    await servidor.close(force: true);
  });

  Future<SesionEmitida> canjear() => contenedor
      .read(canjeSesionProvider)
      .canjear(
        tokenFirebase: 'token-firebase-ficticio',
        idDispositivo: '00000000-0000-4000-8000-000000000000',
        dispositivo: 'Android',
      );

  Map<String, Object?> sesion({required bool esNuevo}) => {
    'accessToken': 'acceso-ficticio',
    'refreshToken': 'renovacion-ficticia',
    'esNuevo': esNuevo,
    'perfilCompleto': !esNuevo,
  };

  test(
    '201 cuenta nueva: esNuevo y perfil incompleto; manda aceptaAviso',
    () async {
      estado = 201;
      cuerpo = sesion(esNuevo: true);

      final s = await canjear();

      expect(s.esNuevo, isTrue);
      expect(s.perfilCompleto, isFalse);
      expect(s.acceso, 'acceso-ficticio');
      expect(s.renovacion, 'renovacion-ficticia');
      expect(s.toString(), isNot(contains('ficticio')));
      expect(jsonDecode(recibido!), {
        'firebaseIdToken': 'token-firebase-ficticio',
        'deviceId': '00000000-0000-4000-8000-000000000000',
        'aceptaAviso': true,
        'dispositivo': 'Android',
      });
    },
  );

  test('200 cuenta existente: esNuevo falso', () async {
    estado = 200;
    cuerpo = sesion(esNuevo: false);

    final s = await canjear();

    expect(s.esNuevo, isFalse);
    expect(s.perfilCompleto, isTrue);
  });

  test('200 sin tokens: datos inválidos', () async {
    estado = 200;
    cuerpo = {
      'accessToken': '',
      'refreshToken': '',
      'esNuevo': false,
      'perfilCompleto': false,
    };
    await expectLater(canjear(), throwsA(isA<DatosInvalidosFailure>()));
  });

  final errores = <(int, Object?, Matcher)>[
    (
      403,
      {'status': 403, 'code': 'account_suspended'},
      isA<CuentaSuspendidaFailure>(),
    ),
    (409, {'status': 409, 'code': 'account_conflict'}, isA<ConflictoFailure>()),
    (
      422,
      {
        'status': 422,
        'errors': {
          'aceptaAviso': ['invalido'],
        },
      },
      isA<DatosRechazadosFailure>(),
    ),
    (429, {'status': 429}, isA<DemasiadosIntentosFailure>()),
    (401, {'status': 401}, isA<NoAutorizadoFailure>()),
  ];
  for (final (codigo, problema, esperado) in errores) {
    test('$codigo se traduce a su Failure', () async {
      estado = codigo;
      cuerpo = problema;
      await expectLater(canjear(), throwsA(esperado));
    });
  }

  test('sin KNOCK_API_URL el canje falla como ApiNoConfigurada', () async {
    final sinUrl = ProviderContainer(
      overrides: [urlApiProvider.overrideWithValue('')],
    );
    addTearDown(sinUrl.dispose);
    await expectLater(
      sinUrl
          .read(canjeSesionProvider)
          .canjear(tokenFirebase: 't', idDispositivo: 'd', dispositivo: 'x'),
      throwsA(isA<ApiNoConfiguradaFailure>()),
    );
  });
}
