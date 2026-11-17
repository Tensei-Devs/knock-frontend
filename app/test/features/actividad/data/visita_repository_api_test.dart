// Backend 022 (spec 016 y 022): la visita del cliente y el aviso de confianza
// contra `GET /api/v1/visitas/{id}` y `POST /api/v1/visitas/{id}/aviso`, con
// cuerpos que siguen el contrato vendorizado.
import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/data/visita_repository_api.dart';
import 'package:app/features/actividad/domain/visita.dart';
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

VisitaRepositoryApi _visitas(MockClient c) =>
    VisitaRepositoryApi(transporte: c, url: _base);

AvisoRepositoryApi _avisos(MockClient c) =>
    AvisoRepositoryApi(transporte: c, url: _base);

Map<String, Object?> _visita({
  String rol = 'cliente',
  String modalidad = 'domicilio',
  Object? codigo = '4821',
  Object? motivo,
  Object? tecnico = _tecnico,
  Object? precio = 450,
}) => {
  'id': _id,
  'rol': rol,
  'estado': 'confirmada',
  'modalidad': modalidad,
  'dia': '2026-11-20',
  'hora': '16:00',
  'precio': precio,
  'tope': '500',
  'tecnico': tecnico,
  'cliente': null,
  'lugar': {
    'tipo': modalidad == 'taller' ? 'taller' : 'cliente',
    'direccion': 'Calle 5 #10',
  },
  'codigo': codigo,
  'codigoVenceEn': '2026-11-20T20:00:00Z',
  'motivoCodigo': motivo,
  'reglaSeguridad': 'No le digas el código por teléfono ni por mensaje.',
  'puedeAvisar': true,
  'puedeLlegar': false,
  'llegadaEn': null,
};

const _tecnico = {
  'nombre': 'Ricardo Mendoza',
  'fotoUrl': null,
  'verificado': true,
  'nivelVerificacion': 'identidad',
  'telefono': '+527711234567',
  'whatsapp': null,
};

