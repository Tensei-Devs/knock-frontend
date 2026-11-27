/// Respuestas del asistente (spec 042; backend 052). Solo los campos del
/// contrato. `deIa` es falso cuando `origen` dice que salió de la plantilla del
/// servidor: la app no la presenta como IA.
class TurnoAsistente {
  const TurnoAsistente({
    required this.categoria,
    required this.mensaje,
    required this.pideFoto,
    required this.seguridad,
    required this.deIa,
  });

  final String categoria;
  final String mensaje;
  final bool pideFoto;
  final String? seguridad;
  final bool deIa;
}

class ResumenChat {
  const ResumenChat({
    required this.sabe,
    required this.porConfirmar,
    required this.queLlevar,
    required this.deIa,
  });

  final List<String> sabe;
  final List<String> porConfirmar;
  final List<String> queLlevar;
  final bool deIa;

  bool get vacio => sabe.isEmpty && porConfirmar.isEmpty && queLlevar.isEmpty;
}

class BorradorCotizacionIa {
  const BorradorCotizacionIa({
    required this.precioSugerido,
    required this.tiempoEstimado,
    required this.dia,
    required this.nota,
    required this.explicacion,
    required this.deIa,
  });

  final num precioSugerido;
  final String tiempoEstimado;
  final String dia;
  final String nota;
  final String explicacion;
  final bool deIa;
}

class RangoPrecio {
  const RangoPrecio({
    required this.minimo,
    required this.maximo,
    required this.muestras,
    required this.fuente,
    this.copiaDel,
  });

  final num minimo;
  final num maximo;
  final int muestras;
  final String fuente;

  /// Fecha de la copia guardada cuando no hubo conexión (CA-13).
  final DateTime? copiaDel;
}

class Bitacora {
  const Bitacora({
    required this.sabe,
    required this.porConfirmar,
    required this.queLlevar,
    this.actualizadaEn,
  });

  final List<String> sabe;
  final List<String> porConfirmar;
  final List<String> queLlevar;
  final DateTime? actualizadaEn;
}

abstract interface class AsistenteRepository {
  Future<TurnoAsistente> turno(String mensaje);

  Future<ResumenChat> resumir(String conversacionId);

  Future<BorradorCotizacionIa> borrador(String conversacionId);

  /// `null` si no hay referencia para ese oficio y tipo de trabajo.
  Future<RangoPrecio?> rango(String oficio, String tipoTrabajo);

  /// `null` si aún no hay bitácora (404 `log_not_found`).
  Future<Bitacora?> bitacora(String solicitudId);

  Future<Bitacora> guardarBitacora(String solicitudId, Bitacora bitacora);
}
