import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/identificador_dispositivo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knock_api/api.dart';

/// Arma la solicitud `POST /auth/firebase` con lo que la spec 009 exige:
/// `deviceId` estable (R-07) y `aceptaAviso` (R-08).
///
/// Si la persona no aceptó el aviso de privacidad lanza
/// [AvisoNoAceptadoFailure] **antes** de generar nada o de llamar al servidor;
/// la pantalla explica el motivo. Quien inicia sesión envía el resultado con
/// `AuthApi` a través de `llamarApi`.
class PrepararCanje {
  const PrepararCanje(this._dispositivo);

  final IdentificadorDispositivo _dispositivo;

  Future<FirebaseExchangeRequest> preparar({
    required String firebaseIdToken,
    required bool avisoAceptado,
    String? dispositivo,
  }) async {
    if (!avisoAceptado) throw const AvisoNoAceptadoFailure();
    return FirebaseExchangeRequest(
      firebaseIdToken: firebaseIdToken,
      deviceId: await _dispositivo.obtener(),
      aceptaAviso: true,
      dispositivo: dispositivo,
    );
  }
}

final prepararCanjeProvider = Provider<PrepararCanje>(
  (ref) => PrepararCanje(ref.watch(identificadorDispositivoProvider)),
);
