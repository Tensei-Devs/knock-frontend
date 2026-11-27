/// Perfil público de un técnico (spec 036, TEC-05 a TEC-07) y sus servicios
/// (spec 037, SRV-01). Solo llevan los campos que declara el contrato.
library;

/// Lo que el servidor agrega cuando hay sesión.
final class DetallePerfil {
  const DetallePerfil({
    required this.disponibleHoy,
    this.descripcion,
    this.atencion,
    this.radioKm,
    this.coloniaId,
  });

  final bool disponibleHoy;
  final String? descripcion;

  /// `taller`, `domicilio` o `ambos`.
  final String? atencion;
  final int? radioKm;
  final String? coloniaId;
}

final class PerfilPublico {
  const PerfilPublico({
    required this.id,
    required this.nombre,
    required this.verificacion,
    required this.oficios,
    this.nombreNegocio,
    this.fotoUrl,
    this.calificacion,
    this.anios,
    this.descripcionCorta,
    this.detalle,
  });

  final String id;
  final String nombre;
  final String verificacion;

  /// Claves del catálogo de oficios.
  final List<String> oficios;
  final String? nombreNegocio;
  final String? fotoUrl;
  final double? calificacion;
  final int? anios;
  final String? descripcionCorta;

  /// `null` sin sesión.
  final DetallePerfil? detalle;

  bool get verificado => verificacion == 'verificado';
}

/// Un servicio con su precio de referencia en pesos.
final class ServicioPublico {
  const ServicioPublico({
    required this.id,
    required this.nombre,
    required this.precioReferencia,
    required this.oficio,
    this.detalle,
  });

  final String id;
  final String nombre;
  final int precioReferencia;
  final String oficio;
  final String? detalle;
}

/// Una foto de un trabajo terminado que el cliente permitió publicar.
final class FotoDeTrabajo {
  const FotoDeTrabajo({required this.id, required this.url});

  final String id;
  final String url;
}

final class PaginaFotos {
  const PaginaFotos(this.fotos, this.siguiente);

  final List<FotoDeTrabajo> fotos;

  /// Cursor opaco o `null`.
  final String? siguiente;
}

/// Falla con un `Failure` de `core/errores`: 401 `NoAutorizadoFailure`, 404
/// `NoEncontradoFailure`, 422 `DatosRechazadosFailure`.
abstract interface class PerfilPublicoRepository {
  Future<PerfilPublico> perfil(String id);

  Future<List<ServicioPublico>> servicios(String id);

  Future<PaginaFotos> fotos(String id, {String? cursor});

  /// Si atiende la colonia [coloniaId].
  Future<bool> llegaAColonia(String id, String coloniaId);
}
