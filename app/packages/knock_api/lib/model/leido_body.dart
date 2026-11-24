//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class LeidoBody {
  /// Returns a new [LeidoBody] instance.
  LeidoBody({
    required this.hasta,
  });

  DateTime? hasta;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LeidoBody &&
    other.hasta == hasta;

  @override
  int get hashCode =>
    (hasta == null ? 0 : hasta!.hashCode);

  @override
  String toString() => 'LeidoBody[hasta=$hasta]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.hasta != null) {
      json[r'hasta'] = this.hasta!.toUtc().toIso8601String();
    } else {
      json[r'hasta'] = null;
    }
    return json;
  }

  /// Returns a new [LeidoBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static LeidoBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'hasta'), 'Required key "LeidoBody[hasta]" is missing from JSON.');
        return true;
      }());

      return LeidoBody(
        hasta: mapDateTime(json, r'hasta', r''),
      );
    }
    return null;
  }

  static List<LeidoBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LeidoBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LeidoBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LeidoBody> mapFromJson(dynamic json) {
    final map = <String, LeidoBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = LeidoBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LeidoBody-objects as value to a dart map
  static Map<String, List<LeidoBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LeidoBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LeidoBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'hasta',
  };
}

