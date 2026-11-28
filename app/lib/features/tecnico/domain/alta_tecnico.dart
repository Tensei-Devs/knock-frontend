// Alta como técnico (spec 036, TEC-01; backend 046).

/// Cómo atiende. El contrato admite además `ambos`, que la pantalla todavía no
/// ofrece.
enum Atencion {
  taller('taller'),
  domicilio('domicilio');

  const Atencion(this.valor);
  final String valor;
}

/// Radios que acepta el servidor para quien atiende a domicilio.
const radiosPermitidosKm = {3, 5, 8, 12};

/// Lo que la persona envía para crear su perfil de técnico.
final class AltaTecnico {
  const AltaTecnico({
    required this.nombre,
    required this.oficios,
    required this.atencion,
    required this.coloniaId,
    required this.aceptaTerminos,
    this.otroOficio,
    this.direccionTaller,
    this.radioKm,
    this.nombreNegocio,
    this.descripcion,
    this.anios,
  });

  final String nombre;

  /// Claves del catálogo: el servidor exige al menos una.
  final List<String> oficios;
  final Atencion atencion;
  final String coloniaId;
  final bool aceptaTerminos;
  final String? otroOficio;

  /// Solo con taller.
  final String? direccionTaller;

  /// Solo a domicilio.
  final int? radioKm;
  final String? nombreNegocio;
  final String? descripcion;
  final int? anios;
}

/// El perfil que devuelve el servidor, solo con lo que la app usa.
final class PerfilTecnico {
  const PerfilTecnico({
    required this.id,
    required this.nombre,
    required this.oficios,
    required this.estado,
    required this.verificacion,
    required this.disponibleHoy,
  });

  final String id;
  final String nombre;
  final List<String> oficios;
  final String estado;
  final String verificacion;
  final bool disponibleHoy;
}

abstract interface class TecnicoRepository {
  /// Crea el perfil de técnico de la cuenta. Falla con `ConflictoFailure` si
  /// la cuenta ya es técnica.
  Future<PerfilTecnico> registrar(AltaTecnico alta);
}
