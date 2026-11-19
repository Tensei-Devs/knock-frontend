import 'package:app/features/inicio/domain/ubicacion_repository.dart';

/// Pide la ubicación una vez, con un aviso previo si el permiso aún falta
/// (spec 012, R-06 y R-07).
///
/// [explicar] muestra para qué se usa la ubicación y devuelve `true` si la
/// persona sigue. Con «Ahora no» no se llega a la petición del sistema y el
/// resultado es [Denegada]: quien llama ofrece la alternativa (el código
/// postal). Si el permiso ya estaba concedido no se repite el aviso.
Future<ResultadoUbicacion> ubicarConAviso(
  UbicacionRepository repositorio,
  Future<bool> Function() explicar,
) async {
  if (!await repositorio.permisoConcedido() && !await explicar()) {
    return const Denegada();
  }
  return repositorio.obtenerUnaVez();
}

/// Lee la ubicación solo si el permiso ya se concedió; nunca lo pide.
///
/// Para lo que ocurre sin que la persona toque nada (por ejemplo, centrar el
/// mapa al crearse): un permiso no se pide sin aviso previo (R-06).
Future<ResultadoUbicacion> ubicarSiHayPermiso(
  UbicacionRepository repositorio,
) async {
  if (!await repositorio.permisoConcedido()) return const Denegada();
  return repositorio.obtenerUnaVez();
}
