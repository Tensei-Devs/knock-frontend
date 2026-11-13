import 'package:app/features/actividad/data/solicitud_mapper.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:flutter_test/flutter_test.dart';

/// Spec 015. Este archivo es el que nombra la spec para la capa `data`. Hoy
/// prueba el cuerpo de la petición (CA-23); CA-06, CA-13 y CA-20 contra el
/// cliente generado esperan que el OpenAPI de backend 020 y 021 traiga
/// `/solicitudes`.
void main() {
  NuevaSolicitud solicitud({String? direccion}) => NuevaSolicitud(
    oficioClave: 'plo',
    descripcion: '  Gotea la llave del baño  ',
    archivoIds: const ['aaaaaaaaaaaaaaaaaaaaaaa1', 'aaaaaaaaaaaaaaaaaaaaaaa2'],
    dia: DateTime(2026, 11, 14, 18, 30),
    franja: Franja.tarde,
    coloniaId: 'cccccccccccccccccccccccc',
    direccion: direccion,
  );

  group('CA_015_23 cuerpo de POST /solicitudes', () {
    test(
      'CA_015_23 a domicilio lleva los campos del contrato y la dirección',
      () {
        final cuerpo = cuerpoDeSolicitud(
          solicitud(direccion: ' Calle de Prueba 123 '),
        );

        expect(cuerpo, {
          'oficioClave': 'plo',
          'descripcion': 'Gotea la llave del baño',
          'fotos': ['aaaaaaaaaaaaaaaaaaaaaaa1', 'aaaaaaaaaaaaaaaaaaaaaaa2'],
          'dia': '2026-11-14',
          'franja': 'tarde',
          'coloniaId': 'cccccccccccccccccccccccc',
          'direccion': 'Calle de Prueba 123',
        });
      },
    );

    test('CA_015_23 en taller no lleva dirección', () {
      final cuerpo = cuerpoDeSolicitud(solicitud());

      expect(cuerpo.containsKey('direccion'), isFalse);
    });

    test('CA_015_23 nunca lleva modalidad', () {
      for (final direccion in [null, 'Calle de Prueba 123']) {
        expect(
          cuerpoDeSolicitud(solicitud(direccion: direccion)).keys,
          isNot(contains('modalidad')),
        );
      }
    });
  });
}
