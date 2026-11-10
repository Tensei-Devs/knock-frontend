/// Una sesión abierta de la cuenta en un dispositivo (`GET /api/v1/me/sesiones`,
/// spec 026, R-09).
final class SesionDispositivo {
  const SesionDispositivo({
    required this.id,
    required this.dispositivo,
    required this.ultimaActividad,
    required this.actual,
  });

  final String id;
  final String dispositivo;
  final DateTime ultimaActividad;

  /// Es la sesión de este teléfono: el servidor no deja cerrarla desde aquí.
  final bool actual;

  @override
  bool operator ==(Object other) =>
      other is SesionDispositivo &&
      other.id == id &&
      other.dispositivo == dispositivo &&
      other.ultimaActividad == ultimaActividad &&
      other.actual == actual;

  @override
  int get hashCode => Object.hash(id, dispositivo, ultimaActividad, actual);
}
