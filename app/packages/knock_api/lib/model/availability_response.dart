//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AvailabilityResponse {
  /// Returns a new [AvailabilityResponse] instance.
  AvailabilityResponse({
    required this.disponibleHoy,
    required this.disponibleHasta,
  });

  bool disponibleHoy;

  DateTime disponibleHasta;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AvailabilityResponse &&
    other.disponibleHoy == disponibleHoy &&
    other.disponibleHasta == disponibleHasta;

  @override
  int get hashCode =>
    (disponibleHoy.hashCode) +
    (disponibleHasta.hashCode);

  @override
  String toString() => 'AvailabilityResponse[disponibleHoy=$disponibleHoy, disponibleHasta=$disponibleHasta]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'disponibleHoy'] = this.disponibleHoy;
      json[r'disponibleHasta'] = this.disponibleHasta.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [AvailabilityResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AvailabilityResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'disponibleHoy'), 'Required key "AvailabilityResponse[disponibleHoy]" is missing from JSON.');
        assert(json[r'disponibleHoy'] != null, 'Required key "AvailabilityResponse[disponibleHoy]" has a null value in JSON.');
        assert(json.containsKey(r'disponibleHasta'), 'Required key "AvailabilityResponse[disponibleHasta]" is missing from JSON.');
        assert(json[r'disponibleHasta'] != null, 'Required key "AvailabilityResponse[disponibleHasta]" has a null value in JSON.');
        return true;
      }());

      return AvailabilityResponse(
        disponibleHoy: mapValueOfType<bool>(json, r'disponibleHoy')!,
        disponibleHasta: mapDateTime(json, r'disponibleHasta', r'')!,
      );
    }
    return null;
  }

  static List<AvailabilityResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AvailabilityResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AvailabilityResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AvailabilityResponse> mapFromJson(dynamic json) {
    final map = <String, AvailabilityResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AvailabilityResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AvailabilityResponse-objects as value to a dart map
  static Map<String, List<AvailabilityResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AvailabilityResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AvailabilityResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'disponibleHoy',
    'disponibleHasta',
  };
}

