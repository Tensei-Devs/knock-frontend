//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrabajoVerificationResponse {
  /// Returns a new [TrabajoVerificationResponse] instance.
  TrabajoVerificationResponse({
    required this.estado,
  });

  String estado;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrabajoVerificationResponse &&
    other.estado == estado;

  @override
  int get hashCode =>
    (estado.hashCode);

  @override
  String toString() => 'TrabajoVerificationResponse[estado=$estado]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'estado'] = this.estado;
    return json;
  }

  /// Returns a new [TrabajoVerificationResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrabajoVerificationResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'estado'), 'Required key "TrabajoVerificationResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "TrabajoVerificationResponse[estado]" has a null value in JSON.');
        return true;
      }());

      return TrabajoVerificationResponse(
        estado: mapValueOfType<String>(json, r'estado')!,
      );
    }
    return null;
  }

  static List<TrabajoVerificationResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrabajoVerificationResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrabajoVerificationResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrabajoVerificationResponse> mapFromJson(dynamic json) {
    final map = <String, TrabajoVerificationResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrabajoVerificationResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrabajoVerificationResponse-objects as value to a dart map
  static Map<String, List<TrabajoVerificationResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrabajoVerificationResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrabajoVerificationResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'estado',
  };
}

