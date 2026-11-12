/// Reglas puras de la solicitud (spec 015, R-02 a R-05). Sin Flutter ni red.

const longitudMinimaDescripcion = 8;
const longitudMaximaDescripcion = 500;
const longitudMinimaDireccion = 8;
const longitudMaximaDireccion = 200;
const maximoDeFotos = 5;
const diasHaciaAdelante = 5;

enum ErrorDescripcion { corta, larga }

enum ErrorDireccion { corta, larga }

enum ErrorFotos { falta, maximo }

/// Valida la descripción (R-02): de 8 a 500 caracteres, sin contar los
/// espacios de los extremos. `null` si es válida.
ErrorDescripcion? validarDescripcion(String texto) {
  final largo = texto.trim().length;
  if (largo < longitudMinimaDescripcion) return ErrorDescripcion.corta;
  if (largo > longitudMaximaDescripcion) return ErrorDescripcion.larga;
  return null;
}

/// Valida la dirección del domicilio (R-05): de 8 a 200 caracteres.
ErrorDireccion? validarDireccion(String texto) {
  final largo = texto.trim().length;
  if (largo < longitudMinimaDireccion) return ErrorDireccion.corta;
  if (largo > longitudMaximaDireccion) return ErrorDireccion.larga;
  return null;
}

/// Valida cuántas fotos lleva la solicitud (R-03): de 1 a 5.
ErrorFotos? validarCantidadDeFotos(int cantidad) {
  if (cantidad < 1) return ErrorFotos.falta;
  if (cantidad > maximoDeFotos) return ErrorFotos.maximo;
  return null;
}

/// Si todavía cabe otra foto.
bool puedeAgregarFoto(int cantidadActual) => cantidadActual < maximoDeFotos;

DateTime _soloDia(DateTime fecha) =>
    DateTime(fecha.year, fecha.month, fecha.day);

/// Los seis días que se ofrecen: hoy y los cinco siguientes (R-04).
List<DateTime> diasDisponibles(DateTime hoy) {
  final inicio = _soloDia(hoy);
  return [
    for (var i = 0; i <= diasHaciaAdelante; i++)
      DateTime(inicio.year, inicio.month, inicio.day + i),
  ];
}

/// Si [dia] está entre hoy y hoy más 5 días (R-04).
bool diaPermitido(DateTime dia, DateTime hoy) {
  final elegido = _soloDia(dia);
  final disponibles = diasDisponibles(hoy);
  return !elegido.isBefore(disponibles.first) &&
      !elegido.isAfter(disponibles.last);
}

/// El día como lo pide el contrato: `AAAA-MM-DD`.
String diaParaContrato(DateTime dia) {
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${dia.year.toString().padLeft(4, '0')}-${dos(dia.month)}-${dos(dia.day)}';
}
