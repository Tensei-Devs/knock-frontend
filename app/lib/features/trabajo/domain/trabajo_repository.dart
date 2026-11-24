import 'package:app/features/trabajo/domain/resumen_de_trabajo.dart';

final class PaginaTrabajo<T> {
  PaginaTrabajo({required List<T> items, required this.nextCursor})
    : items = List.unmodifiable(items);

  final List<T> items;
  final String? nextCursor;
}

final class ResumenPaginado {
  const ResumenPaginado({required this.resumen, required this.nextCursor});
  final ResumenDeTrabajo resumen;
  final String? nextCursor;
}

enum ResultadoDescarte { descartada, noDisponible, noDescartable }

abstract interface class TrabajoRepository {
  Future<PaginaTrabajo<SolicitudNueva>> bandeja({String? cursor});
  Future<ResumenPaginado> resumen({String? cursorTerminadas});
  Future<ResultadoDescarte> descartar(String id);
}
