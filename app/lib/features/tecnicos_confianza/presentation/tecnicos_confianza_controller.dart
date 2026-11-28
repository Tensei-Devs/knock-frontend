import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/tecnicos_confianza/domain/tecnico_confianza.dart';
import 'package:app/features/tecnicos_confianza/tecnicos_confianza_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La lista de técnicos de confianza de la cuenta (spec 032): páginas por
/// cursor, guardar y quitar. No guarda nada en el teléfono.
class TecnicosConfianzaController extends AsyncNotifier<PaginaTecnicosConfianza>
    with PaginasPorCursor<PaginaTecnicosConfianza> {
  @override
  Future<PaginaTecnicosConfianza> build() {
    // Al abrir o cerrar una sesión se vuelve a pedir: nada pasa a otra cuenta.
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    return ref.watch(tecnicosConfianzaRepositoryProvider).listar();
  }

  void reintentar() => ref.invalidateSelf();

  @override
  String? cursorDe(PaginaTecnicosConfianza pagina) => pagina.siguiente;

  @override
  Future<PaginaTecnicosConfianza> pedirPagina(String cursor) =>
      ref.read(tecnicosConfianzaRepositoryProvider).listar(cursor: cursor);

  /// Sin repetir elementos (CA-03).
  @override
  PaginaTecnicosConfianza unirPaginas(
    PaginaTecnicosConfianza actual,
    PaginaTecnicosConfianza siguiente,
  ) => PaginaTecnicosConfianza(
    unirSinRepetir(actual.items, siguiente.items, (e) => e.tecnicoId),
    siguiente.siguiente,
  );

  Future<Failure?> guardar(String tecnicoId) async {
    try {
      final r = await ref
          .read(tecnicosConfianzaRepositoryProvider)
          .guardar(tecnicoId);
      final actual = state.value;
      if (actual != null) {
        state = AsyncData(
          PaginaTecnicosConfianza([
            r.tecnico,
            for (final t in actual.items)
              if (t.tecnicoId != r.tecnico.tecnicoId) t,
          ], actual.siguiente),
        );
      }
      return null;
    } on Failure catch (falla) {
      return falla;
    }
  }

  /// Quita a [tecnicoId]. Un 404 significa que ya no estaba: también sale de
  /// la lista, y se devuelve para explicarlo (CA-09).
  Future<Failure?> quitar(String tecnicoId) async {
    try {
      await ref.read(tecnicosConfianzaRepositoryProvider).quitar(tecnicoId);
    } on NoEncontradoFailure catch (falla) {
      _sacar(tecnicoId);
      return falla;
    } on Failure catch (falla) {
      return falla;
    }
    _sacar(tecnicoId);
    return null;
  }

  void _sacar(String tecnicoId) {
    final actual = state.value;
    if (actual == null) return;
    state = AsyncData(
      PaginaTecnicosConfianza([
        for (final t in actual.items)
          if (t.tecnicoId != tecnicoId) t,
      ], actual.siguiente),
    );
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final tecnicosConfianzaControllerProvider =
    AsyncNotifierProvider<TecnicosConfianzaController, PaginaTecnicosConfianza>(
      TecnicosConfianzaController.new,
      retry: (_, _) => null,
    );
