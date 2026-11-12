import 'package:app/core/preferencias/almacen_borrador_solicitud.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/features/actividad/data/borrador_repository.dart';
import 'package:app/features/actividad/data/solicitud_repository_simulado.dart';
import 'package:app/features/actividad/domain/selector_de_fotos.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Raíz de composición de la función Actividad: lo único que junta `data/`
// con el resto, para que `presentation/` no importe `data/`.

/// Repositorio de solicitudes. **Simulado** en este corte: la implementación
/// sobre el cliente generado llega cuando backend 020 publique su contrato
/// (spec 015, T-01 y T-03).
final solicitudRepositoryProvider = Provider<SolicitudRepository>(
  (ref) => SolicitudRepositorySimulado(),
);

/// Borrador local del formulario; usa el almacén de preferencias de la app si
/// guarda borradores y, si no, uno en memoria.
final borradorRepositoryProvider = Provider<BorradorRepository>((ref) {
  final almacen = ref.watch(almacenPreferenciasProvider);
  return BorradorRepository(
    almacen is AlmacenBorradorSolicitud
        ? almacen as AlmacenBorradorSolicitud
        : AlmacenPreferenciasEnMemoria(),
  );
});

/// Catálogo de oficios del paso 1 (el de la función `oficios`, con su caché).
final oficiosParaSolicitudProvider = FutureProvider<List<Oficio>>(
  (ref) => ref.watch(oficiosRepositoryProvider).listar(),
);

/// Colonia de la zona guardada de la persona. `null` hasta que la spec 017
/// (Zona) la guarde: sin ella no se puede enviar.
final coloniaIdSolicitudProvider = Provider<String?>((ref) => null);

/// Selector de fotos; el real (`image_picker`) llega en el siguiente corte.
final selectorDeFotosProvider = Provider<SelectorDeFotos>(
  (ref) => const SelectorDeFotosAusente(),
);

/// Hoy en la hora de Ciudad de México (UTC−6, sin horario de verano desde
/// 2022), que es la de la ventana de días de la spec 015 (R-04).
final hoyProvider = Provider<DateTime>((ref) {
  final ahora = DateTime.now().toUtc().subtract(const Duration(hours: 6));
  return DateTime(ahora.year, ahora.month, ahora.day);
});

/// Una solicitud por su id. Sin caché: lo personal que cambia no se guarda
/// (spec 015, D-04).
final solicitudDetalleProvider = FutureProvider.autoDispose
    .family<Solicitud, String>(
      (ref, id) => ref.watch(solicitudRepositoryProvider).obtener(id),
    );
