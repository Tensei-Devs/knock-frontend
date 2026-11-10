import 'dart:async';

import 'package:app/core/notificaciones/carga_notificacion.dart';
import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Lleva a la persona a la pantalla de la notificación que tocó (spec 012,
/// R-02): tanto con la app en segundo plano como si la notificación la abrió.
///
/// Una carga que no se reconoce se ignora. `go` respeta el `redirect` del
/// router: un técnico sin el rol sigue sin entrar a Trabajo.
void abrirPantallaDesdeNotificaciones(Ref ref, GoRouter router) {
  void abrir(Map<String, Object?>? datos) {
    final carga = datos == null ? null : CargaNotificacion.desde(datos);
    if (carga != null && ref.mounted) router.go(carga.ruta);
  }

  final servicio = ref.read(servicioNotificacionesProvider);
  final suscripcion = servicio.toques.listen(abrir);
  ref.onDispose(suscripcion.cancel);
  unawaited(servicio.toqueInicial().then(abrir, onError: (_) {}));
}
