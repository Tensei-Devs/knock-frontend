/// Por qué un texto de notificación no es seguro para la pantalla de bloqueo.
enum MotivoSensible {
  /// Código (de visita, de verificación) o cualquier número largo, como un
  /// teléfono.
  codigo,

  /// Dirección o referencia de domicilio.
  direccion,
}

final _numeroLargo = RegExp(r'\d[\s-]?\d[\s-]?\d[\s-]?\d');
final _palabraDeCodigo = RegExp(
  r'\b(c[oó]digo|code|clave|pin|contrase[nñ]a)\b',
  caseSensitive: false,
);
final _palabraDeDireccion = RegExp(
  r'\b(calle|avenida|av|blvd|boulevard|colonia|col|cp|domicilio|'
  r'direcci[oó]n|address|street)\b|#\s*\d',
  caseSensitive: false,
);

/// Motivos por los que [texto] no debe mostrarse en una notificación
/// (spec 012, R-03). Vacío si el texto es seguro.
///
/// Es una barrera de último recurso en la app: el backend arma los textos y
/// debe respetar la misma regla.
Set<MotivoSensible> revisarTextoDeNotificacion(String texto) => {
  if (_numeroLargo.hasMatch(texto) || _palabraDeCodigo.hasMatch(texto))
    MotivoSensible.codigo,
  if (_palabraDeDireccion.hasMatch(texto)) MotivoSensible.direccion,
};

/// Si [texto] no contiene datos sensibles.
bool esTextoSeguro(String texto) => revisarTextoDeNotificacion(texto).isEmpty;
