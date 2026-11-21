//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationPhotoStateResponse {
  /// Returns a new [VerificationPhotoStateResponse] instance.
  VerificationPhotoStateResponse({
    required this.tipo,
    required this.estado,
  });

  String tipo;

  String estado;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationPhotoStateResponse &&
    other.tipo == tipo &&
    other.estado == estado;

  @override
  int get hashCode =>
    (tipo.hashCode) +
    (estado.hashCode);

  @override
  String toString() => 'VerificationPhotoStateResponse[tipo=$tipo, estado=$estado]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tipo'] = this.tipo;
      json[r'estado'] = this.estado;
    return json;
  }

  /// Returns a new [VerificationPhotoStateResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationPhotoStateResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipo'), 'Required key "VerificationPhotoStateResponse[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "VerificationPhotoStateResponse[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "VerificationPhotoStateResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "VerificationPhotoStateResponse[estado]" has a null value in JSON.');
        return true;
      }());

      return VerificationPhotoStateResponse(
        tipo: mapValueOfType<String>(json, r'tipo')!,
        estado: mapValueOfType<String>(json, r'estado')!,
      );
    }
    return null;
  }

  static List<VerificationPhotoStateResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationPhotoStateResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationPhotoStateResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationPhotoStateResponse> mapFromJson(dynamic json) {
    final map = <String, VerificationPhotoStateResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationPhotoStateResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationPhotoStateResponse-objects as value to a dart map
  static Map<String, List<VerificationPhotoStateResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationPhotoStateResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationPhotoStateResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipo',
    'estado',
  };
}

