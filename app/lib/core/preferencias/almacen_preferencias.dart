import 'package:app/core/preferencias/almacen_avisos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dónde se conservan el tema y el idioma elegidos (HU-052, spec §5).
///
/// La lectura es síncrona para que el primer cuadro ya tenga lo guardado.
/// `null` significa «sin valor válido»: quien lee usa el valor por defecto.
abstract interface class AlmacenPreferencias {
  ThemeMode? leerTema();

  Locale? leerIdioma();

  Future<void> guardarTema(ThemeMode modoTema);

  Future<void> guardarIdioma(Locale idioma);
}

/// Almacén sobre `shared_preferences` (API clásico, spec §8 decisión 1).
///
/// Solo escribe dos claves con valores de un conjunto cerrado: nunca tokens
/// ni datos personales, porque este almacenamiento no está cifrado. Los
/// valores son nombres propios de Knock para que un cambio de Flutter no
/// invalide lo guardado.
class AlmacenPreferenciasShared
    with AvisosSobreShared
    implements AlmacenPreferencias {
  const AlmacenPreferenciasShared(this._preferencias);

  static const claveTema = 'knock.preferencias.tema';
  static const claveIdioma = 'knock.preferencias.idioma';

  static const _temas = {
    'automatico': ThemeMode.system,
    'claro': ThemeMode.light,
    'oscuro': ThemeMode.dark,
  };
  static const _idiomas = {'es': Locale('es'), 'en': Locale('en')};

  final SharedPreferences _preferencias;

  @override
  SharedPreferences get preferenciasAvisos => _preferencias;

  @override
  ThemeMode? leerTema() => _temas[_preferencias.get(claveTema)];

  @override
  Locale? leerIdioma() => _idiomas[_preferencias.get(claveIdioma)];

  @override
  Future<void> guardarTema(ThemeMode modoTema) =>
      _preferencias.setString(claveTema, _nombreDe(_temas, modoTema));

  @override
  Future<void> guardarIdioma(Locale idioma) =>
      _preferencias.setString(claveIdioma, _nombreDe(_idiomas, idioma));

  static String _nombreDe<T>(Map<String, T> valores, T valor) =>
      valores.entries.firstWhere((entrada) => entrada.value == valor).key;
}

/// Almacén sin persistencia: valor por defecto del proveedor y respaldo si el
/// almacenamiento del dispositivo no está disponible (spec §8 decisión 5).
class AlmacenPreferenciasEnMemoria
    with AvisosEnMemoria
    implements AlmacenPreferencias {
  ThemeMode? _modoTema;
  Locale? _idioma;

  @override
  ThemeMode? leerTema() => _modoTema;

  @override
  Locale? leerIdioma() => _idioma;

  @override
  Future<void> guardarTema(ThemeMode modoTema) async => _modoTema = modoTema;

  @override
  Future<void> guardarIdioma(Locale idioma) async => _idioma = idioma;
}

/// `main()` lo reemplaza con el almacén de arranque antes de `runApp`.
final almacenPreferenciasProvider = Provider<AlmacenPreferencias>(
  (ref) => AlmacenPreferenciasEnMemoria(),
);
