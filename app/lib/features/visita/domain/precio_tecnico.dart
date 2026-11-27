/// Lo que el técnico propone sobre el precio de su visita en curso (spec 039,
/// CA-01 a CA-03 y CA-07 a CA-09; backend 049).
library;

/// La cotización aceptada de la solicitud de la visita. Sale del resumen de
/// Trabajo porque la visita no la trae. [tope] es el máximo acordado.
final class CotizacionAceptada {
  const CotizacionAceptada({required this.id, required this.tope});

  final String id;
  final int tope;

  int get ajusteMinimo => tope + ReglasDePrecioTecnico.aumentoMinimo;
}

/// Límites de la entrada (backend 049). El servidor los vuelve a revisar.
abstract final class ReglasDePrecioTecnico {
  static const precioMaximo = 2000000;
  static const descripcionMinima = 8;
  static const descripcionMaxima = 500;
  static const motivoMinimo = 10;
  static const motivoMaximo = 300;
  static const aumentoMinimo = 100;

  /// El texto como pesos enteros dentro del rango, o `null`.
  static int? pesos(String texto) {
    final n = int.tryParse(texto.trim());
    return n == null || n < 1 || n > precioMaximo ? null : n;
  }
}

/// Falla con un `Failure`; un 404 es `NoEncontradoFailure` y un 409,
/// `ConflictoFailure`. Una escritura nunca se reintenta sola.
abstract interface class PrecioTecnicoRepository {
  /// `null` si el resumen de Trabajo no trae la cotización aceptada.
  Future<CotizacionAceptada?> cotizacionAceptada(String visitaId);

  Future<void> enviarFinal(
    String visitaId, {
    required int precio,
    required String descripcion,
  });

  Future<void> proponerAjuste(
    String cotizacionId, {
    required int montoNuevo,
    required String motivo,
  });
}
