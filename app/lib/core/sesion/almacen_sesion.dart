import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Guarda y borra los tokens de la sesión en el [AlmacenSeguro]
/// (spec 009, R-02).
///
/// [cerrarSesion] borra solo los tokens: el identificador del dispositivo se
/// conserva para que la siguiente sesión llegue con el mismo `deviceId`.
///
/// El orden importa porque el token de renovación es el que la API rota y
/// revoca: reusar uno revocado cierra todas las sesiones de la cuenta (spec 016,
/// backend). Por eso [guardar] escribe **primero** el de renovación (si la app
/// muere entre las dos escrituras queda el nuevo con un acceso viejo, que vence
/// y se renueva sin problema) y [cerrarSesion] borra **primero** el de
/// renovación.
class AlmacenSesion {
  const AlmacenSesion(this._almacen);

  static const claveAcceso = 'knock.sesion.acceso';
  static const claveRefresco = 'knock.sesion.refresco';

  final AlmacenSeguro _almacen;

  Future<void> guardar({
    required String acceso,
    required String refresco,
  }) async {
    await _almacen.escribir(claveRefresco, refresco);
    await _almacen.escribir(claveAcceso, acceso);
  }

  Future<String?> leerAcceso() => _almacen.leer(claveAcceso);

  Future<String?> leerRefresco() => _almacen.leer(claveRefresco);

  /// Borra primero el token de renovación y después el de acceso. Intenta los
  /// dos aunque el primero falle; si alguno falla, relanza el primer error
  /// cuando ya intentó ambos.
  Future<void> cerrarSesion() async {
    Object? fallo;
    StackTrace? traza;
    for (final clave in [claveRefresco, claveAcceso]) {
      try {
        await _almacen.borrar(clave);
      } on Object catch (error, pila) {
        fallo ??= error;
        traza ??= pila;
      }
    }
    if (fallo != null) Error.throwWithStackTrace(fallo, traza!);
  }
}

final almacenSesionProvider = Provider<AlmacenSesion>(
  (ref) => AlmacenSesion(ref.watch(almacenSeguroProvider)),
);
