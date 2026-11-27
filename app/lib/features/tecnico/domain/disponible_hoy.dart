/// El valor actual de «Disponible hoy» (spec 019, enmienda del 2026-11-27).
/// El cambio va por `HorariosRepository.cambiarDisponibilidad`.
library;

/// Falla con un `Failure`.
abstract interface class DisponibleHoyRepository {
  /// `disponibleHoy` del resumen de Trabajo. La app no calcula cuándo vence.
  Future<bool> consultar();
}
