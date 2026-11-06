/// Rutas de las pestañas de la barra inferior (TT-MOB-01, spec §8 decisión 9).
abstract final class Rutas {
  static const inicio = '/inicio';
  static const explorar = '/explorar';
  static const actividad = '/actividad';
  static const trabajo = '/trabajo';
  static const cuenta = '/cuenta';

  /// Subruta de Explorar (TT-PRU-02): la pantalla cuelga de la rama Explorar y
  /// conserva la barra inferior.
  static const oficios = '/explorar/oficios';

  /// Subruta de Mi cuenta (HU-052): conserva la barra inferior.
  static const configuracion = '/cuenta/configuracion';

  /// Entrada con celular (HU-001): fuera de la barra inferior.
  static const entrar = '/entrar';

  /// Entrada → código de 6 dígitos (subruta de [entrar]).
  static const codigo = '/entrar/codigo';

  /// Completar el perfil la primera vez (HU-002); fuera de la barra inferior.
  static const completarPerfil = '/completar-perfil';
}

/// Devuelve a dónde redirigir según la sesión, o `null` si se permite.
///
/// Sin sesión, todo lo que no sea `/entrar` (o sus subrutas) lleva a
/// `/entrar`; con sesión, `/entrar` y sus subrutas llevan a Inicio (HU-001).
String? redireccionPorSesion({
  required bool sesionIniciada,
  required String ubicacion,
}) {
  final esRutaDeEntrada =
      ubicacion == Rutas.entrar || ubicacion.startsWith('${Rutas.entrar}/');
  if (!sesionIniciada) {
    return esRutaDeEntrada ? null : Rutas.entrar;
  }
  return esRutaDeEntrada ? Rutas.inicio : null;
}

/// Devuelve a dónde redirigir, o `null` si la ubicación está permitida.
///
/// Sin el rol de técnico, `/trabajo` (y sus subrutas) lleva a Inicio.
String? redireccionPorRol({
  required bool esTecnico,
  required String ubicacion,
}) {
  final esRutaTrabajo =
      ubicacion == Rutas.trabajo || ubicacion.startsWith('${Rutas.trabajo}/');
  return !esTecnico && esRutaTrabajo ? Rutas.inicio : null;
}

/// Con el perfil incompleto (cuenta nueva) todo lleva a completar el perfil.
String? redireccionPorPerfil({
  required bool perfilPendiente,
  required String ubicacion,
}) => perfilPendiente && ubicacion != Rutas.completarPerfil
    ? Rutas.completarPerfil
    : null;
