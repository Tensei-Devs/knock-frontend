/// Perfil de la cuenta (`GET/PUT /api/v1/me`, HU-002; spec 026).
final class Perfil {
  const Perfil({
    this.nombre = '',
    this.fotoUrl,
    this.colonia,
    this.codigoPostal,
    this.esTecnico = false,
    this.estado = '',
    this.perfilCompleto = false,
  });

  /// Cuenta recién creada: aún sin nombre.
  static const nuevo = Perfil();

  final String nombre;
  final String? fotoUrl;
  final String? colonia;
  final String? codigoPostal;
  final bool esTecnico;
  final String estado;

  /// Lo que dice el servidor; [completo] sigue siendo lo que usa la interfaz.
  final bool perfilCompleto;

  /// El perfil está completo cuando ya tiene nombre (HU-002 CA6: no se vuelve
  /// a pedir).
  bool get completo => nombre.trim().isNotEmpty;

  /// Iniciales para el avatar cuando no hay foto (máximo dos letras).
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+')).where((p) => p != '');
    return partes.take(2).map((p) => p.substring(0, 1).toUpperCase()).join();
  }

  @override
  bool operator ==(Object other) =>
      other is Perfil &&
      other.nombre == nombre &&
      other.fotoUrl == fotoUrl &&
      other.colonia == colonia &&
      other.codigoPostal == codigoPostal &&
      other.esTecnico == esTecnico &&
      other.estado == estado &&
      other.perfilCompleto == perfilCompleto;

  @override
  int get hashCode => Object.hash(
    nombre,
    fotoUrl,
    colonia,
    codigoPostal,
    esTecnico,
    estado,
    perfilCompleto,
  );
}

final _soloLetras = RegExp(r'^\p{L}+(?: \p{L}+)*$', unicode: true);

/// Valida el nombre de HU-002 CA1/CA2: de 2 a 60 letras (con espacios entre
/// palabras). Devuelve el texto de error, o `null` si es válido.
String? validarNombre(String? texto) {
  final nombre = (texto ?? '').trim();
  if (nombre.length < 2 ||
      nombre.length > 60 ||
      !_soloLetras.hasMatch(nombre)) {
    return 'Escribe tu nombre (solo letras)';
  }
  return null;
}
