import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/oficios/domain/detalle_oficio.dart';
import 'package:app/features/oficios/oficios_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// El detalle de un oficio y, si es la última copia porque no hubo conexión,
/// desde cuándo (CA-04).
final class VistaDetalleOficio {
  const VistaDetalleOficio(this.detalle, {this.copiaDel});

  final DetalleOficio detalle;
  final DateTime? copiaDel;
}

/// Última respuesta buena de cada oficio. Vive solo en memoria y se vacía al
/// abrir o cerrar sesión.
final copiasDetalleOficioProvider =
    Provider<Map<String, (DetalleOficio, DateTime)>>((ref) {
      ref.watch(sesionProvider.select((t) => t != null));
      return {};
    });

class DetalleOficioController extends AsyncNotifier<VistaDetalleOficio> {
  DetalleOficioController(this.clave);

  final String clave;

  @override
  Future<VistaDetalleOficio> build() async {
    final copias = ref.watch(copiasDetalleOficioProvider);
    try {
      final detalle = await ref
          .watch(detalleOficioRepositoryProvider)
          .detalle(clave);
      copias[clave] = (detalle, DateTime.now());
      return VistaDetalleOficio(detalle);
    } on ServicioNoDisponibleFailure {
      final copia = copias[clave];
      if (copia == null) rethrow;
      return VistaDetalleOficio(copia.$1, copiaDel: copia.$2);
    }
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final detalleOficioControllerProvider = AsyncNotifierProvider.autoDispose
    .family<DetalleOficioController, VistaDetalleOficio, String>(
      DetalleOficioController.new,
      retry: (_, _) => null,
    );
