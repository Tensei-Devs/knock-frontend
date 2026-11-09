import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/red/errores_api.dart';
import 'package:knock_api/api.dart';

/// Sesión que emitió la API al canjear el token de Firebase.
final class SesionEmitida {
  const SesionEmitida({
    required this.acceso,
    required this.renovacion,
    required this.esNuevo,
    required this.perfilCompleto,
  });

  final String acceso;
  final String renovacion;

  /// 201: la cuenta se creó ahora. 200: ya existía.
  final bool esNuevo;
  final bool perfilCompleto;

  /// Sin los tokens: nunca deben llegar a un registro.
  @override
  String toString() =>
      'SesionEmitida(esNuevo: $esNuevo, perfilCompleto: $perfilCompleto)';
}

abstract interface class CanjeSesion {
  /// `POST /api/v1/auth/firebase` con `aceptaAviso: true`.
  Future<SesionEmitida> canjear({
    required String tokenFirebase,
    required String idDispositivo,
    required String dispositivo,
  });
}

/// [CanjeSesion] con el cliente generado (spec 006): sin HTTP a mano.
class CanjeSesionApi implements CanjeSesion {
  CanjeSesionApi(this._api);

  /// Se pide al momento del canje: si la URL base falta, el error llega
  /// como [ApiNoConfiguradaFailure] en esa llamada y no al arrancar.
  final AuthApi Function() _api;

  @override
  Future<SesionEmitida> canjear({
    required String tokenFirebase,
    required String idDispositivo,
    required String dispositivo,
  }) async {
    final respuesta = await llamarApi(
      () => _api().apiVversionAuthFirebasePost(
        versionApi,
        FirebaseExchangeRequest(
          firebaseIdToken: tokenFirebase,
          deviceId: idDispositivo,
          aceptaAviso: true,
          dispositivo: dispositivo,
        ),
      ),
    );
    if (respuesta == null ||
        respuesta.accessToken.isEmpty ||
        respuesta.refreshToken.isEmpty) {
      throw const DatosInvalidosFailure();
    }
    return SesionEmitida(
      acceso: respuesta.accessToken,
      renovacion: respuesta.refreshToken,
      esNuevo: respuesta.esNuevo,
      perfilCompleto: respuesta.perfilCompleto,
    );
  }
}
