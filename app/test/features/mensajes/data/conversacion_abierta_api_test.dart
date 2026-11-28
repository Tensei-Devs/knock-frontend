// Spec 047: abrir y leer una conversación, y eventos del canal.
// Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/mensajes/data/canal_mensajes_signalr.dart';
import 'package:app/features/mensajes/data/conversaciones_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/api_falsa.dart';

Map<String, Object?> _mensaje(String id) => {
  'mensajeId': id,
  'autorRol': 'tecnico',
  'texto': 'Hola',
  'contactoOculto': false,
  'enviadoEn': '2026-11-27T12:00:00Z',
};

void main() {
  late ApiFalsa api;
  late ConversacionesRepositoryApi repo;

  setUp(() {
    api = ApiFalsa();
    repo = ConversacionesRepositoryApi(
      transporte: api.transporte,
      url: urlApiPrueba,
    );
  });

  test('CA_047_01 el cliente manda solicitudId y tecnicoId; 200 y 201 valen '
      'igual', () async {
    for (final estado in [200, 201]) {
      api.responder = (_) => jsonOk({'conversacionId': 'c1'}, estado: estado);
      expect(await repo.abrir(solicitudId: 's1', tecnicoId: 't1'), 'c1');
      expect(api.peticiones.last.json, {
        'solicitudId': 's1',
        'tecnicoId': 't1',
      });
    }
    expect(api.llamadas, everyElement('POST conversaciones'));
  });

  test('CA_047_01 el técnico solo manda solicitudId y nunca pide la ruta de '
      'la solicitud', () async {
    api.responder = (_) => jsonOk({'conversacionId': 'c1'}, estado: 201);
    await repo.abrir(solicitudId: 's1');
    expect(api.peticiones.single.json, {'solicitudId': 's1'});
    expect(api.llamadas.join(), isNot(contains('solicitudes/')));
  });

  test('CA_047_03 mapea el detalle con su aviso y motivo de cierre', () async {
    api.responder = (_) => jsonOk({
      'conversacionId': 'c1',
      'solicitudId': 's1',
      'visitaId': null,
      'rol': 'cliente',
      'contraparte': {'nombre': 'Ana', 'fotoUrl': null},
      'servicio': 'Plomería',
      'estado': 'cerrada',
      'motivoCierre': 'request_expired',
      'contactoVisible': false,
      'avisoSeguridad': 'No pagues por adelantado.',
      'noLeidos': 0,
    });
    final d = await repo.detalle('c1');
    expect(api.llamadas, ['GET conversaciones/c1']);
    expect(d.cerrada, isTrue);
    expect(d.motivoCierre, 'request_expired');
    expect(d.avisoSeguridad, 'No pagues por adelantado.');
    expect(d.contraparte.nombre, 'Ana');
  });

  test('CA_047_04 pide 30 mensajes y pasa el cursor', () async {
    api.responder = (_) => jsonOk({
      'items': [_mensaje('m2'), _mensaje('m1')],
      'nextCursor': 'abc',
    });
    final pagina = await repo.mensajes('c1', cursor: 'previo');
    final url = api.peticiones.single.url;
    expect(url.path, endsWith('/conversaciones/c1/mensajes'));
    expect(url.queryParameters, {'limit': '30', 'cursor': 'previo'});
    expect(pagina.items.map((m) => m.id), ['m2', 'm1']);
    expect(pagina.siguiente, 'abc');
  });

  test('CA_047_13 404 es conversación no disponible', () async {
    api.responder = (_) => jsonOk({'status': 404}, estado: 404);
    await expectLater(repo.detalle('c1'), throwsA(isA<NoEncontradoFailure>()));
    await expectLater(repo.mensajes('c1'), throwsA(isA<NoEncontradoFailure>()));
  });

  test('CA_047_11 el evento válido se convierte y el incompleto se '
      'descarta', () {
    final evento = mensajeDelCanal([
      {'conversacionId': 'c1', ..._mensaje('m1')},
    ]);
    expect(evento?.conversacionId, 'c1');
    expect(evento?.mensaje.id, 'm1');
    for (final roto in [
      null,
      <Object?>[],
      [_mensaje('m1')],
      [
        {'conversacionId': 'c1', ..._mensaje('m1'), 'enviadoEn': 'ayer'},
      ],
    ]) {
      expect(mensajeDelCanal(roto), isNull);
    }
  });
}
