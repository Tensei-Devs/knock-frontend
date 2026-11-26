/// Tipos de elemento de «Mi casa y mi auto» (backend 041, R-14).
enum TipoElemento {
  auto('auto'),
  electrodomestico('electrodomestico'),
  instalacion('instalacion'),
  otro('otro');

  const TipoElemento(this.clave);

  /// Valor que viaja en el contrato.
  final String clave;

  static TipoElemento? deClave(String? clave) {
    for (final t in values) {
      if (t.clave == clave) return t;
    }
    return null;
  }
}

/// Un auto o una cosa de la casa (CAS-01 a CAS-04). Solo los campos que
/// declara el contrato (CA-01).
final class ElementoCasa {
  const ElementoCasa({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.creadoEn,
    this.anio,
  });

  final String id;
  final TipoElemento tipo;
  final String nombre;

  /// Solo los autos llevan año.
  final int? anio;
  final DateTime creadoEn;
}

/// Un trabajo terminado relacionado con el elemento (CAS-05).
final class TrabajoDelElemento {
  const TrabajoDelElemento({
    required this.fecha,
    required this.oficio,
    required this.tecnico,
  });

  final DateTime fecha;
  final String oficio;
  final String tecnico;
}

/// Una página del historial: [siguiente] es el cursor de la próxima, o `null`
/// si ya no hay más (CA-15).
final class PaginaHistorial {
  const PaginaHistorial({required this.trabajos, this.siguiente});

  final List<TrabajoDelElemento> trabajos;
  final String? siguiente;
}

/// Campo del formulario que no cumple las reglas del backend 041 (R-14).
enum CampoElemento { nombre, anio }

/// Reglas del formulario (backend 041, R-14), las mismas que valida el
/// servidor, para avisar antes de enviar.
abstract final class ReglasElemento {
  static const nombreMinimo = 2;
  static const nombreMaximo = 60;
  static const anioMinimo = 1950;

  /// Cada persona puede registrar hasta 20 elementos (R-15).
  static const maximoElementos = 20;

  /// El año más alto válido: el actual más uno.
  static int anioMaximo(DateTime hoy) => hoy.year + 1;

  /// Campo inválido, o `null` si se puede enviar. El año solo aplica a autos
  /// y es obligatorio para ellos.
  static CampoElemento? validar({
    required TipoElemento tipo,
    required String nombre,
    required int? anio,
    required DateTime hoy,
  }) {
    final largo = nombre.trim().length;
    if (largo < nombreMinimo || largo > nombreMaximo) {
      return CampoElemento.nombre;
    }
    if (tipo != TipoElemento.auto) {
      return anio == null ? null : CampoElemento.anio;
    }
    if (anio == null || anio < anioMinimo || anio > anioMaximo(hoy)) {
      return CampoElemento.anio;
    }
    return null;
  }
}

/// Acceso a `/me/casa-y-auto` (backend 041). La persona es siempre la de la
/// sesión: ninguna llamada lleva el identificador de otra.
abstract interface class CasaYAutoRepository {
  Future<List<ElementoCasa>> listar();

  Future<ElementoCasa> agregar({
    required TipoElemento tipo,
    required String nombre,
    int? anio,
  });

  Future<ElementoCasa> editar(
    String id, {
    required TipoElemento tipo,
    required String nombre,
    int? anio,
  });

  Future<void> quitar(String id);

  Future<PaginaHistorial> historial(String id, {String? cursor});
}
