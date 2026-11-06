import 'dart:io' show Platform;

import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:app/core/sesion/canje_sesion.dart';
import 'package:app/core/sesion/identificador_dispositivo.dart';
import 'package:app/core/sesion/servicio_entrada.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:app/core/sesion/verificador_celular_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Si al arrancar ya había tokens en el almacenamiento seguro. `main()` lo
/// fija; por defecto, sin sesión.
final sesionInicialProvider = Provider<bool>((ref) => false);

/// Si `Firebase.initializeApp()` funcionó al arrancar (hay
/// `google-services.json`). `main()` lo fija.
final firebaseListoProvider = Provider<bool>((ref) => false);

/// Indica si hay sesión iniciada (KNOCK-228, antes HU-001 en memoria).
///
/// Es un indicador de interfaz para el router; la autorización real la hace
/// la API con el token de acceso. Empieza con lo que había guardado.
class SesionNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(sesionInicialProvider);

  /// Marca la sesión como iniciada; el router lleva a Inicio.
  void iniciar() => state = true;
}

final sesionIniciadaProvider = NotifierProvider<SesionNotifier, bool>(
  SesionNotifier.new,
);

/// Tokens y id del dispositivo, solo en Keystore/Keychain.
final almacenSesionProvider = Provider<AlmacenSesion>(
  (ref) => AlmacenSesion(ref.watch(almacenSeguroProvider)),
);

final verificadorCelularProvider = Provider<VerificadorCelular>((ref) {
  return ref.watch(firebaseListoProvider)
      ? VerificadorCelularFirebase(FirebaseAuth.instance)
      : const VerificadorNoConfigurado();
});

final canjeSesionProvider = Provider<CanjeSesion>(
  (ref) => CanjeSesionApi(() => ref.read(authApiProvider)),
);

/// Nombre genérico del teléfono para `dispositivo`: solo el sistema, nunca el
/// nombre que la persona le puso (puede llevar su nombre).
String nombreDeDispositivo() {
  if (kIsWeb) return 'Web';
  if (Platform.isAndroid) return 'Android';
  if (Platform.isIOS) return 'iOS';
  return 'Otro';
}

final servicioEntradaProvider = Provider<ServicioEntrada>(
  (ref) => ServicioEntradaReal(
    verificador: ref.watch(verificadorCelularProvider),
    canje: ref.watch(canjeSesionProvider),
    almacen: ref.watch(almacenSesionProvider),
    identificador: ref.watch(identificadorDispositivoProvider),
    dispositivo: nombreDeDispositivo(),
  ),
);
