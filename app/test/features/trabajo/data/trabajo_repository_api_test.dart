import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/trabajo/data/trabajo_repository_api.dart';
import 'package:app/features/trabajo/domain/trabajo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:knock_api/api.dart' as api;

class BandejaFalsa extends api.BandejaApi {
  String? cursorRecibido;
  int? limite;

  @override
  Future<api.InboxResponse?> apiVversionTecnicosMeSolicitudesGet(
    String version, {
    String? cursor,
    int? limit,
    Future<void>? abortTrigger,
  }) async {
    expect(version, '1');
    cursorRecibido = cursor;
    limite = limit;
    return api.InboxResponse.fromJson({
      'items': [
        {
          'solicitudId': 's1',
          'oficio': {'clave': 'plo', 'nombre': 'Plomería'},
          'colonia': {'nombre': 'Centro', 'cp': '12345'},
          'descripcion': 'Reparación',
          'fotos': [
            {
              'id': 'f1',
              'url': 'https://example.test/foto',
              'venceEn': '2026-11-25T00:00:00Z',
            },
          ],
          'dia': '2026-11-25',
          'franja': 'tarde',
          'modalidad': 'domicilio',
          'venceEn': '2026-11-25T00:00:00Z',
          'oleada': 1,
          'recibidaEn': '2026-11-24T00:00:00Z',
          'yaCotizo': false,
          'telefono': 'ignorado',
          'direccion': 'ignorada',
        },
      ],
      'nextCursor': 'siguiente',
    });
  }
}

class TrabajoFalso extends api.TrabajoApi {
  String? cursorRecibido;
  int? limite;

  @override
  Future<api.TrabajoResponse?> apiVversionTecnicosMeTrabajoGet(
    String version, {
    String? cursorTerminadas,
    int? limit,
    Future<void>? abortTrigger,
  }) async {
    cursorRecibido = cursorTerminadas;
    limite = limit;
    return api.TrabajoResponse.fromJson({
      'disponibleHoy': true,
      'verificacion': {'estado': 'pendiente'},
      'nivel': {'clave': 'inicial', 'nombre': 'Inicial'},
      'proximasVisitas': [
        {
          'visitaId': 'v1',
          'solicitudId': 's1',
          'dia': '2026-11-25',
          'hora': '12:00',
          'modalidad': 'taller',
          'cliente': {'colonia': 'Centro'},
          'lugar': {'tipo': 'taller', 'direccion': null},
          'precio': null,
          'tope': 150,
          'estado': 'en_curso',
          'puedeLlegar': false,
        },
      ],
      'cotizacionesEnviadas': [
        {
          'cotizacionId': 'c1',
          'solicitudId': 's1',
          'oficioNombre': 'Plomería',
          'tipoPrecio': 'rango',
          'precio': null,
          'precioMin': 100,
          'precioMax': 150,
          'tope': 150,
          'estado': 'rechazada',
          'motivoRechazo': 'other_quote_chosen',
          'enviadaEn': '2026-11-24T00:00:00Z',
        },
      ],
      'terminadas': {
        'items': [
          {
            'solicitudId': 's1',
            'oficioNombre': 'Plomería',
            'terminadaEn': '2026-11-24T00:00:00Z',
            'precio': null,
            'calificacion': 4.5,
          },
        ],
        'nextCursor': 'fin',
      },
      'resumen': {'trabajosTerminados': 1, 'calificacion': null},
    });
  }
}

class DescarteFalso extends api.DescarteApi {
  int estado = 204;
  String codigo = '';
  int llamadas = 0;

  @override
  Future<http.Response> apiVversionSolicitudesIdDescartarPostWithHttpInfo(
    String id,
    String version, {
    Future<void>? abortTrigger,
  }) async {
    llamadas++;
    expect(id, 's1');
    return http.Response(jsonEncode({'code': codigo}), estado);
  }
}

void main() {
  late BandejaFalsa bandeja;
  late TrabajoFalso trabajo;
  late DescarteFalso descarte;
  late TrabajoRepositoryApi repo;

  setUp(() {
    bandeja = BandejaFalsa();
    trabajo = TrabajoFalso();
    descarte = DescarteFalso();
    repo = TrabajoRepositoryApi(
      bandejaApi: bandeja,
      trabajoApi: trabajo,
      descarteApi: descarte,
    );
  });

  test('CA_019_02 bandeja mapea solo los datos permitidos', () async {
    final pagina = await repo.bandeja(cursor: 'anterior');
    expect(bandeja.cursorRecibido, 'anterior');
    expect(bandeja.limite, 20);
    expect(pagina.nextCursor, 'siguiente');
    expect(pagina.items.single.oficio.nombre, 'Plomería');
    expect(pagina.items.single.fotos, ['https://example.test/foto']);
  });

  test('CA_019_11 terminadas conserva el cursor y el precio nulo', () async {
    final resumen = await repo.resumen(cursorTerminadas: 'anterior');
    expect(trabajo.cursorRecibido, 'anterior');
    expect(trabajo.limite, 20);
    expect(resumen.nextCursor, 'fin');
    expect(resumen.resumen.terminadas.single.precio, isNull);
    expect(resumen.resumen.terminadas.single.calificacion, 4.5);
    expect(resumen.resumen.nivel.nombre, 'Inicial');
    expect(resumen.resumen.proximasVisitas.single.direccion, isNull);
    expect(resumen.resumen.proximasVisitas.single.precio, isNull);
    expect(resumen.resumen.cotizacionesEnviadas.single.precioMin, 100);
    expect(
      resumen.resumen.cotizacionesEnviadas.single.motivoRechazo,
      'other_quote_chosen',
    );
  });

  test('CA_019_03 descarte distingue 204, 404 y el 409 concreto', () async {
    expect(await repo.descartar('s1'), ResultadoDescarte.descartada);
    descarte.estado = 404;
    expect(await repo.descartar('s1'), ResultadoDescarte.noDisponible);
    descarte.estado = 409;
    descarte.codigo = 'request_not_dismissable';
    expect(await repo.descartar('s1'), ResultadoDescarte.noDescartable);
    descarte.codigo = 'otro';
    await expectLater(repo.descartar('s1'), throwsA(isA<ConflictoFailure>()));
    expect(descarte.llamadas, 4);
  });
}
