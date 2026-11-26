//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AgendaResponse {
  /// Returns a new [AgendaResponse] instance.
  AgendaResponse({
    this.items = const [],
    required this.nextCursor,
  });

  List<AgendaItem> items;

  String? nextCursor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AgendaResponse &&
    _deepEquality.equals(other.items, items) &&
    other.nextCursor == nextCursor;

  @override
  int get hashCode =>
    (items.hashCode) +
    (nextCursor == null ? 0 : nextCursor!.hashCode);

  @override
  String toString() => 'AgendaResponse[items=$items, nextCursor=$nextCursor]';

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

  /// Returns a new [AgendaResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AgendaResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "AgendaResponse[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "AgendaResponse[items]" has a null value in JSON.');
        assert(json.containsKey(r'nextCursor'), 'Required key "AgendaResponse[nextCursor]" is missing from JSON.');
        return true;
      }());

      return AgendaResponse(
        items: AgendaItem.listFromJson(json[r'items']),
        nextCursor: mapValueOfType<String>(json, r'nextCursor'),
      );
    }
    return null;
  }

  static List<AgendaResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AgendaResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AgendaResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AgendaResponse> mapFromJson(dynamic json) {
    final map = <String, AgendaResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AgendaResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AgendaResponse-objects as value to a dart map
  static Map<String, List<AgendaResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AgendaResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AgendaResponse.listFromJson(entry.value, growable: growable,);
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

