//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PhotoPermissionResponse {
  /// Returns a new [PhotoPermissionResponse] instance.
  PhotoPermissionResponse({
    required this.visitaId,
    required this.permiso,
  });

  String visitaId;

  bool permiso;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PhotoPermissionResponse &&
    other.visitaId == visitaId &&
    other.permiso == permiso;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (permiso.hashCode);

  @override
  String toString() => 'PhotoPermissionResponse[visitaId=$visitaId, permiso=$permiso]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'permiso'] = this.permiso;
    return json;
  }

  /// Returns a new [PhotoPermissionResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PhotoPermissionResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "PhotoPermissionResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "PhotoPermissionResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'permiso'), 'Required key "PhotoPermissionResponse[permiso]" is missing from JSON.');
        assert(json[r'permiso'] != null, 'Required key "PhotoPermissionResponse[permiso]" has a null value in JSON.');
        return true;
      }());

      return PhotoPermissionResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        permiso: mapValueOfType<bool>(json, r'permiso')!,
      );
    }
    return null;
  }

  static List<PhotoPermissionResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PhotoPermissionResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PhotoPermissionResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PhotoPermissionResponse> mapFromJson(dynamic json) {
    final map = <String, PhotoPermissionResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PhotoPermissionResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PhotoPermissionResponse-objects as value to a dart map
  static Map<String, List<PhotoPermissionResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PhotoPermissionResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PhotoPermissionResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'permiso',
  };
}

