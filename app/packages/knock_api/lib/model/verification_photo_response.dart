//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationPhotoResponse {
  /// Returns a new [VerificationPhotoResponse] instance.
  VerificationPhotoResponse({
    required this.tipo,
    required this.estado,
    required this.urlSubida,
    required this.venceEn,
  });

  String tipo;

  String estado;

  String? urlSubida;

  DateTime? venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationPhotoResponse &&
    other.tipo == tipo &&
    other.estado == estado &&
    other.urlSubida == urlSubida &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (tipo.hashCode) +
    (estado.hashCode) +
    (urlSubida == null ? 0 : urlSubida!.hashCode) +
    (venceEn == null ? 0 : venceEn!.hashCode);

  @override
  String toString() => 'VerificationPhotoResponse[tipo=$tipo, estado=$estado, urlSubida=$urlSubida, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tipo'] = this.tipo;
      json[r'estado'] = this.estado;
    if (this.urlSubida != null) {
      json[r'urlSubida'] = this.urlSubida;
    } else {
      json[r'urlSubida'] = null;
    }
    if (this.venceEn != null) {
      json[r'venceEn'] = this.venceEn!.toUtc().toIso8601String();
    } else {
      json[r'venceEn'] = null;
    }
    return json;
  }

  /// Returns a new [VerificationPhotoResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationPhotoResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipo'), 'Required key "VerificationPhotoResponse[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "VerificationPhotoResponse[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "VerificationPhotoResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "VerificationPhotoResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'urlSubida'), 'Required key "VerificationPhotoResponse[urlSubida]" is missing from JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "VerificationPhotoResponse[venceEn]" is missing from JSON.');
        return true;
      }());

      return VerificationPhotoResponse(
        tipo: mapValueOfType<String>(json, r'tipo')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        urlSubida: mapValueOfType<String>(json, r'urlSubida'),
        venceEn: mapDateTime(json, r'venceEn', r''),
      );
    }
    return null;
  }

  static List<VerificationPhotoResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationPhotoResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationPhotoResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationPhotoResponse> mapFromJson(dynamic json) {
    final map = <String, VerificationPhotoResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationPhotoResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationPhotoResponse-objects as value to a dart map
  static Map<String, List<VerificationPhotoResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationPhotoResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationPhotoResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipo',
    'estado',
    'urlSubida',
    'venceEn',
  };
}

