/// Las acciones del cliente sobre su visita (spec 040; backend 050): cancelar,
/// proponer otra fecha y reportar que el trabajo no se terminó. Los modelos
/// solo llevan lo que declara el contrato.
library;

/// `POST /visitas/{id}/cancelar`: [tardia] si faltaban menos de 24 horas.
final class VisitaCancelada {
  const VisitaCancelada({required this.estado, required this.tardia});

  final String estado;
  final bool tardia;
}

/// `POST /visitas/{id}/reprogramar`: la propuesta que espera respuesta.
final class PropuestaDeFecha {
  const PropuestaDeFecha({
    required this.fechaHora,
    required this.propuestaPor,
    required this.venceEn,
  });

  final DateTime fechaHora;
  final String propuestaPor;
  final DateTime venceEn;
}

/// Límites de la entrada (backend 050, R-25 y R-29).
abstract final class ReglasDeVisita {
  static const reporteMinimo = 8;
  static const reporteMaximo = 500;
  static const anticipacionMinima = Duration(hours: 2);
}

/// Falla con un `Failure`; un 404 es `NoEncontradoFailure` y un 409,
/// `ConflictoFailure`. Una escritura nunca se reintenta sola.
abstract interface class AccionesVisitaRepository {
  Future<VisitaCancelada> cancelar(String visitaId, String motivo);

  Future<PropuestaDeFecha> reprogramar(String visitaId, DateTime fechaHora);

  /// El técnico registra que el cliente no estaba (VIS-07). Devuelve el estado.
  Future<String> clienteAusente(String visitaId);

  /// El técnico termina la visita en curso (VIS-09) con los `archivoId` de sus
  /// fotos. Devuelve el estado.
  Future<String> terminar(
    String visitaId, {
    required String descripcion,
    required List<String> fotos,
    String? recomendacion,
  });

  Future<void> reportarNoTerminado(String visitaId, String texto);
}
