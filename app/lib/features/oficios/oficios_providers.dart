import 'package:app/core/cache/revalidador_etag.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/features/oficios/data/oficios_repository_api.dart';
import 'package:app/features/oficios/data/oficios_repository_de_prueba.dart';
import 'package:app/features/oficios/domain/oficios_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repositorio de oficios de la feature (raíz de composición: es lo único que
/// junta `data/` con el resto, para que `presentation/` no importe `data/`).
///
/// Con `KNOCK_API_URL` válida usa `GET /api/v1/oficios` con caché y `ETag`
/// (spec 010); sin ella, los datos de prueba del contrato de TT-PRU-01.
final oficiosRepositoryProvider = Provider<OficiosRepository>((ref) {
  final base = normalizarUrlApi(ref.watch(urlApiProvider));
  if (base == null) return const OficiosRepositoryDePrueba();
  return OficiosRepositoryApi(
    revalidador: ref.watch(revalidadorEtagProvider),
    url: Uri.parse('$base/api/v$versionApi/oficios'),
  );
});
