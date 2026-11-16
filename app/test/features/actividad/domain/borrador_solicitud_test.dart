import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final borrador = BorradorSolicitud(
    oficioClave: 'plo',
    descripcion: 'Gotea la llave del baño',
    rutasDeFotos: const ['/privado/fotos/a1.jpg', '/privado/fotos/b2.jpg'],
    dia: DateTime(2026, 11, 12),
    franja: Franja.tarde,
    actualizadoEn: DateTime.utc(2026, 11, 10, 18),
  );

  group('CA_015_14 el borrador se recupera tal cual', () {
    test('CA_015_14 ida y vuelta por el mapa conserva todo', () {
      final leido = BorradorSolicitud.desdeMapa(borrador.aMapa())!;

      expect(leido.oficioClave, 'plo');
      expect(leido.descripcion, 'Gotea la llave del baño');
      expect(leido.rutasDeFotos, borrador.rutasDeFotos);
      expect(leido.dia, DateTime(2026, 11, 12));
      expect(leido.franja, Franja.tarde);
      expect(leido.actualizadoEn, DateTime.utc(2026, 11, 10, 18));
    });

    test('CA_015_14 un mapa dañado o de otra versión se descarta', () {
      expect(BorradorSolicitud.desdeMapa({'v': 2}), isNull);
      expect(
        BorradorSolicitud.desdeMapa({...borrador.aMapa(), 'fotos': 'x'}),
        isNull,
      );
      expect(
        BorradorSolicitud.desdeMapa({
          ...borrador.aMapa(),
          'fotos': [1],
        }),
        isNull,
      );
    });

    test('CA_015_14 sabe cuándo está vacío', () {
      expect(
        BorradorSolicitud(actualizadoEn: DateTime.utc(2026)).estaVacio,
        isTrue,
      );
      expect(borrador.estaVacio, isFalse);
    });
  });

  test('CA_015_19 el borrador guardado no tiene dirección', () {
    final mapa = borrador.aMapa();

    expect(mapa.keys, isNot(contains('direccion')));
    expect(mapa.values.whereType<String>().join(' '), isNot(contains('Calle')));
  });

  test('CA_015_04 la franja usa el texto del contrato', () {
    expect(Franja.values.map((f) => f.valor), ['manana', 'tarde', 'noche']);
    expect(Franja.desdeTexto('noche'), Franja.noche);
    expect(Franja.desdeTexto('madrugada'), isNull);
  });
}
