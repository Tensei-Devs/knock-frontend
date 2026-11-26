/// Opiniones y reputación (spec 041, backend 051): solo lo que declara el
/// contrato (`ReviewPage`, `CreateReviewBody` y `CreatedReview`).
library;

/// Calificación por partes; cada una es opcional y va de 1 a 5.
final class PartesDeOpinion {
  const PartesDeOpinion({
    this.puntualidad,
    this.calidad,
    this.precioJusto,
    this.trato,
  });

  final int? puntualidad;
  final int? calidad;
  final int? precioJusto;
  final int? trato;

  bool get vacia =>
      puntualidad == null &&
      calidad == null &&
      precioJusto == null &&
      trato == null;
}

/// La respuesta del técnico a una opinión.
final class RespuestaDeOpinion {
  const RespuestaDeOpinion(this.texto, this.fecha);

  final String texto;
  final DateTime fecha;
}

/// Una opinión publicada. El contrato no trae el nombre de quien opinó.
final class Opinion {
  const Opinion({
    required this.id,
    required this.calificacion,
    required this.totalFotos,
    required this.anonimizada,
    required this.servicioVerificado,
    required this.creadoEn,
    this.partes,
    this.comentario,
    this.respuesta,
  });

  final String id;
  final int calificacion;
  final PartesDeOpinion? partes;
  final String? comentario;

  /// Cuántas fotos tiene: la app todavía no las puede mostrar (spec 041, §10).
  final int totalFotos;
  final RespuestaDeOpinion? respuesta;
  final bool anonimizada;
  final bool servicioVerificado;
  final DateTime creadoEn;
}

/// El resumen del técnico: promedio (`null` sin opiniones), total y cuántas
/// hay de cada número de estrellas.
final class ResumenDeOpiniones {
  const ResumenDeOpiniones({
    required this.total,
    required this.distribucion,
    this.promedio,
  });

  final double? promedio;
  final int total;
  final Map<int, int> distribucion;
}

/// Una página de opiniones, de la más nueva a la más vieja.
final class PaginaOpiniones {
  const PaginaOpiniones(this.items, this.resumen, this.siguiente);

  final List<Opinion> items;
  final ResumenDeOpiniones resumen;

  /// Cursor opaco de la página siguiente, o `null` si no hay más.
  final String? siguiente;
}

/// Lo que el cliente escribe al calificar una visita terminada.
final class NuevaOpinion {
  const NuevaOpinion({
    required this.calificacion,
    this.partes = const PartesDeOpinion(),
    this.comentario = '',
    this.guardarTecnicoConfianza = false,
  });

  /// El comentario admite hasta 500 caracteres.
  static const largoComentario = 500;

  final int calificacion;
  final PartesDeOpinion partes;
  final String comentario;
  final bool guardarTecnicoConfianza;
}

/// La opinión recién creada (`CreatedReview`).
final class OpinionCreada {
  const OpinionCreada({
    required this.id,
    required this.calificacion,
    required this.moderacion,
    required this.creadoEn,
  });

  final String id;
  final int calificacion;
  final String moderacion;
  final DateTime creadoEn;
}

/// Las rutas OPI-01 a OPI-03. Falla con un `Failure`.
abstract interface class OpinionesRepository {
  /// `NoEncontradoFailure` si el técnico no existe o no es visible.
  Future<PaginaOpiniones> listar(String tecnicoId, {String? cursor});

  /// `OpinionNoPermitidaFailure` si la visita ya se calificó o venció el plazo.
  Future<OpinionCreada> calificar(String visitaId, NuevaOpinion opinion);

  /// `OpinionYaRespondidaFailure` si la opinión ya tiene respuesta.
  Future<void> responder(String opinionId, String texto);
}
