//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PhotoConfirmedResponse {
  /// Returns a new [PhotoConfirmedResponse] instance.
  PhotoConfirmedResponse({
    required this.tipo,
    required this.estado,
  });

  String tipo;

  String estado;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PhotoConfirmedResponse &&
    other.tipo == tipo &&
    other.estado == estado;

  @override
  int get hashCode =>
    (tipo.hashCode) +
    (estado.hashCode);

  @override
  String toString() => 'PhotoConfirmedResponse[tipo=$tipo, estado=$estado]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tipo'] = this.tipo;
      json[r'estado'] = this.estado;
    return json;
  }

  /// Returns a new [PhotoConfirmedResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PhotoConfirmedResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipo'), 'Required key "PhotoConfirmedResponse[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "PhotoConfirmedResponse[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "PhotoConfirmedResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "PhotoConfirmedResponse[estado]" has a null value in JSON.');
        return true;
      }());

      return PhotoConfirmedResponse(
        tipo: mapValueOfType<String>(json, r'tipo')!,
        estado: mapValueOfType<String>(json, r'estado')!,
      );
    }
    return null;
  }

  static List<PhotoConfirmedResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PhotoConfirmedResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PhotoConfirmedResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PhotoConfirmedResponse> mapFromJson(dynamic json) {
    final map = <String, PhotoConfirmedResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PhotoConfirmedResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PhotoConfirmedResponse-objects as value to a dart map
  static Map<String, List<PhotoConfirmedResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PhotoConfirmedResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PhotoConfirmedResponse.listFromJson(entry.value, growable: growable,);
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

