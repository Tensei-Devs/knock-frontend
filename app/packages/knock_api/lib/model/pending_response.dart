//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PendingResponse {
  /// Returns a new [PendingResponse] instance.
  PendingResponse({
    required this.citas,
    required this.cotizaciones,
  });

  PendingGroupResponse citas;

  PendingGroupResponse cotizaciones;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PendingResponse &&
    other.citas == citas &&
    other.cotizaciones == cotizaciones;

  @override
  int get hashCode =>
    (citas.hashCode) +
    (cotizaciones.hashCode);

  @override
  String toString() => 'PendingResponse[citas=$citas, cotizaciones=$cotizaciones]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'citas'] = this.citas;
      json[r'cotizaciones'] = this.cotizaciones;
    return json;
  }

  /// Returns a new [PendingResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PendingResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'citas'), 'Required key "PendingResponse[citas]" is missing from JSON.');
        assert(json[r'citas'] != null, 'Required key "PendingResponse[citas]" has a null value in JSON.');
        assert(json.containsKey(r'cotizaciones'), 'Required key "PendingResponse[cotizaciones]" is missing from JSON.');
        assert(json[r'cotizaciones'] != null, 'Required key "PendingResponse[cotizaciones]" has a null value in JSON.');
        return true;
      }());

      return PendingResponse(
        citas: PendingGroupResponse.fromJson(json[r'citas'])!,
        cotizaciones: PendingGroupResponse.fromJson(json[r'cotizaciones'])!,
      );
    }
    return null;
  }

  static List<PendingResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PendingResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PendingResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PendingResponse> mapFromJson(dynamic json) {
    final map = <String, PendingResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PendingResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PendingResponse-objects as value to a dart map
  static Map<String, List<PendingResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PendingResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PendingResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'citas',
    'cotizaciones',
  };
}

