// Backend 020 y 021 (spec 015, R-08 y CA-12): las solicitudes, sus cotizaciones
// y la elección contra las rutas reales de `/api/v1/solicitudes`, con cuerpos
// que siguen el contrato vendorizado.
import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/data/solicitud_repository_api.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/regla_cancelacion.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _base = 'https://api.ejemplo.invalid';
const _id = '64b7f0c2a1b2c3d4e5f60718';

http.Response _json(Object cuerpo, [int estado = 200]) => http.Response(
  jsonEncode(cuerpo),
  estado,
  headers: {'content-type': 'application/json'},
);

SolicitudRepositoryApi _repo(MockClient cliente) =>
    SolicitudRepositoryApi(transporte: cliente, url: _base);

Map<String, Object?> _fila({
  String estado = 'cotizando',
  Object? total = 2,
  Object? visitaId,
}) => {
  'id': _id,
  'estado': estado,
  'oficioNombre': 'Plomería',
  'coloniaNombre': 'Centro',
  'dia': '2026-11-20',
  'franja': 'tarde',
  'totalFotos': 2,
  'totalCotizaciones': total,
  'venceEn': '2026-11-19T18:00:00Z',
  'creadoEn': '2026-11-17T18:00:00Z',
  'visitaId': visitaId,
};

Map<String, Object?> _item({
  String tipo = 'fijo',
  Object? precio = 450,
  List<String> etiquetas = const ['verificado', 'mejor_precio', 'desconocida'],
}) => {
  'id': 'c1',
  'estado': 'enviada',
  'tipoPrecio': tipo,
  'precio': precio,
  'precioMin': null,
  'precioMax': null,
  'tope': 500,
  'requiereAprobacion': false,
  'dia': '2026-11-20',
  'hora': '16:00',
  'nota': 'Llevo la refacción',
  'cubre': 'Revisión y mano de obra',
  'etiquetas': etiquetas,
  'tecnico': {
    'id': 't1',
    'nombre': 'Ricardo Mendoza',
    'fotoUrl': null,
    'calificacion': '4.9',
    'verificado': true,
    'nivelVerificacion': 'identidad',
  },
  'motivoRechazo': null,
};

Map<String, Object?> _cita() => {
  'visitaId': 'v1',
  'solicitudId': _id,
  'cotizacionId': 'c1',
  'estado': 'confirmada',
  'modalidad': 'domicilio',
  'dia': '2026-11-20',
  'hora': '16:00',
  'precio': 450,
  'tope': 500,
  'tecnico': {
    'id': 't1',
    'nombre': 'Ricardo Mendoza',
    'fotoUrl': null,
    'verificado': true,
    'nivelVerificacion': 'identidad',
    'telefono': '+527711234567',
    'whatsapp': null,
  },
  'lugar': {'tipo': 'cliente', 'direccion': 'Calle 5 #10'},
};

