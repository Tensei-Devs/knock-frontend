final class TecnicoEncontrado {
  TecnicoEncontrado({
    required this.id,
    required this.nombre,
    required this.verificacion,
    required List<String> oficios,
  }) : oficios = List.unmodifiable(oficios);

  final String id;
  final String nombre;
  final String verificacion;
  final List<String> oficios;
}

final class PaginaTecnicos {
  PaginaTecnicos(List<TecnicoEncontrado> items, this.siguiente)
    : items = List.unmodifiable(items);
  final List<TecnicoEncontrado> items;
  final String? siguiente;
}

/// Centro de una celda agregada, no ubicación de un técnico.
final class GrupoMapa {
  const GrupoMapa({
    required this.latitud,
    required this.longitud,
    required this.cantidad,
    required this.tecnicoId,
  });
  final double latitud;
  final double longitud;
  final int cantidad;
  final String? tecnicoId;
}

/// La zona visible del mapa que se pide en `GET /mapa/tecnicos` (TEC-04). Los
/// límites no se guardan ni se registran (backend 046, R-40).
typedef ConsultaMapa = ({
  String norte,
  String sur,
  String este,
  String oeste,
  String zoom,
  String? oficio,
});
