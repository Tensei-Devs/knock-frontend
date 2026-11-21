//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CoverageResponse {
  /// Returns a new [CoverageResponse] instance.
  CoverageResponse({
    required this.atiende,
  });

  bool atiende;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CoverageResponse &&
    other.atiende == atiende;

  @override
  int get hashCode =>
    (atiende.hashCode);

  @override
  String toString() => 'CoverageResponse[atiende=$atiende]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'atiende'] = this.atiende;
    return json;
  }

  /// Returns a new [CoverageResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CoverageResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'atiende'), 'Required key "CoverageResponse[atiende]" is missing from JSON.');
        assert(json[r'atiende'] != null, 'Required key "CoverageResponse[atiende]" has a null value in JSON.');
        return true;
      }());

      return CoverageResponse(
        atiende: mapValueOfType<bool>(json, r'atiende')!,
      );
    }
    return null;
  }

  static List<CoverageResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CoverageResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoverageResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoverageResponse> mapFromJson(dynamic json) {
    final map = <String, CoverageResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CoverageResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoverageResponse-objects as value to a dart map
  static Map<String, List<CoverageResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CoverageResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CoverageResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'atiende',
  };
}

