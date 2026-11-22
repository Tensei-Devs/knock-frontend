//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrabajoClient {
  /// Returns a new [TrabajoClient] instance.
  TrabajoClient({
    required this.colonia,
  });

  String colonia;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrabajoClient &&
    other.colonia == colonia;

  @override
  int get hashCode =>
    (colonia.hashCode);

  @override
  String toString() => 'TrabajoClient[colonia=$colonia]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'colonia'] = this.colonia;
    return json;
  }

  /// Returns a new [TrabajoClient] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrabajoClient? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'colonia'), 'Required key "TrabajoClient[colonia]" is missing from JSON.');
        assert(json[r'colonia'] != null, 'Required key "TrabajoClient[colonia]" has a null value in JSON.');
        return true;
      }());

      return TrabajoClient(
        colonia: mapValueOfType<String>(json, r'colonia')!,
      );
    }
    return null;
  }

  static List<TrabajoClient> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrabajoClient>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrabajoClient.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrabajoClient> mapFromJson(dynamic json) {
    final map = <String, TrabajoClient>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrabajoClient.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrabajoClient-objects as value to a dart map
  static Map<String, List<TrabajoClient>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrabajoClient>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrabajoClient.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'colonia',
  };
}

