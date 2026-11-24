//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AnswerReviewBody {
  /// Returns a new [AnswerReviewBody] instance.
  AnswerReviewBody({
    required this.texto,
  });

  String? texto;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnswerReviewBody &&
    other.texto == texto;

  @override
  int get hashCode =>
    (texto == null ? 0 : texto!.hashCode);

  @override
  String toString() => 'AnswerReviewBody[texto=$texto]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.texto != null) {
      json[r'texto'] = this.texto;
    } else {
      json[r'texto'] = null;
    }
    return json;
  }

  /// Returns a new [AnswerReviewBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AnswerReviewBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'texto'), 'Required key "AnswerReviewBody[texto]" is missing from JSON.');
        return true;
      }());

      return AnswerReviewBody(
        texto: mapValueOfType<String>(json, r'texto'),
      );
    }
    return null;
  }

  static List<AnswerReviewBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnswerReviewBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnswerReviewBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnswerReviewBody> mapFromJson(dynamic json) {
    final map = <String, AnswerReviewBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AnswerReviewBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnswerReviewBody-objects as value to a dart map
  static Map<String, List<AnswerReviewBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnswerReviewBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnswerReviewBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'texto',
  };
}

