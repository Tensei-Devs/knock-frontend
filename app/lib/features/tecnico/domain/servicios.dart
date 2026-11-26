// Servicios y precios de referencia de un técnico (spec 037, SRV-01 a SRV-04;
// backend 047). El precio solo orienta: no es una cotización.

/// Un servicio, solo con lo que declara el contrato.
final class ServicioTecnico {
  const ServicioTecnico({
    required this.id,
    required this.nombre,
    required this.precioReferencia,
    required this.oficio,
    this.detalle,
  });

  final String id;
  final String nombre;
  final String? detalle;

  /// Pesos enteros.
  final int precioReferencia;

  /// Clave del catálogo de oficios.
  final String oficio;
}

/// Lo que la persona escribe para agregar o editar un servicio.
final class DatosDeServicio {
  const DatosDeServicio({
    required this.nombre,
    required this.precioReferencia,
    required this.oficio,
    this.detalle = '',
  });

  static const maxNombre = 60;
  static const maxDetalle = 150;

  /// El tope es el del entero de 32 bits del contrato.
  static const maxPrecio = 2147483647;

  final String nombre;
  final String detalle;
  final int precioReferencia;
  final String oficio;
}

/// Por qué el servidor no aceptó el cambio, según su código.
enum RechazoDeServicio {
  /// 404 `not_a_technician`: la cuenta no tiene perfil de técnico.
  sinPerfilDeTecnico,

  /// 404 `service_not_found`.
  noExiste,

  /// 409 `service_limit_reached`.
  limite,

  /// 422 `trade_invalid`: el oficio no es uno de los del técnico.
  oficioNoValido,
}

/// El servicio guardado, o el motivo por el que no se guardó.
typedef ServicioGuardado = ({
  ServicioTecnico? servicio,
  RechazoDeServicio? rechazo,
});

/// Cualquier otro error llega como `Failure`.
abstract interface class ServiciosRepository {
  /// Falla con `NoEncontradoFailure` si el técnico no existe o está oculto.
  Future<List<ServicioTecnico>> deTecnico(String tecnicoId);

  Future<ServicioGuardado> agregar(DatosDeServicio datos);

  Future<ServicioGuardado> editar(String id, DatosDeServicio datos);

  /// `null` si se quitó.
  Future<RechazoDeServicio?> quitar(String id);
}
