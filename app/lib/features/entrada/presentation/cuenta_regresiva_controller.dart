import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Segundos que hay que esperar antes de poder pedir otro código.
const int segundosParaReenviar = 60;

/// Cuenta regresiva de «Reenviar en 60 s» (HU-001, spec §8 decisión 1).
///
/// El estado son los segundos que faltan; en 0 la pantalla muestra
/// «Reenviar código». Vive mientras la pantalla del código está abierta
/// (`autoDispose`): al salir se cancela el `Timer`. No hace ninguna llamada
/// de red: reenviar solo reinicia la cuenta (diseño temporal).
class CuentaRegresivaNotifier extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(_detener);
    _arrancar();
    return segundosParaReenviar;
  }

  /// Vuelve a empezar en 60 s.
  void reiniciar() {
    state = segundosParaReenviar;
    _arrancar();
  }

  void _arrancar() {
    _detener();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state <= 1) {
        _detener();
        state = 0;
      } else {
        state = state - 1;
      }
    });
  }

  void _detener() {
    _timer?.cancel();
    _timer = null;
  }
}

final cuentaRegresivaProvider =
    NotifierProvider.autoDispose<CuentaRegresivaNotifier, int>(
      CuentaRegresivaNotifier.new,
    );
