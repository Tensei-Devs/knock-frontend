import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/presentation/cotizaciones_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/solicitud_falsa.dart';

const _id = 'bbbbbbbbbbbbbbbbbbbbbbbb';

void main() {
  late SolicitudesFalsas solicitudes;
  late ProviderContainer contenedor;

  EleccionController control() =>
      contenedor.read(eleccionProvider(_id).notifier);
  EstadoEleccion estado() => contenedor.read(eleccionProvider(_id));

  setUp(() {
    solicitudes = SolicitudesFalsas()
      ..comparacion = ResultadoComparacion(
        cotizaciones: [cotizacionDePrueba('c1')],
        totalCotizaciones: 1,
        tiposMixtos: false,
        puedeElegir: true,
      );
    contenedor = ProviderContainer(
      overrides: dobles(solicitudes: solicitudes, borrador: BorradorFalso()),
    );
    addTearDown(contenedor.dispose);
    contenedor.listen(eleccionProvider(_id), (_, _) {});
    contenedor.listen(cotizacionesProvider(_id), (_, _) {});
  });

  test('CA_015_11 elegir deja la cita con su contacto en memoria', () async {
    await control().elegir('c1');

    expect(solicitudes.elecciones, [(_id, 'c1')]);
    final hecha = estado() as EleccionHecha;
    expect(hecha.cita.tecnico.telefono, '5500000001');
    expect(hecha.cita.direccion, 'Calle de Prueba 123');
  });

  group('CA_015_12 un 409 al elegir', () {
    for (final motivo in MotivoEleccionRechazada.values) {
      test(
        'CA_015_12 ${motivo.name}: sin cita, lista refrescada, sin reintento',
        () async {
          await contenedor.read(cotizacionesProvider(_id).future);
          final pedidasAntes = solicitudes.ordenesPedidos.length;
          solicitudes.fallasAlElegir.add(EleccionRechazadaFailure(motivo));

          await control().elegir('c1');
          await contenedor.read(cotizacionesProvider(_id).future);
          await Future<void>.delayed(const Duration(milliseconds: 20));

          final fallida = estado() as EleccionFallida;
          expect(fallida.falla, isA<EleccionRechazadaFailure>());
          expect((fallida.falla as EleccionRechazadaFailure).motivo, motivo);
          expect(fallida.sePuedeReintentar, isFalse);
          expect(solicitudes.elecciones, hasLength(1));
          expect(solicitudes.ordenesPedidos.length, pedidasAntes + 1);
        },
      );
    }
  });

  group('R-18 una sola elección a la vez', () {
    test('R-18 un segundo toque mientras se elige no hace nada', () async {
      final suelta = Completer<void>();
      solicitudes.retrasoAlElegir = suelta.future;

      final primera = control().elegir('c1');
      expect(estado(), isA<EleccionEnCurso>());
      final segunda = control().elegir('c2');
      control().reiniciar();
      expect(estado(), isA<EleccionEnCurso>());
      suelta.complete();
      await Future.wait([primera, segunda]);

      expect(solicitudes.elecciones, [(_id, 'c1')]);
      expect(estado(), isA<EleccionHecha>());
    });

    test('R-18 después de elegir no se puede elegir otra', () async {
      await control().elegir('c1');
      await control().elegir('c2');

      expect(solicitudes.elecciones, hasLength(1));
    });

    test('R-18 al cerrar la hoja la cita se olvida (D-16)', () async {
      await control().elegir('c1');

      control().reiniciar();

      expect(estado(), isA<EleccionInactiva>());
    });
  });

  group('CA_015_20 un 503 al elegir', () {
    test('CA_015_20 se muestra el error y se reintenta solo a mano', () async {
      solicitudes.fallasAlElegir.add(const ServicioNoDisponibleFailure());

      await control().elegir('c1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final fallida = estado() as EleccionFallida;
      expect(fallida.sePuedeReintentar, isTrue);
      expect(solicitudes.elecciones, hasLength(1));

      await control().elegir('c1');

      expect(solicitudes.elecciones, hasLength(2));
      expect(estado(), isA<EleccionHecha>());
    });
  });
}
