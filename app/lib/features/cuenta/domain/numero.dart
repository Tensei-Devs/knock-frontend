/// Cambio de número y recuperación de acceso (spec 029; backend 039). Los
/// celulares van en E.164 (`+52` y 10 dígitos) y no se guardan ni se registran.
library;

/// Qué cuenta se intenta recuperar.
enum TipoDeCuenta { cliente, tecnico }

/// Falla con un `Failure`; un 409 es `ConflictoFailure` (el número ya es de
/// otra cuenta). Ninguna escritura se reintenta sola.
abstract interface class NumeroRepository {
  /// Antes de gastar un SMS: falla si el número ya es de otra cuenta.
  Future<void> comprobar(String celularNuevo);

  Future<void> confirmar(String firebaseIdToken);

  /// Sin sesión. El servidor responde igual exista o no la cuenta.
  Future<void> recuperar({
    required String firebaseIdToken,
    required String celularAnterior,
    required TipoDeCuenta tipo,
  });
}
