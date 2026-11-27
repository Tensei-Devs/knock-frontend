/// El servidor tiene apagado el registro de dispositivos (503
/// `devices_unavailable`: el push aún no está habilitado). No se reintenta en
/// bucle: la app sigue y avisa que las notificaciones no están disponibles.
class NotificacionesNoDisponiblesException implements Exception {
  const NotificacionesNoDisponiblesException();

  @override
  String toString() => 'NotificacionesNoDisponiblesException';
}

/// Registro del identificador de notificaciones en el servidor (spec 012 §5;
/// contrato `POST /dispositivos` y `DELETE /dispositivos/{id}`).
abstract interface class RegistroDispositivosRepository {
  /// Registra [identificador] y devuelve el id del dispositivo en el servidor
  /// (201 la primera vez, 200 si ya estaba). Lanza
  /// [NotificacionesNoDisponiblesException] con 503 y un `Failure` con el resto.
  Future<String> registrar(String identificador);

  /// Da de baja el dispositivo [id]. Es idempotente: el servidor responde 204
  /// aunque ya no exista.
  Future<void> desregistrar(String id);
}

/// SIMULADO: solo se usa sin `KNOCK_API_URL` fuera de `release`. Guarda los
/// identificadores en memoria y no llama a la red.
class RegistroDispositivosSimulado implements RegistroDispositivosRepository {
  final Map<String, String> _porId = {};

  /// Identificadores registrados, para que las pruebas los revisen.
  Set<String> get registrados => _porId.values.toSet();

  /// Para probar fallos del servidor: si no es `null`, se lanza.
  Exception? fallo;

  @override
  Future<String> registrar(String identificador) async {
    if (fallo != null) throw fallo!;
    final id = 'sim-${identificador.hashCode.toUnsigned(32)}';
    _porId[id] = identificador;
    return id;
  }

  @override
  Future<void> desregistrar(String id) async {
    if (fallo != null) throw fallo!;
    _porId.remove(id);
  }
}
