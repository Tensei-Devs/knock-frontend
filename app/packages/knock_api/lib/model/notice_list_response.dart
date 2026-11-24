//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NoticeListResponse {
  /// Returns a new [NoticeListResponse] instance.
  NoticeListResponse({
    this.items = const [],
    required this.siguienteCursor,
  });

  List<NoticeResponse> items;

  String? siguienteCursor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NoticeListResponse &&
    _deepEquality.equals(other.items, items) &&
    other.siguienteCursor == siguienteCursor;

  @override
  int get hashCode =>
    (items.hashCode) +
    (siguienteCursor == null ? 0 : siguienteCursor!.hashCode);

  @override
  String toString() => 'NoticeListResponse[items=$items, siguienteCursor=$siguienteCursor]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
    if (this.siguienteCursor != null) {
      json[r'siguienteCursor'] = this.siguienteCursor;
    } else {
      json[r'siguienteCursor'] = null;
    }
    return json;
  }

  /// Returns a new [NoticeListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NoticeListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "NoticeListResponse[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "NoticeListResponse[items]" has a null value in JSON.');
        assert(json.containsKey(r'siguienteCursor'), 'Required key "NoticeListResponse[siguienteCursor]" is missing from JSON.');
        return true;
      }());

      return NoticeListResponse(
        items: NoticeResponse.listFromJson(json[r'items']),
        siguienteCursor: mapValueOfType<String>(json, r'siguienteCursor'),
      );
    }
    return null;
  }

  static List<NoticeListResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NoticeListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NoticeListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NoticeListResponse> mapFromJson(dynamic json) {
    final map = <String, NoticeListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NoticeListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NoticeListResponse-objects as value to a dart map
  static Map<String, List<NoticeListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NoticeListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NoticeListResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
    'siguienteCursor',
  };
}

