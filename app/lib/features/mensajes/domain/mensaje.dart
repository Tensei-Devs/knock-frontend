import 'dart:convert';

/// Un mensaje de la conversación como lo devuelve el servidor (spec 020,
/// enmienda 2026-11-26). Vive solo en memoria: nunca se guarda ni se registra.
class Mensaje {
  const Mensaje({
    required this.id,
    required this.autorRol,
    required this.texto,
    required this.contactoOculto,
    required this.enviadoEn,
  });

  final String id;
  final String autorRol;

  /// Texto ya revisado por el servidor: si traía un dato de contacto, llega
  /// reemplazado y [contactoOculto] es verdadero. Se muestra tal cual.
  final String texto;
  final bool contactoOculto;
  final DateTime enviadoEn;
}

/// Por qué un texto no se puede enviar (misma regla que el servidor).
enum MotivoTextoInvalido {
  /// Vacío o solo espacios.
  vacio,

  /// Más de [TextoDeMensaje.maxCaracteres] caracteres o de
  /// [TextoDeMensaje.maxBytes] bytes en UTF-8.
  muyLargo,

  /// Un carácter de control distinto del salto de línea.
  caracterNoPermitido,
}

/// Regla del texto de un mensaje, igual a la del servidor: de 1 a 1 000
/// caracteres, hasta 4 096 bytes en UTF-8 y sin caracteres de control salvo el
/// salto de línea. Se revisa antes de salir a la red.
abstract final class TextoDeMensaje {
  static const maxCaracteres = 1000;
  static const maxBytes = 4096;

  /// El texto que se envía: sin espacios en los extremos y con los saltos de
  /// línea de Windows (`\r\n`) convertidos a `\n`.
  static String preparar(String crudo) => crudo.replaceAll('\r\n', '\n').trim();

  /// `null` si [crudo] (una vez preparado) se puede enviar.
  static MotivoTextoInvalido? validar(String crudo) {
    final texto = preparar(crudo);
    if (texto.isEmpty) return MotivoTextoInvalido.vacio;
    // `length` cuenta unidades UTF-16, como `string.Length` del servidor.
    if (texto.length > maxCaracteres) return MotivoTextoInvalido.muyLargo;
    if (utf8.encode(texto).length > maxBytes) {
      return MotivoTextoInvalido.muyLargo;
    }
    for (final c in texto.codeUnits) {
      if (c != 0x0A && _esControl(c)) {
        return MotivoTextoInvalido.caracterNoPermitido;
      }
    }
    return null;
  }

  /// C0 (U+0000 a U+001F), DEL (U+007F) y C1 (U+0080 a U+009F).
  static bool _esControl(int c) => c < 0x20 || (c >= 0x7F && c <= 0x9F);
}
