//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UpdateNoticePreferencesRequest {
  /// Returns a new [UpdateNoticePreferencesRequest] instance.
  UpdateNoticePreferencesRequest({
    this.tipos = const [],
  });

  List<NoticePreferenceChange>? tipos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateNoticePreferencesRequest &&
    _deepEquality.equals(other.tipos, tipos);

  @override
  int get hashCode =>
    (tipos == null ? 0 : tipos!.hashCode);

  @override
  String toString() => 'UpdateNoticePreferencesRequest[tipos=$tipos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.tipos != null) {
      json[r'tipos'] = this.tipos;
    } else {
      json[r'tipos'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateNoticePreferencesRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UpdateNoticePreferencesRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipos'), 'Required key "UpdateNoticePreferencesRequest[tipos]" is missing from JSON.');
        return true;
      }());

      return UpdateNoticePreferencesRequest(
        tipos: NoticePreferenceChange.listFromJson(json[r'tipos']),
      );
    }
    return null;
  }

  static List<UpdateNoticePreferencesRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateNoticePreferencesRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateNoticePreferencesRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateNoticePreferencesRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateNoticePreferencesRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UpdateNoticePreferencesRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateNoticePreferencesRequest-objects as value to a dart map
  static Map<String, List<UpdateNoticePreferencesRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateNoticePreferencesRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateNoticePreferencesRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipos',
  };
}

