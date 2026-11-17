//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RequestNeighborhood {
  /// Returns a new [RequestNeighborhood] instance.
  RequestNeighborhood({
    required this.id,
    required this.nombre,
    required this.cp,
  });

  String id;

  String nombre;

  String cp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RequestNeighborhood &&
    other.id == id &&
    other.nombre == nombre &&
    other.cp == cp;

  @override
  int get hashCode =>
    (id.hashCode) +
    (nombre.hashCode) +
    (cp.hashCode);

  @override
  String toString() => 'RequestNeighborhood[id=$id, nombre=$nombre, cp=$cp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'nombre'] = this.nombre;
      json[r'cp'] = this.cp;
    return json;
  }

  /// Returns a new [RequestNeighborhood] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RequestNeighborhood? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RequestNeighborhood[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RequestNeighborhood[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "RequestNeighborhood[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "RequestNeighborhood[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'cp'), 'Required key "RequestNeighborhood[cp]" is missing from JSON.');
        assert(json[r'cp'] != null, 'Required key "RequestNeighborhood[cp]" has a null value in JSON.');
        return true;
      }());

      return RequestNeighborhood(
        id: mapValueOfType<String>(json, r'id')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        cp: mapValueOfType<String>(json, r'cp')!,
      );
    }
    return null;
  }

  static List<RequestNeighborhood> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RequestNeighborhood>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestNeighborhood.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RequestNeighborhood> mapFromJson(dynamic json) {
    final map = <String, RequestNeighborhood>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RequestNeighborhood.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RequestNeighborhood-objects as value to a dart map
  static Map<String, List<RequestNeighborhood>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RequestNeighborhood>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RequestNeighborhood.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'nombre',
    'cp',
  };
}

