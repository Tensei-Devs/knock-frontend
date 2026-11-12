import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EstadoSolicitud', () {
    test('CA_015_01 la solicitud recién enviada llega como enviada', () {
      expect(EstadoSolicitud.desdeValor('enviada'), EstadoSolicitud.enviada);
    });

    test('CA_015_01 los estados del contrato se mapean desde su nombre', () {
      expect(
        EstadoSolicitud.desdeValor('cita_confirmada'),
        EstadoSolicitud.citaConfirmada,
      );
      expect(EstadoSolicitud.desdeValor('vencida'), EstadoSolicitud.vencida);
    });

    test('CA_015_01 un estado desconocido se muestra como en proceso', () {
      expect(
        EstadoSolicitud.desdeValor('algo_nuevo'),
        EstadoSolicitud.enProceso,
      );
      expect(EstadoSolicitud.desdeValor(null), EstadoSolicitud.enProceso);
    });
  });

  group('BorradorSolicitud', () {
    final borrador = BorradorSolicitud(
      oficioClave: 'mec',
      descripcion: 'Mi auto no enciende',
      rutasDeFotos: const ['a.jpg', 'b.png'],
      dia: DateTime(2026, 11, 12),
      franja: Franja.tarde,
      actualizadoEn: DateTime.utc(2026, 11, 11, 9),
    );

    test('CA_015_14 se recupera igual después de guardarlo como texto', () {
      final vuelto = BorradorSolicitud.desdeTexto(borrador.comoTexto());
      expect(vuelto, isNotNull);
      expect(vuelto!.oficioClave, 'mec');
      expect(vuelto.descripcion, 'Mi auto no enciende');
      expect(vuelto.rutasDeFotos, ['a.jpg', 'b.png']);
      expect(vuelto.dia, DateTime(2026, 11, 12));
      expect(vuelto.franja, Franja.tarde);
    });

    test('CA_015_19 el texto guardado no contiene dirección alguna', () {
      expect(borrador.comoTexto().toLowerCase(), isNot(contains('direccion')));
    });

    test('CA_015_14 un texto dañado no rompe: no hay borrador', () {
      expect(BorradorSolicitud.desdeTexto('no es json'), isNull);
      expect(BorradorSolicitud.desdeTexto('[1,2]'), isNull);
      expect(BorradorSolicitud.desdeTexto('{"descripcion": 3}'), isNull);
    });
  });
}
