// Spec 036: horarios y «Disponible hoy» (TEC-09 a TEC-11). Solo datos
// ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/tecnico/data/horarios_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/horarios_json.dart';

HorariosRepositoryApi _repo(ApiFalsa api) =>
    HorariosRepositoryApi(transporte: api.cliente, url: urlApiPrueba);

void main() {
  test('CA_036_36 lee los siete días con sus franjas', () async {
    final api = ApiFalsa((_) => jsonOk(semanaJson()));

    final semana = await _repo(api).horarios();

    expect(api.llamadas, ['GET tecnicos/me/horarios']);
    expect(semana.map((d) => d.dia), DiaSemana.values);
    expect(semana.first.franjas, [(inicio: '10:00', fin: '18:00')]);
    expect(semana.last.abierto, isFalse);
  });

  test(
    'CA_036_38 guarda la semana y los días cerrados van sin franjas',
    () async {
      final api = ApiFalsa((_) => jsonOk(semanaJson()));

      await _repo(api).guardar(const [
        HorarioDelDia(
          dia: DiaSemana.lunes,
          abierto: false,
          franjas: [(inicio: '10:00', fin: '18:00')],
        ),
        HorarioDelDia(
          dia: DiaSemana.martes,
          abierto: true,
          franjas: [(inicio: '08:00', fin: '19:00')],
        ),
      ]);

      expect(api.llamadas, ['PUT tecnicos/me/horarios']);
      expect(api.peticiones.single.json, {
        'horarios': [
          {'dia': 'lunes', 'abierto': false, 'franjas': <Object?>[]},
          {
            'dia': 'martes',
            'abierto': true,
            'franjas': [
              {'inicio': '08:00', 'fin': '19:00'},
            ],
          },
        ],
      });
    },
  );

  test('CA_036_33 cambia «Disponible hoy»', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'disponibleHoy': true,
        'disponibleHasta': '2026-11-27T05:59:59Z',
      }),
    );

    final r = await _repo(api).cambiarDisponibilidad(disponibleHoy: true);

    expect(api.llamadas, ['PUT tecnicos/me/disponibilidad']);
    expect(api.peticiones.single.json, {'disponibleHoy': true});
    expect(r.disponibleHoy, isTrue);
    expect(r.hasta, DateTime.utc(2026, 11, 27, 5, 59, 59));
  });

  test(
    'CA_036_34 CA_036_35 CA_036_37 los errores llegan como Failure',
    () async {
      HorariosRepositoryApi con(int estado) =>
          _repo(ApiFalsa((_) => http.Response('', estado)));

      await expectLater(
        con(401).horarios(),
        throwsA(isA<NoAutorizadoFailure>()),
      );
      await expectLater(
        con(401).guardar(const []),
        throwsA(isA<NoAutorizadoFailure>()),
      );
      await expectLater(
        con(404).horarios(),
        throwsA(isA<NoEncontradoFailure>()),
      );
      await expectLater(
        con(422).guardar(const []),
        throwsA(isA<DatosRechazadosFailure>()),
      );
      await expectLater(
        con(403).cambiarDisponibilidad(disponibleHoy: true),
        throwsA(isA<AccesoDenegadoFailure>()),
      );
    },
  );

  test('CA_036_36 un día que no existe es un dato inválido', () async {
    final api = ApiFalsa(
      (_) => jsonOk({
        'horarios': [
          {'dia': 'feriado', 'abierto': false, 'franjas': <Object?>[]},
        ],
      }),
    );

    await expectLater(
      _repo(api).horarios(),
      throwsA(isA<DatosInvalidosFailure>()),
    );
  });

  test('CA_036_38 el controlador recuerda las horas al reabrir y conserva lo '
      'que se veía si falla', () async {
    var falla = false;
    final api = ApiFalsa((p) {
      if (falla) return http.Response('', 503);
      return p.metodo == 'GET' ? jsonOk(semanaJson()) : jsonOk(p.json);
    });
    final c = contenedorConApi(api);
    addTearDown(c.dispose);
    final sub = c.listen(horariosControllerProvider, (_, _) {});
    addTearDown(sub.close);
    await c.read(horariosControllerProvider.future);
    final control = c.read(horariosControllerProvider.notifier);
    HorarioDelDia lunes() => c.read(horariosControllerProvider).value!.first;

    expect(await control.cambiar(DiaSemana.lunes, abierto: false), isNull);
    expect(lunes().abierto, isFalse);
    expect(await control.cambiar(DiaSemana.lunes, abierto: true), isNull);
    expect(lunes().franjas, [(inicio: '10:00', fin: '18:00')]);

    falla = true;
    expect(
      await control.cambiar(DiaSemana.lunes, abierto: false),
      isA<ServicioNoDisponibleFailure>(),
    );
    expect(lunes().abierto, isTrue);
  });

  test('CA_036_38 sin horas previas se usan las de la maqueta', () {
    expect(franjasDeLaMaqueta(DiaSemana.martes), [
      (inicio: '08:00', fin: '19:00'),
    ]);
    expect(franjasDeLaMaqueta(DiaSemana.sabado), [
      (inicio: '09:00', fin: '14:00'),
    ]);
    expect(franjasDeLaMaqueta(DiaSemana.domingo), isEmpty);
  });
}
