import 'mensaje.dart';

/// Puerto de escritura de mensajes (spec 020, enmienda 2026-11-26).
///
/// El envío no es idempotente: quien lo implementa nunca lo reintenta solo.
/// El hub en vivo solo recibe; enviar siempre va por esta ruta.
abstract interface class EnvioDeMensajes {
  /// Envía [texto] a la conversación [conversacionId] y devuelve el mensaje
  /// guardado. Un texto que no cumple [TextoDeMensaje] falla sin salir a la
  /// red.
  Future<Mensaje> enviar(String conversacionId, String texto);
}
