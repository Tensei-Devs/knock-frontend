// Spec 033: repositorio y controlador de reportes y bloqueos. Datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensajes_failure.dart';
import 'package:app/features/reportes/data/reportes_repository_api.dart';
import 'package:app/features/reportes/reportes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/reportes_json.dart';

const _nuevo = NuevoReporte(
  reportadoId: 'u-2',
  visitaId: 'v-1',
  motivo: MotivoDeReporte.malServicio,
  descripcion: '  Texto de ejemplo  ',
);

ReportesRepositoryApi _repo(ApiFalsa api) =>
    ReportesRepositoryApi(transporte: api.cliente, url: urlApiPrueba);

void main() {
  test('CA_033_10 crea el reporte con el cuerpo del contrato', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'reporteId': 'r-1',
        'estado': 'abierto',
        'creadoEn': '2026-11-20T18:00:00Z',
        'avisoEmergencia': null,
      }, estado: 201),
    );

    final creado = await _repo(api).crear(_nuevo);

    expect(creado.reporteId, 'r-1');
    expect(creado.avisoEmergencia, isNull);
    expect(api.llamadas, ['POST reportes']);
    expect(api.peticiones.single.json, {
      'reportadoId': 'u-2',
      'referencia': {'tipo': 'visita', 'id': 'v-1'},
      'motivo': 'mal_servicio',
      'descripcion': 'Texto de ejemplo',
      'evidencia': <Object?>[],
    });
  });

  test('CA_033_12 distingue los errores de crear', () async {
    Future<void> esperar(int estado, String? code, Matcher falla) =>
        expectLater(
          _repo(ApiFalsa((_) => jsonOk({'code': code}, estado: estado)))
              .crear(_nuevo),
          throwsA(falla),
        );
    await esperar(
      422,
      'report_content_rejected',
      isA<ContenidoRechazadoFailure>(),
    );
    await esperar(422, null, isA<DatosRechazadosFailure>());
    await esperar(
      503,
      'report_moderation_unavailable',
      isA<ModeracionNoDisponibleFailure>(),
    );
    await esperar(503, null, isA<ServicioNoDisponibleFailure>());
    await esperar(401, null, isA<NoAutorizadoFailure>());
  });

  test('CA_033_11 un 401 al crear cierra la sesión', () async {
    final api = ApiFalsa((_) => jsonOk({}, estado: 401));
    await expectLater(
      _repo(api).crear(_nuevo),
      throwsA(isA<NoAutorizadoFailure>()),
    );
    expect(api.llamadas, ['POST reportes']);
  });

  test('CA_033_18 apela y distingue appeal_not_allowed', () async {
    final api = ApiFalsa((_) => http.Response('', 200));
    await _repo(api).apelar('r-1', ' Motivo de ejemplo ');
    expect(api.llamadas, ['POST reportes/r-1/apelacion']);
    expect(api.peticiones.single.json, {'texto': 'Motivo de ejemplo'});

    api.responder = (_) => jsonOk({'code': 'appeal_not_allowed'}, estado: 409);
    await expectLater(
      _repo(api).apelar('r-1', 'Motivo de ejemplo'),
      throwsA(isA<ApelacionNoPermitidaFailure>()),
    );
    api.responder = (_) => jsonOk({'code': 'otro'}, estado: 409);
    await expectLater(
      _repo(api).apelar('r-1', 'Motivo de ejemplo'),
      throwsA(isA<ConflictoFailure>()),
    );
  });

  test('CA_033_17 un 401 al apelar cierra la sesión', () async {
    final api = ApiFalsa((_) => jsonOk({}, estado: 401));
    await expectLater(
      _repo(api).apelar('r-1', 'Motivo de ejemplo'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
    expect(api.llamadas, ['POST reportes/r-1/apelacion']);
  });

  test('CA_033_01 bloquea con la ruta del contrato', () async {
    final api = ApiFalsa((_) => http.Response('', 201));
    await _repo(api).bloquear('u-2');
    expect(api.llamadas, ['POST usuarios/u-2/bloqueo']);
    expect(api.peticiones.single.cuerpo, isEmpty);
  });

  test('CA_033_02 un 401 al bloquear cierra la sesión', () async {
    final api = ApiFalsa((_) => jsonOk({}, estado: 401));
    await expectLater(
      _repo(api).bloquear('u-2'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
    expect(api.llamadas, ['POST usuarios/u-2/bloqueo']);
  });

  test('CA_033_03 bloquear: 404 y 409 con su Failure', () async {
    final api = ApiFalsa(
      (_) => jsonOk({'code': 'user_not_found'}, estado: 404),
    );
    await expectLater(
      _repo(api).bloquear('u-2'),
      throwsA(isA<NoEncontradoFailure>()),
    );
    api.responder = (_) => jsonOk({'code': 'already_blocked'}, estado: 409);
    await expectLater(
      _repo(api).bloquear('u-2'),
      throwsA(isA<YaBloqueadoFailure>()),
    );
    api.responder = (_) => jsonOk({'code': 'otro'}, estado: 409);
    await expectLater(
      _repo(api).bloquear('u-2'),
      throwsA(isA<ConflictoFailure>()),
    );
  });

  test('CA_033_04 desbloquea con la ruta del contrato', () async {
    final api = ApiFalsa((_) => http.Response('', 204));
    await _repo(api).desbloquear('u-2');
    expect(api.llamadas, ['DELETE usuarios/u-2/bloqueo']);
  });

  test('CA_033_05 un 401 al desbloquear cierra la sesión', () async {
    final api = ApiFalsa((_) => jsonOk({}, estado: 401));
    await expectLater(
      _repo(api).desbloquear('u-2'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
    expect(api.llamadas, ['DELETE usuarios/u-2/bloqueo']);
  });

  test('CA_033_06 desbloquear sin bloqueo es NoEncontrado', () async {
    final api = ApiFalsa(
      (_) => jsonOk({'code': 'block_not_found'}, estado: 404),
    );
    await expectLater(
      _repo(api).desbloquear('u-2'),
      throwsA(isA<NoEncontradoFailure>()),
    );
  });

  test('CA_033_07 la lista trae solo los campos del contrato', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'items': [
          {
            'usuarioId': 'u-2',
            'nombre': 'Persona de ejemplo',
            'bloqueadoEn': '2026-11-20T18:00:00Z',
            'campoSinContrato': 'x',
          },
        ],
        'nextCursor': 'c2',
      }),
    );

    final pagina = await _repo(api).bloqueados();

    expect(pagina.items.single.usuarioId, 'u-2');
    expect(pagina.items.single.nombre, 'Persona de ejemplo');
    expect(pagina.siguiente, 'c2');
    expect(api.llamadas, ['GET me/bloqueos']);
  });

  test('CA_033_08 un 401 en la lista cierra la sesión', () async {
    final api = ApiFalsa((_) => jsonOk({}, estado: 401));
    await expectLater(
      _repo(api).bloqueados(),
      throwsA(isA<NoAutorizadoFailure>()),
    );
    expect(api.llamadas, ['GET me/bloqueos']);
  });

  test('CA_033_09 el controlador pagina sin repetir y desbloquea', () async {
    final api = ApiFalsa((p) {
      if (p.metodo == 'DELETE') return http.Response('', 204);
      return p.url.queryParameters['cursor'] == null
          ? jsonOk(paginaDeBloqueadosJson(['u-2'], 'c1'))
          : jsonOk(paginaDeBloqueadosJson(['u-2', 'u-3'], null));
    });
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    c.listen(bloqueosControllerProvider, (_, _) {});
    await c.read(bloqueosControllerProvider.future);
    final control = c.read(bloqueosControllerProvider.notifier);

    expect(await control.cargarMas(), isNull);
    expect(
      c.read(bloqueosControllerProvider).value!.items.map((e) => e.usuarioId),
      ['u-2', 'u-3'],
    );

    expect(await control.desbloquear('u-2'), isNull);
    expect(api.llamadas, contains('DELETE usuarios/u-2/bloqueo'));
    api.responder = (_) => jsonOk({'code': 'block_not_found'}, estado: 404);
    expect(await control.desbloquear('u-2'), isA<NoEncontradoFailure>());
  });

  test('CA_033_13 la lista de reportes trae los campos del contrato', () async {
    final api = ApiFalsa(
      (_) => jsonOk(paginaDeReportesJson(['r-1'], null, puedeApelar: true)),
    );
    final pagina = await _repo(api).listar();
    expect(pagina.items.single.reporteId, 'r-1');
    expect(pagina.items.single.motivo, 'fraude');
    expect(pagina.items.single.puedeApelar, isTrue);
    expect(api.llamadas, ['GET reportes/me']);
  });

  test('CA_033_14 un 401 en los reportes cierra la sesión', () async {
    final api = ApiFalsa((_) => jsonOk({}, estado: 401));
    await expectLater(_repo(api).listar(), throwsA(isA<NoAutorizadoFailure>()));
    expect(api.llamadas, ['GET reportes/me']);
  });

  test('CA_033_16 apela una vez con el texto recortado', () async {
    final api = ApiFalsa((_) => http.Response('', 200));
    await _repo(api).apelar('r-1', ' Motivo de ejemplo ');
    expect(api.llamadas, ['POST reportes/r-1/apelacion']);
    expect(api.peticiones.single.json, {'texto': 'Motivo de ejemplo'});
  });

  test('CA_033_27 el modelo y los errores no llevan datos personales', () {
    final persona = PersonaBloqueada(
      usuarioId: 'u-2',
      nombre: 'Persona Ejemplo',
      bloqueadoEn: DateTime.utc(2026, 11, 20),
    );
    final reporte = NuevoReporte(
      reportadoId: 'u-2',
      visitaId: 'v-1',
      motivo: MotivoDeReporte.otro,
      descripcion: 'Texto privado de ejemplo',
    );
    expect('$persona$reporte', isNot(contains('Persona Ejemplo')));
    expect('$persona$reporte', isNot(contains('Texto privado')));
    expect(
      mensajeDeFailure(const YaBloqueadoFailure()),
      isNot(contains('u-2')),
    );
    expect(
      mensajeDeFailure(const ApelacionNoPermitidaFailure()),
      isNot(contains('r-1')),
    );
  });

  test('el destino sale de la visita y es nulo sin cuenta', () async {
    final api = ApiFalsa((_) => jsonOk(visitaParaReportarJson('u-2')));
    final destino = await _repo(api).destinoDeVisita('v-1');
    expect(destino!.usuarioId, 'u-2');
    expect(destino.nombre, 'Técnico de ejemplo');
    expect(api.llamadas, ['GET visitas/v-1']);

    api.responder = (_) => jsonOk(visitaParaReportarJson(null));
    expect(await _repo(api).destinoDeVisita('v-1'), isNull);
  });

  test('CA_033_15 el controlador pagina sin repetir y apela', () async {
    final api = ApiFalsa((p) {
      if (p.metodo == 'POST') return http.Response('', 200);
      return p.url.queryParameters['cursor'] == null
          ? jsonOk(paginaDeReportesJson(['r-1'], 'c1'))
          : jsonOk(paginaDeReportesJson(['r-1', 'r-2'], null));
    });
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    c.listen(misReportesControllerProvider, (_, _) {});
    await c.read(misReportesControllerProvider.future);
    final control = c.read(misReportesControllerProvider.notifier);

    expect(await control.cargarMas(), isNull);
    expect(
      c
          .read(misReportesControllerProvider)
          .value!
          .items
          .map((r) => r.reporteId),
      ['r-1', 'r-2'],
    );

    expect(await control.apelar('r-1', 'Motivo de ejemplo'), isNull);
    api.responder = (_) => jsonOk({'code': 'appeal_not_allowed'}, estado: 409);
    expect(
      await control.apelar('r-1', 'Motivo de ejemplo'),
      isA<ApelacionNoPermitidaFailure>(),
    );
  });
}
