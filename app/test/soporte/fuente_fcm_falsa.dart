import 'dart:async';

import 'package:app/core/permisos/gestor_permisos.dart';
import 'package:app/features/notificaciones/data/servicio_notificaciones_fcm.dart';

/// FCM de prueba: identificador, permiso y toques a mano. Sin Firebase.
class FuenteFcmFalsa implements FuenteFcm {
  FuenteFcmFalsa({
    this.identificador = 'fcm-prueba-1',
    this.estadoPermiso = EstadoPermiso.sinPedir,
    this.alPedir = EstadoPermiso.concedido,
  });

  String? identificador;
  EstadoPermiso estadoPermiso;
  EstadoPermiso alPedir;
  Exception? falloAlPedirToken;
  Map<String, Object?>? cargaInicial;
  int borrados = 0;
  int ajustesAbiertos = 0;
  int permisosPedidos = 0;
  final _abiertas = StreamController<Map<String, Object?>>.broadcast();

  void tocar(Map<String, Object?> datos) => _abiertas.add(datos);

  @override
  Future<String?> token() async {
    final fallo = falloAlPedirToken;
    if (fallo != null) throw fallo;
    return identificador;
  }

  @override
  Future<void> borrarToken() async {
    borrados++;
    identificador = null;
  }

  @override
  Stream<Map<String, Object?>> get abiertas => _abiertas.stream;

  @override
  Future<Map<String, Object?>?> inicial() async => cargaInicial;

  @override
  Future<EstadoPermiso> permiso() async => estadoPermiso;

  @override
  Future<EstadoPermiso> pedirPermiso() async {
    permisosPedidos++;
    return estadoPermiso = alPedir;
  }

  @override
  Future<void> abrirAjustes() async => ajustesAbiertos++;
}
