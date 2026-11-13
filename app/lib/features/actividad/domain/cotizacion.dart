/// Cotizaciones de una solicitud y su comparación (spec 015, §5, CA-07 a
/// CA-10; backend 021).
library;

/// Cómo cotizó el técnico (backend 020 R-13).
enum TipoPrecio {
  fijo('fijo'),
  rango('rango'),
  visita('visita');

  const TipoPrecio(this.valor);

  final String valor;

  static TipoPrecio? desdeTexto(String texto) {
    for (final tipo in values) {
      if (tipo.valor == texto) return tipo;
    }
    return null;
  }
}

/// Etiquetas que pone el servidor (backend 021 R-06). Una desconocida se
/// ignora.
enum EtiquetaCotizacion {
  verificado('verificado'),
  mejorPrecio('mejor_precio'),
  puedeIrMasPronto('puede_ir_mas_pronto');

  const EtiquetaCotizacion(this.valor);

  final String valor;

  static EtiquetaCotizacion? desdeTexto(String texto) {
    for (final etiqueta in values) {
      if (etiqueta.valor == texto) return etiqueta;
    }
    return null;
  }
}

/// Orden que se le pide al servidor (R-08). La app nunca reordena.
enum OrdenCotizaciones {
  recomendadas('recomendadas'),
  precio('precio'),
  calificacion('calificacion'),
  pronto('pronto');

  const OrdenCotizaciones(this.valor);

  /// Valor del parámetro `orden`.
  final String valor;
}

/// Por qué no se puede elegir (backend 021 R-08, con los códigos en inglés).
enum MotivoSinEleccion {
  sinCotizaciones('request_without_quotes'),
  vencida('request_expired'),
  cancelada('request_cancelled'),
  yaElegida('request_already_chosen');

  const MotivoSinEleccion(this.valor);

  final String valor;

  static MotivoSinEleccion? desdeTexto(String texto) {
    for (final motivo in values) {
      if (motivo.valor == texto) return motivo;
    }
    return null;
  }
}

/// Lo público del técnico antes de elegir: **sin** teléfono ni dirección
/// (R-09, CA-10).
final class TecnicoResumen {
  const TecnicoResumen({
    required this.id,
    required this.nombre,
    required this.verificado,
    this.fotoUrl,
    this.calificacion,
    this.nivelVerificacion,
  });

  final String id;
  final String nombre;
  final String? fotoUrl;

  /// De 1 a 5; `null` si aún no tiene calificaciones.
  final double? calificacion;
  final bool verificado;

  /// `basico` o `completo`, tal como lo manda el servidor.
  final String? nivelVerificacion;
}

/// Una cotización tal como se compara (backend 021 R-02).
final class Cotizacion {
  const Cotizacion({
    required this.id,
    required this.tipoPrecio,
    required this.tope,
    required this.requiereAprobacion,
    required this.dia,
    required this.hora,
    required this.cubre,
    required this.tecnico,
    this.precio,
    this.precioMin,
    this.precioMax,
    this.nota,
    this.etiquetas = const {},
  });

  final String id;
  final TipoPrecio tipoPrecio;

  /// Precio fijo o cuota de visita, en pesos.
  final int? precio;
  final int? precioMin;
  final int? precioMax;

  /// Lo más que se puede cobrar sin pedir aprobación (backend 020 R-14).
  final int tope;
  final bool requiereAprobacion;
  final DateTime dia;

  /// `HH:mm`.
  final String hora;
  final String? nota;

  /// Qué cubre el precio (texto del servidor, backend 021 R-07).
  final String cubre;
  final Set<EtiquetaCotizacion> etiquetas;
  final TecnicoResumen tecnico;
}

/// La comparación que devuelve el servidor, en su orden (R-08).
final class ResultadoComparacion {
  const ResultadoComparacion({
    required this.cotizaciones,
    required this.totalCotizaciones,
    required this.tiposMixtos,
    required this.puedeElegir,
    this.motivo,
    this.visitaId,
  });

  /// Como máximo 5, en el orden del servidor.
  final List<Cotizacion> cotizaciones;
  final int totalCotizaciones;
  final bool tiposMixtos;
  final bool puedeElegir;
  final MotivoSinEleccion? motivo;

  /// La visita, cuando ya se eligió (`request_already_chosen`).
  final String? visitaId;

  /// Cuántas no se muestran: «Te mostramos 5 de N» (CA-07).
  bool get hayMasDeLasMostradas => totalCotizaciones > cotizaciones.length;
}
