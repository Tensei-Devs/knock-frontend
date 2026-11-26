/// El estado de mi verificación de identidad (spec 018; backend 025).
library;

enum EstadoDeVerificacion {
  sinVerificar,
  enCaptura,
  enRevision,
  verificada,
  noVerificada,
}

/// `GET /me/verificacion`, solo con lo que la pantalla muestra. Las fotos y la
/// CURP no llegan ni se guardan.
final class Verificacion {
  const Verificacion({
    required this.estado,
    this.motivo,
    this.consejos = const [],
    this.nivelOtorgado,
    this.enviadoEn,
  });

  final EstadoDeVerificacion estado;

  /// Texto del catálogo del servidor, o `fotos_borradas`.
  final String? motivo;
  final List<String> consejos;

  /// `basica` o `completa`.
  final String? nivelOtorgado;
  final DateTime? enviadoEn;

  bool get fotosBorradas => motivo == 'fotos_borradas';
}

abstract interface class VerificacionRepository {
  /// Falla con un `Failure`.
  Future<Verificacion> miEstado();
}
