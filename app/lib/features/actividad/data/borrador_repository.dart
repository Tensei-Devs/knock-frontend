import 'package:app/core/preferencias/almacen_borrador_solicitud.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';

/// Guarda y recupera el borrador de la solicitud (spec 015, R-07).
///
/// Delega la persistencia en [AlmacenBorradorSolicitud]. Las fotos del
/// borrador se copian al directorio privado en el siguiente corte
/// (`path_provider`); hoy se guardan sus rutas.
class BorradorRepository {
  const BorradorRepository(this._almacen);

  final AlmacenBorradorSolicitud _almacen;

  BorradorSolicitud? leer() =>
      BorradorSolicitud.desdeTexto(_almacen.leerBorrador());

  Future<void> guardar(BorradorSolicitud borrador) =>
      _almacen.guardarBorrador(borrador.comoTexto());

  /// Borra el borrador: al enviar, al descartar y al cerrar sesión.
  Future<void> descartar() => _almacen.borrarBorrador();
}
