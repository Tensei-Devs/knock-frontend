//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class Contraparte {
  /// Returns a new [Contraparte] instance.
  Contraparte({
    required this.nombre,
    required this.fotoUrl,
  });

  String nombre;

  String? fotoUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Contraparte &&
    other.nombre == nombre &&
    other.fotoUrl == fotoUrl;

  @override
  int get hashCode =>
    (nombre.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode);

  @override
  String toString() => 'Contraparte[nombre=$nombre, fotoUrl=$fotoUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'nombre'] = this.nombre;
    if (this.fotoUrl != null) {
      json[r'fotoUrl'] = this.fotoUrl;
    } else {
      json[r'fotoUrl'] = null;
    }
    return json;
  }

  /// Returns a new [Contraparte] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static Contraparte? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'nombre'), 'Required key "Contraparte[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "Contraparte[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'fotoUrl'), 'Required key "Contraparte[fotoUrl]" is missing from JSON.');
        return true;
      }());

      return Contraparte(
        nombre: mapValueOfType<String>(json, r'nombre')!,
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
      );
    }
    return null;
  }

  static List<Contraparte> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Contraparte>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Contraparte.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Contraparte> mapFromJson(dynamic json) {
    final map = <String, Contraparte>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = Contraparte.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Contraparte-objects as value to a dart map
  static Map<String, List<Contraparte>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Contraparte>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Contraparte.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'nombre',
    'fotoUrl',
  };
}

