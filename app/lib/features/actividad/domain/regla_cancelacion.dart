import 'package:app/features/actividad/domain/solicitud.dart';

/// Solo el servidor cambia el estado; esta regla controla la acción visible.
final class ReglaCancelacion {
  const ReglaCancelacion(this.estado);

  final EstadoSolicitud estado;

  bool get puedeCancelar =>
      estado == EstadoSolicitud.enviada || estado == EstadoSolicitud.cotizando;
}

enum MotivoCancelacion {
  yaNoLoNecesito('no_longer_needed'),
  loResolviPorOtroMedio('solved_elsewhere'),
  tardaMucho('takes_too_long'),
  otro('other');

  const MotivoCancelacion(this.valor);
  final String valor;
}

sealed class ResultadoCancelacion {
  const ResultadoCancelacion();
}

final class Cancelada extends ResultadoCancelacion {
  const Cancelada(this.canceladaEn);
  final DateTime canceladaEn;
}

final class CancelacionConCita extends ResultadoCancelacion {
  const CancelacionConCita();
}

final class CancelacionYaVencida extends ResultadoCancelacion {
  const CancelacionYaVencida();
}

final class CancelacionNoDisponible extends ResultadoCancelacion {
  const CancelacionNoDisponible();
}

final class CancelacionInvalida extends ResultadoCancelacion {
  const CancelacionInvalida();
}

final class CancelacionLimite extends ResultadoCancelacion {
  const CancelacionLimite(this.espera);
  final Duration espera;
}

final class CancelacionError extends ResultadoCancelacion {
  const CancelacionError();
}

final class CancelacionSinConexion extends ResultadoCancelacion {
  const CancelacionSinConexion();
}
