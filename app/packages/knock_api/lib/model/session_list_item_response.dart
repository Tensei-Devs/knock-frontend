//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class SessionListItemResponse {
  /// Returns a new [SessionListItemResponse] instance.
  SessionListItemResponse({
    required this.id,
    required this.dispositivo,
    required this.ultimaActividad,
    required this.actual,
  });

  String id;

  String dispositivo;

  DateTime ultimaActividad;

  bool actual;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SessionListItemResponse &&
    other.id == id &&
    other.dispositivo == dispositivo &&
    other.ultimaActividad == ultimaActividad &&
    other.actual == actual;

  @override
  int get hashCode =>
    (id.hashCode) +
    (dispositivo.hashCode) +
    (ultimaActividad.hashCode) +
    (actual.hashCode);

  @override
  String toString() => 'SessionListItemResponse[id=$id, dispositivo=$dispositivo, ultimaActividad=$ultimaActividad, actual=$actual]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'dispositivo'] = this.dispositivo;
      json[r'ultimaActividad'] = this.ultimaActividad.toUtc().toIso8601String();
      json[r'actual'] = this.actual;
    return json;
  }

  /// Returns a new [SessionListItemResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static SessionListItemResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "SessionListItemResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "SessionListItemResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'dispositivo'), 'Required key "SessionListItemResponse[dispositivo]" is missing from JSON.');
        assert(json[r'dispositivo'] != null, 'Required key "SessionListItemResponse[dispositivo]" has a null value in JSON.');
        assert(json.containsKey(r'ultimaActividad'), 'Required key "SessionListItemResponse[ultimaActividad]" is missing from JSON.');
        assert(json[r'ultimaActividad'] != null, 'Required key "SessionListItemResponse[ultimaActividad]" has a null value in JSON.');
        assert(json.containsKey(r'actual'), 'Required key "SessionListItemResponse[actual]" is missing from JSON.');
        assert(json[r'actual'] != null, 'Required key "SessionListItemResponse[actual]" has a null value in JSON.');
        return true;
      }());

      return SessionListItemResponse(
        id: mapValueOfType<String>(json, r'id')!,
        dispositivo: mapValueOfType<String>(json, r'dispositivo')!,
        ultimaActividad: mapDateTime(json, r'ultimaActividad', r'')!,
        actual: mapValueOfType<bool>(json, r'actual')!,
      );
    }
    return null;
  }

  static List<SessionListItemResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SessionListItemResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SessionListItemResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SessionListItemResponse> mapFromJson(dynamic json) {
    final map = <String, SessionListItemResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = SessionListItemResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SessionListItemResponse-objects as value to a dart map
  static Map<String, List<SessionListItemResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SessionListItemResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SessionListItemResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'dispositivo',
    'ultimaActividad',
    'actual',
  };
}

