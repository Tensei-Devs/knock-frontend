/// El lado del técnico de la cotización (specs 046, 019 y 038). Dart puro.
///
/// Ningún modelo tiene dirección, nombre ni teléfono del cliente (046, CA-01).
library;

final class FotoParaCotizar {
  const FotoParaCotizar({required this.id, required this.url});

  final String id;

  /// Enlace temporal: no se guarda ni se registra (CA-10).
  final String url;
}

/// La solicitud como la ve el técnico que puede cotizarla.
final class SolicitudParaCotizar {
  const SolicitudParaCotizar({
    required this.id,
    required this.oficio,
    required this.colonia,
    required this.descripcion,
    required this.dia,
    required this.franja,
    required this.creadoEn,
    this.oficioClave = '',
    this.fotos = const [],
  });

  final String id;
  final String oficio;

  /// Clave del oficio, para pedir la referencia de mercado (spec 038).
  final String oficioClave;
  final String colonia;
  final String descripcion;
  final String dia;
  final String franja;
  final DateTime creadoEn;
  final List<FotoParaCotizar> fotos;
}

/// De dónde sale la referencia de mercado (spec 038, enmienda 2026-11-27).
enum OrigenReferencia { mercado, categoria, sinDatos }

/// Lo que cobran otros técnicos por trabajos parecidos, en pesos enteros. El
/// servidor no dice de cuántas cotizaciones sale y la app no lo muestra.
final class ReferenciaDeMercado {
  const ReferenciaDeMercado({
    required this.origen,
    this.p25,
    this.mediana,
    this.p75,
  });

  final OrigenReferencia origen;
  final int? p25;
  final int? mediana;
  final int? p75;

  /// «Usar este rango» solo con los dos extremos y un rango con amplitud.
  bool get tieneRango => p25 != null && p75 != null && p25! < p75!;
}

/// Una tarjeta de «Solicitudes nuevas» (spec 019).
final class SolicitudRecibida {
  const SolicitudRecibida({
    required this.solicitudId,
    required this.oficio,
    required this.colonia,
    required this.descripcion,
    required this.dia,
    required this.franja,
    required this.yaCotizo,
  });

  final String solicitudId;
  final String oficio;
  final String colonia;
  final String descripcion;
  final String dia;
  final String franja;
  final bool yaCotizo;
}

enum TipoPrecio { fijo, rango, visita }

/// Una cotización que ya envió el técnico (spec 038, y la respuesta del envío).
final class CotizacionPropia {
  const CotizacionPropia({
    required this.id,
    required this.solicitudId,
    required this.estado,
    required this.tipoPrecio,
    required this.tope,
    required this.dia,
    required this.hora,
    this.precio,
    this.precioMin,
    this.precioMax,
    this.requiereAprobacion,
  });

  final String id;
  final String solicitudId;
  final String estado;
  final String tipoPrecio;
  final int? precio;
  final int? precioMin;
  final int? precioMax;

  /// Lo calcula el servidor; la app solo lo muestra.
  final int tope;
  final String dia;
  final String hora;

  /// Solo viene al enviar.
  final bool? requiereAprobacion;
}

final class PaginaDeSolicitudes {
  const PaginaDeSolicitudes(this.items, this.siguiente);

  final List<SolicitudRecibida> items;
  final String? siguiente;
}

final class PaginaDeCotizaciones {
  const PaginaDeCotizaciones(this.items, this.siguiente);

  final List<CotizacionPropia> items;
  final String? siguiente;
}

/// Lo que se envía. La nota no existe mientras no haya moderación (046, §13).
final class CotizacionNueva {
  const CotizacionNueva({
    required this.tipo,
    required this.dia,
    required this.hora,
    this.precio,
    this.precioMin,
    this.precioMax,
  });

  final TipoPrecio tipo;
  final int? precio;
  final int? precioMin;
  final int? precioMax;

