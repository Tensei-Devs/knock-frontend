/// Datos de ejemplo del modo demostración (spec 027, R-12 y R-17).
///
/// Todo es inventado: nombres ficticios, sin celular, sin dirección y sin
/// coordenadas reales (los pines son fracciones del lienzo dibujado). Este
/// archivo solo se importa desde el panel de demostración, que se alcanza
/// detrás de `if (demoDatosActivo)`: en `release` el compilador lo elimina y
/// `scripts/verificar_release_sin_demo.py` lo comprueba sobre el binario.
final class ExpertoDeEjemplo {
  const ExpertoDeEjemplo({
    required this.nombre,
    required this.oficio,
    required this.calificacion,
    required this.x,
    required this.y,
  });

  final String nombre;
  final String oficio;
  final String calificacion;

  /// Posición del pin como fracción del lienzo (0 a 1); no es una coordenada.
  final double x;
  final double y;
}

/// Colonia ficticia que muestra el panel.
const coloniaDeEjemplo = 'Colonia Muestra Centro';

const expertosDeEjemplo = <ExpertoDeEjemplo>[
  ExpertoDeEjemplo(
    nombre: 'Elena Muestra Ríos',
    oficio: 'Electricidad',
    calificacion: '4.8',
    x: 0.28,
    y: 0.34,
  ),
  ExpertoDeEjemplo(
    nombre: 'Beto Muestra Lara',
    oficio: 'Mecánica',
    calificacion: '4.6',
    x: 0.62,
    y: 0.58,
  ),
  ExpertoDeEjemplo(
    nombre: 'Tania Muestra Cruz',
    oficio: 'Plomería',
    calificacion: '4.9',
    x: 0.48,
    y: 0.22,
  ),
];
