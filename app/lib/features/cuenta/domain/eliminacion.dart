/// Lo que la persona tiene abierto antes de eliminar su cuenta
/// (`GET /me/pendientes`, spec 029).
final class PendientesDeCuenta {
  const PendientesDeCuenta({required this.citas, required this.cotizaciones});

  final int citas;
  final int cotizaciones;

  bool get hayPendientes => citas > 0 || cotizaciones > 0;
}

/// Qué respondió el servidor al pedir la eliminación.
sealed class ResultadoDeEliminacion {
  const ResultadoDeEliminacion();
}

/// 202: la cuenta se borra en [eliminarEn] si no se cancela.
final class EliminacionProgramada extends ResultadoDeEliminacion {
  const EliminacionProgramada(this.eliminarEn);

  final DateTime eliminarEn;
}

/// 422 en `firebaseIdToken`: la sesión tiene más de 24 horas y hay que volver
/// a verificar el celular. [rechazada] si ya se envió una prueba y no sirvió.
final class PideVerificacion extends ResultadoDeEliminacion {
  const PideVerificacion({required this.rechazada});

  final bool rechazada;
}

abstract interface class EliminacionRepository {
  /// El texto exacto que pide el servidor para confirmar.
  static const confirmacion = 'ELIMINAR';

  Future<PendientesDeCuenta> pendientes();

  /// Programa la eliminación. [motivo] es opcional.
  Future<ResultadoDeEliminacion> programar({
    String? firebaseIdToken,
    String? motivo,
  });

  Future<void> cancelar();
}
