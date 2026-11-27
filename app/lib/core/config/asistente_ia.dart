import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interruptor del asistente de IA (spec 042). **Apagado por omisión**: el
/// recurso de Azure OpenAI no está encendido (backend 052, R-16).
///
/// Apagado, la app no llama a `/api/v1/asistente/*` y lo dice en pantalla. Se
/// enciende al compilar con `--dart-define=ASISTENTE_IA=true`.
const bool asistenteIaDeCompilacion = bool.fromEnvironment('ASISTENTE_IA');

/// El interruptor de esta ejecución. Las pruebas lo sustituyen.
final asistenteIaActivoProvider = Provider<bool>(
  (ref) => asistenteIaDeCompilacion,
);
