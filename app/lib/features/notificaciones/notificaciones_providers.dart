import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:app/core/notificaciones/registro_dispositivos_provider.dart';
import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/notificaciones/data/registro_dispositivos_api.dart';
import 'package:app/features/notificaciones/data/servicio_notificaciones_fcm.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

/// FCM de esta ejecución. Las pruebas lo sustituyen por una fuente falsa.
final fuenteFcmProvider = Provider<FuenteFcm>((ref) => FuenteFcmFirebase());

/// Registro del dispositivo con el contrato real si hay `KNOCK_API_URL`
/// válida; sin ella, el SIMULADO (solo fuera de `release`: `main.dart` ya
/// rechaza un `release` sin URL, spec 026 R-10).
RegistroDispositivosRepository registroDispositivosReal(Ref ref) {
  if (!usaApiReal(ref)) return RegistroDispositivosSimulado();
  return RegistroDispositivosApi(
    transporte: ref.watch(transporteApiProvider),
    url: ref.watch(urlApiProvider),
    plataforma: defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
  );
}

/// Sustituciones de la raíz de composición para las notificaciones
/// (spec 012, KNOCK-60).
///
/// El registro usa siempre el repositorio real. FCM (identificador, toques y
/// permiso) solo entra con el interruptor [pushActivo] encendido y Firebase
/// iniciado; si no, la app sigue sin notificaciones, como hasta ahora.
List<Override> overridesDeNotificaciones({
  required bool pushActivo,
  required bool firebaseListo,
}) => [
  registroDispositivosRepositoryProvider.overrideWith(registroDispositivosReal),
  if (pushActivo && firebaseListo) ...[
    servicioNotificacionesProvider.overrideWith(
      (ref) => ServicioNotificacionesFcm(ref.watch(fuenteFcmProvider)),
    ),
    gestorPermisosProvider.overrideWith(
      (ref) => GestorPermisosFcm(ref.watch(fuenteFcmProvider)),
    ),
  ],
];
