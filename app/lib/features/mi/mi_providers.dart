import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/mi/data/casa_y_auto_repository_api.dart';
import 'package:app/features/mi/data/casa_y_auto_repository_simulado.dart';
import 'package:app/features/mi/domain/casa_y_auto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repositorio de «Mi casa y mi auto» (spec 031). Con `KNOCK_API_URL` válida
/// usa el backend 041; sin ella, el SIMULADO solo fuera de `release`.
///
/// Se vuelve a crear al abrir o cerrar una sesión, para que lo de una cuenta no
/// pase a la siguiente (no hay copia local que borrar: §5).
final casaYAutoRepositoryProvider = Provider<CasaYAutoRepository>((ref) {
  ref.watch(sesionProvider.select((tokens) => tokens != null));
  if (!usaApiReal(ref)) return CasaYAutoRepositorySimulado();
  return CasaYAutoRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  );
});
