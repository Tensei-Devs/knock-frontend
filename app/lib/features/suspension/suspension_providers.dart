import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/suspension/data/apelacion_suspension_repository_api.dart';
import 'package:app/features/suspension/domain/apelacion_suspension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sin la sesión de Knock: solo el transporte público de la app.
final apelacionSuspensionRepositoryProvider =
    Provider<ApelacionSuspensionRepository>(
      (ref) => ApelacionSuspensionRepositoryApi(
        transporte: ref.watch(transporteHttpProvider),
        url: ref.watch(urlApiProvider),
      ),
    );
