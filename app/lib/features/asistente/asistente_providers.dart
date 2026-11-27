import 'package:app/core/cache/almacen_cache.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/asistente/data/asistente_repository_api.dart';
import 'package:app/features/asistente/domain/asistente.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Asistente de IA (spec 042). Solo se usa con el interruptor encendido.
final asistenteRepositoryProvider = Provider<AsistenteRepository>(
  (ref) => AsistenteRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
    cache: ref.watch(almacenCacheProvider),
  ),
);
