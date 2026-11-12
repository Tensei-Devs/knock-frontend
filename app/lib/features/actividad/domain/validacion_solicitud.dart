/// Reglas puras del formulario «Pedir cotización» (spec 015, R-02 a R-05).
///
/// No dependen de Flutter ni de la red: la pantalla las usa para mostrar el
/// error en línea y el controlador para no enviar una solicitud incompleta.
library;

/// Largo mínimo y máximo de la descripción (R-02, backend 020).
const minimoDescripcion = 8;
const maximoDescripcion = 500;

/// Largo mínimo y máximo de la dirección a domicilio (R-05, backend 020 R-06).
const minimoDireccion = 8;
const maximoDireccion = 200;

/// Número mínimo y máximo de fotos por solicitud (R-03).
const minimoFotos = 1;
const maximoFotos = 5;

/// Días que se ofrecen después de hoy (R-04: de hoy a hoy + 5, seis días).
const diasHaciaAdelante = 5;

/// Por qué un texto no es válido.
enum ErrorDeLargo { corto, largo }

/// Por qué la lista de fotos no es válida.
enum ErrorDeFotos { faltan, sobran }

/// Largo de un texto contado en caracteres que ve la persona (puntos de código),
/// sin los espacios de los extremos.
int largoVisible(String texto) => texto.trim().runes.length;

ErrorDeLargo? _validarLargo(String texto, int minimo, int maximo) {
  final largo = largoVisible(texto);
  if (largo < minimo) return ErrorDeLargo.corto;
  if (largo > maximo) return ErrorDeLargo.largo;
  return null;
}

/// `null` si la descripción mide de 8 a 500 caracteres (CA-02).
ErrorDeLargo? validarDescripcion(String descripcion) =>
    _validarLargo(descripcion, minimoDescripcion, maximoDescripcion);

/// `null` si la dirección mide de 8 a 200 caracteres (CA-17).
ErrorDeLargo? validarDireccion(String direccion) =>
    _validarLargo(direccion, minimoDireccion, maximoDireccion);

/// `null` si hay de 1 a 5 fotos (CA-03).
ErrorDeFotos? validarCantidadDeFotos(int cantidad) {
  if (cantidad < minimoFotos) return ErrorDeFotos.faltan;
  if (cantidad > maximoFotos) return ErrorDeFotos.sobran;
  return null;
}

/// Si todavía cabe otra foto.
bool puedeAgregarFoto(int cantidadActual) => cantidadActual < maximoFotos;

/// La fecha de calendario de [momento], sin hora.
DateTime soloFecha(DateTime momento) =>
    DateTime(momento.year, momento.month, momento.day);

/// Los seis días que se ofrecen: de [hoy] a [hoy] + 5 (CA-04).
///
/// [hoy] es la fecha de la persona en `America/Mexico_City`; la calcula quien
/// llama, para que esta función no dependa del reloj.
List<DateTime> diasPermitidos(DateTime hoy) {
  final inicio = soloFecha(hoy);
  return [
    for (var i = 0; i <= diasHaciaAdelante; i++)
      DateTime(inicio.year, inicio.month, inicio.day + i),
  ];
}

/// Si [dia] está entre [hoy] y [hoy] + 5, ambos incluidos (CA-04).
bool esDiaPermitido(DateTime dia, DateTime hoy) =>
    diasPermitidos(hoy).contains(soloFecha(dia));

/// El día en el formato del contrato, `AAAA-MM-DD` (backend 020 R-05).
String diaDelContrato(DateTime dia) {
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${dia.year.toString().padLeft(4, '0')}-${dos(dia.month)}-${dos(dia.day)}';
}
