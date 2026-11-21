//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class InboxNeighborhood {
  /// Returns a new [InboxNeighborhood] instance.
  InboxNeighborhood({
    required this.nombre,
    required this.cp,
  });

  String nombre;

  String cp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InboxNeighborhood &&
    other.nombre == nombre &&
    other.cp == cp;

  @override
  int get hashCode =>
    (nombre.hashCode) +
    (cp.hashCode);

  @override
  String toString() => 'InboxNeighborhood[nombre=$nombre, cp=$cp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'nombre'] = this.nombre;
      json[r'cp'] = this.cp;
    return json;
  }

  /// Returns a new [InboxNeighborhood] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static InboxNeighborhood? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'nombre'), 'Required key "InboxNeighborhood[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "InboxNeighborhood[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'cp'), 'Required key "InboxNeighborhood[cp]" is missing from JSON.');
        assert(json[r'cp'] != null, 'Required key "InboxNeighborhood[cp]" has a null value in JSON.');
        return true;
      }());

      return InboxNeighborhood(
        nombre: mapValueOfType<String>(json, r'nombre')!,
        cp: mapValueOfType<String>(json, r'cp')!,
      );
    }
    return null;
  }

  static List<InboxNeighborhood> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InboxNeighborhood>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InboxNeighborhood.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InboxNeighborhood> mapFromJson(dynamic json) {
    final map = <String, InboxNeighborhood>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = InboxNeighborhood.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InboxNeighborhood-objects as value to a dart map
  static Map<String, List<InboxNeighborhood>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InboxNeighborhood>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InboxNeighborhood.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'nombre',
    'cp',
  };
}

