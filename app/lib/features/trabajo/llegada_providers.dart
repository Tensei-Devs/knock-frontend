import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/trabajo/data/llegada_repository_api.dart';
import 'package:app/features/trabajo/domain/llegada.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Llegada del técnico (spec 016). La maqueta lo usa solo con sesión y API.
final llegadaRepositoryProvider = Provider<LlegadaRepository>(
  (ref) => LlegadaRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
