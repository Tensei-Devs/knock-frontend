/// Franja del día en que la persona quiere la visita (spec 015, R-04).
///
/// El [valor] es el del contrato (`manana`, `tarde`, `noche`, en minúsculas y
/// sin tilde).
enum Franja {
  manana('manana'),
  tarde('tarde'),
  noche('noche');

  const Franja(this.valor);

  final String valor;

  /// La franja del contrato, o `null` si el texto no es una de las tres.
  static Franja? desdeValor(String? texto) {
    for (final franja in values) {
      if (franja.valor == texto) return franja;
    }
    return null;
  }
}
