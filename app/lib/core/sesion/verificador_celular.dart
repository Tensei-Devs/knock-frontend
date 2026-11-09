/// Verificación del celular por SMS (KNOCK-228). La implementación real es
/// Firebase Phone Auth; las pruebas usan un doble.
library;

import 'package:app/core/errores/failure.dart';

/// Código pedido para un celular: lo que hace falta para verificarlo o
/// pedir otro. Solo vive en memoria mientras dura la entrada.
final class SolicitudCodigo {
  const SolicitudCodigo({
    required this.celular,
    required this.idVerificacion,
    this.tokenReenvio,
  });

  /// Los 10 dígitos, sin +52.
  final String celular;

  /// `verificationId` de Firebase.
  final String idVerificacion;

  /// `forceResendingToken` de Firebase (Android), para reenviar.
  final int? tokenReenvio;

  @override
  String toString() => 'SolicitudCodigo';
}

abstract interface class VerificadorCelular {
  /// Pide el SMS para [celular] (10 dígitos de México). Si se da [anterior],
  /// es un reenvío.
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  });

  /// Verifica [codigo] y devuelve el ID token de Firebase para el canje.
  Future<String> tokenDeId(SolicitudCodigo solicitud, String codigo);

  /// Cierra la sesión de Firebase (la app ya tiene la suya).
  Future<void> cerrarSesion();
}

/// Lo que se usa cuando la compilación no trae la configuración de Firebase:
/// toda verificación falla con un error claro en lugar de cerrarse la app.
class VerificadorNoConfigurado implements VerificadorCelular {
  const VerificadorNoConfigurado();

  static const error = VerificacionNoDisponibleFailure();

  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) => Future.error(error);

  @override
  Future<String> tokenDeId(SolicitudCodigo solicitud, String codigo) =>
      Future.error(error);

  @override
  Future<void> cerrarSesion() async {}
}
