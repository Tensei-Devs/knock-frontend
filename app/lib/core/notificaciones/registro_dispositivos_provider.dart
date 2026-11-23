import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:app/core/notificaciones/registro_dispositivos_api.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repositorio del registro (raíz de composición). Con `KNOCK_API_URL` válida
/// usa el contrato real; sin ella, el SIMULADO solo fuera de `release` (en
/// `release` falla con `ApiNoConfiguradaFailure`, spec 026 R-10).
final registroDispositivosRepositoryProvider =
    Provider<RegistroDispositivosRepository>((ref) {
      if (!usaApiReal(ref)) return RegistroDispositivosSimulado();
      return RegistroDispositivosApi(
        transporte: ref.watch(transporteApiProvider),
        url: ref.watch(urlApiProvider),
        plataforma: defaultTargetPlatform == TargetPlatform.iOS
            ? 'ios'
            : 'android',
      );
    });
