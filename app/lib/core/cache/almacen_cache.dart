import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Un dato guardado: el cuerpo tal como llegó, su `ETag` y cuándo se guardó o
/// se confirmó vigente por última vez (spec 010, R-01 y R-02).
final class EntradaCache {
  const EntradaCache({
    required this.cuerpo,
    required this.guardadoEn,
    this.etag,
  });

  final String cuerpo;
  final String? etag;
  final DateTime guardadoEn;

  EntradaCache conFecha(DateTime fecha) =>
      EntradaCache(cuerpo: cuerpo, etag: etag, guardadoEn: fecha);
}

/// Familias de clave que sí se pueden guardar (spec 010, R-01). Todo lo demás,
/// en especial las listas personales que cambian al crear algo, se rechaza
/// (R-04): una clave nueva exige ampliar esta lista a propósito.
const List<String> prefijosCacheables = [
  'catalogo/',
  'perfil/',
  'reciente/',
  'imagen/',
];

/// Si [clave] pertenece a una familia que se puede guardar (R-04).
bool esClaveCacheable(String clave) => prefijosCacheables.any(clave.startsWith);

/// Caché local de datos de solo lectura. No guarda tokens ni listas
/// personales: ver [esClaveCacheable].
abstract interface class AlmacenCache {
  Future<EntradaCache?> leer(String clave);

  /// Lanza [ArgumentError] si la clave no es cacheable (R-04).
  Future<void> guardar(String clave, EntradaCache entrada);

  /// Borra toda la caché (R-05, cierre de sesión).
  Future<void> borrarTodo();
}

/// Caché sin persistencia: valor por defecto del proveedor y de las pruebas.
class AlmacenCacheEnMemoria implements AlmacenCache {
  final Map<String, EntradaCache> _entradas = {};

  @override
  Future<EntradaCache?> leer(String clave) async => _entradas[clave];

  @override
  Future<void> guardar(String clave, EntradaCache entrada) async {
    _exigirCacheable(clave);
    _entradas[clave] = entrada;
  }

  @override
  Future<void> borrarTodo() async => _entradas.clear();
}

/// Caché que sobrevive al cierre de la app, sobre `shared_preferences`
/// (mínimo viable sin SQLite, spec 010 §2: la base local queda pendiente).
///
/// Todas sus claves llevan el prefijo [prefijo]: [borrarTodo] solo toca esas
/// y deja intactas las preferencias de tema e idioma.
class AlmacenCacheShared implements AlmacenCache {
  const AlmacenCacheShared(this._preferencias);

  static const prefijo = 'knock.cache.';

  final SharedPreferences _preferencias;

  @override
  Future<EntradaCache?> leer(String clave) async {
    final texto = _preferencias.getString('$prefijo$clave');
    if (texto == null) return null;
    try {
      final json = jsonDecode(texto);
      if (json is! Map<String, Object?>) return null;
      final cuerpo = json['cuerpo'];
      final fecha = DateTime.tryParse('${json['guardadoEn']}');
      final etag = json['etag'];
      if (cuerpo is! String || fecha == null) return null;
      return EntradaCache(
        cuerpo: cuerpo,
        guardadoEn: fecha,
        etag: etag is String ? etag : null,
      );
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> guardar(String clave, EntradaCache entrada) async {
    _exigirCacheable(clave);
    await _preferencias.setString(
      '$prefijo$clave',
      jsonEncode({
        'cuerpo': entrada.cuerpo,
        'etag': entrada.etag,
        'guardadoEn': entrada.guardadoEn.toUtc().toIso8601String(),
      }),
    );
  }

  @override
  Future<void> borrarTodo() async {
    for (final clave in _preferencias.getKeys().toList()) {
      if (clave.startsWith(prefijo)) await _preferencias.remove(clave);
    }
  }
}

void _exigirCacheable(String clave) {
  if (!esClaveCacheable(clave)) {
    throw ArgumentError.value(clave, 'clave', 'no se guarda en caché (R-04)');
  }
}

/// Caché de la app. `main()` puede reemplazarla por [AlmacenCacheShared].
final almacenCacheProvider = Provider<AlmacenCache>(
  (ref) => AlmacenCacheEnMemoria(),
);

/// Borra toda la caché local. Lo llama el cierre de sesión (spec 010, R-05).
final borrarCacheLocalProvider = Provider<Future<void> Function()>(
  (ref) => ref.watch(almacenCacheProvider).borrarTodo,
);
