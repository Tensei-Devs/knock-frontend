//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VisitCustomer {
  /// Returns a new [VisitCustomer] instance.
  VisitCustomer({
    required this.colonia,
  });

  String colonia;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VisitCustomer &&
    other.colonia == colonia;

  @override
  int get hashCode =>
    (colonia.hashCode);

  @override
  String toString() => 'VisitCustomer[colonia=$colonia]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'colonia'] = this.colonia;
    return json;
  }

  /// Returns a new [VisitCustomer] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VisitCustomer? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'colonia'), 'Required key "VisitCustomer[colonia]" is missing from JSON.');
        assert(json[r'colonia'] != null, 'Required key "VisitCustomer[colonia]" has a null value in JSON.');
        return true;
      }());

      return VisitCustomer(
        colonia: mapValueOfType<String>(json, r'colonia')!,
      );
    }
    return null;
  }

  static List<VisitCustomer> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VisitCustomer>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VisitCustomer.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VisitCustomer> mapFromJson(dynamic json) {
    final map = <String, VisitCustomer>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VisitCustomer.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VisitCustomer-objects as value to a dart map
  static Map<String, List<VisitCustomer>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VisitCustomer>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VisitCustomer.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'colonia',
  };
}

