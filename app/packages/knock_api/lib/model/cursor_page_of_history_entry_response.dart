//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CursorPageOfHistoryEntryResponse {
  /// Returns a new [CursorPageOfHistoryEntryResponse] instance.
  CursorPageOfHistoryEntryResponse({
    this.items = const [],
    required this.nextCursor,
  });

  /// Elementos de la página, como máximo int PageLimit.Max.
  List<HistoryEntryResponse> items;

  /// Cursor opaco para pedir la página siguiente, o `null` si no hay más.
  String? nextCursor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CursorPageOfHistoryEntryResponse &&
    _deepEquality.equals(other.items, items) &&
    other.nextCursor == nextCursor;

  @override
  int get hashCode =>
    (items.hashCode) +
    (nextCursor == null ? 0 : nextCursor!.hashCode);

  @override
  String toString() => 'CursorPageOfHistoryEntryResponse[items=$items, nextCursor=$nextCursor]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
    if (this.nextCursor != null) {
      json[r'nextCursor'] = this.nextCursor;
    } else {
      json[r'nextCursor'] = null;
    }
    return json;
  }

  /// Returns a new [CursorPageOfHistoryEntryResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CursorPageOfHistoryEntryResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "CursorPageOfHistoryEntryResponse[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "CursorPageOfHistoryEntryResponse[items]" has a null value in JSON.');
        assert(json.containsKey(r'nextCursor'), 'Required key "CursorPageOfHistoryEntryResponse[nextCursor]" is missing from JSON.');
        return true;
      }());

      return CursorPageOfHistoryEntryResponse(
        items: HistoryEntryResponse.listFromJson(json[r'items']),
        nextCursor: mapValueOfType<String>(json, r'nextCursor'),
      );
    }
    return null;
  }

  static List<CursorPageOfHistoryEntryResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CursorPageOfHistoryEntryResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CursorPageOfHistoryEntryResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CursorPageOfHistoryEntryResponse> mapFromJson(dynamic json) {
    final map = <String, CursorPageOfHistoryEntryResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CursorPageOfHistoryEntryResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CursorPageOfHistoryEntryResponse-objects as value to a dart map
  static Map<String, List<CursorPageOfHistoryEntryResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CursorPageOfHistoryEntryResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CursorPageOfHistoryEntryResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
    'nextCursor',
  };
}

