// Spec 036 (backend 046, TEC-01): el repositorio del alta manda solo lo que
// aplica, lee los campos del contrato y traduce cada estado. Y el rol de
// técnico sale de `GET /me`. Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/tecnico/data/tecnico_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

const _colonia = 'c0c0c0c0c0c0c0c0c0c0c0c0';

const _aDomicilio = AltaTecnico(
  nombre: ' Ana López ',
  oficios: ['plo'],
  atencion: Atencion.domicilio,
  radioKm: 8,
  direccionTaller: 'No debe viajar a domicilio',
  coloniaId: _colonia,
  aceptaTerminos: true,
  otroOficio: '  ',
  nombreNegocio: '',
);

Map<String, Object?> _creado() => {
  'id': 'a0a0a0a0a0a0a0a0a0a0a0a0',
  'nombre': 'Ana López',
  'oficios': ['plo'],
  'estado': 'activo',
  'verificacion': 'sin_verificar',
  'disponibleHoy': false,
  'campoQueNoDeclaraElContrato': 'x',
};

TecnicoRepositoryApi _repo(ApiFalsa api) =>
    TecnicoRepositoryApi(transporte: api.transporte, url: urlApiPrueba);

void main() {
  test('CA_036_01 a domicilio envía el radio, sin dirección de taller ni '
      'campos vacíos, y lee la respuesta', () async {
    final api = ApiFalsa((_) => jsonOk(_creado(), estado: 201));

    final perfil = await _repo(api).registrar(_aDomicilio);

    expect(api.llamadas, ['POST tecnicos']);
    expect(api.peticiones.single.json, {
      'nombre': 'Ana López',
      'oficios': ['plo'],
      'atencion': 'domicilio',
      'radioKm': 8,
      'coloniaId': _colonia,
      'aceptaTerminos': true,
    });
    expect(perfil.nombre, 'Ana López');
    expect(perfil.disponibleHoy, isFalse);
  });

  test('CA_036_01 en taller envía la dirección, sin radio, y el perfil '
      'opcional', () {
    final cuerpo = cuerpoDeAlta(
      const AltaTecnico(
        nombre: 'Ana López',
        oficios: ['mec'],
        atencion: Atencion.taller,
        direccionTaller: ' Calle Jacarandas 45 ',
        radioKm: 8,
        coloniaId: _colonia,
        aceptaTerminos: true,
        otroOficio: 'Herrería',
        nombreNegocio: 'Taller Demo',
        descripcion: 'Descripción de ejemplo',
        anios: 4,
      ),
    );

    expect(cuerpo['direccionTaller'], 'Calle Jacarandas 45');
    expect(cuerpo.containsKey('radioKm'), isFalse);
    expect(cuerpo['otroOficio'], 'Herrería');
    expect(cuerpo['perfil'], {
      'nombreNegocio': 'Taller Demo',
      'descripcion': 'Descripción de ejemplo',
      'anios': 4,
    });
  });

  test('CA_036_02 y CA_036_03 cada respuesta de error llega como su '
      'Failure', () async {
    final casos = <(http.Response, Type)>[
      (http.Response('', 401), NoAutorizadoFailure),
      (jsonOk({'code': 'already_a_technician'}, estado: 409), ConflictoFailure),
      (
        jsonOk({
          'errors': {
            'oficios': ['trade_invalid'],
          },
        }, estado: 422),
        OpcionNoDisponibleFailure,
      ),
      (
        jsonOk({
          'errors': {'coloniaId': 'colonia_not_found'},
        }, estado: 422),
        OpcionNoDisponibleFailure,
      ),
      (
        jsonOk({
          'errors': {
            'nombre': ['The value is not valid.'],
          },
        }, estado: 422),
        DatosRechazadosFailure,
      ),
      (http.Response('', 503), ServicioNoDisponibleFailure),
      (jsonOk({'id': 'x'}, estado: 201), DatosInvalidosFailure),
    ];
    for (final (respuesta, tipo) in casos) {
      await expectLater(
        _repo(ApiFalsa((_) => respuesta)).registrar(_aDomicilio),
        throwsA(predicate((e) => e.runtimeType == tipo, '$tipo')),
      );
    }
  });

  test('con la API real, el rol de técnico lo dice GET /me', () async {
    for (final esTecnico in [true, false]) {
      final api = ApiFalsa(
        (_) => jsonOk({...perfilJson(), 'esTecnico': esTecnico}),
      );
      final c = contenedorConApi(api);
      addTearDown(c.dispose);
      c.read(esTecnicoProvider.notifier).cambiar(esTecnico: !esTecnico);
      c.listen(perfilControllerProvider, (_, _) {});

      await c.read(perfilControllerProvider.future);

      expect(c.read(esTecnicoProvider), esTecnico);
    }
  });
}
