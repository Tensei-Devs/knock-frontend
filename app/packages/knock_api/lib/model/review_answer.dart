//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReviewAnswer {
  /// Returns a new [ReviewAnswer] instance.
  ReviewAnswer({
    required this.texto,
    required this.fecha,
  });

  String texto;

  DateTime fecha;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewAnswer &&
    other.texto == texto &&
    other.fecha == fecha;

  @override
  int get hashCode =>
    (texto.hashCode) +
    (fecha.hashCode);

  @override
  String toString() => 'ReviewAnswer[texto=$texto, fecha=$fecha]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'texto'] = this.texto;
      json[r'fecha'] = this.fecha.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ReviewAnswer] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReviewAnswer? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'texto'), 'Required key "ReviewAnswer[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "ReviewAnswer[texto]" has a null value in JSON.');
        assert(json.containsKey(r'fecha'), 'Required key "ReviewAnswer[fecha]" is missing from JSON.');
        assert(json[r'fecha'] != null, 'Required key "ReviewAnswer[fecha]" has a null value in JSON.');
        return true;
      }());

      return ReviewAnswer(
        texto: mapValueOfType<String>(json, r'texto')!,
        fecha: mapDateTime(json, r'fecha', r'')!,
      );
    }
    return null;
  }

  static List<ReviewAnswer> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewAnswer>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewAnswer.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewAnswer> mapFromJson(dynamic json) {
    final map = <String, ReviewAnswer>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReviewAnswer.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewAnswer-objects as value to a dart map
  static Map<String, List<ReviewAnswer>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewAnswer>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewAnswer.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'texto',
    'fecha',
  };
}

