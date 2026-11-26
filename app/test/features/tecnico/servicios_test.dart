// Spec 037: repositorio y controladores de los servicios del técnico (SRV-01 a
// SRV-04). Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/tecnico/data/servicios_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/servicios_json.dart';

const _datos = DatosDeServicio(
  nombre: ' Cambio de llave ',
  precioReferencia: 250,
  oficio: 'plo',
);

ServiciosRepositoryApi _repo(ApiFalsa api) =>
    ServiciosRepositoryApi(transporte: api.cliente, url: urlApiPrueba);

ServiciosRepositoryApi _responde(int estado, [String? codigo]) => _repo(
  ApiFalsa(
    (_) => codigo == null
        ? http.Response('', estado)
        : jsonOk({'code': codigo}, estado: estado),
  ),
);

void main() {
  test(
    'CA_037_01 lee los servicios, con el precio como entero o texto',
    () async {
      final api = ApiFalsa(
        (_) => jsonOk({
          'items': [servicioJson('1'), servicioJson('2', precio: '300')],
        }),
      );

      final items = await _repo(api).deTecnico('t1');

      expect(api.llamadas, ['GET tecnicos/t1/servicios']);
      expect(items.map((s) => s.precioReferencia), [250, 300]);
      expect(items.first.detalle, isNull);
    },
  );

  test('CA_037_05 CA_037_08 CA_037_11 agrega, edita y quita', () async {
    final api = ApiFalsa(
      (p) => p.metodo == 'DELETE'
          ? http.Response('', 204)
          : jsonOk(servicioJson('1'), estado: p.metodo == 'POST' ? 201 : 200),
    );
    final repo = _repo(api);

    expect((await repo.agregar(_datos)).servicio?.id, '1');
    expect((await repo.editar('1', _datos)).rechazo, isNull);
    expect(await repo.quitar('1'), isNull);

    expect(api.llamadas, [
      'POST tecnicos/me/servicios',
      'PUT tecnicos/me/servicios/1',
      'DELETE tecnicos/me/servicios/1',
    ]);
    expect(api.peticiones.first.json, {
      'nombre': 'Cambio de llave',
      'detalle': '',
      'precioReferencia': 250,
      'oficio': 'plo',
    });
  });

  test('CA_037_07 CA_037_10 CA_037_13 cada código es su rechazo', () async {
    Future<void> espera(
      int estado,
      String codigo,
      RechazoDeServicio rechazo,
    ) async => expect(
      (await _responde(estado, codigo).agregar(_datos)).rechazo,
      rechazo,
    );

    await espera(404, 'not_a_technician', RechazoDeServicio.sinPerfilDeTecnico);
    await espera(404, 'service_not_found', RechazoDeServicio.noExiste);
    await espera(409, 'service_limit_reached', RechazoDeServicio.limite);
    await espera(422, 'trade_invalid', RechazoDeServicio.oficioNoValido);
    expect(
      await _responde(404, 'not_a_technician').quitar('1'),
      RechazoDeServicio.sinPerfilDeTecnico,
    );
  });

  test('CA_037_07 el motivo también se lee de errors', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'errors': {
          'oficio': ['trade_invalid'],
        },
      }, estado: 422),
    );

    expect(
      (await _repo(api).agregar(_datos)).rechazo,
      RechazoDeServicio.oficioNoValido,
    );
  });

  test('CA_037_02 CA_037_03 CA_037_06 el resto llega como Failure', () async {
    await expectLater(
      _responde(401).deTecnico('t1'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
    await expectLater(
      _responde(401).quitar('1'),
      throwsA(isA<NoAutorizadoFailure>()),
    );
    await expectLater(
      _responde(404, 'technician_not_found').deTecnico('t1'),
      throwsA(isA<NoEncontradoFailure>()),
    );
    await expectLater(
      _responde(404).agregar(_datos),
      throwsA(isA<NoEncontradoFailure>()),
    );
    await expectLater(
      _responde(409).agregar(_datos),
      throwsA(isA<ConflictoFailure>()),
    );
    await expectLater(
      _responde(422).agregar(_datos),
      throwsA(isA<DatosRechazadosFailure>()),
    );
    await expectLater(
      _repo(
        ApiFalsa(
          (_) => jsonOk({
            'items': [servicioJson('1', precio: 'gratis')],
          }),
        ),
      ).deTecnico('t1'),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });

  test('CA_037_04 sin conexión entrega la última copia con su fecha', () async {
    var falla = false;
    final api = ApiFalsa(
      (_) => falla
          ? http.Response('', 503)
          : jsonOk({
              'items': [servicioJson('1')],
            }),
    );
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    final proveedor = serviciosDeTecnicoProvider('t1');
    final sub = c.listen(proveedor, (_, _) {});
    addTearDown(sub.close);
    expect((await c.read(proveedor.future)).copiaDel, isNull);

    falla = true;
    c.invalidate(proveedor);
    final vistos = await c.read(proveedor.future);

    expect(vistos.copiaDel, isNotNull);
    expect(vistos.items.single.id, '1');
  });

  test('CA_037_05 CA_037_11 con el id conocido lista, y la lista sigue los '
      'cambios', () async {
    final api = ApiFalsa(
      (p) => switch (p.metodo) {
        'GET' => jsonOk({
          'items': [servicioJson('1')],
        }),
        'POST' => jsonOk(servicioJson('2'), estado: 201),
        'PUT' => jsonOk(servicioJson('1', nombre: 'Otro nombre')),
        _ => http.Response('', 204),
      },
    );
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    final sub = c.listen(misServiciosControllerProvider, (_, _) {});
    addTearDown(sub.close);

    expect(
      (await c.read(misServiciosControllerProvider.future)).listaCompleta,
      isFalse,
    );
    expect(api.peticiones, isEmpty);

    c.read(miTecnicoIdProvider.notifier).recordar('t1');
    expect(
      (await c.read(misServiciosControllerProvider.future)).listaCompleta,
      isTrue,
    );
    final control = c.read(misServiciosControllerProvider.notifier);
    List<String> nombres() => [
      for (final s in c.read(misServiciosControllerProvider).value!.items)
        s.nombre,
    ];

    await control.guardar(_datos);
    await control.guardar(_datos, id: '1');
    expect(nombres(), ['Otro nombre', 'Servicio 2']);

    await control.quitar('2');
    expect(nombres(), ['Otro nombre']);
  });
}
