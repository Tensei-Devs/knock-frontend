import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Apaga o enciende la miniatura de la app en la vista de tareas recientes
/// (Android 13+, spec 016 R-18). Lo hace `MainActivity` por el canal
/// `knock/pantalla`; en otras plataformas o versiones no hace nada.
abstract interface class CapturaEnRecientes {
  Future<void> permitir({required bool permitir});
}

class CapturaEnRecientesAndroid implements CapturaEnRecientes {
  const CapturaEnRecientesAndroid();

  static const _canal = MethodChannel('knock/pantalla');

  @override
  Future<void> permitir({required bool permitir}) async {
    try {
      await _canal.invokeMethod<void>('capturaEnRecientes', permitir);
    } on MissingPluginException {
      // Sin canal (pruebas o iOS): no hay miniatura que apagar.
    } on PlatformException {
      // No debe romper la pantalla de la visita.
    }
  }
}

final capturaEnRecientesProvider = Provider<CapturaEnRecientes>(
  (ref) => const CapturaEnRecientesAndroid(),
);
