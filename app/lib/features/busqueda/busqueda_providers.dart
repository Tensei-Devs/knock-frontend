import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/busqueda/data/busqueda_repository_api.dart';
import 'package:app/features/busqueda/domain/busqueda_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Buscar un experto por texto (spec 021): solo capa de datos; la pantalla se
/// agrega con T-04.
final busquedaRepositoryProvider = Provider<BusquedaRepository>(
  (ref) => BusquedaRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
