/// Colonia donde cae un punto (contrato de `GET /api/v1/colonias/en-punto`).
final class Colonia {
  const Colonia({
    required this.id,
    required this.nombre,
    required this.cp,
    required this.municipio,
  });

  final String id;
  final String nombre;
  final String cp;
  final String municipio;
}

/// Resultado de buscar la colonia de un punto: con cobertura trae [colonia];
/// fuera de cobertura es `null` (el servidor responde 200 en ambos casos).
final class ResultadoColonia {
  const ResultadoColonia({required this.enCobertura, this.colonia});

  final bool enCobertura;
  final Colonia? colonia;
}
