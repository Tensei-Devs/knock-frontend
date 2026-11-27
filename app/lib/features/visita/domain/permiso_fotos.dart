/// El permiso del cliente para publicar las fotos de su trabajo terminado
/// (spec 040, CA-23 a CA-25 y enmienda del 2026-11-27; backend 050, R-30).
library;

/// Lo que se usa de `GET /visitas/{id}`. [permiso] es `false` si no viene.
final class PermisoDeFotos {
  const PermisoDeFotos({required this.terminada, required this.permiso});

  /// Solo en una visita terminada y en la vista del cliente se pregunta.
  final bool terminada;
  final bool permiso;
}

/// Falla con un `Failure`; un 404 es `NoEncontradoFailure` y un 409,
/// `ConflictoFailure`. La escritura nunca se reintenta sola.
abstract interface class PermisoFotosRepository {
  Future<PermisoDeFotos> consultar(String visitaId);

  /// Devuelve el valor que quedó guardado en el servidor.
  Future<bool> guardar(String visitaId, {required bool permiso});
}
