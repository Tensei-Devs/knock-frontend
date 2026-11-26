//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReportQueuePage {
  /// Returns a new [ReportQueuePage] instance.
  ReportQueuePage({
    this.items = const [],
    required this.nextCursor,
  });

  List<ReportQueueItem> items;

  String? nextCursor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportQueuePage &&
    _deepEquality.equals(other.items, items) &&
    other.nextCursor == nextCursor;

  @override
  int get hashCode =>
    (items.hashCode) +
    (nextCursor == null ? 0 : nextCursor!.hashCode);

  @override
  String toString() => 'ReportQueuePage[items=$items, nextCursor=$nextCursor]';

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

  /// Returns a new [ReportQueuePage] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReportQueuePage? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "ReportQueuePage[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "ReportQueuePage[items]" has a null value in JSON.');
        assert(json.containsKey(r'nextCursor'), 'Required key "ReportQueuePage[nextCursor]" is missing from JSON.');
        return true;
      }());

      return ReportQueuePage(
        items: ReportQueueItem.listFromJson(json[r'items']),
        nextCursor: mapValueOfType<String>(json, r'nextCursor'),
      );
    }
    return null;
  }

  static List<ReportQueuePage> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportQueuePage>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportQueuePage.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportQueuePage> mapFromJson(dynamic json) {
    final map = <String, ReportQueuePage>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReportQueuePage.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportQueuePage-objects as value to a dart map
  static Map<String, List<ReportQueuePage>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportQueuePage>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportQueuePage.listFromJson(entry.value, growable: growable,);
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

