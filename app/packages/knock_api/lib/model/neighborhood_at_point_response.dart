//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NeighborhoodAtPointResponse {
  /// Returns a new [NeighborhoodAtPointResponse] instance.
  NeighborhoodAtPointResponse({
    required this.enCobertura,
    required this.colonia,
  });

  bool enCobertura;

  NeighborhoodAtPointColoniaResponse? colonia;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NeighborhoodAtPointResponse &&
    other.enCobertura == enCobertura &&
    other.colonia == colonia;

  @override
  int get hashCode =>
    (enCobertura.hashCode) +
    (colonia == null ? 0 : colonia!.hashCode);

  @override
  String toString() => 'NeighborhoodAtPointResponse[enCobertura=$enCobertura, colonia=$colonia]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'enCobertura'] = this.enCobertura;
    if (this.colonia != null) {
      json[r'colonia'] = this.colonia;
    } else {
      json[r'colonia'] = null;
    }
    return json;
  }

  /// Returns a new [NeighborhoodAtPointResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NeighborhoodAtPointResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'enCobertura'), 'Required key "NeighborhoodAtPointResponse[enCobertura]" is missing from JSON.');
        assert(json[r'enCobertura'] != null, 'Required key "NeighborhoodAtPointResponse[enCobertura]" has a null value in JSON.');
        assert(json.containsKey(r'colonia'), 'Required key "NeighborhoodAtPointResponse[colonia]" is missing from JSON.');
        return true;
      }());

      return NeighborhoodAtPointResponse(
        enCobertura: mapValueOfType<bool>(json, r'enCobertura')!,
        colonia: NeighborhoodAtPointColoniaResponse.fromJson(json[r'colonia']),
      );
    }
    return null;
  }

  static List<NeighborhoodAtPointResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NeighborhoodAtPointResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NeighborhoodAtPointResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NeighborhoodAtPointResponse> mapFromJson(dynamic json) {
    final map = <String, NeighborhoodAtPointResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NeighborhoodAtPointResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NeighborhoodAtPointResponse-objects as value to a dart map
  static Map<String, List<NeighborhoodAtPointResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NeighborhoodAtPointResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NeighborhoodAtPointResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'enCobertura',
    'colonia',
  };
}

