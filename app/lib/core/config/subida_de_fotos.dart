import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interruptor de la subida de fotos de una solicitud (spec 015, T-04; backend
/// 062). **Apagado por omisión**: confirmar una foto necesita el almacenamiento
/// privado y la moderación reales de Azure, que todavía no se han comprobado
/// desde la app.
///
/// Apagado, «Enviar solicitud» no llama a la API (el contrato exige de 1 a 5
/// fotos) y sigue el flujo de datos de ejemplo. Se enciende al compilar con
/// `--dart-define=SUBIDA_DE_FOTOS=true`.
const bool subidaDeFotosDeCompilacion = bool.fromEnvironment('SUBIDA_DE_FOTOS');

/// El interruptor de esta ejecución. Las pruebas lo sustituyen para verificar
/// los dos casos.
final subidaDeFotosActivaProvider = Provider<bool>(
  (ref) => subidaDeFotosDeCompilacion,
);
