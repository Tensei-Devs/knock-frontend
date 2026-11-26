import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/reportes/domain/reporte.dart';
import 'package:app/features/reportes/reportes_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A quién tiene bloqueado la persona (spec 033, BLO-01 a BLO-03): páginas por
/// cursor, bloquear y desbloquear. No guarda nada en el teléfono.
class BloqueosController extends AsyncNotifier<PaginaBloqueados>
    with PaginasPorCursor<PaginaBloqueados> {
  @override
  Future<PaginaBloqueados> build() {
    // Al abrir o cerrar una sesión se vuelve a pedir: nada pasa a otra cuenta.
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(bloqueosRepositoryProvider).bloqueados();
  }

  void reintentar() => ref.invalidateSelf();

  @override
  String? cursorDe(PaginaBloqueados pagina) => pagina.siguiente;

  @override
  Future<PaginaBloqueados> pedirPagina(String cursor) =>
      ref.read(bloqueosRepositoryProvider).bloqueados(cursor: cursor);

  /// Sin repetir elementos (CA-09).
  @override
  PaginaBloqueados unirPaginas(
    PaginaBloqueados actual,
    PaginaBloqueados siguiente,
  ) => PaginaBloqueados(
    unirSinRepetir(actual.items, siguiente.items, (e) => e.usuarioId),
    siguiente.siguiente,
  );

  /// Bloquea y vuelve a pedir la lista; devuelve el error si falla (CA-01,
  /// CA-03).
  Future<Failure?> bloquear(String usuarioId) async {
    try {
      await ref.read(bloqueosRepositoryProvider).bloquear(usuarioId);
    } on Failure catch (falla) {
      return falla;
    }
    ref.invalidateSelf();
    return null;
  }

  /// Deshace el bloqueo; devuelve el error si falla (CA-04, CA-06).
  Future<Failure?> desbloquear(String usuarioId) async {
    try {
      await ref.read(bloqueosRepositoryProvider).desbloquear(usuarioId);
    } on Failure catch (falla) {
      return falla;
    }
    ref.invalidateSelf();
    return null;
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final bloqueosControllerProvider =
    AsyncNotifierProvider<BloqueosController, PaginaBloqueados>(
      BloqueosController.new,
      retry: (_, _) => null,
    );
