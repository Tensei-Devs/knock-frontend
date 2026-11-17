import 'dart:async';

import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Le dice a Android el modo de noche de **esta app** (no el del teléfono),
/// según el ajuste «Apariencia». Lo hace `MainActivity` por el canal
/// `knock/pantalla` (Android 12 o superior); en otras plataformas o versiones
/// no hace nada.
///
/// Hace falta porque el mapa nativo se oscurece con el modo de noche de
/// Android y no con el tema de Flutter: con el teléfono en oscuro y la app en
/// «Claro», el mapa se veía oscuro.
abstract interface class ModoNocheDeLaApp {
  Future<void> fijar(ThemeMode modo);
}

class ModoNocheDeLaAppAndroid implements ModoNocheDeLaApp {
  const ModoNocheDeLaAppAndroid();

  static const _canal = MethodChannel('knock/pantalla');

  /// 0 sigue al sistema, 1 claro y 2 oscuro.
  static int codigo(ThemeMode modo) => switch (modo) {
    ThemeMode.system => 0,
    ThemeMode.light => 1,
    ThemeMode.dark => 2,
  };

  @override
  Future<void> fijar(ThemeMode modo) async {
    try {
      await _canal.invokeMethod<void>('modoNoche', codigo(modo));
    } on MissingPluginException {
      // Sin canal (pruebas o iOS): no hay modo de noche nativo que fijar.
    } on PlatformException {
      // No debe romper la app.
    }
  }
}

final modoNocheDeLaAppProvider = Provider<ModoNocheDeLaApp>(
  (ref) => const ModoNocheDeLaAppAndroid(),
);

/// Mantiene el modo de noche de Android igual al ajuste «Apariencia»: corre al
/// arrancar y cada vez que cambia. Se observa desde la raíz de la app.
final modoNocheSincronizadoProvider = Provider<void>((ref) {
  final modo = ref.watch(preferenciasProvider.select((p) => p.modoTema));
  unawaited(ref.read(modoNocheDeLaAppProvider).fijar(modo));
});
