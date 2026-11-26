//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class MapResponse {
  /// Returns a new [MapResponse] instance.
  MapResponse({
    this.grupos = const [],
  });

  List<MapGroup> grupos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapResponse &&
    _deepEquality.equals(other.grupos, grupos);

  @override
  int get hashCode =>
    (grupos.hashCode);

  @override
  String toString() => 'MapResponse[grupos=$grupos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'grupos'] = this.grupos;
    return json;
  }

  /// Returns a new [MapResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static MapResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'grupos'), 'Required key "MapResponse[grupos]" is missing from JSON.');
        assert(json[r'grupos'] != null, 'Required key "MapResponse[grupos]" has a null value in JSON.');
        return true;
      }());

      return MapResponse(
        grupos: MapGroup.listFromJson(json[r'grupos']),
      );
    }
    return null;
  }

  static List<MapResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapResponse> mapFromJson(dynamic json) {
    final map = <String, MapResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = MapResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapResponse-objects as value to a dart map
  static Map<String, List<MapResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'grupos',
  };
}

