import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interruptor de «Descargar mis datos» (spec 029, USR-06 y USR-06b).
/// **Apagado por omisión**: el archivo se guarda en el almacenamiento privado
/// de Azure, que todavía no existe, así que el servidor no puede entregarlo.
///
/// Apagado, la app no llama a `me/exportaciones` y dice que la descarga aún no
/// está disponible. Se enciende al compilar con
/// `--dart-define=EXPORTACION_DE_DATOS=true`.
const bool exportacionDeDatosDeCompilacion = bool.fromEnvironment(
  'EXPORTACION_DE_DATOS',
);

/// El interruptor de esta ejecución. Las pruebas lo sustituyen para verificar
/// los dos casos.
final exportacionDeDatosActivaProvider = Provider<bool>(
  (ref) => exportacionDeDatosDeCompilacion,
);
