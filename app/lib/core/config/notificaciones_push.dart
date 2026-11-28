import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interruptor de las notificaciones push (spec 012, KNOCK-60). **Apagado por
/// omisión**: el envío desde la nube todavía no está encendido.
///
/// Apagado, la app no usa Firebase Cloud Messaging: no pide el permiso de
/// notificaciones, no obtiene el identificador del teléfono y no registra el
/// dispositivo. Se enciende al compilar con
/// `--dart-define=NOTIFICACIONES_PUSH=true` (además hace falta
/// `google-services.json`).
const bool notificacionesPushDeCompilacion = bool.fromEnvironment(
  'NOTIFICACIONES_PUSH',
);

/// El interruptor de esta ejecución. Las pruebas lo sustituyen para verificar
/// los dos casos.
final notificacionesPushActivasProvider = Provider<bool>(
  (ref) => notificacionesPushDeCompilacion,
);
