// Spec 021 (KNOCK-66): pruebas unitarias de `ConsultaBusquedaNotifier` y
// `BusquedaController`.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/busqueda/busqueda.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

Map<String, Object?> _experto(String id) => {
  'id': id,
  'nombre': 'Experto $id',
  'oficios': [
    {'clave': 'plo', 'nombre': 'Plomería'},
  ],
  'calificacion': 4.8,
  'totalResenas': 10,
  'verificado': true,
  'nivelVerificacion': 'identidad',
  'coloniaBase': 'Centro',
  'distanciaKm': 2,
  'atiendeTuColonia': true,
  'fotoUrl': null,
};

Map<String, Object?> _pagina({List<Object?>? items, String? siguiente}) => {
  'interpretacion': {
    'estado': 'detectado',
    'oficioDetectado': {'clave': 'plo', 'nombre': 'Plomería'},
    'oficiosSugeridos': null,
  },
  'items': items ?? [_experto('1')],
  'nextCursor': siguiente,
};

void main() {
  test('CA_021_07 escribir espera 400 ms y cancela la pausa anterior', () {
    fakeAsync((async) {
      final api = ApiFalsa((_) => jsonOk(_pagina()));
      final c = contenedorConApi(api);
      addTearDown(c.dispose);

      c.listen(busquedaControllerProvider('col-1'), (_, _) {});
      final notifier = c.read(consultaBusquedaProvider.notifier);

      notifier.escribir('bo');
      async.elapse(const Duration(milliseconds: 200));
      expect(api.peticiones, isEmpty);

      notifier.escribir('boiler');
      async.elapse(const Duration(milliseconds: 399));
      expect(api.peticiones, isEmpty);

      async.elapse(const Duration(milliseconds: 1));
      async.flushMicrotasks();
      expect(api.peticiones, hasLength(1));
      expect(api.peticiones.single.url.queryParameters['q'], 'boiler');
    });
  });

  test(
    'CA_021_08 filtrarOficio y soloVerificados viajan al servidor',
    () async {
      final api = ApiFalsa((_) => jsonOk(_pagina()));
      final c = contenedorConApi(api);
      addTearDown(c.dispose);

      c.listen(busquedaControllerProvider('col-1'), (_, _) {});
      c.read(consultaBusquedaProvider.notifier).buscarYa('boiler');
      await c.read(busquedaControllerProvider('col-1').future);

      c.read(consultaBusquedaProvider.notifier).filtrarOficio('plo');
      await c.read(busquedaControllerProvider('col-1').future);
      expect(api.peticiones.last.url.queryParameters['oficio'], 'plo');

      c.read(consultaBusquedaProvider.notifier).soloVerificados(activo: true);
      await c.read(busquedaControllerProvider('col-1').future);
      expect(
        api.peticiones.last.url.queryParameters['soloVerificados'],
        'true',
      );
    },
  );

  test(
    'CA_021_17_18 verMas une sin repetir y reinicia si invalid_cursor',
    () async {
      var cursorInvalido = false;
      final api = ApiFalsa((p) {
        final cursor = p.url.queryParameters['cursor'];
        if (cursor == null) {
          return jsonOk(_pagina(items: [_experto('1')], siguiente: 'c1'));
        }
        if (cursorInvalido) {
          return jsonOk({'code': 'invalid_cursor'}, estado: 400);
        }
        return jsonOk(
          _pagina(items: [_experto('1'), _experto('2')], siguiente: 'c2'),
        );
      });
      final c = contenedorConApi(api);
      addTearDown(c.dispose);

      c.listen(busquedaControllerProvider('col-1'), (_, _) {});
      c.read(consultaBusquedaProvider.notifier).buscarYa('boiler');
      var pagina = await c.read(busquedaControllerProvider('col-1').future);
      expect(pagina?.items.map((e) => e.id), ['1']);

      final falla = await c
          .read(busquedaControllerProvider('col-1').notifier)
          .verMas();
      expect(falla, isNull);
      pagina = c.read(busquedaControllerProvider('col-1')).value;
      expect(pagina?.items.map((e) => e.id), ['1', '2']);

      cursorInvalido = true;
      final fallaCursor = await c
          .read(busquedaControllerProvider('col-1').notifier)
          .verMas();
      expect(fallaCursor, isNull);
      pagina = await c.read(busquedaControllerProvider('col-1').future);
      expect(pagina?.items.map((e) => e.id), ['1']);
    },
  );

  test(
    'CA_021_13 503 en verMas devuelve ServicioNoDisponibleFailure',
    () async {
      var fase = 0;
      final api = ApiFalsa((_) {
        if (fase == 0) {
          fase = 1;
          return jsonOk(_pagina(items: [_experto('1')], siguiente: 'c1'));
        }
        return http.Response('', 503);
      });
      final c = contenedorConApi(api);
      addTearDown(c.dispose);

      c.listen(busquedaControllerProvider('col-1'), (_, _) {});
      c.read(consultaBusquedaProvider.notifier).buscarYa('boiler');
      await c.read(busquedaControllerProvider('col-1').future);

      final falla = await c
          .read(busquedaControllerProvider('col-1').notifier)
          .verMas();
      expect(falla, isA<ServicioNoDisponibleFailure>());
    },
  );

  test('sugerenciasBusquedaProvider pide solo con texto válido', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'sugerencias': [
          {'tipo': 'oficio', 'texto': 'Plomería', 'clave': 'plo', 'id': null},
        ],
      }),
    );
    final c = contenedorConApi(api);
    addTearDown(c.dispose);

    expect(await c.read(sugerenciasBusquedaProvider.future), isEmpty);
    c.read(consultaBusquedaProvider.notifier).buscarYa('plo');
    final lista = await c.read(sugerenciasBusquedaProvider.future);
    expect(lista.single.texto, 'Plomería');
  });
}
