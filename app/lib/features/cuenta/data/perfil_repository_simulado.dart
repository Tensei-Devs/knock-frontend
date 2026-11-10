import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:app/features/cuenta/domain/perfil_repository.dart';

/// SIMULADO: perfil y cierre de sesión en memoria. No hay red.
///
/// Sustituye a `GET/PUT /api/v1/me` y `POST /api/v1/auth/logout`, que la API
/// aún no publica. Empieza con un perfil ya completo (demo); cerrar sesión lo
/// deja como cuenta nueva (sin nombre) para recorrer el flujo «completar
/// perfil → inicio», como si la siguiente persona entrara por primera vez.
/// Cuando existan los endpoints se cambia solo `perfilRepositoryProvider`.
class PerfilRepositorySimulado implements PerfilRepository {
  PerfilRepositorySimulado({
    Perfil inicial = const Perfil(nombre: 'Persona Demo'),
  }) : _perfil = inicial;

  Perfil _perfil;

  /// Veces que se cerró la sesión (para las pruebas).
  int cierres = 0;

  @override
  Future<Perfil> obtener() async => _perfil;

  @override
  Future<Perfil> guardarNombre(String nombre) async =>
      _perfil = Perfil(nombre: nombre.trim());

  @override
  Future<void> cerrarSesion() async {
    cierres++;
    _perfil = Perfil.nuevo;
  }
}
