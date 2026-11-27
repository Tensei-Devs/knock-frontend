/// Reportes y bloqueos (spec 033, backend 043): solo lo que declara el
/// contrato.
library;

/// Los motivos de la lista cerrada del servidor (backend 043, R-20). Solo
/// [peligro] trae el aviso de llamar al 911.
enum MotivoDeReporte {
  acoso('acoso'),
  fraude('fraude'),
  malServicio('mal_servicio'),
  comportamientoInapropiado('comportamiento_inapropiado'),
  peligro('peligro'),
  otro('otro');

  const MotivoDeReporte(this.valor);

  final String valor;

  /// `null` si la app no conoce el motivo.
  static MotivoDeReporte? desdeTexto(String texto) {
    for (final motivo in values) {
      if (motivo.valor == texto) return motivo;
    }
    return null;
  }
}

/// A quién se reporta desde una visita: la cuenta del técnico y su nombre.
final class DestinoDeReporte {
  const DestinoDeReporte({required this.usuarioId, required this.nombre});

  final String usuarioId;
  final String nombre;
}

/// Un reporte sobre la otra persona de una visita (`CreateReportBody`).
final class NuevoReporte {
  const NuevoReporte({
    required this.reportadoId,
    required this.visitaId,
    required this.motivo,
    required this.descripcion,
  });

  /// La descripción lleva de 8 a 500 caracteres.
  static const largoMinimo = 8;
  static const largoMaximo = 500;

  final String reportadoId;
  final String visitaId;
  final MotivoDeReporte motivo;
  final String descripcion;
}

/// El reporte recién creado (o el abierto igual que ya existía).
final class ReporteCreado {
  const ReporteCreado({
    required this.reporteId,
    required this.estado,
    required this.creadoEn,
    this.avisoEmergencia,
  });

  final String reporteId;
  final String estado;
  final DateTime creadoEn;

  /// El texto del servidor para llamar al 911, si el motivo implica peligro.
  final String? avisoEmergencia;
}

/// Un reporte propio en la lista. Nunca trae datos de la otra parte.
final class ResumenDeReporte {
  const ResumenDeReporte({
    required this.reporteId,
    required this.motivo,
    required this.estado,
    required this.creadoEn,
    required this.puedeApelar,
  });

  final String reporteId;
  final String motivo;

  /// `abierto`, `decidido` o `en_apelacion`.
  final String estado;
  final DateTime creadoEn;
  final bool puedeApelar;
}

final class PaginaReportes {
  const PaginaReportes(this.items, this.siguiente);

  final List<ResumenDeReporte> items;

  /// Cursor opaco de la página siguiente, o `null` si no hay más.
  final String? siguiente;
}

/// Una persona bloqueada: solo identificador, nombre público y fecha.
final class PersonaBloqueada {
  const PersonaBloqueada({
    required this.usuarioId,
    required this.nombre,
    required this.bloqueadoEn,
  });

  final String usuarioId;
  final String nombre;
  final DateTime bloqueadoEn;
}

final class PaginaBloqueados {
  const PaginaBloqueados(this.items, this.siguiente);

  final List<PersonaBloqueada> items;
  final String? siguiente;
}

/// Las rutas REP-01 a REP-03. Falla con un `Failure`.
abstract interface class ReportesRepository {
  /// `null` si la visita no dice a quién reportar.
  Future<DestinoDeReporte?> destinoDeVisita(String visitaId);

  Future<ReporteCreado> crear(NuevoReporte reporte);

  Future<PaginaReportes> listar({String? cursor});

  /// `ApelacionNoPermitidaFailure` sin decisión o con una apelación previa.
  Future<void> apelar(String reporteId, String texto);
}

/// Las rutas BLO-01 a BLO-03. Falla con un `Failure`.
abstract interface class BloqueosRepository {
  /// `YaBloqueadoFailure` si ya estaba bloqueada.
  Future<void> bloquear(String usuarioId);

  /// `NoEncontradoFailure` si no había bloqueo.
  Future<void> desbloquear(String usuarioId);

  Future<PaginaBloqueados> bloqueados({String? cursor});
}
