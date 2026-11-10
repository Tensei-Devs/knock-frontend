import 'package:app/core/router/rutas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Destino al que volver tras entrar (spec 027, R-08 y R-09). Vive solo en
/// memoria: el router lo guarda (ya validado) cuando llega a `/entrar?volver=…`
/// y se usa al entrar o al terminar de completar el perfil.
class DestinoDeRegreso extends Notifier<String?> {
  @override
  String? build() => null;

  /// Guarda [valor] solo si es un destino permitido; si no, lo ignora.
  void recordar(String? valor) => state = destinoValidoODescartar(valor);

  void olvidar() => state = null;
}

final destinoDeRegresoProvider = NotifierProvider<DestinoDeRegreso, String?>(
  DestinoDeRegreso.new,
);
