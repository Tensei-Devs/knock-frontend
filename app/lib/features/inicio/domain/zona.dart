import 'colonia.dart';

/// Zona elegida, sin coordenadas.
final class Zona {
  const Zona({
    required this.coloniaId,
    required this.nombre,
    required this.cp,
    required this.municipio,
  });

  final String coloniaId;
  final String nombre;
  final String cp;
  final String municipio;
}

/// Cobertura y colonias proporcionadas por el servidor.
final class ResultadoZona {
  ResultadoZona({
    required this.enCobertura,
    required this.ciudadPiloto,
    required List<Colonia> colonias,
  }) : colonias = List.unmodifiable(colonias);

  final bool enCobertura;
  final String ciudadPiloto;
  final List<Colonia> colonias;
}

/// Registro confirmado en la lista de espera, sin coordenadas.
final class RegistroListaEspera {
  const RegistroListaEspera({
    required this.cp,
    required this.creadoEn,
    required this.yaRegistrado,
    this.municipio,
  });

  final String cp;
  final String? municipio;
  final DateTime creadoEn;
  final bool yaRegistrado;
}

/// Código postal de cinco dígitos ASCII exactos.
bool esCodigoPostalValido(String texto) =>
    texto.length == 5 && RegExp(r'^[0-9]{5}$').hasMatch(texto);

/// Municipio opcional; si se proporciona, contiene de 1 a 100 caracteres válidos.
bool esMunicipioValido(String? texto) {
  if (texto == null) return true;
  final patron = RegExp(r"^[\p{L} .'-]{1,100}$", unicode: true);
  final coincidencia = patron.firstMatch(texto);
  return coincidencia != null && coincidencia.end == texto.length;
}
