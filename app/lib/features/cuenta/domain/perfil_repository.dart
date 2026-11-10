import 'package:app/features/cuenta/domain/perfil.dart';

/// Fuente del perfil y de la sesión de la cuenta.
///
/// La implementación real usa `GET/PUT /api/v1/me` y
/// `POST /api/v1/auth/logout` (spec 026); la simulada queda solo para pruebas
/// y para la compilación de desarrollo sin `KNOCK_API_URL`.
/// Falla con un `Failure` de `core/errores`.
abstract interface class PerfilRepository {
  /// `GET /me`.
  Future<Perfil> obtener();

  /// `PUT /me`: guarda el nombre y devuelve el perfil guardado.
  Future<Perfil> guardarNombre(String nombre);

  /// Revoca la sesión y borra lo guardado de la cuenta (HU-004 CA2). Pase lo
  /// que pase con la red, la sesión local queda cerrada.
  Future<void> cerrarSesion();
}
