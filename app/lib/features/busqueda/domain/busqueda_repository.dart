import 'package:app/features/busqueda/domain/busqueda.dart';

/// Buscar un experto por texto (spec 021, `GET /busqueda`). Falla con un
/// `Failure` de `core/errores`: 401 `NoAutorizadoFailure`; 400 (con cursor:
/// `invalid_cursor`, hay que reiniciar desde la primera página) y 422 sin
/// `colonia_not_found` `DatosRechazadosFailure`; 422 `colonia_not_found`
/// `OpcionNoDisponibleFailure` (pedir la zona otra vez); 429
/// `DemasiadosIntentosFailure`; 503 y otros 5xx [BusquedaNoDisponible]; sin
/// conexión `ServicioNoDisponibleFailure`.
abstract interface class BusquedaRepository {
  /// [consulta] ya normalizada con `normalizarConsulta`; si no es válida no
  /// sale a la red. Nada de lo buscado se guarda en disco ni en caché (R-05).
  Future<PaginaBusqueda> buscar({
    required String consulta,
    required String coloniaId,
    String? oficio,
    bool soloVerificados = false,
    String? cursor,
    int limite = 20,
  });

  /// `GET /tecnicos/autocompletar` con [consulta] ya normalizada.
  Future<List<SugerenciaBusqueda>> sugerencias(String consulta);
}
