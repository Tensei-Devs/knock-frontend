import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Almacenamiento cifrado del sistema (Keystore en Android) para lo que no
/// puede quedar legible: tokens de sesión e identificador del dispositivo
/// (spec 009, R-02 y R-07). Nunca se usa `shared_preferences` para esto.
abstract interface class AlmacenSeguro {
  Future<String?> leer(String clave);

  Future<void> escribir(String clave, String valor);

  Future<void> borrar(String clave);
}

/// Almacén en memoria: valor por defecto del proveedor y doble de las pruebas.
///
/// No persiste nada entre arranques.
class AlmacenSeguroEnMemoria implements AlmacenSeguro {
  final _valores = <String, String>{};

  /// Copia de lo guardado, para que las pruebas revisen qué quedó.
  Map<String, String> get contenido => Map.unmodifiable(_valores);

  @override
  Future<String?> leer(String clave) async => _valores[clave];

  @override
  Future<void> escribir(String clave, String valor) async =>
      _valores[clave] = valor;

  @override
  Future<void> borrar(String clave) async => _valores.remove(clave);
}

/// Adaptador real sobre `flutter_secure_storage` (Keystore en Android,
/// Keychain en iOS). Se usa en producción desde `main.dart`; en pruebas se
/// reemplaza con `AlmacenSeguroEnMemoria` o se mockea `FlutterSecureStorage`.
class AlmacenSeguroFlutterSecureStorage implements AlmacenSeguro {
  AlmacenSeguroFlutterSecureStorage({
    this._almacen = const FlutterSecureStorage(),
  });

  final FlutterSecureStorage _almacen;

  @override
  Future<String?> leer(String clave) async => _almacen.read(key: clave);

  @override
  Future<void> escribir(String clave, String valor) async =>
      _almacen.write(key: clave, value: valor);

  @override
  Future<void> borrar(String clave) async => _almacen.delete(key: clave);
}

final almacenSeguroProvider = Provider<AlmacenSeguro>(
  (ref) => AlmacenSeguroEnMemoria(),
);
