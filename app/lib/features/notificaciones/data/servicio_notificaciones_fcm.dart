import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;

/// Lo que la app usa de Firebase Cloud Messaging (spec 012). Es la única pieza
/// que toca el paquete; el resto se prueba con una fuente falsa.
abstract interface class FuenteFcm {
  /// Identificador de este teléfono, o `null` si FCM no lo entrega.
  Future<String?> token();

  /// Invalida el identificador (FCM entregará uno nuevo después).
  Future<void> borrarToken();

  /// Cargas (`data`) de las notificaciones tocadas con la app en segundo plano.
  Stream<Map<String, Object?>> get abiertas;

  /// Carga de la notificación que abrió la app cerrada, si la hubo.
  Future<Map<String, Object?>?> inicial();

  /// Si la persona permite las notificaciones.
  Future<EstadoPermiso> permiso();

  /// Muestra el diálogo del sistema (iOS y Android 13 o más).
  Future<EstadoPermiso> pedirPermiso();

  /// Abre los ajustes de la app para cambiar el permiso.
  Future<void> abrirAjustes();
}

/// [FuenteFcm] sobre `FirebaseMessaging.instance`. Solo se crea con el
/// interruptor encendido y Firebase iniciado.
class FuenteFcmFirebase implements FuenteFcm {
  FuenteFcmFirebase([FirebaseMessaging? mensajeria])
    : _mensajeria = mensajeria ?? FirebaseMessaging.instance;

  final FirebaseMessaging _mensajeria;

  /// El backend envía al token de registro de FCM (HTTP v1 `message.token`),
  /// no al FID de `register()`; por eso se usa `getToken` (EXC-006).
  @override
  // ignore: deprecated_member_use -- EXC-006
  Future<String?> token() => _mensajeria.getToken();

  @override
  // ignore: deprecated_member_use -- EXC-006
  Future<void> borrarToken() => _mensajeria.deleteToken();

  @override
  Stream<Map<String, Object?>> get abiertas => FirebaseMessaging
      .onMessageOpenedApp
      .map((m) => Map<String, Object?>.of(m.data));

  @override
  Future<Map<String, Object?>?> inicial() async {
    final mensaje = await _mensajeria.getInitialMessage();
    return mensaje == null ? null : Map<String, Object?>.of(mensaje.data);
  }

  @override
  Future<EstadoPermiso> permiso() async => estadoDePermisoFcm(
    (await _mensajeria.getNotificationSettings()).authorizationStatus,
  );

  @override
  Future<EstadoPermiso> pedirPermiso() async => estadoDePermisoFcm(
    (await _mensajeria.requestPermission()).authorizationStatus,
  );

  /// FCM no abre los ajustes; `geolocator` (ya en la app) sí, en Android e iOS.
  @override
  Future<void> abrirAjustes() async {
    await Geolocator.openAppSettings();
  }
}

/// Traduce el estado de FCM al de la app.
///
/// Un permiso negado ya no muestra el diálogo del sistema (iOS siempre; Android
/// tras negarlo), así que se trata como «solo se cambia en Ajustes».
EstadoPermiso estadoDePermisoFcm(AuthorizationStatus estado) =>
    switch (estado) {
      AuthorizationStatus.authorized ||
      AuthorizationStatus.provisional => EstadoPermiso.concedido,
      AuthorizationStatus.denied || AuthorizationStatus.deniedPermanently =>
        EstadoPermiso.denegadoParaSiempre,
      AuthorizationStatus.notDetermined => EstadoPermiso.sinPedir,
    };

/// [ServicioNotificaciones] sobre FCM (spec 012, R-01 y R-02).
///
/// Un fallo de FCM al pedir el identificador no rompe el inicio de sesión:
/// devuelve `null` y el registro queda «sin identificador».
class ServicioNotificacionesFcm implements ServicioNotificaciones {
  const ServicioNotificacionesFcm(this._fuente);

  final FuenteFcm _fuente;

  @override
  Future<String?> obtenerIdentificador() async {
    try {
      final token = await _fuente.token();
      return token == null || token.isEmpty ? null : token;
    } on Object {
      return null;
    }
  }

  @override
  Future<void> borrarIdentificador() => _fuente.borrarToken();

  @override
  Stream<Map<String, Object?>> get toques => _fuente.abiertas;

  @override
  Future<Map<String, Object?>?> toqueInicial() => _fuente.inicial();
}

/// [GestorPermisos] con el permiso de notificaciones de FCM. Los demás
/// permisos siguen con [otros] (la ubicación la maneja su propio repositorio).
class GestorPermisosFcm implements GestorPermisos {
  const GestorPermisosFcm(
    this._fuente, {
    this.otros = const GestorPermisosNoDisponible(),
  });

  final FuenteFcm _fuente;

  /// Gestor de los permisos que no son de notificaciones.
  final GestorPermisos otros;

  @override
  Future<EstadoPermiso> estado(PermisoApp permiso) =>
      permiso == PermisoApp.notificaciones
      ? _fuente.permiso()
      : otros.estado(permiso);

  @override
  Future<EstadoPermiso> pedir(PermisoApp permiso) =>
      permiso == PermisoApp.notificaciones
      ? _fuente.pedirPermiso()
      : otros.pedir(permiso);

  @override
  Future<void> abrirAjustes() => _fuente.abrirAjustes();
}
