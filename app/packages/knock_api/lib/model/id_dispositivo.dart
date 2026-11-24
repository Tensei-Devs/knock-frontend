//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class IdDispositivo {
  /// Returns a new [IdDispositivo] instance.
  IdDispositivo({
    required this.id,
  });

  String id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IdDispositivo &&
    other.id == id;

  @override
  int get hashCode =>
    (id.hashCode);

  @override
  String toString() => 'IdDispositivo[id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    return json;
  }

  /// Returns a new [IdDispositivo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static IdDispositivo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "IdDispositivo[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "IdDispositivo[id]" has a null value in JSON.');
        return true;
      }());

      return IdDispositivo(
        id: mapValueOfType<String>(json, r'id')!,
      );
    }
    return null;
  }

  static List<IdDispositivo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IdDispositivo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IdDispositivo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IdDispositivo> mapFromJson(dynamic json) {
    final map = <String, IdDispositivo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = IdDispositivo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IdDispositivo-objects as value to a dart map
  static Map<String, List<IdDispositivo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IdDispositivo>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IdDispositivo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
  };
}

