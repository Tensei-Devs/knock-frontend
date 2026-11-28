//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NoticePreferencesResponse {
  /// Returns a new [NoticePreferencesResponse] instance.
  NoticePreferencesResponse({
    this.tipos = const [],
  });

  List<NoticePreferenceResponse> tipos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NoticePreferencesResponse &&
    _deepEquality.equals(other.tipos, tipos);

  @override
  int get hashCode =>
    (tipos.hashCode);

  @override
  String toString() => 'NoticePreferencesResponse[tipos=$tipos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tipos'] = this.tipos;
    return json;
  }

  /// Returns a new [NoticePreferencesResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NoticePreferencesResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipos'), 'Required key "NoticePreferencesResponse[tipos]" is missing from JSON.');
        assert(json[r'tipos'] != null, 'Required key "NoticePreferencesResponse[tipos]" has a null value in JSON.');
        return true;
      }());

      return NoticePreferencesResponse(
        tipos: NoticePreferenceResponse.listFromJson(json[r'tipos']),
      );
    }
    return null;
  }

  static List<NoticePreferencesResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NoticePreferencesResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NoticePreferencesResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NoticePreferencesResponse> mapFromJson(dynamic json) {
    final map = <String, NoticePreferencesResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NoticePreferencesResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NoticePreferencesResponse-objects as value to a dart map
  static Map<String, List<NoticePreferencesResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NoticePreferencesResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NoticePreferencesResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipos',
  };
}

