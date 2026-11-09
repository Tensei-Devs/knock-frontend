import 'package:app/features/cuenta/domain/perfil.dart';

/// Fuente del perfil y de la sesión de la cuenta.
///
/// Hoy solo existe la implementación SIMULADA: `GET/PUT /api/v1/me` y el
/// cierre de sesión (`POST /api/v1/auth/logout`) no existen aún en la API.
/// Falla con un `Failure` de `core/errores`.
abstract interface class PerfilRepository {
  /// `GET /me`.
  Future<Perfil> obtener();

  /// `PUT /me`: guarda el nombre y devuelve el perfil guardado.
  Future<Perfil> guardarNombre(String nombre);

  /// Revoca la sesión y borra lo guardado de la cuenta (HU-004 CA2).
  Future<void> cerrarSesion();
}
