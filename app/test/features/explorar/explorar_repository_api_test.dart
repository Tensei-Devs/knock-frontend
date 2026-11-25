// Spec 036 (backend 046, TEC-14): el repositorio de Explorar manda el filtro,
// lee solo los campos del contrato y traduce cada estado.
import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/explorar/data/explorar_repository_api.dart';
import 'package:app/features/explorar/domain/explorar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _url = 'https://api.knock.test';

Map<String, Object?> _tecnico({String id = 't1', Object? calificacion = 4.8}) =>
    {
      'id': id,
      'nombre': 'Taller Demo',
      'nombreNegocio': null,
      'fotoUrl': null,
      'verificacion': 'completa',
      'calificacion': calificacion,
      'anios': '12',
      'descripcionCorta': null,
      'oficios': ['mec'],
      'detalle': null,
      'campoQueNoDeclaraElContrato': 'x',
    };

Map<String, Object?> _respuesta({bool conSesion = false}) => {
  'filtro': 'auto',
  'serviciosPopulares': [
    {'clave': 'mec', 'nombre': 'Mecánica', 'tecnicos': 3},
  ],
  'mejorCalificados': [_tecnico()],
  'ideas': [
    {'clave': 'ele', 'nombre': 'Electricidad'},
  ],
  'trabajosReales': conSesion
      ? [
          {
            'id': 'f1',
            'url': 'https://fotos.knock.test/f1.jpg',
            'creadoEn': '2026-11-20T18:00:00Z',
          },
        ]
      : null,
  'cercaDeTi': conSesion ? [_tecnico(id: 't2', calificacion: null)] : null,
};

({ExplorarRepositoryApi repo, List<http.Request> peticiones}) _crear(
  int estado, [
  Object? cuerpo,
]) {
  final peticiones = <http.Request>[];
  final cliente = MockClient((peticion) async {
    peticiones.add(peticion);
    return http.Response(
      cuerpo == null ? '' : jsonEncode(cuerpo),
      estado,
      headers: {'content-type': 'application/json'},
    );
  });
  return (
    repo: ExplorarRepositoryApi(transporte: cliente, url: _url),
    peticiones: peticiones,
  );
}

void main() {
  test(
    'CA_036_43 sin sesión lee los bloques públicos y manda el filtro',
    () async {
      final (:repo, :peticiones) = _crear(200, _respuesta());

      final explorar = await repo.cargar(FiltroExplorar.auto);

      expect(peticiones.single.method, 'GET');
      expect(peticiones.single.url.path, '/api/v1/explorar');
      expect(peticiones.single.url.queryParameters, {'filtro': 'auto'});
      expect(explorar.serviciosPopulares.single.tecnicos, 3);
      expect(explorar.mejorCalificados.single.anios, 12);
      expect(explorar.mejorCalificados.single.verificado, isTrue);
      expect(explorar.ideas.single.clave, 'ele');
      expect(explorar.trabajosReales, isNull);
      expect(explorar.cercaDeTi, isNull);
    },
  );

  test(
    'CA_036_43 con sesión lee también trabajos reales y cerca de ti',
    () async {
      final (:repo, peticiones: _) = _crear(200, _respuesta(conSesion: true));

      final explorar = await repo.cargar(FiltroExplorar.todo);

      expect(
        explorar.trabajosReales!.single.creadoEn,
        DateTime.utc(2026, 11, 20, 18),
      );
      expect(explorar.cercaDeTi!.single.id, 't2');
      expect(explorar.cercaDeTi!.single.calificacion, isNull);
      expect(explorar.vacio, isFalse);
    },
  );

  test(
    'CA_036_43 una respuesta sin un bloque obligatorio es dato inválido',
    () async {
      final incompleta = _respuesta()..remove('ideas');
      final (:repo, peticiones: _) = _crear(200, incompleta);
      await expectLater(
        repo.cargar(FiltroExplorar.todo),
        throwsA(isA<DatosInvalidosFailure>()),
      );
    },
  );

  test('CA_036_44 un 401 llega como sesión vencida', () async {
    final (:repo, peticiones: _) = _crear(401);
    await expectLater(
      repo.cargar(FiltroExplorar.todo),
      throwsA(isA<NoAutorizadoFailure>()),
    );
  });

  test('CA_036_43 un 422 del filtro es dato rechazado', () async {
    final (:repo, peticiones: _) = _crear(422, {
      'errors': {
        'filtro': ['The value is not valid.'],
      },
    });
    await expectLater(
      repo.cargar(FiltroExplorar.luz),
      throwsA(isA<DatosRechazadosFailure>()),
    );
  });

  test('el filtro sale del oficio del catálogo y cae en «todo»', () {
    expect(FiltroExplorar.deOficio('mec'), FiltroExplorar.auto);
    expect(FiltroExplorar.deOficio('plo'), FiltroExplorar.agua);
    expect(FiltroExplorar.deOficio('ele'), FiltroExplorar.luz);
    expect(FiltroExplorar.deOficio(null), FiltroExplorar.todo);
    expect(FiltroExplorar.deOficio('jardineria'), FiltroExplorar.todo);
  });
}
