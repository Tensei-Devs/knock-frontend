//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class WorkPhotoListResponse {
  /// Returns a new [WorkPhotoListResponse] instance.
  WorkPhotoListResponse({
    this.fotos = const [],
    required this.nextCursor,
  });

  List<WorkPhotoResponse> fotos;

  String? nextCursor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WorkPhotoListResponse &&
    _deepEquality.equals(other.fotos, fotos) &&
    other.nextCursor == nextCursor;

  @override
  int get hashCode =>
    (fotos.hashCode) +
    (nextCursor == null ? 0 : nextCursor!.hashCode);

  @override
  String toString() => 'WorkPhotoListResponse[fotos=$fotos, nextCursor=$nextCursor]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fotos'] = this.fotos;
    if (this.nextCursor != null) {
      json[r'nextCursor'] = this.nextCursor;
    } else {
      json[r'nextCursor'] = null;
    }
    return json;
  }

  /// Returns a new [WorkPhotoListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static WorkPhotoListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'fotos'), 'Required key "WorkPhotoListResponse[fotos]" is missing from JSON.');
        assert(json[r'fotos'] != null, 'Required key "WorkPhotoListResponse[fotos]" has a null value in JSON.');
        assert(json.containsKey(r'nextCursor'), 'Required key "WorkPhotoListResponse[nextCursor]" is missing from JSON.');
        return true;
      }());

      return WorkPhotoListResponse(
        fotos: WorkPhotoResponse.listFromJson(json[r'fotos']),
        nextCursor: mapValueOfType<String>(json, r'nextCursor'),
      );
    }
    return null;
  }

  static List<WorkPhotoListResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WorkPhotoListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WorkPhotoListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WorkPhotoListResponse> mapFromJson(dynamic json) {
    final map = <String, WorkPhotoListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = WorkPhotoListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WorkPhotoListResponse-objects as value to a dart map
  static Map<String, List<WorkPhotoListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WorkPhotoListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WorkPhotoListResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fotos',
    'nextCursor',
  };
}

