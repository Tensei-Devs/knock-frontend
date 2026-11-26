// Spec 041 (OPI-01 a OPI-03): el repositorio lee solo lo que declara el
// contrato, traduce sus errores y el controlador pagina y guarda la última
// copia en memoria. Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/opiniones/data/opiniones_repository_api.dart';
import 'package:app/features/opiniones/opiniones.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/opiniones_falsas.dart';

OpinionesRepositoryApi _repo(ApiFalsa api) =>
    OpinionesRepositoryApi(transporte: api.transporte, url: urlApiPrueba);

const _nueva = NuevaOpinion(calificacion: 4, comentario: '  Bien  ');

void main() {
  test('CA_041_01 lee la página del contrato', () async {
    final api = ApiFalsa(
      (_) => jsonOk(paginaJson([opinionJson('o1')], cursor: 'c1')),
    );

    final pagina = await _repo(api).listar('t1');

    expect(api.llamadas, ['GET tecnicos/t1/opiniones']);
    expect(pagina.siguiente, 'c1');
    expect(pagina.resumen.promedio, 4.5);
    expect(pagina.resumen.distribucion[5], 1);
    final o = pagina.items.single;
    expect(o.calificacion, 5);
    expect(o.partes!.puntualidad, 5);
    expect(o.partes!.calidad, isNull);
    expect(o.totalFotos, 1);
    expect(o.respuesta!.texto, 'Gracias');
    expect(o.servicioVerificado, isTrue);
  });

  test('un campo que no cumple el contrato es un dato inválido', () async {
    final api = ApiFalsa(
      (_) => jsonOk(
        paginaJson([
          {...opinionJson('o1'), 'calificacion': 'cinco'},
        ]),
      ),
    );

    await expectLater(
      _repo(api).listar('t1'),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });

  test('CA_041_03 un 404 es un técnico no disponible', () async {
    final api = ApiFalsa((_) => http.Response('', 404));

    await expectLater(
      _repo(api).listar('t1'),
      throwsA(isA<NoEncontradoFailure>()),
    );
  });

  test('CA_041_06 califica con el cuerpo del contrato', () async {
    final api = ApiFalsa((_) => jsonOk(creadaJson, estado: 201));

    final creada = await _repo(api).calificar('v1', _nueva);

    expect(api.llamadas, ['POST visitas/v1/opinion']);
    expect(api.peticiones.single.json, {
      'calificacion': 4,
      'partes': null,
      'comentario': 'Bien',
      'fotos': <Object?>[],
      'guardarTecnicoConfianza': false,
    });
    expect(creada.moderacion, 'publicada');
  });

  test('CA_041_06 manda las partes elegidas', () async {
    final api = ApiFalsa((_) => jsonOk(creadaJson, estado: 201));

    await _repo(api).calificar(
      'v1',
      const NuevaOpinion(calificacion: 5, partes: PartesDeOpinion(trato: 3)),
    );

    final cuerpo = api.peticiones.single.json;
    expect((cuerpo['partes'] as Map)['trato'], 3);
    expect(cuerpo['comentario'], isNull);
  });

  final errores = <(int, String?, Matcher)>[
    (409, 'review_not_allowed', isA<OpinionNoPermitidaFailure>()),
    (409, 'otro', isA<ConflictoFailure>()),
    (403, null, isA<AccesoDenegadoFailure>()),
    (404, null, isA<NoEncontradoFailure>()),
    (422, null, isA<DatosRechazadosFailure>()),
  ];
  for (final (estado, codigo, esperado) in errores) {
    test('CA_041_08 $estado $codigo al calificar', () async {
      final api = ApiFalsa((_) => jsonOk({'code': ?codigo}, estado: estado));

      await expectLater(_repo(api).calificar('v1', _nueva), throwsA(esperado));
      expect(api.peticiones, hasLength(1), reason: 'sin reintento');
    });
  }

  test('CA_041_09 y CA_041_11 responder y sus conflictos', () async {
    final api = ApiFalsa((_) => http.Response('', 200));
    await _repo(api).responder('o1', ' Gracias ');
    expect(api.llamadas, ['POST opiniones/o1/respuesta']);
    expect(api.peticiones.single.json, {'texto': 'Gracias'});

    api.responder = (_) =>
        jsonOk({'code': 'review_already_answered'}, estado: 409);
    await expectLater(
      _repo(api).responder('o1', 'x'),
      throwsA(isA<OpinionYaRespondidaFailure>()),
    );
    api.responder = (_) => http.Response('', 403);
    await expectLater(
      _repo(api).responder('o1', 'x'),
      throwsA(isA<AccesoDenegadoFailure>()),
    );
  });

  final con401 = <String, Future<Object?> Function(OpinionesRepository)>{
    'CA_041_02 listar': (r) => r.listar('t1'),
    'CA_041_07 calificar': (r) => r.calificar('v1', _nueva),
    'CA_041_10 responder': (r) async => r.responder('o1', 'x'),
  };
  for (final caso in con401.entries) {
    test('${caso.key}: un 401 cierra la sesión local', () async {
      final api = ApiFalsa((_) => http.Response('', 401));
      final c = contenedorConApi(api);
      addTearDown(c.dispose);

      await expectLater(
        caso.value(c.read(opinionesRepositoryProvider)),
        throwsA(isA<Failure>()),
      );

      expect(c.read(sesionProvider), isNull);
    });
  }

  test('CA_041_04 la página siguiente usa el cursor y no repite', () async {
    final api = ApiFalsa(
      (p) => p.url.queryParameters['cursor'] == null
          ? jsonOk(paginaJson([opinionJson('o1')], cursor: 'c1'))
          : jsonOk(paginaJson([opinionJson('o1'), opinionJson('o2')])),
    );
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    final proveedor = opinionesControllerProvider('t1');
    c.listen(proveedor, (_, _) {});
    await c.read(proveedor.future);

    expect(await c.read(proveedor.notifier).cargarMas(), isNull);

    final pagina = c.read(proveedor).value!.pagina;
    expect([for (final o in pagina.items) o.id], ['o1', 'o2']);
    expect(pagina.siguiente, isNull);
    expect(api.peticiones.last.url.queryParameters['cursor'], 'c1');
  });

  test('CA_041_05 sin conexión entrega la última copia con su fecha', () async {
    final api = ApiFalsa((_) => jsonOk(paginaJson([opinionJson('o1')])));
    final fecha = DateTime(2026, 11, 20, 10);
    final c = contenedorConApi(
      api,
      extra: [relojOpinionesProvider.overrideWithValue(() => fecha)],
    );
    addTearDown(c.dispose);
    final proveedor = opinionesControllerProvider('t1');
    c.listen(proveedor, (_, _) {});
    expect((await c.read(proveedor.future)).copiaDel, isNull);

    api.responder = (_) => throw http.ClientException('sin red');
    c.read(proveedor.notifier).reintentar();
    final vista = await c.read(proveedor.future);

    expect(vista.copiaDel, fecha);
    expect(vista.pagina.items.single.id, 'o1');
  });
}
