/// Lo que el cliente decide sobre el precio de su visita (spec 039; backend
/// 049 y 063). Los modelos solo llevan lo que declara el contrato.
library;

/// `GET /visitas/{id}/cotizacion-final`.
final class CotizacionFinal {
  const CotizacionFinal({
    required this.precio,
    required this.descripcion,
    required this.estado,
    required this.venceEn,
  });

  final num precio;
  final String descripcion;

  /// `enviada`, `aprobada`, `rechazada` o `vencida`.
  final String estado;
  final DateTime venceEn;

  bool get porDecidir => estado == 'enviada';
}

/// Un elemento de `GET /visitas/{id}/ajustes-pendientes`.
final class AjusteDePrecio {
  const AjusteDePrecio({
    required this.id,
    required this.montoNuevo,
    required this.motivo,
    required this.venceEn,
  });

  final String id;
  final num montoNuevo;
  final String motivo;
  final DateTime venceEn;
}

/// La cotización final (`null` si no hay) y los ajustes por decidir.
final class PrecioDeVisita {
  const PrecioDeVisita({this.cotizacionFinal, this.ajustes = const []});

  final CotizacionFinal? cotizacionFinal;
  final List<AjusteDePrecio> ajustes;
}

/// Falla con un `Failure`; un 404 de una decisión es `NoEncontradoFailure` y
/// un 409, `ConflictoFailure`. Una decisión nunca se reintenta sola.
abstract interface class PrecioDeVisitaRepository {
  /// `null` si la visita no tiene cotización final (404 uniforme).
  Future<CotizacionFinal?> cotizacionFinal(String visitaId);

  Future<List<AjusteDePrecio>> ajustesPendientes(String visitaId);

  Future<void> decidirCotizacionFinal(String visitaId, {required bool aprueba});

  Future<void> decidirAjuste(String ajusteId, {required bool aprueba});
}
