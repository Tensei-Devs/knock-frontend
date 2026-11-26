//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ImagenConfirmadaResponse {
  /// Returns a new [ImagenConfirmadaResponse] instance.
  ImagenConfirmadaResponse({
    required this.id,
    required this.url,
    required this.ancho,
    required this.alto,
    required this.bytes,
  });

  String? id;

  String url;

  int ancho;

  int alto;

  int bytes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ImagenConfirmadaResponse &&
    other.id == id &&
    other.url == url &&
    other.ancho == ancho &&
    other.alto == alto &&
    other.bytes == bytes;

  @override
  int get hashCode =>
    (id == null ? 0 : id!.hashCode) +
    (url.hashCode) +
    (ancho.hashCode) +
    (alto.hashCode) +
    (bytes.hashCode);

  @override
  String toString() => 'ImagenConfirmadaResponse[id=$id, url=$url, ancho=$ancho, alto=$alto, bytes=$bytes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
      json[r'url'] = this.url;
      json[r'ancho'] = this.ancho;
      json[r'alto'] = this.alto;
      json[r'bytes'] = this.bytes;
    return json;
  }

  /// Returns a new [ImagenConfirmadaResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ImagenConfirmadaResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ImagenConfirmadaResponse[id]" is missing from JSON.');
        assert(json.containsKey(r'url'), 'Required key "ImagenConfirmadaResponse[url]" is missing from JSON.');
        assert(json[r'url'] != null, 'Required key "ImagenConfirmadaResponse[url]" has a null value in JSON.');
        assert(json.containsKey(r'ancho'), 'Required key "ImagenConfirmadaResponse[ancho]" is missing from JSON.');
        assert(json[r'ancho'] != null, 'Required key "ImagenConfirmadaResponse[ancho]" has a null value in JSON.');
        assert(json.containsKey(r'alto'), 'Required key "ImagenConfirmadaResponse[alto]" is missing from JSON.');
        assert(json[r'alto'] != null, 'Required key "ImagenConfirmadaResponse[alto]" has a null value in JSON.');
        assert(json.containsKey(r'bytes'), 'Required key "ImagenConfirmadaResponse[bytes]" is missing from JSON.');
        assert(json[r'bytes'] != null, 'Required key "ImagenConfirmadaResponse[bytes]" has a null value in JSON.');
        return true;
      }());

      return ImagenConfirmadaResponse(
        id: mapValueOfType<String>(json, r'id'),
        url: mapValueOfType<String>(json, r'url')!,
        ancho: mapValueOfType<int>(json, r'ancho')!,
        alto: mapValueOfType<int>(json, r'alto')!,
        bytes: mapValueOfType<int>(json, r'bytes')!,
      );
    }
    return null;
  }

  static List<ImagenConfirmadaResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ImagenConfirmadaResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ImagenConfirmadaResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ImagenConfirmadaResponse> mapFromJson(dynamic json) {
    final map = <String, ImagenConfirmadaResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ImagenConfirmadaResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ImagenConfirmadaResponse-objects as value to a dart map
  static Map<String, List<ImagenConfirmadaResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ImagenConfirmadaResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ImagenConfirmadaResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'url',
    'ancho',
    'alto',
    'bytes',
  };
}

