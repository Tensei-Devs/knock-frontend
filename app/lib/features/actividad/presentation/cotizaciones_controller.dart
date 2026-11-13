import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Orden elegido en la comparación de cada solicitud (CA-08).
final ordenCotizacionesProvider = NotifierProvider.autoDispose
    .family<OrdenCotizacionesNotifier, OrdenCotizaciones, String>(
      OrdenCotizacionesNotifier.new,
    );

class OrdenCotizacionesNotifier extends Notifier<OrdenCotizaciones> {
  OrdenCotizacionesNotifier(this.solicitudId);

  final String solicitudId;

  @override
  OrdenCotizaciones build() => OrdenCotizaciones.recomendadas;

  void elegir(OrdenCotizaciones orden) => state = orden;
}

/// La comparación de la solicitud [solicitudId] en el orden elegido.
///
/// Cada cambio de orden **vuelve a pedirla al servidor** con `orden`; la app
/// nunca reordena ni filtra (R-08). Sin caché (R-11).
final cotizacionesProvider = FutureProvider.autoDispose
    .family<ResultadoComparacion, String>((ref, solicitudId) {
      final orden = ref.watch(ordenCotizacionesProvider(solicitudId));
      return ref
          .watch(solicitudRepositoryProvider)
          .cotizaciones(solicitudId, orden: orden);
    });

/// Estado de la elección de una cotización (spec 015, CA-11, CA-12 y R-18).
sealed class EstadoEleccion {
  const EstadoEleccion();
}

final class EleccionInactiva extends EstadoEleccion {
  const EleccionInactiva();
}

/// Mientras se elige no se puede elegir otra tarjeta ni cerrar la hoja (R-18).
final class EleccionEnCurso extends EstadoEleccion {
  const EleccionEnCurso(this.cotizacionId);

  final String cotizacionId;
}

/// La cita confirmada: solo vive en memoria (R-18, D-16).
final class EleccionHecha extends EstadoEleccion {
  const EleccionHecha(this.cita);

  final CitaConfirmada cita;
}

final class EleccionFallida extends EstadoEleccion {
  const EleccionFallida(this.falla, this.cotizacionId);

  final Failure falla;
  final String cotizacionId;

  /// Un 409 no se reintenta: la cotización o la solicitud cambiaron (CA-12).
  /// Un 503 o la red sí, pero a mano (CA-20).
  bool get sePuedeReintentar => falla is! EleccionRechazadaFailure;
}

/// Elige una cotización de la solicitud y refresca la comparación.
class EleccionController extends Notifier<EstadoEleccion> {
  EleccionController(this.solicitudId);

  final String solicitudId;

  @override
  EstadoEleccion build() => const EleccionInactiva();

  /// Confirma la elección. Nunca reintenta solo; un segundo toque mientras
  /// hay una elección en curso no hace nada (R-18).
  Future<void> elegir(String cotizacionId) async {
    if (state is EleccionEnCurso || state is EleccionHecha) return;
    state = EleccionEnCurso(cotizacionId);
    try {
      final cita = await ref
          .read(solicitudRepositoryProvider)
          .elegir(solicitudId, cotizacionId);
      state = EleccionHecha(cita);
      // La comparación pasa a «ya elegiste» (backend 021 R-08).
      ref.invalidate(cotizacionesProvider(solicitudId));
    } on Failure catch (falla) {
      // CA-20: un reintento que llega a una solicitud ya elegida no es un
      // error si la cita existe: se consulta y se muestra.
      if (falla is EleccionRechazadaFailure &&
          falla.motivo == MotivoEleccionRechazada.yaElegida) {
        final cita = await _citaYaConfirmada(cotizacionId);
        if (cita != null) {
          state = EleccionHecha(cita);
          ref.invalidate(cotizacionesProvider(solicitudId));
          return;
        }
      }
      state = EleccionFallida(falla, cotizacionId);
      // Con un 409 la lista ya no es la que se veía: se vuelve a pedir (CA-12).
      if (falla is EleccionRechazadaFailure) {
        ref.invalidate(cotizacionesProvider(solicitudId));
      }
    }
  }

  /// La cita de una solicitud ya elegida: la visita de `visitaId` (spec 016).
  /// `null` si no se puede consultar; entonces queda el mensaje de CA-12.
  Future<CitaConfirmada?> _citaYaConfirmada(String cotizacionId) async {
    try {
      final comparacion = await ref
          .read(solicitudRepositoryProvider)
          .cotizaciones(solicitudId);
      final visitaId = comparacion.visitaId;
      if (visitaId == null) return null;
      final visita = await ref
          .read(visitaRepositoryProvider)
          .obtenerVisita(visitaId);
      return CitaConfirmada(
        visitaId: visita.id,
        solicitudId: solicitudId,
        cotizacionId: cotizacionId,
        modalidad: visita.esTaller ? 'taller' : 'domicilio',
        dia: visita.dia,
        hora: visita.hora,
        precio: visita.precio,
        tope: visita.tope ?? 0,
        direccion: visita.direccion,
        tecnico: TecnicoElegido(
          nombre: visita.tecnico.nombre,
          verificado: visita.tecnico.verificado,
          nivelVerificacion: visita.tecnico.nivelVerificacion,
          telefono: visita.tecnico.telefono,
          whatsapp: visita.tecnico.whatsapp,
        ),
      );
    } on Failure {
      return null;
    }
  }

  /// Al cerrar la hoja: la cita no se conserva (D-16).
  void reiniciar() {
    if (state is EleccionEnCurso) return;
    state = const EleccionInactiva();
  }
}

final eleccionProvider = NotifierProvider.autoDispose
    .family<EleccionController, EstadoEleccion, String>(EleccionController.new);
