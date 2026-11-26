import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/verificacion/data/verificacion_repository_api.dart';
import 'package:app/features/verificacion/domain/verificacion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Verificación de identidad (spec 018). La maqueta lo usa solo con sesión y
/// API.
final verificacionRepositoryProvider = Provider<VerificacionRepository>(
  (ref) => VerificacionRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);
