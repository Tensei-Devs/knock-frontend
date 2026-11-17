import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/presentation/cotizaciones_controller.dart';
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Qué comparación se pide: la solicitud y el orden (el servidor ordena, R-08).
typedef ConsultaCotizaciones = ({String solicitudId, OrdenCotizaciones orden});

/// Las cotizaciones de una solicitud real (`GET /solicitudes/{id}/cotizaciones`)
/// en el orden pedido. Cada cambio de orden la vuelve a pedir; sin caché y sin
/// reintento automático (la persona decide con Reintentar).
final cotizacionesRealesProvider = FutureProvider.autoDispose
    .family<ResultadoComparacion, ConsultaCotizaciones>(
      (ref, consulta) => ref
          .watch(solicitudesRealesRepositoryProvider)
          .cotizaciones(consulta.solicitudId, orden: consulta.orden),
      retry: (_, _) => null,
    );

/// Elige una cotización de una solicitud real (`POST /solicitudes/{id}/elegir`).
///
/// Nunca reintenta solo y un segundo toque mientras hay una elección en curso
/// no hace nada (spec 015, R-18). La cita, con el contacto del técnico, vive
/// solo en memoria (D-16).
class EleccionRealController extends Notifier<EstadoEleccion> {
  EleccionRealController(this.solicitudId);

  final String solicitudId;

  @override
  EstadoEleccion build() => const EleccionInactiva();

  Future<void> elegir(String cotizacionId) async {
    if (state is EleccionEnCurso || state is EleccionHecha) return;
    state = EleccionEnCurso(cotizacionId);
    try {
      final cita = await ref
          .read(solicitudesRealesRepositoryProvider)
          .elegir(solicitudId, cotizacionId);
      state = EleccionHecha(cita);
      // La solicitud pasa a «cita confirmada» y la comparación a «ya elegiste».
      ref
        ..invalidate(solicitudesRealesControllerProvider)
        ..invalidate(cotizacionesRealesProvider);
    } on Failure catch (falla) {
      state = EleccionFallida(falla, cotizacionId);
      // Con un 409 lo que se veía ya no es cierto: se vuelve a pedir.
      if (falla is EleccionRechazadaFailure) {
        ref
          ..invalidate(solicitudesRealesControllerProvider)
          ..invalidate(cotizacionesRealesProvider);
      }
    }
  }

  /// Al cerrar la hoja: la cita no se conserva (D-16).
  void reiniciar() {
    if (state is EleccionEnCurso) return;
    state = const EleccionInactiva();
  }
}

final eleccionRealProvider = NotifierProvider.autoDispose
    .family<EleccionRealController, EstadoEleccion, String>(
      EleccionRealController.new,
    );
