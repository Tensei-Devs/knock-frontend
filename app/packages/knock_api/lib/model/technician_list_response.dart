//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TechnicianListResponse {
  /// Returns a new [TechnicianListResponse] instance.
  TechnicianListResponse({
    this.tecnicos = const [],
    required this.nextCursor,
  });

  List<TechnicianProfileResponse> tecnicos;

  String? nextCursor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TechnicianListResponse &&
    _deepEquality.equals(other.tecnicos, tecnicos) &&
    other.nextCursor == nextCursor;

  @override
  int get hashCode =>
    (tecnicos.hashCode) +
    (nextCursor == null ? 0 : nextCursor!.hashCode);

  @override
  String toString() => 'TechnicianListResponse[tecnicos=$tecnicos, nextCursor=$nextCursor]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tecnicos'] = this.tecnicos;
    if (this.nextCursor != null) {
      json[r'nextCursor'] = this.nextCursor;
    } else {
      json[r'nextCursor'] = null;
    }
    return json;
  }

  /// Returns a new [TechnicianListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TechnicianListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tecnicos'), 'Required key "TechnicianListResponse[tecnicos]" is missing from JSON.');
        assert(json[r'tecnicos'] != null, 'Required key "TechnicianListResponse[tecnicos]" has a null value in JSON.');
        assert(json.containsKey(r'nextCursor'), 'Required key "TechnicianListResponse[nextCursor]" is missing from JSON.');
        return true;
      }());

      return TechnicianListResponse(
        tecnicos: TechnicianProfileResponse.listFromJson(json[r'tecnicos']),
        nextCursor: mapValueOfType<String>(json, r'nextCursor'),
      );
    }
    return null;
  }

  static List<TechnicianListResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TechnicianListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TechnicianListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TechnicianListResponse> mapFromJson(dynamic json) {
    final map = <String, TechnicianListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TechnicianListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TechnicianListResponse-objects as value to a dart map
  static Map<String, List<TechnicianListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TechnicianListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TechnicianListResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tecnicos',
    'nextCursor',
  };
}

