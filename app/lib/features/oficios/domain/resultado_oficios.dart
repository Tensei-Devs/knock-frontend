import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/domain/oficios_repository.dart';

/// Oficios más una marca de frescura (spec 010, R-03).
final class ResultadoOficios {
  const ResultadoOficios(this.oficios, {this.sinConexion = false});

  final List<Oficio> oficios;

  /// `true` si se muestran datos guardados porque no se pudo consultar.
  final bool sinConexion;
}

/// Repositorio que muestra primero lo guardado y luego lo nuevo (R-03).
abstract interface class OficiosRepositoryConCache
    implements OficiosRepository {
  /// Emite lo guardado (si hay) y después el resultado de consultar. Falla
  /// con un `Failure` solo si no hay nada que mostrar.
  Stream<ResultadoOficios> observar();
}
