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

  /// «Pedir cotización» (spec 015): subruta de Actividad. Acepta
  /// `?oficio=<clave>` para saltar el paso 1 (CA-24).
  static const solicitudNueva = '/actividad/solicitud/nueva';

  /// Nombre del parámetro con la clave del oficio de [solicitudNueva].
  static const parametroOficio = 'oficio';

  /// Detalle de una solicitud (spec 015): `/actividad/solicitud/<id>`.
  static String solicitud(String id) =>
      '/actividad/solicitud/${Uri.encodeComponent(id)}';

  /// Subruta de Mi cuenta (HU-052): conserva la barra inferior.
  static const configuracion = '/cuenta/configuracion';

  /// Entrada con celular (HU-001): fuera de la barra inferior.
  static const entrar = '/entrar';

  /// Entrada → código de 6 dígitos (subruta de [entrar]).
  static const codigo = '/entrar/codigo';

  /// Completar el perfil la primera vez (HU-002); fuera de la barra inferior.
  static const completarPerfil = '/completar-perfil';

  /// Pantalla de inicio sin sesión (spec 027, R-01): fuera de la barra
  /// inferior, con su propia barra de marca.
  static const previa = '/previa';

  /// Catálogo de oficios sin sesión (spec 027, R-07); regresa a [previa].
  static const previaOficios = '/previa/oficios';

  /// Nombre del parámetro de ruta con el destino al que volver tras entrar
  /// (spec 027, R-08). Se valida con `destinoDeRegreso`.
  static const parametroVolver = 'volver';
}

bool _esRutaDe(String ubicacion, String base) =>
    ubicacion == base || ubicacion.startsWith('$base/');

/// Rutas que se ven sin sesión (spec 027, R-02): la previa, su catálogo y la
/// entrada con celular (con sus subrutas).
bool esRutaPublica(String ubicacion) =>
    _esRutaDe(ubicacion, Rutas.previa) || _esRutaDe(ubicacion, Rutas.entrar);

/// Devuelve a dónde redirigir según la sesión, o `null` si se permite.
///
/// Sin sesión solo pasan las rutas públicas ([esRutaPublica]); todo lo demás
/// lleva a la previa (spec 027, R-02). Con sesión, `/entrar` y sus subrutas
/// llevan al destino de regreso [volver] si es válido, o a Inicio (HU-001,
/// spec 027 R-09); la previa y su catálogo llevan a Inicio.
String? redireccionPorSesion({
  required bool sesionIniciada,
  required String ubicacion,
  String? volver,
}) {
  if (!sesionIniciada) {
    return esRutaPublica(ubicacion) ? null : Rutas.previa;
  }
  if (_esRutaDe(ubicacion, Rutas.entrar)) return destinoDeRegreso(volver);
  if (_esRutaDe(ubicacion, Rutas.previa)) return Rutas.inicio;
  return null;
}

/// Ruta de la entrada con el destino al que volver (`/entrar?volver=…`), o
/// `/entrar` a secas si no hay destino válido (spec 027, R-08).
String rutaDeEntrada(String? volver, {String base = Rutas.entrar}) {
  final destino = destinoValidoODescartar(volver);
  if (destino == null) return base;
  return Uri(
    path: base,
    queryParameters: {Rutas.parametroVolver: destino},
  ).toString();
}

/// Destino de regreso tras entrar (spec 027, R-08 y R-09, decisión D-08).
///
/// Solo se acepta una ruta interna: una pestaña de la app (Inicio, Explorar,
/// Actividad, Trabajo o Mi cuenta) o una subruta de Explorar. `/previa/oficios`
/// se traduce al catálogo de Explorar, porque con sesión la previa ya no existe.
/// Cualquier otra cosa (otro sitio, `//otro`, vacío, mal formado) va a Inicio.
String destinoDeRegreso(String? valor) =>
    destinoValidoODescartar(valor) ?? Rutas.inicio;

/// Como [destinoDeRegreso], pero `null` si el valor no es un destino permitido
/// (o es el propio Inicio, que no hace falta recordar).
String? destinoValidoODescartar(String? valor) {
  if (valor == null || valor.isEmpty) return null;
  if (valor == Rutas.previaOficios) return Rutas.oficios;
  // Solo caracteres de una ruta interna: nada de esquemas, `//`, barras
  // invertidas, espacios, `?`, `#` ni `..`.
  if (!RegExp(r'^/[A-Za-z0-9/_-]*$').hasMatch(valor) ||
      valor.contains('//') ||
      valor.contains('..')) {
    return null;
  }
  const pestanas = [
    Rutas.explorar,
    Rutas.actividad,
    Rutas.trabajo,
    Rutas.cuenta,
  ];
  if (pestanas.contains(valor) || valor.startsWith('${Rutas.explorar}/')) {
    return valor;
  }
  return null;
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
