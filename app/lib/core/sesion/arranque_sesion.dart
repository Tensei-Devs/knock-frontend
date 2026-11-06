import 'dart:io' show Platform;

import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Si la app corre en un teléfono (Android o iOS), los únicos destinos con
/// Firebase y almacenamiento seguro configurados.
bool get esTelefono => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

/// Inicia Firebase con la configuración nativa (`google-services.json`).
///
/// Sin ese archivo la app arranca igual y la entrada muestra «La verificación
/// por SMS no está disponible»: devuelve `false` en lugar de cerrarse. Fuera
/// de un teléfono (escritorio o `flutter test`) no lo intenta.
Future<bool> iniciarFirebase() async {
  if (!esTelefono) return false;
  try {
    await Firebase.initializeApp();
    return true;
  } on Exception {
    if (kDebugMode) {
      debugPrint(
        'Firebase no está configurado: falta android/app/google-services.json '
        '(ver app/README.md). La entrada por SMS no funcionará.',
      );
    }
    return false;
  }
}

/// Si hay una sesión guardada. Un fallo del almacenamiento cuenta como «sin
/// sesión» (se vuelve a entrar) y no se registra. Fuera de un teléfono,
/// siempre sin sesión.
Future<bool> haySesionGuardada(AlmacenSesion almacen) async {
  if (!esTelefono) return false;
  try {
    return await almacen.leerRefresco() != null;
  } on Exception {
    return false;
  }
}
