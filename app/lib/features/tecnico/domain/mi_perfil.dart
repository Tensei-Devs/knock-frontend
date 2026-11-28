// Perfil propio del técnico (spec 036, enmienda 2026-11-27; backend 046,
// TEC-15 y TEC-08). Nada de esto se guarda en el teléfono.

/// Lo que `GET /api/v1/tecnicos/me` devuelve y la edición usa. La dirección
/// del taller viene descifrada: no se registra ni se guarda en disco.
final class MiPerfilTecnico {
  const MiPerfilTecnico({
    required this.id,
    required this.nombre,
    required this.oficios,
    required this.atencion,
    required this.estado,
    required this.verificacion,
    this.radioKm,
    this.nombreNegocio,
    this.descripcion,
    this.anios,
    this.direccionTaller,
  });

  /// Identificador de técnico: solo en memoria (servicios y opiniones).
  final String id;
  final String nombre;
  final List<String> oficios;

  /// `taller`, `domicilio` o `ambos`.
  final String atencion;
  final String estado;
  final String verificacion;
  final int? radioKm;
  final String? nombreNegocio;
  final String? descripcion;
  final int? anios;
  final String? direccionTaller;

  bool get atiendeEnTaller => atencion == 'taller' || atencion == 'ambos';
  bool get vaADomicilio => atencion == 'domicilio' || atencion == 'ambos';
}

/// Los campos que la persona puede cambiar en «Tu perfil público».
enum CampoPerfil { nombre, nombreNegocio, anios, descripcion, direccionTaller }

/// Lo que la persona escribe. Se abre con los datos guardados.
final class EdicionPerfil {
  EdicionPerfil({
    required this.nombre,
    required this.nombreNegocio,
    required this.anios,
    required this.descripcion,
    required this.direccionTaller,
    required this.radioKm,
  });

  factory EdicionPerfil.desde(MiPerfilTecnico p) => EdicionPerfil(
    nombre: p.nombre,
    nombreNegocio: p.nombreNegocio ?? '',
    anios: p.anios?.toString() ?? '',
    descripcion: p.descripcion ?? '',
    direccionTaller: p.direccionTaller ?? '',
    radioKm: p.radioKm,
  );

  String nombre;
  String nombreNegocio;
  String anios;
  String descripcion;
  String direccionTaller;
  int? radioKm;
}

/// Radios que acepta el servidor para quien va a domicilio.
const radiosDeAtencionKm = [3, 5, 8, 12];

/// Reglas del servidor (backend 046, R-45, y los validadores del registro): nombre de 2 a 80, negocio hasta
/// 60, años de 0 a 60, descripción hasta 300 y dirección de 8 a 200.
Map<CampoPerfil, String> erroresDeEdicion(EdicionPerfil e) {
  final errores = <CampoPerfil, String>{};
  final nombre = e.nombre.trim();
  if (nombre.length < 2 || nombre.length > 80) {
    errores[CampoPerfil.nombre] = 'Escribe tu nombre completo';
  }
  if (e.nombreNegocio.trim().length > 60) {
    errores[CampoPerfil.nombreNegocio] = 'Usa hasta 60 caracteres';
  }
  final anios = e.anios.trim();
  final n = int.tryParse(anios);
  if (anios.isNotEmpty && (n == null || n < 0 || n > 60)) {
    errores[CampoPerfil.anios] = 'Escribe un número de 0 a 60';
  }
  if (e.descripcion.trim().length > 300) {
    errores[CampoPerfil.descripcion] = 'Usa hasta 300 caracteres';
  }
  final direccion = e.direccionTaller.trim();
  if (direccion.isNotEmpty &&
      (direccion.length < 8 || direccion.length > 200)) {
    errores[CampoPerfil.direccionTaller] = 'Escribe calle, número y colonia';
  }
  return errores;
}

/// El cuerpo del `PUT`: solo lo que cambió (CA-G01). El servidor deja igual
/// lo que no llega, así que un campo opcional vaciado no se envía. La
/// dirección solo va si atiende en taller y el radio solo si va a domicilio.
Map<String, Object?> cambiosDelPerfil(
  MiPerfilTecnico original,
  EdicionPerfil e,
) {
  String? cambio(String nuevo, String? antes) {
    final limpio = nuevo.trim();
    return limpio.isEmpty || limpio == (antes ?? '').trim() ? null : limpio;
  }

  final anios = int.tryParse(e.anios.trim());
  return {
    'nombre': ?cambio(e.nombre, original.nombre),
    'nombreNegocio': ?cambio(e.nombreNegocio, original.nombreNegocio),
    if (anios != null && anios != original.anios) 'anios': anios,
    'descripcion': ?cambio(e.descripcion, original.descripcion),
    if (original.atiendeEnTaller)
      'direccionTaller': ?cambio(e.direccionTaller, original.direccionTaller),
    if (original.vaADomicilio &&
        e.radioKm != null &&
        e.radioKm != original.radioKm)
      'radioKm': e.radioKm,
  };
}

abstract interface class MiPerfilRepository {
  /// `GET /tecnicos/me`. Falla con `NoEncontradoFailure` si la cuenta no
  /// tiene perfil de técnico.
  Future<MiPerfilTecnico> leer();

  /// `PUT /tecnicos/me` con solo los campos cambiados.
  Future<void> guardar(Map<String, Object?> cambios);
}
