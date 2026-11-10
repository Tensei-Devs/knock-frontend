import 'package:app/features/cuenta/domain/sesion_dispositivo.dart';

/// Sesiones por dispositivo de la cuenta (spec 026, R-09). Solo capa de datos:
/// aún no hay pantalla. Falla con un `Failure` de `core/errores`.
abstract interface class SesionesRepository {
  /// `GET /me/sesiones`, en el orden del servidor.
  Future<List<SesionDispositivo>> listar();

  /// `DELETE /me/sesiones/{id}`. Una sesión que el servidor ya no conoce (404)
  /// cuenta como cerrada; la sesión actual (409) falla con `ConflictoFailure`.
  Future<void> cerrar(String id);
}
