//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PhotoPermissionBody {
  /// Returns a new [PhotoPermissionBody] instance.
  PhotoPermissionBody({
    required this.permiso,
  });

  bool? permiso;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PhotoPermissionBody &&
    other.permiso == permiso;

  @override
  int get hashCode =>
    (permiso == null ? 0 : permiso!.hashCode);

  @override
  String toString() => 'PhotoPermissionBody[permiso=$permiso]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.permiso != null) {
      json[r'permiso'] = this.permiso;
    } else {
      json[r'permiso'] = null;
    }
    return json;
  }

  /// Returns a new [PhotoPermissionBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PhotoPermissionBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'permiso'), 'Required key "PhotoPermissionBody[permiso]" is missing from JSON.');
        return true;
      }());

      return PhotoPermissionBody(
        permiso: mapValueOfType<bool>(json, r'permiso'),
      );
    }
    return null;
  }

  static List<PhotoPermissionBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PhotoPermissionBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PhotoPermissionBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PhotoPermissionBody> mapFromJson(dynamic json) {
    final map = <String, PhotoPermissionBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PhotoPermissionBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PhotoPermissionBody-objects as value to a dart map
  static Map<String, List<PhotoPermissionBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PhotoPermissionBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PhotoPermissionBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'permiso',
  };
}

