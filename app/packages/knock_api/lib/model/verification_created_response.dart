//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationCreatedResponse {
  /// Returns a new [VerificationCreatedResponse] instance.
  VerificationCreatedResponse({
    required this.id,
    required this.estado,
    required this.nivel,
    this.fotos = const [],
    required this.capturaVenceEn,
  });

  String id;

  String estado;

  String nivel;

  List<VerificationPhotoResponse> fotos;

  DateTime capturaVenceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationCreatedResponse &&
    other.id == id &&
    other.estado == estado &&
    other.nivel == nivel &&
    _deepEquality.equals(other.fotos, fotos) &&
    other.capturaVenceEn == capturaVenceEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (nivel.hashCode) +
    (fotos.hashCode) +
    (capturaVenceEn.hashCode);

  @override
  String toString() => 'VerificationCreatedResponse[id=$id, estado=$estado, nivel=$nivel, fotos=$fotos, capturaVenceEn=$capturaVenceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
      json[r'nivel'] = this.nivel;
      json[r'fotos'] = this.fotos;
      json[r'capturaVenceEn'] = this.capturaVenceEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [VerificationCreatedResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationCreatedResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "VerificationCreatedResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "VerificationCreatedResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "VerificationCreatedResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "VerificationCreatedResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'nivel'), 'Required key "VerificationCreatedResponse[nivel]" is missing from JSON.');
        assert(json[r'nivel'] != null, 'Required key "VerificationCreatedResponse[nivel]" has a null value in JSON.');
        assert(json.containsKey(r'fotos'), 'Required key "VerificationCreatedResponse[fotos]" is missing from JSON.');
        assert(json[r'fotos'] != null, 'Required key "VerificationCreatedResponse[fotos]" has a null value in JSON.');
        assert(json.containsKey(r'capturaVenceEn'), 'Required key "VerificationCreatedResponse[capturaVenceEn]" is missing from JSON.');
        assert(json[r'capturaVenceEn'] != null, 'Required key "VerificationCreatedResponse[capturaVenceEn]" has a null value in JSON.');
        return true;
      }());

      return VerificationCreatedResponse(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        nivel: mapValueOfType<String>(json, r'nivel')!,
        fotos: VerificationPhotoResponse.listFromJson(json[r'fotos']),
        capturaVenceEn: mapDateTime(json, r'capturaVenceEn', r'')!,
      );
    }
    return null;
  }

  static List<VerificationCreatedResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationCreatedResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationCreatedResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationCreatedResponse> mapFromJson(dynamic json) {
    final map = <String, VerificationCreatedResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationCreatedResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationCreatedResponse-objects as value to a dart map
  static Map<String, List<VerificationCreatedResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationCreatedResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationCreatedResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'nivel',
    'fotos',
    'capturaVenceEn',
  };
}

