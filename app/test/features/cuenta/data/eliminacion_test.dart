// Spec 029: repositorio y controladores de la eliminación de la cuenta. Solo
// datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/cuenta/cuenta.dart';
import 'package:app/features/cuenta/data/eliminacion_repository_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../soporte/api_falsa.dart';

EliminacionRepositoryApi _repo(ApiFalsa api) =>
    EliminacionRepositoryApi(transporte: api.cliente, url: urlApiPrueba);

http.Response _programada() =>
    jsonOk({'eliminarEn': '2026-12-03T18:00:00Z'}, estado: 202);

http.Response _pideFirebase() => jsonOk({
  'errors': {
    'firebaseIdToken': ['Is required.'],
  },
}, estado: 422);

void main() {
  test('CA_029_17 lee los totales, como número o como texto', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'citas': {'total': 1, 'ids': <String>[]},
        'cotizaciones': {'total': '2', 'ids': <String>[]},
      }),
    );

    final p = await _repo(api).pendientes();

    expect(api.llamadas, ['GET me/pendientes']);
    expect((p.citas, p.cotizaciones, p.hayPendientes), (1, 2, true));

    api.responder = (_) => jsonOk({
      'citas': {'total': 'x'},
      'cotizaciones': {'total': 0},
    });
    await expectLater(
      _repo(api).pendientes(),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });

  test('CA_029_19 envía ELIMINAR sin campos vacíos', () async {
    final api = ApiFalsa((_) => _programada());

    final r = await _repo(api).programar();

    expect(
      api.peticiones.single.llamadaCompleta,
      'POST /api/v1/me/eliminacion',
    );
    expect(api.peticiones.single.json, {'confirmacion': 'ELIMINAR'});
    expect(
      (r as EliminacionProgramada).eliminarEn,
      DateTime.utc(2026, 12, 3, 18),
    );

    await _repo(api).programar(firebaseIdToken: 'prueba', motivo: 'Otro');
    expect(api.peticiones.last.json, {
      'confirmacion': 'ELIMINAR',
      'firebaseIdToken': 'prueba',
      'motivo': 'Otro',
    });
  });

  test('un 422 de firebaseIdToken pide verificar; otro es rechazo', () async {
    final api = ApiFalsa((_) => _pideFirebase());
    final sin = await _repo(api).programar();
    expect((sin as PideVerificacion).rechazada, isFalse);
    final con = await _repo(api).programar(firebaseIdToken: 'prueba');
    expect((con as PideVerificacion).rechazada, isTrue);

    api.responder = (_) => jsonOk({
      'errors': {
        'motivo': ['Too long.'],
      },
    }, estado: 422);
    await expectLater(
      _repo(api).programar(),
      throwsA(isA<DatosRechazadosFailure>()),
    );
  });

  test('CA_029_21 y CA_029_24 los 409, 429 y 503 son fallas', () async {
    final api = ApiFalsa((_) => http.Response('', 409));
    await expectLater(_repo(api).programar(), throwsA(isA<ConflictoFailure>()));
    await expectLater(_repo(api).cancelar(), throwsA(isA<ConflictoFailure>()));
    expect(api.llamadas.last, 'POST me/eliminacion/cancelar');
    api.responder = (_) => http.Response('', 429);
    await expectLater(
      _repo(api).programar(),
      throwsA(isA<DemasiadosIntentosFailure>()),
    );
    api.responder = (_) => http.Response('', 503);
    await expectLater(
      _repo(api).pendientes(),
      throwsA(isA<ServicioNoDisponibleFailure>()),
    );
  });

  test('el controlador guarda la fecha y la olvida al cancelar', () async {
    var cancelar = 503;
    final api = ApiFalsa((p) {
      if (p.ruta == 'me') return jsonOk(perfilJson());
      return p.ruta == 'me/eliminacion'
          ? _programada()
          : http.Response('', cancelar);
    });
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    c.listen(eliminacionEnCursoProvider, (_, _) {});
    final control = c.read(eliminacionControllerProvider.notifier)
      ..motivo = 'Ya no lo necesito';

    await control.programar();

    expect(api.peticiones.firstWhere((p) => p.ruta == 'me/eliminacion').json, {
      'confirmacion': 'ELIMINAR',
      'motivo': 'Ya no lo necesito',
    });
    expect(c.read(eliminacionEnCursoProvider), isTrue);

    expect(await control.cancelar(), isA<ServicioNoDisponibleFailure>());
    expect(c.read(eliminacionControllerProvider), isNotNull);

    cancelar = 200;
    expect(await control.cancelar(), isNull);
    expect(c.read(eliminacionControllerProvider), isNull);
  });

  test('el estado del perfil también indica la eliminación en curso', () async {
    final api = ApiFalsa(
      (_) => jsonOk({...perfilJson(), 'estado': 'eliminacion_programada'}),
    );
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    c.listen(eliminacionEnCursoProvider, (_, _) {});

    await c.read(perfilControllerProvider.future);

    expect(c.read(eliminacionEnCursoProvider), isTrue);
  });
}