void main() {
  test('cancelación CA_025_04 envía motivo y acepta 200 repetido', () async {
    var llamadas = 0;
    final repo = _repo(
      MockClient((p) async {
        llamadas++;
        expect(p.method, 'POST');
        expect(p.url.path, '/api/v1/solicitudes/$_id/cancelar');
        expect(jsonDecode(p.body), {'motivo': 'other'});
        return _json({
          'id': _id,
          'estado': 'cancelada',
          'canceladaEn': '2026-11-20T12:00:00Z',
          'motivo': 'other',
        });
      }),
    );
    for (var i = 0; i < 2; i++) {
      expect(
        await repo.cancelar(_id, motivo: MotivoCancelacion.otro),
        isA<Cancelada>(),
      );
    }
    expect(llamadas, 2);
  });

  test(
    'cancelación CA_025_07 mapea 404 y conflictos sin filtrar datos',
    () async {
      for (final (codigo, respuesta, tipo) in [
        (404, '', CancelacionNoDisponible),
        (409, 'request_with_appointment', CancelacionConCita),
        (409, 'request_expired', CancelacionYaVencida),
        (400, '', CancelacionInvalida),
      ]) {
        final repo = _repo(
          MockClient((_) async => _json({'code': respuesta}, codigo)),
        );
        expect((await repo.cancelar(_id)).runtimeType, tipo);
      }
    },
  );

  test('cancelación CA_025_08 respeta límite y no reintenta 5xx', () async {
    var llamadas = 0;
    final repo = _repo(
      MockClient((_) async {
        llamadas++;
        return http.Response('', 429, headers: {'retry-after': '30'});
      }),
    );
    final resultado = await repo.cancelar(_id);
    expect(
      (resultado as CancelacionLimite).espera,
      const Duration(seconds: 30),
    );
    expect(llamadas, 1);
    final fallida = _repo(MockClient((_) async => http.Response('', 503)));
    expect(await fallida.cancelar(_id), isA<CancelacionError>());
  });

  group('GET /solicitudes', () {
    test('Lista_LeeLasFilasYSigueElCursor', () async {
      final llamadas = <Uri>[];
      final repo = _repo(
        MockClient((p) async {
          llamadas.add(p.url);
          return p.url.queryParameters['cursor'] == null
              ? _json({
                  'items': [_fila()],
                  'nextCursor': 'abc',
                })
              : _json({
                  'items': [_fila(estado: 'enviada', total: 0)],
                  'nextCursor': null,
                });
        }),
      );

      final lista = await repo.listar();

      expect(lista, hasLength(2));
      expect(llamadas.first.queryParameters['limit'], '50');
      expect(llamadas.last.queryParameters['cursor'], 'abc');
      final s = lista.first;
      expect(s.estado, EstadoSolicitud.cotizando);
      expect(s.oficioNombre, 'Plomería');
      expect(s.coloniaNombre, 'Centro');
      expect(s.franja, Franja.tarde);
      expect(s.dia, DateTime(2026, 11, 20));
      expect(s.totalCotizaciones, 2);
      expect(s.descripcion, isEmpty, reason: 'la fila no trae la descripción');
    });

    test('Enteros_QueLleganComoTexto_SeLeen', () async {
      final repo = _repo(
        MockClient(
          (_) async => _json({
            'items': [_fila(total: '3')],
            'nextCursor': null,
          }),
        ),
      );

      expect((await repo.listar()).single.totalCotizaciones, 3);
    });

    test('Estado_Desconocido_NoRompe', () async {
      final repo = _repo(
        MockClient(
          (_) async => _json({
            'items': [_fila(estado: 'rara')],
            'nextCursor': null,
          }),
        ),
      );

      expect((await repo.listar()).single.estado, EstadoSolicitud.desconocido);
    });

    test('Franja_Desconocida_EsDatosInvalidos', () async {
      final fila = _fila()..['franja'] = 'madrugada';
      final repo = _repo(
        MockClient(
          (_) async => _json({
            'items': [fila],
            'nextCursor': null,
          }),
        ),
      );

      expect(repo.listar(), throwsA(isA<DatosInvalidosFailure>()));
    });

    test('Sin_Sesion_401_EsNoAutorizado', () async {
      final repo = _repo(MockClient((_) async => http.Response('', 401)));

      expect(repo.listar(), throwsA(isA<NoAutorizadoFailure>()));
    });
  });

  group('GET /solicitudes/{id}', () {
    test('Detalle_TraeDescripcionYClaveDelOficio', () async {
      final repo = _repo(
        MockClient(
          (_) async => _json({
            'id': _id,
            'estado': 'enviada',
            'modalidad': 'domicilio',
            'oficio': {'clave': 'plo', 'nombre': 'Plomería'},
            'colonia': {'id': '1', 'nombre': 'Centro', 'cp': '42800'},
            'descripcion': 'Fuga en el boiler',
            'fotos': [
              {
                'id': 'f1',
                'url': 'https://x.invalid/1',
                'venceEn': '2026-11-17T18:05:00Z',
              },
            ],
            'dia': '2026-11-20',
            'franja': 'manana',
            'direccion': 'Calle 5 #10',
            'totalCotizaciones': null,
            'venceEn': '2026-11-19T18:00:00Z',
            'creadoEn': '2026-11-17T18:00:00Z',
          }),
        ),
      );

      final s = await repo.obtener(_id);

      expect(s.oficioClave, 'plo');
      expect(s.descripcion, 'Fuga en el boiler');
      expect(s.totalFotos, 1);
      expect(s.totalCotizaciones, 0);
    });

    test('Ajena_O_Inexistente_404_EsNoEncontrada', () async {
      final repo = _repo(MockClient((_) async => http.Response('', 404)));

      expect(repo.obtener(_id), throwsA(isA<NoEncontradoFailure>()));
    });
  });

  group('GET /solicitudes/{id}/cotizaciones', () {
    test('CA_015_13 rechaza una comparación de otra solicitud', () async {
      final repo = _repo(
        MockClient(
          (_) async => _json({
            'solicitudId': 'otra',
            'cotizaciones': <Object?>[],
            'totalCotizaciones': 0,
            'tiposMixtos': false,
            'puedeElegir': false,
          }),
        ),
      );
      await expectLater(
        repo.cotizaciones(_id),
        throwsA(isA<DatosInvalidosFailure>()),
      );
    });

    test('Comparacion_ConEtiquetasConocidasYCalificacionDeTexto', () async {
      Uri? recibida;
      final repo = _repo(
        MockClient((p) async {
          recibida = p.url;
          return _json({
            'solicitudId': _id,
            'cotizaciones': [_item()],
            'totalCotizaciones': 1,
            'tiposMixtos': false,
            'puedeElegir': true,
            'motivo': null,
            'visitaId': null,
          });
        }),
      );

      final r = await repo.cotizaciones(_id, orden: OrdenCotizaciones.precio);

      expect(recibida!.queryParameters['Orden'], 'precio');
      expect(r.puedeElegir, isTrue);
      final c = r.cotizaciones.single;
      expect(c.tipoPrecio, TipoPrecio.fijo);
      expect(c.precio, 450);
      expect(c.precioMin, isNull);
      expect(c.etiquetas, {
        EtiquetaCotizacion.verificado,
        EtiquetaCotizacion.mejorPrecio,
      });
      expect(c.tecnico.nombre, 'Ricardo Mendoza');
      expect(c.tecnico.calificacion, 4.9);
    });

    test('SinElegir_TraeElMotivo', () async {
      final repo = _repo(
        MockClient(
          (_) async => _json({
            'solicitudId': _id,
            'cotizaciones': <Object?>[],
            'totalCotizaciones': 0,
            'tiposMixtos': false,
            'puedeElegir': false,
            'motivo': 'request_without_quotes',
            'visitaId': null,
          }),
        ),
      );

      final r = await repo.cotizaciones(_id);

      expect(r.puedeElegir, isFalse);
      expect(r.motivo, MotivoSinEleccion.sinCotizaciones);
    });

    test('TipoDePrecio_Desconocido_EsDatosInvalidos', () async {
      final repo = _repo(
        MockClient(
          (_) async => _json({
            'solicitudId': _id,
            'cotizaciones': [_item(tipo: 'mensual')],
            'totalCotizaciones': 1,
            'tiposMixtos': false,
            'puedeElegir': true,
            'motivo': null,
            'visitaId': null,
          }),
        ),
      );

      expect(repo.cotizaciones(_id), throwsA(isA<DatosInvalidosFailure>()));
    });
  });

  group('POST /solicitudes/{id}/elegir', () {
    test('Eleccion_DevuelveLaCitaConElContactoDelTecnico', () async {
      http.Request? recibida;
      final repo = _repo(
        MockClient((p) async {
          recibida = p;
          return _json(_cita());
        }),
      );

      final cita = await repo.elegir(_id, 'c1');

      expect(recibida!.method, 'POST');
      expect(recibida!.url.path, '/api/v1/solicitudes/$_id/elegir');
      expect(jsonDecode(recibida!.body), {'cotizacionId': 'c1'});
      expect(cita.visitaId, 'v1');
      expect(cita.modalidad, 'domicilio');
      expect(cita.tecnico.telefono, '+527711234567');
      expect(cita.tecnico.whatsapp, isNull);
      expect(cita.direccion, 'Calle 5 #10');
    });

    for (final (codigo, motivo) in [
      ('request_already_chosen', MotivoEleccionRechazada.yaElegida),
      ('quote_unavailable', MotivoEleccionRechazada.cotizacionNoDisponible),
      ('request_expired', MotivoEleccionRechazada.vencida),
      ('request_cancelled', MotivoEleccionRechazada.cancelada),
      ('request_without_quotes', MotivoEleccionRechazada.sinCotizaciones),
    ]) {
      test('409_${codigo}_SeRechazaConSuMotivo', () async {
        final repo = _repo(
          MockClient((_) async => _json({'code': codigo}, 409)),
        );

        await expectLater(
          repo.elegir(_id, 'c1'),
          throwsA(
            isA<EleccionRechazadaFailure>().having(
              (f) => f.motivo,
              'motivo',
              motivo,
            ),
          ),
        );
      });
    }

    test('409_SinCodigoConocido_EsConflicto', () async {
      final repo = _repo(MockClient((_) async => _json({'code': 'otro'}, 409)));

      expect(repo.elegir(_id, 'c1'), throwsA(isA<ConflictoFailure>()));
    });

    test('404_EsNoEncontrada', () async {
      final repo = _repo(MockClient((_) async => http.Response('', 404)));

      expect(repo.elegir(_id, 'c1'), throwsA(isA<NoEncontradoFailure>()));
    });

    test('503_EsServicioNoDisponible_YNoSeReintenta', () async {
      var llamadas = 0;
      final repo = _repo(
        MockClient((_) async {
          llamadas++;
          return _json({'code': 'service_unavailable'}, 503);
        }),
      );

      await expectLater(
        repo.elegir(_id, 'c1'),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
      expect(llamadas, 1);
    });
  });

  group('POST /solicitudes y fotos', () {
    test('SubirFoto_SinModuloDeArchivos_EsServicioNoDisponible', () async {
      final repo = _repo(MockClient((_) async => http.Response('', 200)));

      expect(
        repo.subirFoto('/tmp/foto.jpg'),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    });

    test('Crear_503ModeracionNoDisponible_FallaCerrado', () async {
      final repo = _repo(
        MockClient((_) async => _json({'code': 'moderation_unavailable'}, 503)),
      );

      expect(
        repo.crear(
          NuevaSolicitud(
            oficioClave: 'plo',
            descripcion: 'Fuga',
            archivoIds: const ['f1'],
            dia: DateTime(2026, 11, 20),
            franja: Franja.tarde,
            coloniaId: '1',
          ),
        ),
        throwsA(isA<ModeracionNoDisponibleFailure>()),
      );
    });
  });
}
