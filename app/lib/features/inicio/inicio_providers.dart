import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/inicio/data/colonias_repository_http.dart';
import 'package:app/features/inicio/data/colonias_repository_simulado.dart';
import 'package:app/features/inicio/data/ubicacion_geolocator_repository.dart';
import 'package:app/features/inicio/domain/colonias_repository.dart';
import 'package:app/features/inicio/domain/ubicacion_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repositorio de ubicación de la app (raíz de composición: es lo único que
/// junta `data/` con el resto, para que `presentation/` no importe `data/`).
/// Las pruebas lo reemplazan por uno falso.
final ubicacionRepositoryProvider = Provider<UbicacionRepository>(
  (ref) => UbicacionGeolocatorRepository(),
);

/// Raíz de composición de la colonia: API real con `KNOCK_API_URL` válida
/// (por el transporte con sesión: la ruta pide Bearer); sin ella, respuesta
/// SIMULADA solo fuera de `release` (spec 026, R-10).
final coloniasRepositoryProvider = Provider<ColoniasRepository>((ref) {
  if (!usaApiReal(ref)) return const ColoniasRepositorySimulado();
  return ColoniasRepositoryHttp(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  );
});
