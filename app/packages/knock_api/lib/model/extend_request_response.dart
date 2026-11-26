//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ExtendRequestResponse {
  /// Returns a new [ExtendRequestResponse] instance.
  ExtendRequestResponse({
    required this.id,
    required this.estado,
  });

  String id;

  String estado;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ExtendRequestResponse &&
    other.id == id &&
    other.estado == estado;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode);

  @override
  String toString() => 'ExtendRequestResponse[id=$id, estado=$estado]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
    return json;
  }

  /// Returns a new [ExtendRequestResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ExtendRequestResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ExtendRequestResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ExtendRequestResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "ExtendRequestResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "ExtendRequestResponse[estado]" has a null value in JSON.');
        return true;
      }());

      return ExtendRequestResponse(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
      );
    }
    return null;
  }

  static List<ExtendRequestResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ExtendRequestResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ExtendRequestResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ExtendRequestResponse> mapFromJson(dynamic json) {
    final map = <String, ExtendRequestResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ExtendRequestResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ExtendRequestResponse-objects as value to a dart map
  static Map<String, List<ExtendRequestResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ExtendRequestResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ExtendRequestResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
  };
}

