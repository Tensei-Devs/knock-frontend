// Spec 029: repositorio y controladores de consentimientos y descarga de
// datos. Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/cuenta/cuenta.dart';
import 'package:app/features/cuenta/data/privacidad_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../soporte/api_falsa.dart';

Map<String, Object?> _consentimiento(
  String tipo, {
  bool vigente = false,
  bool obligatorio = false,
}) => {
  'tipo': tipo,
  'vigente': vigente,
  'obligatorio': obligatorio,
  'version': vigente ? 'v1' : null,
  'fecha': vigente ? '2026-11-20T18:00:00Z' : null,
};

PrivacidadRepositoryApi _repo(ApiFalsa api) =>
    PrivacidadRepositoryApi(transporte: api.cliente, url: urlApiPrueba);

void main() {
  test('CA_029_13 lee la lista de consentimientos', () async {
    final api = ApiFalsa(
      (_) => jsonOk([
        _consentimiento('terminos', vigente: true, obligatorio: true),
        _consentimiento('promociones'),
      ]),
    );

    final lista = await _repo(api).consentimientos();

    expect(api.llamadas, ['GET me/consentimientos']);
    expect(lista.first.version, 'v1');
    expect(lista.first.fecha, DateTime.utc(2026, 11, 20, 18));
    expect(lista.last.fecha, isNull);
    expect(lista.last.obligatorio, isFalse);
  });

  test('CA_029_15 cambia un consentimiento con tipo y vigente', () async {
    final api = ApiFalsa(
      (_) => jsonOk(_consentimiento('promociones', vigente: true)),
    );

    final nuevo = await _repo(api)
        .cambiarConsentimiento('promociones', vigente: true);

    expect(
      api.peticiones.single.llamadaCompleta,
      'PUT /api/v1/me/consentimientos',
    );
    expect(api.peticiones.single.json, {
      'tipo': 'promociones',
      'vigente': true,
    });
    expect(nuevo.vigente, isTrue);
  });

  test('CA_029_10 y CA_029_12 pide el archivo; 409 y 429 son fallas', () async {
    final api = ApiFalsa((_) => http.Response('', 202));
    await _repo(api).pedirExportacion();
    expect(api.llamadas, ['POST me/exportaciones']);

    api.responder = (_) => http.Response('', 409);
    await expectLater(
      _repo(api).pedirExportacion(),
      throwsA(isA<ConflictoFailure>()),
    );
    api.responder = (_) => http.Response('', 429);
    await expectLater(
      _repo(api).pedirExportacion(),
      throwsA(isA<DemasiadosIntentosFailure>()),
    );
  });

  test('la última exportación: sin pedir, en preparación y lista', () async {
    final api = ApiFalsa((_) => http.Response('', 404));
    expect(await _repo(api).ultimaExportacion(), isNull);
    expect(api.llamadas, ['GET me/exportaciones/ultima']);

    api.responder = (_) =>
        jsonOk({'estado': 'en_preparacion', 'enlace': null, 'venceEn': null});
    expect(
      (await _repo(api).ultimaExportacion())!.estado,
      EstadoExportacion.enPreparacion,
    );

    api.responder = (_) => jsonOk({
      'estado': 'lista',
      'enlace': 'https://archivos.knock.test/x.zip?firma=ficticia',
      'venceEn': '2026-11-27T18:00:00Z',
    });
    final lista = (await _repo(api).ultimaExportacion())!;
    expect(lista.enlace!.host, 'archivos.knock.test');
    expect(lista.venceEn, DateTime.utc(2026, 11, 27, 18));
    expect(lista.toString(), isNot(contains('firma')));
  });

  test('rechaza un enlace sin https, un estado raro y un 503', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'estado': 'lista',
        'enlace': 'http://archivos.knock.test/x.zip',
        'venceEn': '2026-11-27T18:00:00Z',
      }),
    );
    await expectLater(
      _repo(api).ultimaExportacion(),
      throwsA(isA<DatosInvalidosFailure>()),
    );
    api.responder = (_) =>
        jsonOk({'estado': 'otro', 'enlace': null, 'venceEn': null});
    await expectLater(
      _repo(api).ultimaExportacion(),
      throwsA(isA<DatosInvalidosFailure>()),
    );
    api.responder = (_) => http.Response('', 503);
    await expectLater(
      _repo(api).ultimaExportacion(),
      throwsA(isA<ServicioNoDisponibleFailure>()),
    );
  });

  test('CA_029_14 un 401 sin renovación cierra la sesión local', () async {
    final api = ApiFalsa((_) => http.Response('', 401));
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    c.listen(consentimientosControllerProvider, (_, _) {});

    await expectLater(
      c.read(consentimientosControllerProvider.future),
      throwsA(anything),
    );

    expect(api.llamadas, contains('POST auth/refresh'));
    expect(c.read(sesionProvider), isNull);
  });

  test('el controlador solo cambia lo que el servidor confirma', () async {
    var falla = true;
    final api = ApiFalsa((p) {
      if (p.metodo == 'GET') {
        return jsonOk([_consentimiento('promociones')]);
      }
      return falla
          ? http.Response('', 503)
          : jsonOk(_consentimiento('promociones', vigente: true));
    });
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    c.listen(consentimientosControllerProvider, (_, _) {});
    await c.read(consentimientosControllerProvider.future);
    final control = c.read(consentimientosControllerProvider.notifier);

    expect(
      await control.cambiar('promociones', vigente: true),
      isA<ServicioNoDisponibleFailure>(),
    );
    expect(
      c.read(consentimientosControllerProvider).value!.single.vigente,
      isFalse,
    );

    falla = false;
    expect(await control.cambiar('promociones', vigente: true), isNull);
    expect(
      c.read(consentimientosControllerProvider).value!.single.vigente,
      isTrue,
    );
  });

  test('pedir deja el archivo en preparación; con 409 vuelve a leer', () async {
    var estado = 202;
    final api = ApiFalsa(
      (p) => p.metodo == 'GET'
          ? http.Response('', 404)
          : http.Response('', estado),
    );
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    c.listen(exportacionControllerProvider, (_, _) {});
    expect(await c.read(exportacionControllerProvider.future), isNull);
    final control = c.read(exportacionControllerProvider.notifier);

    expect(await control.pedir(), isNull);
    expect(
      c.read(exportacionControllerProvider).value!.estado,
      EstadoExportacion.enPreparacion,
    );

    estado = 409;
    expect(await control.pedir(), isA<ConflictoFailure>());
    await c.read(exportacionControllerProvider.future);
    expect(api.llamadas.last, 'GET me/exportaciones/ultima');
  });
}
