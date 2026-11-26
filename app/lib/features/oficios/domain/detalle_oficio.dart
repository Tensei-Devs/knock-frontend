/// Detalle de un oficio y pedido de uno nuevo (spec 035; backend 045).
library;

/// `GET /oficios/{clave}`, solo con lo que la app usa.
final class DetalleOficio {
  const DetalleOficio({required this.clave, required this.frasesSugeridas});

  final String clave;
  final List<String> frasesSugeridas;
}

/// Falla con un `Failure`; un oficio que no existe es `NoEncontradoFailure`.
abstract interface class DetalleOficioRepository {
  Future<DetalleOficio> detalle(String clave);

  /// `POST /oficios-pedidos`: el texto no se registra ni se guarda aquí.
  Future<void> pedirOficio(String texto);
}
