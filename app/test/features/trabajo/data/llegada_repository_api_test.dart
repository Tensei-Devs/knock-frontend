// Spec 016: la vista del técnico y «Ya llegué» contra la API falsa.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/trabajo/trabajo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../soporte/api_falsa.dart';
import '../../../soporte/llegada_json.dart';

const _id = visitaDeLlegadaId;

LlegadaRepository _repo(ApiFalsa api) {
  final c = contenedorConApi(api);
  addTearDown(c.dispose);
  return c.read(llegadaRepositoryProvider);
}

Future<ResultadoLlegada> _confirmar(ApiFalsa api) =>
    _repo(api).confirmar(_id, '4821');

void main() {
  test('CA_016_10 lee la vista del técnico con sesión', () async {
    final api = ApiFalsa((_) => jsonOk(visitaTecnicoJson()));
    final visita = await _repo(api).obtener(_id);
    expect(visita.puedeLlegar, isTrue);
    expect(visita.colonia, 'Centro');
    final p = api.peticiones.single;
    expect(p.llamadaCompleta, 'GET /api/v1/visitas/$_id');
    expect(p.autorizacion, 'Bearer ${tokensA.accessToken}');
  });

  test('CA_016_10 manda solo el código, sin Idempotency-Key', () async {
    final json = visitaTecnicoJson(
      estado: 'en_curso',
      puedeLlegar: false,
      llegadaEn: '2026-11-27T22:00:00Z',
    );
    final api = ApiFalsa((_) => jsonOk(json));
    final r = await _confirmar(api);
    expect(r, isA<LlegadaConfirmada>());
    final visita = (r as LlegadaConfirmada).visita;
    expect(visita.llegadaEn, DateTime.utc(2026, 11, 27, 22));
    final p = api.peticiones.single;
    expect(p.llamadaCompleta, 'POST /api/v1/visitas/$_id/llegada');
    expect(p.json, {'codigo': '4821'});
    expect(p.cabeceras.containsKey('idempotency-key'), isFalse);
  });

  test('CA_016_11 wrong_code trae los intentos del servidor', () async {
    final api = ApiFalsa(
      (_) => problemaJson(422, 'wrong_code', {'intentosRestantes': 2}),
    );
    final r = await _confirmar(api) as LlegadaRechazada;
    expect(r.motivo, MotivoLlegada.codigoIncorrecto);
    expect(r.intentosRestantes, 2);
  });

  for (final (estado, codigo, motivo) in [
    (409, 'visit_locked', MotivoLlegada.visitaBloqueada),
    (409, 'code_expired', MotivoLlegada.codigoVencido),
    (409, 'visit_cancelled', MotivoLlegada.visitaCancelada),
    (409, 'visit_not_active', MotivoLlegada.visitaNoVigente),
    (409, 'visit_without_code', MotivoLlegada.visitaSinCodigo),
    (409, 'outside_window', MotivoLlegada.fueraDeVentana),
    (403, 'not_a_technician', MotivoLlegada.noEsTecnico),
    (400, 'validation_error', MotivoLlegada.formato),
  ]) {
    test('CA_016_13 $estado $codigo', () async {
      final api = ApiFalsa((_) => problemaJson(estado, codigo));
      final r = await _confirmar(api) as LlegadaRechazada;
      expect(r.motivo, motivo);
      expect(api.peticiones, hasLength(1));
    });
  }

  test('CA_016_13 un 422 de formato no es un intento fallido', () async {
    final api = ApiFalsa(
      (_) => problemaJson(422, 'validation_error', {
        'errors': {
          'codigo': ['4 dígitos'],
        },
      }),
    );
    final r = await _confirmar(api) as LlegadaRechazada;
    expect(r.motivo, MotivoLlegada.formato);
    expect(r.intentosRestantes, isNull);
  });

  test('CA_016_17 code_used con la visita en curso es éxito', () async {
    final api = ApiFalsa(
      (p) => p.metodo == 'POST'
          ? problemaJson(409, 'code_used')
          : jsonOk(visitaTecnicoJson(estado: 'en_curso', puedeLlegar: false)),
    );
    expect(await _confirmar(api), isA<LlegadaConfirmada>());
    expect(api.llamadas, ['POST visitas/$_id/llegada', 'GET visitas/$_id']);
  });

  test('CA_016_17 code_used sin estar en curso es un rechazo', () async {
    final api = ApiFalsa(
      (p) => p.metodo == 'POST'
          ? problemaJson(409, 'code_used')
          : jsonOk(visitaTecnicoJson()),
    );
    final r = await _confirmar(api) as LlegadaRechazada;
    expect(r.motivo, MotivoLlegada.codigoUsado);
  });

  for (final (estado, falla) in [
    (403, isA<AccesoDenegadoFailure>()),
    (404, isA<NoEncontradoFailure>()),
    (409, isA<ConflictoFailure>()),
    (422, isA<DatosRechazadosFailure>()),
    (429, isA<DemasiadosIntentosFailure>()),
    (500, isA<ServicioNoDisponibleFailure>()),
  ]) {
    test('CA_016_15 un $estado sin código conocido es un Failure', () async {
      final api = ApiFalsa((_) => http.Response('', estado));
      await expectLater(_confirmar(api), throwsA(falla));
      expect(api.peticiones, hasLength(1));
    });
  }

  test('CA_016_15 sin red no se reintenta', () async {
    final api = ApiFalsa((_) => throw http.ClientException('sin red'));
    await expectLater(
      _confirmar(api),
      throwsA(isA<ServicioNoDisponibleFailure>()),
    );
    expect(api.peticiones, hasLength(1));
  });

  test('CA_016_10 la vista del cliente no sirve para la llegada', () async {
    final api = ApiFalsa(
      (_) => jsonOk({...visitaTecnicoJson(), 'rol': 'cliente'}),
    );
    await expectLater(
      _repo(api).obtener(_id),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });
}
