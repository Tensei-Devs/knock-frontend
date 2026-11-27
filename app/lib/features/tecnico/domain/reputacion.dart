final class Reputacion {
  Reputacion({
    required this.promedio,
    required this.total,
    required Map<int, int> distribucion,
    required this.nivel,
  }) : distribucion = Map.unmodifiable(distribucion);

  final double? promedio;
  final int total;
  final Map<int, int> distribucion;
  final String nivel;
}

abstract interface class ReputacionRepository {
  Future<Reputacion> obtener();
}
