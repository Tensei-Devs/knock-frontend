// Spec 046 (CA-01, CA-03, CA-05 a CA-07, CA-10) y spec 038 (CA-08 a CA-11):
// dominio, repositorio y controladores contra una API falsa.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/api_falsa.dart';
import '../../soporte/cotizar_json.dart';

ProviderContainer _contenedor(ApiFalsa api, {bool conSesion = true}) {
  final c = conSesion
      ? contenedorConApi(api)
      : contenedorConApi(api, tokens: null);
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('validador', () {
    RevisionDeCotizacion revisar(
      TipoPrecio tipo, {
      String precio = '',
      String min = '',
      String max = '',
      String? dia = '2026-11-27',
      String hora = '09:30',
    }) => revisarCotizacion(
      tipo: tipo,
      precio: precio,
      precioMin: min,
      precioMax: max,
      dia: dia,
      hora: hora,
    );

    test('CA_046_03 cada tipo pide solo sus montos', () {
      final fijo = revisar(TipoPrecio.fijo, precio: '350', min: 'x');
      expect(fijo.cotizacion!.precio, 350);
      expect(fijo.cotizacion!.precioMin, isNull);
      final rango = revisar(TipoPrecio.rango, precio: 'x', min: '1', max: '2');
      expect(rango.cotizacion!.precio, isNull);
      expect(rango.cotizacion!.precioMax, 2);
      expect(revisar(TipoPrecio.visita, precio: '150').errores, isEmpty);
    });

    test('CA_046_03 rechaza montos, rango, día y hora no válidos', () {
      for (final malo in ['', '0', '200001', '1.5', '-1', 'diez']) {
        expect(revisar(TipoPrecio.fijo, precio: malo).errores, {
          CampoCotizacion.precio,
        }, reason: malo);
      }
      expect(revisar(TipoPrecio.rango, min: '5', max: '5').errores, {
        CampoCotizacion.precioMax,
      });
      expect(
        revisar(TipoPrecio.fijo, precio: '1', dia: null, hora: '24:00').errores,
        {CampoCotizacion.dia, CampoCotizacion.hora},
      );
    });

    test('el precio de la visita va de 100 a 250', () {
      for (final bueno in ['100', '250']) {
        expect(revisar(TipoPrecio.visita, precio: bueno).errores, isEmpty);
      }
      for (final malo in ['99', '251', '200000']) {
        expect(revisar(TipoPrecio.visita, precio: malo).errores, {
          CampoCotizacion.precio,
        }, reason: malo);
      }
    });

    test('CA_046_03 los días van del día de la solicitud a 7 después', () {
      final dias = diasParaCotizar('2026-11-28', DateTime(2026, 11, 20));
      expect(dias, hasLength(8));
      expect(dias.first, '2026-11-28');
      expect(dias.last, '2026-12-05');
    });

    test('los días que ya pasaron no se ofrecen', () {
      final dias = diasParaCotizar('2026-11-28', DateTime(2026, 12, 3, 23, 59));
      expect(dias, ['2026-12-03', '2026-12-04', '2026-12-05']);
      expect(diasParaCotizar('2026-11-28', DateTime(2026, 12, 6)), isEmpty);
      expect(diasParaCotizar('sin fecha', DateTime(2026, 11, 28)), isEmpty);
    });
  });

  test('CA_046_01 el detalle no toma datos del cliente', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        ...detalleJson(),
        'direccion': 'Calle inventada 1',
        'totalCotizaciones': 2,
      }),
    );
    final s = await _contenedor(api)
        .read(cotizarRepositoryProvider)
        .solicitud('s1');
    expect(api.llamadas, ['GET solicitudes/s1']);
    expect(s.oficio, 'Plomería');
    expect(s.colonia, 'Centro');
    expect(s.fotos.single.id, 'f1');
  });

  test('envía solo los campos del tipo y sin nota', () async {
    final api = ApiFalsa((_) => jsonOk(cotizacionJson(), estado: 201));
    final c = await _contenedor(api)
        .read(cotizarRepositoryProvider)
        .enviar(
          's1',
          const CotizacionNueva(
            tipo: TipoPrecio.fijo,
            precio: 350,
            dia: '2026-11-27',
            hora: '09:30',
          ),
        );
    expect(api.llamadas, ['POST solicitudes/s1/cotizaciones']);
    expect(api.peticiones.single.autorizacion, isNotNull);
    expect(api.peticiones.single.json, {
      'tipoPrecio': 'fijo',
      'precio': 350,
      'dia': '2026-11-27',
      'hora': '09:30',
    });
    expect(c.tope, 400);
    expect(c.requiereAprobacion, isTrue);
  });

  test('CA_046_05 a CA_046_07 cada error del contrato tiene su Failure', () {
    final casos = <(int, String?, Matcher)>[
      (400, null, isA<DatosRechazadosFailure>()),
      (403, 'not_a_technician', isA<SinPerfilTecnicoFailure>()),
      (404, null, isA<NoEncontradoFailure>()),
      (409, 'request_not_quotable', isA<CotizacionNoPermitidaFailure>()),
      (409, 'quote_duplicate', isA<CotizacionNoPermitidaFailure>()),
      (409, 'quote_quota_full', isA<CotizacionNoPermitidaFailure>()),
      (413, null, isA<DatosRechazadosFailure>()),
      (422, 'content_rejected', isA<ContenidoRechazadoFailure>()),
      (422, null, isA<DatosRechazadosFailure>()),
      (429, null, isA<DemasiadosIntentosFailure>()),
      (503, 'moderation_unavailable', isA<ModeracionNoDisponibleFailure>()),
    ];
    return Future.wait([
      for (final (estado, codigo, esperado) in casos)
        expectLater(
          _contenedor(
            ApiFalsa((_) => jsonOk({'code': ?codigo}, estado: estado)),
          ).read(cotizarRepositoryProvider).solicitud('s1'),
          throwsA(esperado),
          reason: '$estado $codigo',
        ),
    ]);
  });

  test('CA_038_11 pagina por cursor sin repetir', () async {
    final api = ApiFalsa(
      (p) => jsonOk(
        p.url.queryParameters['cursor'] == null
            ? {
                'items': [cotizacionJson(id: 'c1')],
                'nextCursor': 'dos',
              }
            : {
                'items': [cotizacionJson(id: 'c1'), cotizacionJson(id: 'c2')],
                'nextCursor': null,
              },
      ),
    );
    final c = _contenedor(api);
    c.listen(cotizacionesEnviadasProvider, (_, _) {});
    await c.read(cotizacionesEnviadasProvider.future);
    await c.read(cotizacionesEnviadasProvider.notifier).cargarMas();
    expect(c.read(cotizacionesEnviadasProvider).value!.items.map((e) => e.id), [
      'c1',
      'c2',
    ]);
    expect(api.peticiones.first.url.queryParameters, {'limite': '20'});
  });

  test('sin sesión los controladores no piden nada', () async {
    final api = ApiFalsa();
    final c = _contenedor(api, conSesion: false);
    c
      ..listen(cotizacionesEnviadasProvider, (_, _) {})
      ..listen(solicitudesRecibidasProvider, (_, _) {});
    await c.read(cotizacionesEnviadasProvider.future);
    await c.read(solicitudesRecibidasProvider.future);
    expect(api.peticiones, isEmpty);
  });

  test('CA_046_10 una respuesta no-store no se queda en la caché', () async {
    final api = ApiFalsa(
      (_) => jsonOk(
        detalleJson(),
        h: {'etag': '"1"', 'cache-control': 'private, no-store'},
      ),
    );
    final c = _contenedor(api);
    await c.read(cotizarRepositoryProvider).solicitud('s1');
    await c.read(cotizarRepositoryProvider).solicitud('s1');
    expect(api.peticiones.last.cabeceras, isNot(contains('if-none-match')));
    expect(c.read(urlApiProvider), urlApiPrueba);
  });
}
