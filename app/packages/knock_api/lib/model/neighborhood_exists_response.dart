//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NeighborhoodExistsResponse {
  /// Returns a new [NeighborhoodExistsResponse] instance.
  NeighborhoodExistsResponse({
    required this.existe,
  });

  bool existe;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NeighborhoodExistsResponse &&
    other.existe == existe;

  @override
  int get hashCode =>
    (existe.hashCode);

  @override
  String toString() => 'NeighborhoodExistsResponse[existe=$existe]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'existe'] = this.existe;
    return json;
  }

  /// Returns a new [NeighborhoodExistsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NeighborhoodExistsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'existe'), 'Required key "NeighborhoodExistsResponse[existe]" is missing from JSON.');
        assert(json[r'existe'] != null, 'Required key "NeighborhoodExistsResponse[existe]" has a null value in JSON.');
        return true;
      }());

      return NeighborhoodExistsResponse(
        existe: mapValueOfType<bool>(json, r'existe')!,
      );
    }
    return null;
  }

  static List<NeighborhoodExistsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NeighborhoodExistsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NeighborhoodExistsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NeighborhoodExistsResponse> mapFromJson(dynamic json) {
    final map = <String, NeighborhoodExistsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NeighborhoodExistsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NeighborhoodExistsResponse-objects as value to a dart map
  static Map<String, List<NeighborhoodExistsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NeighborhoodExistsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NeighborhoodExistsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'existe',
  };
}

