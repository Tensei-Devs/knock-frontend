// Spec 040: cancelar, reprogramar y «no terminado» contra la API falsa.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/visita/visita.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

const _id = 'c1c1c1c1c1c1c1c1c1c1c1c1';

AccionesVisitaRepository _repo(ApiFalsa api) {
  final c = contenedorConApi(api);
  addTearDown(c.dispose);
  return c.read(accionesVisitaRepositoryProvider);
}

void main() {
  test('CA_040_11 cancelar manda el motivo con sesión', () async {
    final api = ApiFalsa(
      (_) => jsonOk({'visitaId': _id, 'estado': 'cancelada', 'tardia': true}),
    );
    final r = await _repo(api).cancelar(_id, 'Cambié de planes');
    expect(r.tardia, isTrue);
    expect(r.estado, 'cancelada');
    final p = api.peticiones.single;
    expect(p.llamadaCompleta, 'POST /api/v1/visitas/$_id/cancelar');
    expect(p.json, {'motivo': 'Cambié de planes'});
    expect(p.autorizacion, 'Bearer ${tokensA.accessToken}');
  });

  test('CA_040_05 reprogramar manda la fecha en UTC', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'visitaId': _id,
        'fechaHora': '2026-11-20T18:00:00Z',
        'propuestaPor': 'cliente',
        'venceEn': '2026-11-19T18:00:00Z',
      }),
    );
    final fecha = DateTime.utc(2026, 11, 20, 18).toLocal();
    final r = await _repo(api).reprogramar(_id, fecha);
    expect(r.propuestaPor, 'cliente');
    expect(r.fechaHora, DateTime.utc(2026, 11, 20, 18));
    final p = api.peticiones.single;
    expect(p.llamadaCompleta, 'POST /api/v1/visitas/$_id/reprogramar');
    expect(p.json, {'fechaHora': '2026-11-20T18:00:00.000Z'});
  });

  test('CA_040_20 no-terminado manda el texto', () async {
    final api = ApiFalsa(
      (_) => jsonOk({'visitaId': _id, 'estado': 'terminada'}, estado: 201),
    );
    await _repo(api).reportarNoTerminado(_id, 'Sigue goteando');
    final p = api.peticiones.single;
    expect(p.llamadaCompleta, 'POST /api/v1/visitas/$_id/no-terminado');
    expect(p.json, {'texto': 'Sigue goteando'});
  });

  for (final (estado, falla) in [
    (403, isA<AccesoDenegadoFailure>()),
    (404, isA<NoEncontradoFailure>()),
    (409, isA<ConflictoFailure>()),
    (422, isA<DatosRechazadosFailure>()),
  ]) {
    test('CA_040_13 un $estado es un Failure y no se reintenta', () async {
      final api = ApiFalsa((_) => http.Response('', estado));
      await expectLater(
        _repo(api).cancelar(_id, 'Cambié de planes'),
        throwsA(falla),
      );
      expect(api.peticiones, hasLength(1));
    });
  }

  test('CA_040_11 una respuesta fuera de contrato es dato inválido', () async {
    final api = ApiFalsa((_) => jsonOk({'estado': 'cancelada'}));
    await expectLater(
      _repo(api).cancelar(_id, 'Cambié de planes'),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });
}
