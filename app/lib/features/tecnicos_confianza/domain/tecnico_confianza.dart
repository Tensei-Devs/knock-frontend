/// Técnico que la persona guardó como de confianza (spec 032,
/// `GET /me/tecnicos-confianza`). Solo los campos que declara el contrato.
final class TecnicoDeConfianza {
  const TecnicoDeConfianza({
    required this.tecnicoId,
    required this.nombre,
    required this.nivelVerificacion,
    required this.guardadoEn,
    this.fotoUrl,
  });

  final String tecnicoId;
  final String nombre;
  final String? fotoUrl;
  final String nivelVerificacion;
  final DateTime guardadoEn;

  @override
  String toString() => 'TecnicoDeConfianza(id: $tecnicoId)';
}

/// Página de la lista; [siguiente] es el cursor opaco o `null`.
final class PaginaTecnicosConfianza {
  const PaginaTecnicosConfianza(this.items, this.siguiente);

  final List<TecnicoDeConfianza> items;
  final String? siguiente;
}

/// Resultado de guardar: `PUT` responde 201 si es nuevo y 200 si ya estaba.
final class ResultadoGuardado {
  const ResultadoGuardado(this.tecnico, {required this.yaEstaba});

  final TecnicoDeConfianza tecnico;
  final bool yaEstaba;
}
