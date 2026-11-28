import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/mensajes/data/canal_mensajes_signalr.dart';
import 'package:app/features/mensajes/data/conversaciones_repository_api.dart';
import 'package:app/features/mensajes/domain/canal_mensajes.dart';
import 'package:app/features/mensajes/domain/conversaciones_repository.dart';
import 'package:app/features/mensajes/domain/envio_de_mensajes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conversacionesRepositoryProvider = Provider<ConversacionesRepository>(
  (ref) => ConversacionesRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

/// Envío de mensajes por REST; el hub en vivo solo recibe (spec 020,
/// enmienda 2026-11-26).
final envioDeMensajesProvider = Provider<EnvioDeMensajes>(
  (ref) => ConversacionesRepositoryApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
  ),
);

final canalMensajesProvider = Provider<CanalMensajes>(
  (ref) => CanalMensajesSignalR(
    url: ref.watch(urlApiProvider),
    token: () => ref.read(sesionProvider)?.accessToken,
  ),
);
