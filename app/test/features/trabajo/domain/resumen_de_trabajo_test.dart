import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/oficios/domain/modalidad.dart';
import 'package:app/features/trabajo/domain/resumen_de_trabajo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CA_019_02 conserva solo los datos permitidos de la solicitud', () {
    final fotos = <String>['foto'];
    final solicitud = SolicitudNueva(
      solicitudId: 's1',
      oficio: const OficioDeSolicitud(clave: 'plo', nombre: 'Plomería'),
      colonia: const ColoniaDeSolicitud(nombre: 'Centro', cp: '12345'),
      descripcion: 'Reparación',
      fotos: fotos,
      dia: DateTime(2026, 11, 25),
      franja: Franja.tarde,
      modalidad: Modalidad.domicilio,
      venceEn: DateTime.utc(2026, 11, 25),
      oleada: 1,
      recibidaEn: DateTime.utc(2026, 11, 24),
      yaCotizo: true,
    );
    fotos.add('otra');
    expect(solicitud.fotos, ['foto']);
    expect(() => solicitud.fotos.add('otra'), throwsUnsupportedError);
    expect(solicitud.oficio.clave, 'plo');
    expect(solicitud.colonia.cp, '12345');
    expect(solicitud.franja, Franja.tarde);
    expect(solicitud.yaCotizo, isTrue);
  });

  test('CA_019_05 la dirección pertenece a la visita aceptada', () {
    final visita = VisitaProxima(
      visitaId: 'v1',
      solicitudId: 's1',
      dia: DateTime(2026, 11, 25),
      hora: '12:00',
      modalidad: Modalidad.domicilio,
      coloniaCliente: 'Centro',
      direccion: 'Calle de ejemplo',
      precio: 100,
      tope: 150,
      estado: EstadoVisitaProxima.confirmada,
      puedeLlegar: true,
    );
    expect(visita.direccion, 'Calle de ejemplo');
    expect(visita.estado, EstadoVisitaProxima.confirmada);
    expect(visita.puedeLlegar, isTrue);
  });

  test(
    'CA_019_13 el resumen conserva datos del servidor e inmoviliza listas',
    () {
      final terminadas = <TrabajoTerminado>[
        TrabajoTerminado(
          solicitudId: 's1',
          oficio: 'Plomería',
          terminadaEn: DateTime.utc(2026, 11, 24),
          precio: 100,
        ),
      ];
      final cotizacion = CotizacionEnviada(
        cotizacionId: 'c1',
        solicitudId: 's1',
        oficio: 'Plomería',
        tipoPrecio: TipoPrecio.rango,
        precio: 100,
        precioMin: 100,
        precioMax: 150,
        tope: 150,
        estado: EstadoCotizacionEnviada.rechazada,
        motivoRechazo: 'other_quote_chosen',
        enviadaEn: DateTime.utc(2026, 11, 24),
      );
      final resumen = ResumenDeTrabajo(
        disponibleHoy: true,
        estadoVerificacion: 'pendiente',
        nivel: const NivelDeTrabajo(clave: 'inicial', nombre: 'Inicial'),
        proximasVisitas: [],
        solicitudesNuevas: [],
        cotizacionesEnviadas: [cotizacion],
        terminadas: terminadas,
        trabajosTerminados: 1,
        calificacion: null,
      );
      terminadas.clear();
      expect(resumen.terminadas, hasLength(1));
      expect(resumen.terminadas.clear, throwsUnsupportedError);
      expect(resumen.proximasVisitas.clear, throwsUnsupportedError);
      expect(resumen.solicitudesNuevas.clear, throwsUnsupportedError);
      expect(resumen.cotizacionesEnviadas.clear, throwsUnsupportedError);
      expect(resumen.estadoVerificacion, 'pendiente');
      expect(resumen.nivel.clave, 'inicial');
      expect(
        resumen.cotizacionesEnviadas.single.motivoRechazo,
        'other_quote_chosen',
      );
      expect(resumen.calificacion, isNull);
    },
  );
}
