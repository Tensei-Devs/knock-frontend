import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/opiniones/data/opiniones_repository_api.dart';
import 'package:app/features/opiniones/domain/opinion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opiniones (spec 041). La maqueta lo usa solo con sesión y API.
final opinionesRepositoryProvider = Provider<OpinionesRepository>(
  (ref) => OpinionesRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
