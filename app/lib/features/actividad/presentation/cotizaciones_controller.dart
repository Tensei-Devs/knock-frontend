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
