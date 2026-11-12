import 'dart:io' show Platform;

import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:app/core/sesion/sesion.dart';
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
    // Sin registro en consola (R-05): la entrada avisa en pantalla que el SMS no está disponible.
    return false;
  }
}

/// Los tokens guardados en el almacenamiento seguro, o `null` si no hay
/// sesión. Un fallo del almacenamiento cuenta como «sin sesión» (se vuelve a
/// entrar) y no se registra. Fuera de un teléfono, siempre sin sesión.
Future<TokensSesion?> leerTokensGuardados(AlmacenSesion almacen) async {
  if (!esTelefono) return null;
  try {
    final refresco = await almacen.leerRefresco();
    if (refresco == null) return null;
    // Sin token de acceso la primera llamada recibe 401 y se renueva.
    final acceso = await almacen.leerAcceso() ?? '';
    return TokensSesion(accessToken: acceso, refreshToken: refresco);
  } on Exception {
    return null;
  }
}
