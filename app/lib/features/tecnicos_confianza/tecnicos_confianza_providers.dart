import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/tecnicos_confianza/data/tecnicos_confianza_repository_api.dart';
import 'package:app/features/tecnicos_confianza/domain/tecnicos_confianza_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Técnicos de confianza (spec 032). La maqueta lo usa solo con sesión y API.
final tecnicosConfianzaRepositoryProvider =
    Provider<TecnicosConfianzaRepository>(
      (ref) => TecnicosConfianzaRepositoryApi(
        transporte: ref.watch(transporteApiProvider),
        url: ref.watch(urlApiProvider),
      ),
    );
