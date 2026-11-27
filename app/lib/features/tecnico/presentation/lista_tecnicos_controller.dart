import 'package:app/core/red/paginas_por_cursor.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/tecnico/domain/buscar_tecnicos.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef FiltrosTecnicos = ({
  String? oficio,
  bool verificados,
  bool disponibles,

  /// `distancia`, `calificacion` o `recomendadas`; `null` es el orden del
  /// servidor.
  String? orden,

  /// 3, 5, 8 o 12 km alrededor de [lat] y [lng].
  int? radioKm,
  String? lat,
  String? lng,
});

class ListaTecnicosController extends AsyncNotifier<PaginaTecnicos>
    with PaginasPorCursor<PaginaTecnicos> {
  ListaTecnicosController(this.filtros);
  final FiltrosTecnicos filtros;

  @override
  Future<PaginaTecnicos> build() {
    ref.watch(sesionProvider.select((t) => t != null));
    return _pedir();
  }

  Future<PaginaTecnicos> _pedir([String? cursor]) => ref
      .read(buscarTecnicosRepositoryProvider)
      .listar(
        oficio: filtros.oficio,
        soloVerificados: filtros.verificados ? true : null,
        disponibleHoy: filtros.disponibles ? true : null,
        orden: filtros.orden,
        radioKm: filtros.radioKm?.toString(),
        lat: filtros.lat,
        lng: filtros.lng,
        cursor: cursor,
      );

  void reintentar() => ref.invalidateSelf();

  @override
  String? cursorDe(PaginaTecnicos pagina) => pagina.siguiente;
  @override
  Future<PaginaTecnicos> pedirPagina(String cursor) => _pedir(cursor);
  @override
  PaginaTecnicos unirPaginas(PaginaTecnicos actual, PaginaTecnicos siguiente) =>
      PaginaTecnicos(
        unirSinRepetir(actual.items, siguiente.items, (tecnico) => tecnico.id),
        siguiente.siguiente,
      );
}

final listaTecnicosControllerProvider = AsyncNotifierProvider.autoDispose
    .family<ListaTecnicosController, PaginaTecnicos, FiltrosTecnicos>(
      ListaTecnicosController.new,
      retry: (_, _) => null,
    );
