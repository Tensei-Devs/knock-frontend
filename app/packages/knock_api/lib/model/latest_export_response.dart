//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class LatestExportResponse {
  /// Returns a new [LatestExportResponse] instance.
  LatestExportResponse({
    required this.estado,
    required this.enlace,
    required this.venceEn,
  });

  String estado;

  String? enlace;

  DateTime? venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LatestExportResponse &&
    other.estado == estado &&
    other.enlace == enlace &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (estado.hashCode) +
    (enlace == null ? 0 : enlace!.hashCode) +
    (venceEn == null ? 0 : venceEn!.hashCode);

  @override
  String toString() => 'LatestExportResponse[estado=$estado, enlace=$enlace, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'estado'] = this.estado;
    if (this.enlace != null) {
      json[r'enlace'] = this.enlace;
    } else {
      json[r'enlace'] = null;
    }
    if (this.venceEn != null) {
      json[r'venceEn'] = this.venceEn!.toUtc().toIso8601String();
    } else {
      json[r'venceEn'] = null;
    }
    return json;
  }

  /// Returns a new [LatestExportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static LatestExportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'estado'), 'Required key "LatestExportResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "LatestExportResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'enlace'), 'Required key "LatestExportResponse[enlace]" is missing from JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "LatestExportResponse[venceEn]" is missing from JSON.');
        return true;
      }());

      return LatestExportResponse(
        estado: mapValueOfType<String>(json, r'estado')!,
        enlace: mapValueOfType<String>(json, r'enlace'),
        venceEn: mapDateTime(json, r'venceEn', r''),
      );
    }
    return null;
  }

  static List<LatestExportResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LatestExportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LatestExportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LatestExportResponse> mapFromJson(dynamic json) {
    final map = <String, LatestExportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = LatestExportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LatestExportResponse-objects as value to a dart map
  static Map<String, List<LatestExportResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LatestExportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LatestExportResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'estado',
    'enlace',
    'venceEn',
  };
}