void main() {
  group('GET /visitas/{id}', () {
    test('Cliente_LeeLaVisitaConElCodigoYElTecnico', () async {
      Uri? recibida;
      final repo = _visitas(
        MockClient((p) async {
          recibida = p.url;
          return _json(_visita());
        }),
      );

      final v = await repo.obtenerVisita(_id);

      expect(recibida!.path, '/api/v1/visitas/$_id');
      expect(v.estado, EstadoVisita.confirmada);
      expect(v.esTaller, isFalse);
      expect(v.dia, DateTime(2026, 11, 20));
      expect(v.hora, '16:00');
      expect(v.codigo, '4821');
      expect(v.motivoCodigo, isNull);
      expect(v.tecnico.nombre, 'Ricardo Mendoza');
      expect(v.tecnico.telefono, '+527711234567');
      expect(v.direccion, 'Calle 5 #10');
      expect(v.precio, 450);
      expect(v.tope, 500, reason: 'el entero llega como texto');
      expect(v.puedeAvisar, isTrue);
    });

    test('Sin_Codigo_TraeElMotivo_YNoInventaUno', () async {
      final repo = _visitas(
        MockClient(
          (_) async => _json(_visita(codigo: null, motivo: 'vencido')),
        ),
      );

      final v = await repo.obtenerVisita(_id);

      expect(v.codigo, isNull);
      expect(v.motivoCodigo, MotivoCodigo.vencido);
    });

    test('Un_Codigo_QueNoEsDeCuatroDigitos_SeDescarta', () async {
      final repo = _visitas(
        MockClient((_) async => _json(_visita(codigo: '12ab'))),
      );

      expect((await repo.obtenerVisita(_id)).codigo, isNull);
    });

    test('Taller_MarcaLaVisitaComoCita', () async {
      final repo = _visitas(
        MockClient(
          (_) async => _json(_visita(modalidad: 'taller', codigo: null)),
        ),
      );

      expect((await repo.obtenerVisita(_id)).esTaller, isTrue);
    });

    test('Vista_DelTecnico_EsDatosInvalidos', () async {
      final repo = _visitas(
        MockClient((_) async => _json(_visita(rol: 'tecnico', tecnico: null))),
      );

      expect(repo.obtenerVisita(_id), throwsA(isA<DatosInvalidosFailure>()));
    });

    test('Sin_Tecnico_EsDatosInvalidos', () async {
      final repo = _visitas(
        MockClient((_) async => _json(_visita(tecnico: null))),
      );

      expect(repo.obtenerVisita(_id), throwsA(isA<DatosInvalidosFailure>()));
    });

    test('Ajena_O_Inexistente_404_EsNoEncontrada', () async {
      final repo = _visitas(MockClient((_) async => http.Response('', 404)));

      expect(repo.obtenerVisita(_id), throwsA(isA<NoEncontradoFailure>()));
    });

    test('Sin_Sesion_401_EsNoAutorizado', () async {
      final repo = _visitas(MockClient((_) async => http.Response('', 401)));

      expect(repo.obtenerVisita(_id), throwsA(isA<NoAutorizadoFailure>()));
    });

    test('El_Codigo_NoApareceEnLosErrores', () async {
      final repo = _visitas(
        MockClient((_) async => _json({'codigo': '4821'}, 503)),
      );

      Object? error;
      try {
        await repo.obtenerVisita(_id);
      } on Failure catch (e) {
        error = e;
      }
      expect(error, isA<ServicioNoDisponibleFailure>());
      expect('$error', isNot(contains('4821')));
    });
  });

  group('POST /visitas/{id}/aviso', () {
    test('Aviso_DevuelveElTextoSinCodigoNiDireccion', () async {
      http.Request? recibida;
      final repo = _avisos(
        MockClient((p) async {
          recibida = p;
          return _json({
            'texto': 'Hoy me visita Ricardo Mendoza entre 16:00 y 18:00.',
            'incluyeCodigo': false,
            'incluyeDireccion': false,
          });
        }),
      );

      final a = await repo.pedirAviso(_id);

      expect(recibida!.method, 'POST');
      expect(recibida!.url.path, '/api/v1/visitas/$_id/aviso');
      expect(a.texto, contains('Ricardo Mendoza'));
      expect(a.esSeguro, isTrue);
    });

    test('409_visit_not_notifiable_BloqueaElAviso', () async {
      final repo = _avisos(
        MockClient((_) async => _json({'code': 'visit_not_notifiable'}, 409)),
      );

      expect(repo.pedirAviso(_id), throwsA(isA<AvisoNoPermitidoFailure>()));
    });

    test('409_DeOtroCodigo_EsConflicto_YDejaElTextoDeRespaldo', () async {
      final repo = _avisos(
        MockClient((_) async => _json({'code': 'otro'}, 409)),
      );

      expect(repo.pedirAviso(_id), throwsA(isA<ConflictoFailure>()));
    });

    test('404_EsNoEncontrada', () async {
      final repo = _avisos(MockClient((_) async => http.Response('', 404)));

      expect(repo.pedirAviso(_id), throwsA(isA<NoEncontradoFailure>()));
    });

    test('Sin_Texto_EsDatosInvalidos', () async {
      final repo = _avisos(
        MockClient(
          (_) async => _json({
            'texto': '',
            'incluyeCodigo': false,
            'incluyeDireccion': false,
          }),
        ),
      );

      expect(repo.pedirAviso(_id), throwsA(isA<DatosInvalidosFailure>()));
    });

    test('503_NoSeReintenta', () async {
      var llamadas = 0;
      final repo = _avisos(
        MockClient((_) async {
          llamadas++;
          return http.Response('', 503);
        }),
      );

      await expectLater(
        repo.pedirAviso(_id),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
      expect(llamadas, 1);
    });
  });
}
