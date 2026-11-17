//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RefreshResponse {
  /// Returns a new [RefreshResponse] instance.
  RefreshResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
  });

  String accessToken;

  int expiresIn;

  String refreshToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RefreshResponse &&
    other.accessToken == accessToken &&
    other.expiresIn == expiresIn &&
    other.refreshToken == refreshToken;

  @override
  int get hashCode =>
    (accessToken.hashCode) +
    (expiresIn.hashCode) +
    (refreshToken.hashCode);

  @override
  String toString() => 'RefreshResponse[accessToken=$accessToken, expiresIn=$expiresIn, refreshToken=$refreshToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'accessToken'] = this.accessToken;
      json[r'expiresIn'] = this.expiresIn;
      json[r'refreshToken'] = this.refreshToken;
    return json;
  }

  /// Returns a new [RefreshResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RefreshResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'accessToken'), 'Required key "RefreshResponse[accessToken]" is missing from JSON.');
        assert(json[r'accessToken'] != null, 'Required key "RefreshResponse[accessToken]" has a null value in JSON.');
        assert(json.containsKey(r'expiresIn'), 'Required key "RefreshResponse[expiresIn]" is missing from JSON.');
        assert(json[r'expiresIn'] != null, 'Required key "RefreshResponse[expiresIn]" has a null value in JSON.');
        assert(json.containsKey(r'refreshToken'), 'Required key "RefreshResponse[refreshToken]" is missing from JSON.');
        assert(json[r'refreshToken'] != null, 'Required key "RefreshResponse[refreshToken]" has a null value in JSON.');
        return true;
      }());

      return RefreshResponse(
        accessToken: mapValueOfType<String>(json, r'accessToken')!,
        expiresIn: mapValueOfType<int>(json, r'expiresIn')!,
        refreshToken: mapValueOfType<String>(json, r'refreshToken')!,
      );
    }
    return null;
  }

  static List<RefreshResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RefreshResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RefreshResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RefreshResponse> mapFromJson(dynamic json) {
    final map = <String, RefreshResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RefreshResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RefreshResponse-objects as value to a dart map
  static Map<String, List<RefreshResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RefreshResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RefreshResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'accessToken',
    'expiresIn',
    'refreshToken',
  };
}

