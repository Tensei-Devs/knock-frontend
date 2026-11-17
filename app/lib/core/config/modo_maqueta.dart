import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modo maqueta (spec 045, enmienda 2): la maqueta es la interfaz de la app y
/// va encendida por defecto. Muestra las pantallas de demostración; lo que ya
/// tiene endpoint usa la API real y lo que no, datos de ejemplo con su rótulo.
///
/// Se apaga al compilar con `--dart-define=MODO_MAQUETA=false`: la app
/// conserva entonces sus flujos anteriores y no aparece ningún dato simulado.
const bool modoMaquetaDeCompilacion = bool.fromEnvironment(
  'MODO_MAQUETA',
  defaultValue: true,
);

/// Modo maqueta de esta ejecución. Las pruebas lo sustituyen para verificar
/// los dos modos por separado.
final modoMaquetaProvider = Provider<bool>((ref) => modoMaquetaDeCompilacion);
