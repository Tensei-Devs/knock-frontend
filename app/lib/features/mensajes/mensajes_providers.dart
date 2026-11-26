import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/mensajes/data/conversaciones_repository_api.dart';
import 'package:app/features/mensajes/domain/conversaciones_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conversacionesRepositoryProvider = Provider<ConversacionesRepository>(
  (ref) => ConversacionesRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

final contadorConversacionesProvider = FutureProvider.autoDispose<int>((ref) {
  ref.watch(sesionProvider);
  return ref.watch(conversacionesRepositoryProvider).contador();
}, retry: (_, _) => null);
