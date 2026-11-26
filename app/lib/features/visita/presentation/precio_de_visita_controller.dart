import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/visita/domain/precio_de_visita.dart';
import 'package:app/features/visita/visita_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La cotización final y los ajustes por decidir de una visita. Sin sesión no
/// pide nada.
class PrecioDeVisitaController extends AsyncNotifier<PrecioDeVisita> {
  PrecioDeVisitaController(this.visitaId);

  final String visitaId;

  @override
  Future<PrecioDeVisita> build() async {
    final conSesion = ref.watch(sesionProvider.select((t) => t != null));
    if (!conSesion) return const PrecioDeVisita();
    final repo = ref.watch(precioDeVisitaRepositoryProvider);
    final cotizacion = await repo.cotizacionFinal(visitaId);
    final ajustes = await repo.ajustesPendientes(visitaId);
    return PrecioDeVisita(cotizacionFinal: cotizacion, ajustes: ajustes);
  }
}

/// Sin reintento automático: la persona decide con Actualizar.
final precioDeVisitaControllerProvider = AsyncNotifierProvider.autoDispose
    .family<PrecioDeVisitaController, PrecioDeVisita, String>(
      PrecioDeVisitaController.new,
      retry: (_, _) => null,
    );
