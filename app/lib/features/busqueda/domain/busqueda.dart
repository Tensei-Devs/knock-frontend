/// Largo mínimo y máximo del texto de búsqueda, ya normalizado (spec 021).
const largoMinimoBusqueda = 2;
const largoMaximoBusqueda = 80;

/// Texto de búsqueda normalizado: sin espacios al inicio y al final y con los
/// espacios internos colapsados. `null` si no mide de 2 a 80 caracteres (el
/// servidor no se llama, CA-05 y CA-06). El texto no se guarda ni se registra.
String? normalizarConsulta(String texto) {
  final limpio = texto.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (limpio.length < largoMinimoBusqueda ||
      limpio.length > largoMaximoBusqueda) {
    return null;
  }
  return limpio;
}

/// Un oficio como lo devuelve la búsqueda (`clave` y `nombre`).
final class OficioBuscado {
  const OficioBuscado({required this.clave, required this.nombre});

  final String clave;
  final String nombre;
}

/// Cómo entendió el servidor el texto (R-04); la app no adivina el oficio.
enum EstadoInterpretacion {
  detectado('detectado'),
  ambiguo('ambiguo'),
  noEntendido('no_entendido'),
  elegido('elegido');

  const EstadoInterpretacion(this.valor);

  final String valor;

  static EstadoInterpretacion? desde(String? texto) {
    for (final e in values) {
      if (e.valor == texto) return e;
    }
    return null;
  }
}

final class InterpretacionBusqueda {
  const InterpretacionBusqueda({
    required this.estado,
    this.oficioDetectado,
    this.oficiosSugeridos = const [],
  });

  final EstadoInterpretacion estado;
  final OficioBuscado? oficioDetectado;
  final List<OficioBuscado> oficiosSugeridos;
}

/// Un experto del resultado. No tiene teléfono, contacto ni dirección porque
/// el contrato no los trae (CA-10).
final class ExpertoBuscado {
  const ExpertoBuscado({
    required this.id,
    required this.nombre,
    required this.oficios,
    required this.calificacion,
    required this.totalResenas,
    required this.verificado,
    required this.nivelVerificacion,
    required this.atiendeTuColonia,
    this.coloniaBase,
    this.distanciaKm,
    this.fotoUrl,
  });

  final String id;
  final String nombre;
  final List<OficioBuscado> oficios;
  final double calificacion;
  final int totalResenas;
  final bool verificado;
  final String nivelVerificacion;
  final String? coloniaBase;

  /// Distancia aproximada en kilómetros enteros.
  final int? distanciaKm;
  final bool atiendeTuColonia;
  final String? fotoUrl;
}

/// Una página de resultados; [siguiente] es el cursor opaco o `null`.
final class PaginaBusqueda {
  const PaginaBusqueda({
    required this.interpretacion,
    required this.items,
    this.siguiente,
  });

  final InterpretacionBusqueda interpretacion;
  final List<ExpertoBuscado> items;
  final String? siguiente;
}
