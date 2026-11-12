import 'package:shared_preferences/shared_preferences.dart';

/// Clave en `shared_preferences` del borrador de la solicitud (spec 015, D-11).
const claveBorradorSolicitud = 'knock.borrador.solicitud';

/// Dónde se guarda el borrador de la solicitud como texto (spec 015, R-07).
///
/// Este archivo es el único de la app que importa `shared_preferences` para el
/// borrador; la función solo lo recibe inyectado. El texto no es cifrado:
/// quien lo arma no debe incluir la dirección del domicilio ni datos de otra
/// cuenta.
abstract interface class AlmacenBorradorSolicitud {
  /// `null` si no hay borrador guardado.
  String? leerBorrador();

  Future<void> guardarBorrador(String texto);

  Future<void> borrarBorrador();
}

mixin BorradorSobreShared implements AlmacenBorradorSolicitud {
  SharedPreferences get preferenciasBorrador;

  @override
  String? leerBorrador() {
    final valor = preferenciasBorrador.get(claveBorradorSolicitud);
    return valor is String ? valor : null;
  }

  @override
  Future<void> guardarBorrador(String texto) =>
      preferenciasBorrador.setString(claveBorradorSolicitud, texto);

  @override
  Future<void> borrarBorrador() =>
      preferenciasBorrador.remove(claveBorradorSolicitud);
}

mixin BorradorEnMemoria implements AlmacenBorradorSolicitud {
  String? _borrador;

  @override
  String? leerBorrador() => _borrador;

  @override
  Future<void> guardarBorrador(String texto) async => _borrador = texto;

  @override
  Future<void> borrarBorrador() async => _borrador = null;
}
