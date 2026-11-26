final class VisitaAgenda {
  const VisitaAgenda({
    required this.id,
    required this.estado,
    required this.modalidad,
    required this.fechaHora,
    required this.dia,
    required this.hora,
    required this.precio,
  });

  final String id;
  final String estado;
  final String modalidad;
  final DateTime fechaHora;
  final String dia;
  final String hora;
  final int? precio;
}

final class PaginaAgenda {
  PaginaAgenda(List<VisitaAgenda> items, this.siguiente)
    : items = List.unmodifiable(items);
  final List<VisitaAgenda> items;
  final String? siguiente;
}

abstract interface class AgendaRepository {
  Future<PaginaAgenda> listar({String? cursor});
}
