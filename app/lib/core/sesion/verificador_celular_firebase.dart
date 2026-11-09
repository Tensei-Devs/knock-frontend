import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Prefijo de México: la app solo acepta celulares de 10 dígitos de México.
const prefijoMexico = '+52';

/// [VerificadorCelular] con Firebase Phone Auth (KNOCK-228).
///
/// Firebase envía el SMS y verifica el código en el teléfono; el backend
/// nunca ve el código (spec 015 del backend). Ni el celular ni el código se
/// registran.
class VerificadorCelularFirebase implements VerificadorCelular {
  VerificadorCelularFirebase(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) {
    final resultado = Completer<SolicitudCodigo>();
    unawaited(
      _auth
          .verifyPhoneNumber(
            phoneNumber: '$prefijoMexico$celular',
            forceResendingToken: anterior?.tokenReenvio,
            // En Android Firebase puede leer el SMS solo; aun así la persona
            // escribe el código, para que el flujo sea uno solo.
            verificationCompleted: (_) {},
            verificationFailed: (error) {
              if (!resultado.isCompleted) {
                resultado.completeError(mapearErrorFirebase(error.code));
              }
            },
            codeSent: (idVerificacion, tokenReenvio) {
              if (!resultado.isCompleted) {
                resultado.complete(
                  SolicitudCodigo(
                    celular: celular,
                    idVerificacion: idVerificacion,
                    tokenReenvio: tokenReenvio,
                  ),
                );
              }
            },
            codeAutoRetrievalTimeout: (_) {},
          )
          .catchError((Object error) {
            if (!resultado.isCompleted) {
              resultado.completeError(
                error is FirebaseAuthException
                    ? mapearErrorFirebase(error.code)
                    : const ServicioNoDisponibleFailure(),
              );
            }
          }),
    );
    return resultado.future;
  }

  @override
  Future<String> tokenDeId(SolicitudCodigo solicitud, String codigo) async {
    final credencial = PhoneAuthProvider.credential(
      verificationId: solicitud.idVerificacion,
      smsCode: codigo,
    );
    try {
      final entrada = await _auth.signInWithCredential(credencial);
      final token = await entrada.user?.getIdToken();
      if (token == null || token.isEmpty) {
        throw const ServicioNoDisponibleFailure();
      }
      return token;
    } on FirebaseAuthException catch (error) {
      throw mapearErrorFirebase(error.code);
    }
  }

  @override
  Future<void> cerrarSesion() => _auth.signOut();
}

/// Traduce el código de error de Firebase Auth a un [Failure] sin detalles.
Failure mapearErrorFirebase(String codigo) => switch (codigo) {
  'invalid-verification-code' => const CodigoIncorrectoFailure(),
  'session-expired' || 'code-expired' => const CodigoVencidoFailure(),
  'invalid-phone-number' => const CelularRechazadoFailure(),
  'too-many-requests' || 'quota-exceeded' => const DemasiadosIntentosFailure(),
  'app-not-authorized' ||
  'invalid-app-credential' ||
  'missing-client-identifier' => const VerificacionNoDisponibleFailure(),
  _ => const ServicioNoDisponibleFailure(),
};
