//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrabajoPlace {
  /// Returns a new [TrabajoPlace] instance.
  TrabajoPlace({
    required this.tipo,
    required this.direccion,
  });

  String tipo;

  String? direccion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrabajoPlace &&
    other.tipo == tipo &&
    other.direccion == direccion;

  @override
  int get hashCode =>
    (tipo.hashCode) +
    (direccion == null ? 0 : direccion!.hashCode);

  @override
  String toString() => 'TrabajoPlace[tipo=$tipo, direccion=$direccion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tipo'] = this.tipo;
    if (this.direccion != null) {
      json[r'direccion'] = this.direccion;
    } else {
      json[r'direccion'] = null;
    }
    return json;
  }

  /// Returns a new [TrabajoPlace] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrabajoPlace? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipo'), 'Required key "TrabajoPlace[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "TrabajoPlace[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'direccion'), 'Required key "TrabajoPlace[direccion]" is missing from JSON.');
        return true;
      }());

      return TrabajoPlace(
        tipo: mapValueOfType<String>(json, r'tipo')!,
        direccion: mapValueOfType<String>(json, r'direccion'),
      );
    }
    return null;
  }

  static List<TrabajoPlace> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrabajoPlace>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrabajoPlace.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrabajoPlace> mapFromJson(dynamic json) {
    final map = <String, TrabajoPlace>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrabajoPlace.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrabajoPlace-objects as value to a dart map
  static Map<String, List<TrabajoPlace>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrabajoPlace>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrabajoPlace.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipo',
    'direccion',
  };
}

