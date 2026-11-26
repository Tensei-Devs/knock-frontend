/// Rutas del lado del técnico.
abstract final class RT {
  static const registro = '/m/tecnico/registro';
  static const verif = '/m/tecnico/verificacion';
  static const pendiente = '/m/tecnico/pendiente';
  static const verificado = '/m/tecnico/verificado';
  static const rechazada = '/m/tecnico/rechazada';
  static const mensajes = '/m/tecnico/mensajes';
  static String chat(String cid, String rid) => '/m/tecnico/chat/$cid/$rid';
  static String cotizar(String rid) => '/m/tecnico/cotizar/$rid';
  static String iniciar(String vid) => '/m/tecnico/iniciar/$vid';
  static String cerrar(String vid) => '/m/tecnico/cerrar/$vid';
  static const perfil = '/m/tecnico/perfil';
  static const reputacion = '/m/tecnico/reputacion';
}
