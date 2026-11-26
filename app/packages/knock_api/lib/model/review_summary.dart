//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReviewSummary {
  /// Returns a new [ReviewSummary] instance.
  ReviewSummary({
    required this.promedio,
    required this.total,
    this.distribucion = const {},
  });

  double? promedio;

  int total;

  Map<String, int> distribucion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewSummary &&
    other.promedio == promedio &&
    other.total == total &&
    _deepEquality.equals(other.distribucion, distribucion);

  @override
  int get hashCode =>
    (promedio == null ? 0 : promedio!.hashCode) +
    (total.hashCode) +
    (distribucion.hashCode);

  @override
  String toString() => 'ReviewSummary[promedio=$promedio, total=$total, distribucion=$distribucion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.promedio != null) {
      json[r'promedio'] = this.promedio;
    } else {
      json[r'promedio'] = null;
    }
      json[r'total'] = this.total;
      json[r'distribucion'] = this.distribucion;
    return json;
  }

  /// Returns a new [ReviewSummary] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReviewSummary? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'promedio'), 'Required key "ReviewSummary[promedio]" is missing from JSON.');
        assert(json.containsKey(r'total'), 'Required key "ReviewSummary[total]" is missing from JSON.');
        assert(json[r'total'] != null, 'Required key "ReviewSummary[total]" has a null value in JSON.');
        assert(json.containsKey(r'distribucion'), 'Required key "ReviewSummary[distribucion]" is missing from JSON.');
        assert(json[r'distribucion'] != null, 'Required key "ReviewSummary[distribucion]" has a null value in JSON.');
        return true;
      }());

      return ReviewSummary(
        promedio: mapValueOfType<double>(json, r'promedio'),
        total: mapValueOfType<int>(json, r'total')!,
        distribucion: mapCastOfType<String, int>(json, r'distribucion')!,
      );
    }
    return null;
  }

  static List<ReviewSummary> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewSummary>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewSummary.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewSummary> mapFromJson(dynamic json) {
    final map = <String, ReviewSummary>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReviewSummary.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewSummary-objects as value to a dart map
  static Map<String, List<ReviewSummary>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewSummary>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewSummary.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'promedio',
    'total',
    'distribucion',
  };
}

