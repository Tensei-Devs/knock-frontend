/// Enlaces que la app abre en apps del sistema con `AbridorDeEnlaces`
/// (spec 016, R-05 y CA-21). Solo se arman con estas funciones: nunca se
/// abre una dirección que llegue tal cual del servidor (sin esquemas
/// arbitrarios).
abstract final class Enlaces {
  /// Mapas: `https://www.google.com/maps/search/?api=1&query=<dirección>`.
  static Uri mapa(String direccion) => Uri.parse(
    'https://www.google.com/maps/search/?api=1&query='
    '${Uri.encodeComponent(direccion)}',
  );

  /// Marcador del teléfono con el número (solo dígitos).
  static Uri? llamada(String telefono) {
    final digitos = _soloDigitos(telefono);
    return digitos.length < 10 ? null : Uri(scheme: 'tel', path: digitos);
  }

  /// WhatsApp con el número de México (`52` + 10 dígitos).
  static Uri? whatsapp(String numero) {
    final digitos = _soloDigitos(numero);
    if (digitos.length < 10) return null;
    final completo = digitos.length == 10 ? '52$digitos' : digitos;
    return Uri.parse('https://wa.me/$completo');
  }

  /// SMS con el número y el texto ya escritos; lo envía la persona (spec 022,
  /// CA-09, sin el permiso `SEND_SMS`).
  static Uri? sms(String celular, String texto) {
    final digitos = _soloDigitos(celular);
    if (digitos.length != 10) return null;
    return Uri.parse('sms:$digitos?body=${Uri.encodeComponent(texto)}');
  }

  /// WhatsApp con el texto ya escrito: `https://wa.me/52<celular>?text=…`
  /// (spec 022, CA-10).
  static Uri? whatsappConTexto(String celular, String texto) {
    final chat = whatsapp(celular);
    if (chat == null) return null;
    return Uri.parse('$chat?text=${Uri.encodeComponent(texto)}');
  }

  static String _soloDigitos(String texto) =>
      texto.replaceAll(RegExp(r'[^0-9]'), '');
}
