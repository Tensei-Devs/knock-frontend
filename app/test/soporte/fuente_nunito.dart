import 'package:flutter/services.dart';

/// Carga la tipografía Nunito de la app en la prueba.
///
/// `flutter test` no carga las fuentes del `pubspec.yaml`: sin esto, el texto
/// se mide con una fuente de cuadrados mucho más ancha y las filas «desbordan»
/// aunque en el teléfono quepan. Llamar en `setUpAll`.
Future<void> cargarNunito() async {
  final cargador = FontLoader('Nunito');
  for (final peso in [
    'Regular',
    'Medium',
    'SemiBold',
    'Bold',
    'ExtraBold',
    'Black',
  ]) {
    cargador.addFont(rootBundle.load('assets/fonts/nunito/Nunito-$peso.ttf'));
  }
  await cargador.load();
}
