import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/visita/domain/agenda.dart';
import 'package:app/features/visita/visita_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgendaController extends AsyncNotifier<PaginaAgenda>
    with PaginasPorCursor<PaginaAgenda> {
  @override
  Future<PaginaAgenda> build() {
    ref.watch(sesionProvider.select((t) => t != null));
    return ref.watch(agendaRepositoryProvider).listar();
  }

  void reintentar() => ref.invalidateSelf();

  @override
  String? cursorDe(PaginaAgenda pagina) => pagina.siguiente;

  @override
  Future<PaginaAgenda> pedirPagina(String cursor) =>
      ref.read(agendaRepositoryProvider).listar(cursor: cursor);

  @override
  PaginaAgenda unirPaginas(PaginaAgenda actual, PaginaAgenda siguiente) =>
      PaginaAgenda(
        unirSinRepetir(actual.items, siguiente.items, (item) => item.id),
        siguiente.siguiente,
      );
}

final agendaControllerProvider =
    AsyncNotifierProvider.autoDispose<AgendaController, PaginaAgenda>(
      AgendaController.new,
      retry: (_, _) => null,
    );
