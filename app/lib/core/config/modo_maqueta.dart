import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modo maqueta (spec 045, R-02): muestra las pantallas de demostración con
/// datos de ejemplo en lugar de los flujos reales que aún no tienen endpoint.
///
/// Se activa al compilar con `--dart-define=MODO_MAQUETA=true`. Apagado por
/// defecto: sin la bandera la app conserva sus flujos y no aparece ningún
/// dato simulado.
const bool modoMaquetaDeCompilacion = bool.fromEnvironment('MODO_MAQUETA');

/// Modo maqueta de esta ejecución. Las pruebas lo sustituyen para verificar
/// los dos modos por separado.
final modoMaquetaProvider = Provider<bool>((ref) => modoMaquetaDeCompilacion);
