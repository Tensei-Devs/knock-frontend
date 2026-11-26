import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/reportes/domain/reporte.dart';
import 'package:app/features/reportes/reportes_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Los reportes propios (spec 033): páginas por cursor y apelación. No guarda
/// nada en el teléfono.
class MisReportesController extends AsyncNotifier<PaginaReportes>
    with PaginasPorCursor<PaginaReportes> {
  @override
  Future<PaginaReportes> build() {
    // Al abrir o cerrar una sesión se vuelve a pedir: nada pasa a otra cuenta.
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(reportesRepositoryProvider).listar();
  }

  void reintentar() => ref.invalidateSelf();

  @override
  String? cursorDe(PaginaReportes pagina) => pagina.siguiente;

  @override
  Future<PaginaReportes> pedirPagina(String cursor) =>
      ref.read(reportesRepositoryProvider).listar(cursor: cursor);

  /// Sin repetir elementos (CA-15).
  @override
  PaginaReportes unirPaginas(PaginaReportes actual, PaginaReportes siguiente) =>
      PaginaReportes(
        unirSinRepetir(actual.items, siguiente.items, (e) => e.reporteId),
        siguiente.siguiente,
      );

  /// Apela una vez y vuelve a pedir la lista; devuelve el error si falla.
  Future<Failure?> apelar(String reporteId, String texto) async {
    try {
      await ref.read(reportesRepositoryProvider).apelar(reporteId, texto);
    } on Failure catch (falla) {
      return falla;
    }
    ref.invalidateSelf();
    return null;
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final misReportesControllerProvider =
    AsyncNotifierProvider<MisReportesController, PaginaReportes>(
      MisReportesController.new,
      retry: (_, _) => null,
    );

/// A quién se reporta desde una visita; se vuelve a pedir al cambiar la sesión.
final destinoDeReporteProvider = FutureProvider.autoDispose
    .family<DestinoDeReporte?, String>((ref, visitaId) {
      ref.watch(sesionProvider.select((tokens) => tokens != null));
      return ref.watch(reportesRepositoryProvider).destinoDeVisita(visitaId);
    }, retry: (_, _) => null);
