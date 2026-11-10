//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class SessionResponse {
  /// Returns a new [SessionResponse] instance.
  SessionResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.esNuevo,
    required this.perfilCompleto,
  });

  String accessToken;

  String refreshToken;

  bool esNuevo;

  bool perfilCompleto;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SessionResponse &&
    other.accessToken == accessToken &&
    other.refreshToken == refreshToken &&
    other.esNuevo == esNuevo &&
    other.perfilCompleto == perfilCompleto;

  @override
  int get hashCode =>
    (accessToken.hashCode) +
    (refreshToken.hashCode) +
    (esNuevo.hashCode) +
    (perfilCompleto.hashCode);

  @override
  String toString() => 'SessionResponse[accessToken=$accessToken, refreshToken=$refreshToken, esNuevo=$esNuevo, perfilCompleto=$perfilCompleto]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'accessToken'] = this.accessToken;
      json[r'refreshToken'] = this.refreshToken;
      json[r'esNuevo'] = this.esNuevo;
      json[r'perfilCompleto'] = this.perfilCompleto;
    return json;
  }

  /// Returns a new [SessionResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static SessionResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'accessToken'), 'Required key "SessionResponse[accessToken]" is missing from JSON.');
        assert(json[r'accessToken'] != null, 'Required key "SessionResponse[accessToken]" has a null value in JSON.');
        assert(json.containsKey(r'refreshToken'), 'Required key "SessionResponse[refreshToken]" is missing from JSON.');
        assert(json[r'refreshToken'] != null, 'Required key "SessionResponse[refreshToken]" has a null value in JSON.');
        assert(json.containsKey(r'esNuevo'), 'Required key "SessionResponse[esNuevo]" is missing from JSON.');
        assert(json[r'esNuevo'] != null, 'Required key "SessionResponse[esNuevo]" has a null value in JSON.');
        assert(json.containsKey(r'perfilCompleto'), 'Required key "SessionResponse[perfilCompleto]" is missing from JSON.');
        assert(json[r'perfilCompleto'] != null, 'Required key "SessionResponse[perfilCompleto]" has a null value in JSON.');
        return true;
      }());

      return SessionResponse(
        accessToken: mapValueOfType<String>(json, r'accessToken')!,
        refreshToken: mapValueOfType<String>(json, r'refreshToken')!,
        esNuevo: mapValueOfType<bool>(json, r'esNuevo')!,
        perfilCompleto: mapValueOfType<bool>(json, r'perfilCompleto')!,
      );
    }
    return null;
  }

  static List<SessionResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SessionResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SessionResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SessionResponse> mapFromJson(dynamic json) {
    final map = <String, SessionResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = SessionResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SessionResponse-objects as value to a dart map
  static Map<String, List<SessionResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SessionResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SessionResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'accessToken',
    'refreshToken',
    'esNuevo',
    'perfilCompleto',
  };
}

