/// Resultado de pedir la ubicación del dispositivo una sola vez.
sealed class ResultadoUbicacion {
  const ResultadoUbicacion();
}

/// La persona concedió el permiso y hubo lectura. La posición se usa para
/// mover la cámara y se descarta: no se guarda ni se envía (constitución §6).
final class Concedida extends ResultadoUbicacion {
  const Concedida({required this.latitud, required this.longitud});

  final double latitud;
  final double longitud;

  /// Sin coordenadas: el resultado nunca debe terminar en un log.
  @override
  String toString() => 'Concedida';
}

/// La persona negó el permiso esta vez; se le puede volver a preguntar.
final class Denegada extends ResultadoUbicacion {
  const Denegada();
}

/// La persona negó el permiso para siempre; solo se cambia en Ajustes.
final class DenegadaParaSiempre extends ResultadoUbicacion {
  const DenegadaParaSiempre();
}

/// El servicio de ubicación del teléfono está apagado (o no respondió).
final class ServicioDesactivado extends ResultadoUbicacion {
  const ServicioDesactivado();
}

/// Acceso a la ubicación del dispositivo.
abstract interface class UbicacionRepository {
  /// Si el permiso ya está concedido. No lo pide ni muestra nada.
  Future<bool> permisoConcedido();

  /// Pide el permiso (solo si falta) y lee la posición **una vez**.
  ///
  /// Nunca lanza: todo caso termina en un [ResultadoUbicacion].
  Future<ResultadoUbicacion> obtenerUnaVez();

  /// Abre los ajustes de la app para cambiar un permiso negado para siempre.
  Future<void> abrirAjustes();
}
