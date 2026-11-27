import 'package:app/core/errores/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// «Ver más» de una lista paginada por cursor: pide la página siguiente, une
/// sin repetir y no deja dos pedidos a la vez.
mixin PaginasPorCursor<P> on AsyncNotifier<P> {
  bool _pidiendoMas = false;

  /// El cursor de la página siguiente, o `null` si no hay más.
  String? cursorDe(P pagina);

  Future<P> pedirPagina(String cursor);

  /// [actual] seguida de lo nuevo de [siguiente].
  P unirPaginas(P actual, P siguiente);

  /// Devuelve el error si falla; lo que ya se mostraba sigue igual.
  Future<Failure?> cargarMas() async {
    final actual = state.value;
    final cursor = actual == null ? null : cursorDe(actual);
    if (actual == null || cursor == null || _pidiendoMas) return null;
    _pidiendoMas = true;
    try {
      state = AsyncData(unirPaginas(actual, await pedirPagina(cursor)));
      return null;
    } on Failure catch (falla) {
      return falla;
    } finally {
      _pidiendoMas = false;
    }
  }
}

/// [actuales] y, después, los [nuevos] cuyo [id] aún no estaba.
List<T> unirSinRepetir<T>(
  List<T> actuales,
  List<T> nuevos,
  String Function(T) id,
) {
  final vistos = {for (final e in actuales) id(e)};
  return [
    ...actuales,
    for (final e in nuevos)
      if (!vistos.contains(id(e))) e,
  ];
}
