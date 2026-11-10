import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Guarda y borra los tokens de la sesión en el [AlmacenSeguro]
/// (spec 009, R-02).
///
/// [cerrarSesion] borra solo los tokens: el identificador del dispositivo se
/// conserva para que la siguiente sesión llegue con el mismo `deviceId`.
class AlmacenSesion {
  const AlmacenSesion(this._almacen);

  static const claveAcceso = 'knock.sesion.acceso';
  static const claveRefresco = 'knock.sesion.refresco';

  final AlmacenSeguro _almacen;

  Future<void> guardar({
    required String acceso,
    required String refresco,
  }) async {
    await _almacen.escribir(claveAcceso, acceso);
    await _almacen.escribir(claveRefresco, refresco);
  }

  Future<String?> leerAcceso() => _almacen.leer(claveAcceso);

  Future<String?> leerRefresco() => _almacen.leer(claveRefresco);

  Future<void> cerrarSesion() async {
    await _almacen.borrar(claveAcceso);
    await _almacen.borrar(claveRefresco);
  }
}

final almacenSesionProvider = Provider<AlmacenSesion>(
  (ref) => AlmacenSesion(ref.watch(almacenSeguroProvider)),
);
