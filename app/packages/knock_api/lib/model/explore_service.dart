//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ExploreService {
  /// Returns a new [ExploreService] instance.
  ExploreService({
    required this.clave,
    required this.nombre,
    required this.tecnicos,
  });

  String clave;

  String nombre;

  int tecnicos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ExploreService &&
    other.clave == clave &&
    other.nombre == nombre &&
    other.tecnicos == tecnicos;

  @override
  int get hashCode =>
    (clave.hashCode) +
    (nombre.hashCode) +
    (tecnicos.hashCode);

  @override
  String toString() => 'ExploreService[clave=$clave, nombre=$nombre, tecnicos=$tecnicos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'clave'] = this.clave;
      json[r'nombre'] = this.nombre;
      json[r'tecnicos'] = this.tecnicos;
    return json;
  }

  /// Returns a new [ExploreService] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ExploreService? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'clave'), 'Required key "ExploreService[clave]" is missing from JSON.');
        assert(json[r'clave'] != null, 'Required key "ExploreService[clave]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "ExploreService[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "ExploreService[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'tecnicos'), 'Required key "ExploreService[tecnicos]" is missing from JSON.');
        assert(json[r'tecnicos'] != null, 'Required key "ExploreService[tecnicos]" has a null value in JSON.');
        return true;
      }());

      return ExploreService(
        clave: mapValueOfType<String>(json, r'clave')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        tecnicos: mapValueOfType<int>(json, r'tecnicos')!,
      );
    }
    return null;
  }

  static List<ExploreService> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ExploreService>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ExploreService.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ExploreService> mapFromJson(dynamic json) {
    final map = <String, ExploreService>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ExploreService.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ExploreService-objects as value to a dart map
  static Map<String, List<ExploreService>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ExploreService>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ExploreService.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'clave',
    'nombre',
    'tecnicos',
  };
}