  /// `AAAA-MM-DD`.
  final String dia;

  /// `HH:mm`.
  final String hora;
}

const montoMinimo = 1;
const montoMaximo = 200000;

/// El precio de la visita que acepta el backend con su configuración por
/// omisión. El servidor lo vuelve a revisar.
const visitaMinima = 100;
const visitaMaxima = 250;

/// El monto escrito, o `null` si no es un entero de 1 a 200 000.
int? montoValido(String texto) {
  final limpio = texto.trim();
  if (!RegExp(r'^\d+$').hasMatch(limpio)) return null;
  final n = int.tryParse(limpio);
  return n == null || n < montoMinimo || n > montoMaximo ? null : n;
}

bool horaValida(String texto) =>
    RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(texto);

/// Los días que se pueden proponer: el [dia] de la solicitud (`AAAA-MM-DD`) y
/// los 7 siguientes, sin los anteriores a [hoy]. El servidor valida contra ese
/// mismo día. Un [dia] ilegible no ofrece ninguno.
List<String> diasParaCotizar(String dia, DateTime hoy) {
  final base = DateTime.tryParse(dia);
  if (base == null) return const [];
  final desde = DateTime.utc(hoy.year, hoy.month, hoy.day);
  return [
    for (var i = 0; i <= 7; i++)
      if (DateTime.utc(base.year, base.month, base.day + i) case final fecha
          when !fecha.isBefore(desde))
        fecha.toIso8601String().substring(0, 10),
  ];
}

enum CampoCotizacion { precio, precioMin, precioMax, dia, hora }

/// Lo escrito en el formulario, ya revisado.
final class RevisionDeCotizacion {
  const RevisionDeCotizacion(this.errores, [this.cotizacion]);

  final Set<CampoCotizacion> errores;
  final CotizacionNueva? cotizacion;
}

RevisionDeCotizacion revisarCotizacion({
  required TipoPrecio tipo,
  required String precio,
  required String precioMin,
  required String precioMax,
  required String? dia,
  required String hora,
}) {
  final rango = tipo == TipoPrecio.rango;
  var unico = rango ? null : montoValido(precio);
  if (tipo == TipoPrecio.visita &&
      unico != null &&
      (unico < visitaMinima || unico > visitaMaxima)) {
    unico = null;
  }
  final min = rango ? montoValido(precioMin) : null;
  final max = rango ? montoValido(precioMax) : null;
  final errores = <CampoCotizacion>{
    if (!rango && unico == null) CampoCotizacion.precio,
    if (rango && min == null) CampoCotizacion.precioMin,
    if (rango && (max == null || (min != null && min >= max)))
      CampoCotizacion.precioMax,
    if (dia == null) CampoCotizacion.dia,
    if (!horaValida(hora.trim())) CampoCotizacion.hora,
  };
  if (errores.isNotEmpty) return RevisionDeCotizacion(errores);
  return RevisionDeCotizacion(
    errores,
    CotizacionNueva(
      tipo: tipo,
      precio: unico,
      precioMin: min,
      precioMax: max,
      dia: dia!,
      hora: hora.trim(),
    ),
  );
}

enum ResultadoDescarte { descartada, noDisponible, noDescartable }

abstract interface class CotizarRepository {
  Future<PaginaDeSolicitudes> recibidas({String? cursor});

  Future<ResultadoDescarte> descartar(String solicitudId);

  Future<PaginaDeCotizaciones> enviadas({String? cursor});

  Future<SolicitudParaCotizar> solicitud(String id);

  Future<CotizacionPropia> enviar(String solicitudId, CotizacionNueva nueva);

  /// `GET /cotizaciones/referencia-mercado` (COT-03). [tipo] es el tipo de
  /// precio elegido en el formulario.
  Future<ReferenciaDeMercado> referenciaDeMercado({
    required String oficio,
    required TipoPrecio tipo,
  });
}
