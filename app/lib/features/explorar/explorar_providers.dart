import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/explorar/data/explorar_repository_api.dart';
import 'package:app/features/explorar/data/explorar_repository_simulado.dart';
import 'package:app/features/explorar/domain/explorar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repositorio de Explorar (spec 036, TEC-14). Con `KNOCK_API_URL` válida usa
/// el backend 046; sin ella, el SIMULADO solo fuera de `release`. Se vuelve a
/// crear al abrir o cerrar sesión: con sesión llegan más bloques.
final explorarRepositoryProvider = Provider<ExplorarRepository>((ref) {
  ref.watch(sesionProvider.select((tokens) => tokens != null));
  if (!usaApiReal(ref)) return const ExplorarRepositorySimulado();
  return ExplorarRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  );
});
