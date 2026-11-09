import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Puerto del servicio de notificaciones del teléfono (spec 012).
///
/// Lo implementará un adaptador sobre Firebase Cloud Messaging cuando el
/// proyecto tenga `google-services.json` (lo trae el inicio de sesión,
/// KNOCK-228). Hasta entonces nada de la app depende del paquete.
abstract interface class ServicioNotificaciones {
  /// Identificador de este teléfono para recibir notificaciones, o `null` si
  /// el servicio no está disponible.
  Future<String?> obtenerIdentificador();

  /// Invalida el identificador de este teléfono (cierre de sesión): el
  /// servicio entregará uno nuevo la próxima vez.
  Future<void> borrarIdentificador();

  /// Cargas (`data`) de las notificaciones que la persona toca con la app en
  /// segundo plano.
  Stream<Map<String, Object?>> get toques;

  /// Carga de la notificación que abrió la app cerrada, si la hubo.
  Future<Map<String, Object?>?> toqueInicial();
}

/// Servicio por defecto: sin notificaciones (no hay adaptador real todavía).
class ServicioNotificacionesNoDisponible implements ServicioNotificaciones {
  const ServicioNotificacionesNoDisponible();

  @override
  Future<String?> obtenerIdentificador() async => null;

  @override
  Future<void> borrarIdentificador() async {}

  @override
  Stream<Map<String, Object?>> get toques => const Stream.empty();

  @override
  Future<Map<String, Object?>?> toqueInicial() async => null;
}

final servicioNotificacionesProvider = Provider<ServicioNotificaciones>(
  (ref) => const ServicioNotificacionesNoDisponible(),
);
