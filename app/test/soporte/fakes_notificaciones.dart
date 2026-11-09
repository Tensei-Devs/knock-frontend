import 'dart:async';

import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:app/core/permisos/gestor_permisos.dart';

/// Servicio de notificaciones de prueba: identificador fijo y toques a mano.
class ServicioNotificacionesFalso implements ServicioNotificaciones {
  ServicioNotificacionesFalso({this.identificador = 'id-prueba-1'});

  String? identificador;
  Map<String, Object?>? inicial;
  int borrados = 0;
  final _toques = StreamController<Map<String, Object?>>.broadcast();

  void tocar(Map<String, Object?> datos) => _toques.add(datos);

  @override
  Future<String?> obtenerIdentificador() async => identificador;

  @override
  Future<void> borrarIdentificador() async {
    borrados++;
    identificador = null;
  }

  @override
  Stream<Map<String, Object?>> get toques => _toques.stream;

  @override
  Future<Map<String, Object?>?> toqueInicial() async => inicial;
}

/// Gestor de permisos de prueba: responde lo que se le indique.
class GestorPermisosFalso implements GestorPermisos {
  GestorPermisosFalso({
    EstadoPermiso estadoInicial = EstadoPermiso.sinPedir,
    this.alPedir = EstadoPermiso.concedido,
  }) : _estado = {for (final p in PermisoApp.values) p: estadoInicial};

  final Map<PermisoApp, EstadoPermiso> _estado;
  EstadoPermiso alPedir;
  final List<PermisoApp> pedidos = [];
  int ajustesAbiertos = 0;

  @override
  Future<EstadoPermiso> estado(PermisoApp permiso) async => _estado[permiso]!;

  @override
  Future<EstadoPermiso> pedir(PermisoApp permiso) async {
    pedidos.add(permiso);
    return _estado[permiso] = alPedir;
  }

  @override
  Future<void> abrirAjustes() async => ajustesAbiertos++;
}
