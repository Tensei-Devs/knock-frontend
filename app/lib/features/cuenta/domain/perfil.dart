/// Perfil de la cuenta (contrato futuro de `GET/PUT /api/v1/me`, HU-002).
final class Perfil {
  const Perfil({this.nombre = ''});

  /// Cuenta recién creada: aún sin nombre.
  static const nuevo = Perfil();

  final String nombre;

  /// El perfil está completo cuando ya tiene nombre (HU-002 CA6: no se vuelve
  /// a pedir).
  bool get completo => nombre.trim().isNotEmpty;

  /// Iniciales para el avatar cuando no hay foto (máximo dos letras).
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+')).where((p) => p != '');
    return partes.take(2).map((p) => p.substring(0, 1).toUpperCase()).join();
  }

  @override
  bool operator ==(Object other) => other is Perfil && other.nombre == nombre;

  @override
  int get hashCode => nombre.hashCode;
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
