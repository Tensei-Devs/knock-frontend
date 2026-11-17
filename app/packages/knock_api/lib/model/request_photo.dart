//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RequestPhoto {
  /// Returns a new [RequestPhoto] instance.
  RequestPhoto({
    required this.id,
    required this.url,
    required this.venceEn,
  });

  String id;

  String url;

  DateTime venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RequestPhoto &&
    other.id == id &&
    other.url == url &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (url.hashCode) +
    (venceEn.hashCode);

  @override
  String toString() => 'RequestPhoto[id=$id, url=$url, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'url'] = this.url;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [RequestPhoto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RequestPhoto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RequestPhoto[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RequestPhoto[id]" has a null value in JSON.');
        assert(json.containsKey(r'url'), 'Required key "RequestPhoto[url]" is missing from JSON.');
        assert(json[r'url'] != null, 'Required key "RequestPhoto[url]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "RequestPhoto[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "RequestPhoto[venceEn]" has a null value in JSON.');
        return true;
      }());

      return RequestPhoto(
        id: mapValueOfType<String>(json, r'id')!,
        url: mapValueOfType<String>(json, r'url')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
      );
    }
    return null;
  }

  static List<RequestPhoto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RequestPhoto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestPhoto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RequestPhoto> mapFromJson(dynamic json) {
    final map = <String, RequestPhoto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RequestPhoto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RequestPhoto-objects as value to a dart map
  static Map<String, List<RequestPhoto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RequestPhoto>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RequestPhoto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'url',
    'venceEn',
  };
}

