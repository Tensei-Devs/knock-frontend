//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UnreadCountResponse {
  /// Returns a new [UnreadCountResponse] instance.
  UnreadCountResponse({
    required this.cantidad,
    required this.masDe99,
  });

  int cantidad;

  bool masDe99;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UnreadCountResponse &&
    other.cantidad == cantidad &&
    other.masDe99 == masDe99;

  @override
  int get hashCode =>
    (cantidad.hashCode) +
    (masDe99.hashCode);

  @override
  String toString() => 'UnreadCountResponse[cantidad=$cantidad, masDe99=$masDe99]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'cantidad'] = this.cantidad;
      json[r'masDe99'] = this.masDe99;
    return json;
  }

  /// Returns a new [UnreadCountResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UnreadCountResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'cantidad'), 'Required key "UnreadCountResponse[cantidad]" is missing from JSON.');
        assert(json[r'cantidad'] != null, 'Required key "UnreadCountResponse[cantidad]" has a null value in JSON.');
        assert(json.containsKey(r'masDe99'), 'Required key "UnreadCountResponse[masDe99]" is missing from JSON.');
        assert(json[r'masDe99'] != null, 'Required key "UnreadCountResponse[masDe99]" has a null value in JSON.');
        return true;
      }());

      return UnreadCountResponse(
        cantidad: mapValueOfType<int>(json, r'cantidad')!,
        masDe99: mapValueOfType<bool>(json, r'masDe99')!,
      );
    }
    return null;
  }

  static List<UnreadCountResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UnreadCountResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UnreadCountResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UnreadCountResponse> mapFromJson(dynamic json) {
    final map = <String, UnreadCountResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UnreadCountResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UnreadCountResponse-objects as value to a dart map
  static Map<String, List<UnreadCountResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UnreadCountResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UnreadCountResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'cantidad',
    'masDe99',
  };
}

