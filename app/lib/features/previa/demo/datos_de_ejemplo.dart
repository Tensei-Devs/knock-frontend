/// Datos de ejemplo de la previa (spec 027, R-12 y R-17, decisión D-12).
///
/// Todo es inventado: nombres claramente ficticios («Muestra»), sin celular,
/// sin dirección y sin coordenadas reales (los pines son puntos del mundo
/// dibujado, no coordenadas geográficas). La previa los muestra siempre,
/// también en la tienda, con el rótulo fijo «Datos de ejemplo»: todavía no
/// existe el endpoint de expertos cercanos.
final class ExpertoDeEjemplo {
  const ExpertoDeEjemplo({
    required this.nombre,
    required this.claveOficio,
    required this.oficio,
    required this.calificacion,
    required this.distanciaKm,
    required this.x,
    required this.y,
  });

  final String nombre;

  /// Clave del oficio (`ele`, `mec`, `plo`): colorea el pin y lo filtra con
  /// los chips.
  final String claveOficio;
  final String oficio;
  final String calificacion;
  final double distanciaKm;

  /// Posición del pin en el mundo dibujado (ver `VistaMapa`); no es una
  /// coordenada geográfica.
  final double x;
  final double y;

  /// Iniciales para el avatar: primera letra del primer y del último nombre.
  String get iniciales {
    final partes = nombre.split(' ');
    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }
}

/// Colonia ficticia que muestra el panel.
const coloniaDeEjemplo = 'Colonia Muestra Centro';

/// Ordenados por distancia, como la lista de la maqueta.
const expertosDeEjemplo = <ExpertoDeEjemplo>[
  ExpertoDeEjemplo(
    nombre: 'Tania Muestra Cruz',
    claveOficio: 'plo',
    oficio: 'Plomería',
    calificacion: '4.9',
    distanciaKm: 0.9,
    x: 500,
    y: 665,
  ),
  ExpertoDeEjemplo(
    nombre: 'Elena Muestra Ríos',
    claveOficio: 'ele',
    oficio: 'Electricidad',
    calificacion: '4.8',
    distanciaKm: 1.2,
    x: 650,
    y: 650,
  ),
  ExpertoDeEjemplo(
    nombre: 'Taller Muestra Centro',
    claveOficio: 'mec',
    oficio: 'Mecánica',
    calificacion: '4.8',
    distanciaKm: 1.8,
    x: 705,
    y: 745,
  ),
  ExpertoDeEjemplo(
    nombre: 'Beto Muestra Lara',
    claveOficio: 'mec',
    oficio: 'Mecánica',
    calificacion: '4.6',
    distanciaKm: 2.4,
    x: 450,
    y: 770,
  ),
  ExpertoDeEjemplo(
    nombre: 'Lucía Muestra Soto',
    claveOficio: 'ele',
    oficio: 'Electricidad',
    calificacion: '4.7',
    distanciaKm: 3.0,
    x: 735,
    y: 835,
  ),
  ExpertoDeEjemplo(
    nombre: 'Omar Muestra Vega',
    claveOficio: 'plo',
    oficio: 'Plomería',
    calificacion: '4.5',
    distanciaKm: 3.6,
    x: 580,
    y: 825,
  ),
];
