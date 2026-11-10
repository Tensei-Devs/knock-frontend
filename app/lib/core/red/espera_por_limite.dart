import 'dart:io' show HttpDate;

import 'package:app/core/errores/failure.dart';
import 'package:http/http.dart' as http;

/// Transporte que obedece `Retry-After` de las respuestas 429 (spec 009, R-09).
///
/// Al recibir un 429 anota hasta cuándo esperar y lanza
/// [DemasiadosIntentosFailure] con ese tiempo. Mientras dure la espera, las
/// llamadas nuevas fallan igual **sin salir a la red**. No reintenta nada por
/// sí mismo: quien llama decide cuándo volver a intentar.
class ClienteConEspera extends http.BaseClient {
  ClienteConEspera(
    this._interno, {
    DateTime Function()? ahora,
    this.esperaPorOmision = const Duration(seconds: 30),
    this.esperaMaxima = const Duration(hours: 1),
  }) : _ahora = ahora ?? DateTime.now;

  final http.Client _interno;
  final DateTime Function() _ahora;

  /// Espera si el 429 no trae un `Retry-After` válido.
  final Duration esperaPorOmision;

  /// Tope para que un valor absurdo del servidor no deje la app bloqueada.
  final Duration esperaMaxima;

  DateTime? _hasta;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final restante = _restante();
    if (restante != null) throw DemasiadosIntentosFailure(espera: restante);
    final respuesta = await _interno.send(request);
    if (respuesta.statusCode != 429) return respuesta;
    // Se descarta el cuerpo del 429: solo importa el tiempo de espera.
    await respuesta.stream.drain<void>();
    final espera = _leerEspera(respuesta.headers['retry-after']);
    _hasta = _ahora().add(espera);
    throw DemasiadosIntentosFailure(espera: espera);
  }

  Duration? _restante() {
    final hasta = _hasta;
    if (hasta == null) return null;
    final resto = hasta.difference(_ahora());
    if (resto <= Duration.zero) {
      _hasta = null;
      return null;
    }
    return resto;
  }

  Duration _leerEspera(String? valor) {
    Duration? espera;
    final texto = valor?.trim();
    if (texto != null && texto.isNotEmpty) {
      final segundos = int.tryParse(texto);
      if (segundos != null) {
        espera = Duration(seconds: segundos);
      } else {
        try {
          espera = HttpDate.parse(texto).difference(_ahora().toUtc());
        } on Exception {
          espera = null;
        }
      }
    }
    if (espera == null || espera <= Duration.zero) return esperaPorOmision;
    return espera > esperaMaxima ? esperaMaxima : espera;
  }

  @override
  void close() => _interno.close();
}
