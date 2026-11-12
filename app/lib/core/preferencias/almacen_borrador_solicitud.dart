import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Dónde se guarda el borrador de «Pedir cotización» (spec 015, R-07 y D-11).
///
/// Este archivo es el único de la función que toca `shared_preferences`
/// (regla de `core/preferencias/`). El borrador **no** lleva la dirección del
/// domicilio ni tokens: este almacenamiento no está cifrado. La forma del mapa
/// la decide `BorradorSolicitud` (dominio de `actividad`).
abstract interface class AlmacenBorradorSolicitud {
  /// El borrador guardado, o `null` si no hay o está dañado.
  Map<String, Object?>? leerBorrador();

  Future<void> guardarBorrador(Map<String, Object?> borrador);

  Future<void> borrarBorrador();
}

/// Clave del borrador (nombre propio de Knock, excluido de la copia de
/// seguridad junto con el resto de `knock.*`, R-16).
const claveBorradorSolicitud = 'knock.borrador.solicitud';

mixin BorradorSobreShared implements AlmacenBorradorSolicitud {
  SharedPreferences get preferenciasBorrador;

  @override
  Map<String, Object?>? leerBorrador() {
    final texto = preferenciasBorrador.get(claveBorradorSolicitud);
    if (texto is! String) return null;
    try {
      final valor = jsonDecode(texto);
      return valor is Map<String, Object?> ? valor : null;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> guardarBorrador(Map<String, Object?> borrador) =>
      preferenciasBorrador.setString(
        claveBorradorSolicitud,
        jsonEncode(borrador),
      );

  @override
  Future<void> borrarBorrador() =>
      preferenciasBorrador.remove(claveBorradorSolicitud);
}

mixin BorradorEnMemoria implements AlmacenBorradorSolicitud {
  Map<String, Object?>? _borrador;

  @override
  Map<String, Object?>? leerBorrador() => _borrador;

  @override
  Future<void> guardarBorrador(Map<String, Object?> borrador) async =>
      _borrador = Map.of(borrador);

  @override
  Future<void> borrarBorrador() async => _borrador = null;
}
