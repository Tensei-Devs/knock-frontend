import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Permisos del teléfono que la app puede pedir (spec 012, R-06 y R-08).
///
/// No existe el permiso de contactos: para elegir un contacto se usa el
/// selector del sistema, que no lo necesita.
enum PermisoApp { notificaciones, ubicacion }

enum EstadoPermiso {
  sinPedir,
  concedido,
  denegado,

  /// Se negó con «no volver a preguntar»: solo se cambia en Ajustes.
  denegadoParaSiempre;

  bool get concedida => this == concedido;
}

/// Puerto del sistema de permisos. Lo implementará un adaptador sobre el
/// paquete de permisos cuando se integre (junto con `POST_NOTIFICATIONS` en el
/// manifiesto, que comparte archivo con KNOCK-228).
abstract interface class GestorPermisos {
  Future<EstadoPermiso> estado(PermisoApp permiso);

  /// Muestra el diálogo del sistema. Solo se llama tras la explicación previa.
  Future<EstadoPermiso> pedir(PermisoApp permiso);

  /// Abre los ajustes de la app.
  Future<void> abrirAjustes();
}

/// Gestor por defecto: nunca concede nada. Mantiene los avisos apagados hasta
/// que exista el adaptador real.
class GestorPermisosNoDisponible implements GestorPermisos {
  const GestorPermisosNoDisponible();

  @override
  Future<EstadoPermiso> estado(PermisoApp permiso) async =>
      EstadoPermiso.sinPedir;

  @override
  Future<EstadoPermiso> pedir(PermisoApp permiso) async =>
      EstadoPermiso.denegado;

  @override
  Future<void> abrirAjustes() async {}
}

final gestorPermisosProvider = Provider<GestorPermisos>(
  (ref) => const GestorPermisosNoDisponible(),
);
