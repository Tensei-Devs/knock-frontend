//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class DeletionScheduledResponse {
  /// Returns a new [DeletionScheduledResponse] instance.
  DeletionScheduledResponse({
    required this.eliminarEn,
  });

  DateTime eliminarEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeletionScheduledResponse &&
    other.eliminarEn == eliminarEn;

  @override
  int get hashCode =>
    (eliminarEn.hashCode);

  @override
  String toString() => 'DeletionScheduledResponse[eliminarEn=$eliminarEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'eliminarEn'] = this.eliminarEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [DeletionScheduledResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static DeletionScheduledResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'eliminarEn'), 'Required key "DeletionScheduledResponse[eliminarEn]" is missing from JSON.');
        assert(json[r'eliminarEn'] != null, 'Required key "DeletionScheduledResponse[eliminarEn]" has a null value in JSON.');
        return true;
      }());

      return DeletionScheduledResponse(
        eliminarEn: mapDateTime(json, r'eliminarEn', r'')!,
      );
    }
    return null;
  }

  static List<DeletionScheduledResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DeletionScheduledResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DeletionScheduledResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DeletionScheduledResponse> mapFromJson(dynamic json) {
    final map = <String, DeletionScheduledResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = DeletionScheduledResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DeletionScheduledResponse-objects as value to a dart map
  static Map<String, List<DeletionScheduledResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DeletionScheduledResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DeletionScheduledResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'eliminarEn',
  };
}

