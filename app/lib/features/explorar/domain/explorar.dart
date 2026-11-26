/// Filtro de la pestaña Explorar (backend 046, R-49): `todo`, `auto`, `agua` o
/// `luz`, que el servidor traduce a los oficios `mec`, `plo` y `ele`.
enum FiltroExplorar {
  todo('todo', null),
  auto('auto', 'mec'),
  agua('agua', 'plo'),
  luz('luz', 'ele');

  const FiltroExplorar(this.clave, this.oficio);

  /// Valor del parámetro `filtro`.
  final String clave;

  /// Clave del oficio del catálogo que representa (`null` en [todo]).
  final String? oficio;

  /// El filtro de un oficio del catálogo; [todo] si no es uno de los tres.
  static FiltroExplorar deOficio(String? oficio) => values.firstWhere(
    (f) => f.oficio != null && f.oficio == oficio,
    orElse: () => todo,
  );
}

/// Oficio con cuántos técnicos visibles lo ofrecen.
final class ServicioPopular {
  const ServicioPopular({
    required this.clave,
    required this.nombre,
    required this.tecnicos,
  });

  final String clave;
  final String nombre;
  final int tecnicos;
}

/// Oficio sugerido que todavía no está entre los populares.
final class IdeaExplorar {
  const IdeaExplorar({required this.clave, required this.nombre});

  final String clave;
  final String nombre;
}

/// Resumen público de un técnico: nunca trae teléfono, dirección ni ubicación.
final class TecnicoDestacado {
  const TecnicoDestacado({
    required this.id,
    required this.nombre,
    required this.verificacion,
    required this.oficios,
    this.nombreNegocio,
    this.fotoUrl,
    this.calificacion,
    this.anios,
    this.descripcionCorta,
  });

  final String id;
  final String nombre;
  final String? nombreNegocio;
  final String? fotoUrl;

  /// `ninguno`, `basica` o `completa` (spec 025).
  final String verificacion;

  /// Promedio con un decimal; `null` si aún no tiene calificaciones.
  final double? calificacion;
  final int? anios;
  final String? descripcionCorta;
  final List<String> oficios;

  bool get verificado => verificacion != 'ninguno';

  /// Lo que se muestra como título: el negocio si lo tiene.
  String get titulo => nombreNegocio ?? nombre;
}

/// Foto de un trabajo terminado que el cliente permitió publicar.
final class FotoTrabajo {
  const FotoTrabajo({
    required this.id,
    required this.url,
    required this.creadoEn,
  });

  final String id;
  final String url;
  final DateTime creadoEn;
}

/// Los bloques de Explorar, de hasta 10 elementos cada uno. Sin sesión,
/// [trabajosReales] y [cercaDeTi] llegan en `null`.
final class Explorar {
  const Explorar({
    required this.filtro,
    required this.serviciosPopulares,
    required this.mejorCalificados,
    required this.ideas,
    this.trabajosReales,
    this.cercaDeTi,
  });

  final FiltroExplorar filtro;
  final List<ServicioPopular> serviciosPopulares;
  final List<TecnicoDestacado> mejorCalificados;
  final List<IdeaExplorar> ideas;
  final List<FotoTrabajo>? trabajosReales;
  final List<TecnicoDestacado>? cercaDeTi;

  /// Ningún bloque trae algo que mostrar.
  bool get vacio =>
      serviciosPopulares.isEmpty &&
      mejorCalificados.isEmpty &&
      ideas.isEmpty &&
      (trabajosReales?.isEmpty ?? true) &&
      (cercaDeTi?.isEmpty ?? true);
}

/// Contrato de `GET /api/v1/explorar` (TEC-14).
abstract interface class ExplorarRepository {
  Future<Explorar> cargar(FiltroExplorar filtro);
}
