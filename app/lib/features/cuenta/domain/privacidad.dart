/// Un consentimiento de la cuenta (`GET /me/consentimientos`, spec 029).
/// [version] y [fecha] faltan mientras no se ha activado un opcional.
final class Consentimiento {
  const Consentimiento({
    required this.tipo,
    required this.vigente,
    required this.obligatorio,
    this.version,
    this.fecha,
  });

  final String tipo;
  final bool vigente;
  final bool obligatorio;
  final String? version;
  final DateTime? fecha;
}

enum EstadoExportacion { enPreparacion, lista, vencida }

/// La última descarga de datos que pidió la persona. [enlace] y [venceEn] solo
/// vienen con la exportación lista; el enlace no se guarda en el teléfono.
final class Exportacion {
  const Exportacion(this.estado, {this.enlace, this.venceEn});

  final EstadoExportacion estado;
  final Uri? enlace;
  final DateTime? venceEn;

  /// Sin el enlace: es una credencial temporal.
  @override
  String toString() => 'Exportacion(${estado.name})';
}

abstract interface class PrivacidadRepository {
  Future<List<Consentimiento>> consentimientos();

  /// Activa o retira un consentimiento opcional.
  Future<Consentimiento> cambiarConsentimiento(
    String tipo, {
    required bool vigente,
  });

  Future<void> pedirExportacion();

  /// `null` si la persona nunca pidió su archivo.
  Future<Exportacion?> ultimaExportacion();
}
