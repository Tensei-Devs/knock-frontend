/// Validación pura de la entrada con celular y código (HU-001, diseño).
///
/// Dart puro: sin Flutter, sin red y sin almacenamiento. El celular y el
/// código solo viven en memoria mientras dura el flujo (spec §5 y §6).
library;

/// Dígitos de un celular de México sin el prefijo +52.
const int digitosDeCelular = 10;

/// Dígitos del código que llega por SMS.
const int digitosDeCodigo = 6;

final RegExp _celular = RegExp('^[0-9]{$digitosDeCelular}\$');
final RegExp _codigo = RegExp('^[0-9]{$digitosDeCodigo}\$');

/// Si [texto] son exactamente 10 dígitos (sin espacios, signos ni letras).
bool esCelularValido(String texto) => _celular.hasMatch(texto);

/// Si [texto] son exactamente 6 dígitos.
bool esCodigoValido(String texto) => _codigo.hasMatch(texto);

/// Celular de 10 dígitos con el formato `55 1234 5678`.
///
/// Si [digitos] no es un celular válido se devuelve sin cambios.
String formatearCelular(String digitos) {
  if (!esCelularValido(digitos)) {
    return digitos;
  }
  return '${digitos.substring(0, 2)} '
      '${digitos.substring(2, 6)} '
      '${digitos.substring(6)}';
}
