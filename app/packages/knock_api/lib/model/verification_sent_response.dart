//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationSentResponse {
  /// Returns a new [VerificationSentResponse] instance.
  VerificationSentResponse({
    required this.id,
    required this.estado,
    required this.enviadoEn,
    required this.expiraEn,
  });

  String id;

  String estado;

  DateTime enviadoEn;

  DateTime expiraEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationSentResponse &&
    other.id == id &&
    other.estado == estado &&
    other.enviadoEn == enviadoEn &&
    other.expiraEn == expiraEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (enviadoEn.hashCode) +
    (expiraEn.hashCode);

  @override
  String toString() => 'VerificationSentResponse[id=$id, estado=$estado, enviadoEn=$enviadoEn, expiraEn=$expiraEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
      json[r'enviadoEn'] = this.enviadoEn.toUtc().toIso8601String();
      json[r'expiraEn'] = this.expiraEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [VerificationSentResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationSentResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "VerificationSentResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "VerificationSentResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "VerificationSentResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "VerificationSentResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'enviadoEn'), 'Required key "VerificationSentResponse[enviadoEn]" is missing from JSON.');
        assert(json[r'enviadoEn'] != null, 'Required key "VerificationSentResponse[enviadoEn]" has a null value in JSON.');
        assert(json.containsKey(r'expiraEn'), 'Required key "VerificationSentResponse[expiraEn]" is missing from JSON.');
        assert(json[r'expiraEn'] != null, 'Required key "VerificationSentResponse[expiraEn]" has a null value in JSON.');
        return true;
      }());

      return VerificationSentResponse(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        enviadoEn: mapDateTime(json, r'enviadoEn', r'')!,
        expiraEn: mapDateTime(json, r'expiraEn', r'')!,
      );
    }
    return null;
  }

  static List<VerificationSentResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationSentResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationSentResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationSentResponse> mapFromJson(dynamic json) {
    final map = <String, VerificationSentResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationSentResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationSentResponse-objects as value to a dart map
  static Map<String, List<VerificationSentResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationSentResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationSentResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'enviadoEn',
    'expiraEn',
  };
}

