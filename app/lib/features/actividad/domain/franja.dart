/// Parte del día en que la persona quiere el servicio (spec 015, R-04).
///
/// [valor] es el texto exacto del contrato de backend 020 (R-05), en
/// minúsculas y sin acentos.
enum Franja {
  manana('manana'),
  tarde('tarde'),
  noche('noche');

  const Franja(this.valor);

  /// Texto del contrato.
  final String valor;

  /// La franja de un texto del contrato, o `null` si no es una conocida.
  static Franja? desdeTexto(String texto) {
    for (final franja in values) {
      if (franja.valor == texto) return franja;
    }
    return null;
  }
}
