//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class WorkPhotoResponse {
  /// Returns a new [WorkPhotoResponse] instance.
  WorkPhotoResponse({
    required this.id,
    required this.url,
    required this.creadoEn,
  });

  String id;

  String url;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WorkPhotoResponse &&
    other.id == id &&
    other.url == url &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (url.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'WorkPhotoResponse[id=$id, url=$url, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'url'] = this.url;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [WorkPhotoResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static WorkPhotoResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "WorkPhotoResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "WorkPhotoResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'url'), 'Required key "WorkPhotoResponse[url]" is missing from JSON.');
        assert(json[r'url'] != null, 'Required key "WorkPhotoResponse[url]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "WorkPhotoResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "WorkPhotoResponse[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return WorkPhotoResponse(
        id: mapValueOfType<String>(json, r'id')!,
        url: mapValueOfType<String>(json, r'url')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<WorkPhotoResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WorkPhotoResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WorkPhotoResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WorkPhotoResponse> mapFromJson(dynamic json) {
    final map = <String, WorkPhotoResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = WorkPhotoResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WorkPhotoResponse-objects as value to a dart map
  static Map<String, List<WorkPhotoResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WorkPhotoResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WorkPhotoResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'url',
    'creadoEn',
  };
}

