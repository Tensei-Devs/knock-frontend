//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReviewPage {
  /// Returns a new [ReviewPage] instance.
  ReviewPage({
    this.items = const [],
    required this.resumen,
    required this.nextCursor,
  });

  List<ReviewItem> items;

  ReviewSummary resumen;

  String? nextCursor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewPage &&
    _deepEquality.equals(other.items, items) &&
    other.resumen == resumen &&
    other.nextCursor == nextCursor;

  @override
  int get hashCode =>
    (items.hashCode) +
    (resumen.hashCode) +
    (nextCursor == null ? 0 : nextCursor!.hashCode);

  @override
  String toString() => 'ReviewPage[items=$items, resumen=$resumen, nextCursor=$nextCursor]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
      json[r'resumen'] = this.resumen;
    if (this.nextCursor != null) {
      json[r'nextCursor'] = this.nextCursor;
    } else {
      json[r'nextCursor'] = null;
    }
    return json;
  }

  /// Returns a new [ReviewPage] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReviewPage? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "ReviewPage[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "ReviewPage[items]" has a null value in JSON.');
        assert(json.containsKey(r'resumen'), 'Required key "ReviewPage[resumen]" is missing from JSON.');
        assert(json[r'resumen'] != null, 'Required key "ReviewPage[resumen]" has a null value in JSON.');
        assert(json.containsKey(r'nextCursor'), 'Required key "ReviewPage[nextCursor]" is missing from JSON.');
        return true;
      }());

      return ReviewPage(
        items: ReviewItem.listFromJson(json[r'items']),
        resumen: ReviewSummary.fromJson(json[r'resumen'])!,
        nextCursor: mapValueOfType<String>(json, r'nextCursor'),
      );
    }
    return null;
  }

  static List<ReviewPage> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewPage>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewPage.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewPage> mapFromJson(dynamic json) {
    final map = <String, ReviewPage>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReviewPage.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewPage-objects as value to a dart map
  static Map<String, List<ReviewPage>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewPage>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewPage.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
    'resumen',
    'nextCursor',
  };
}

