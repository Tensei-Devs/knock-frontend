//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class DecisionBody {
  /// Returns a new [DecisionBody] instance.
  DecisionBody({
    required this.decision,
  });

  String? decision;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DecisionBody &&
    other.decision == decision;

  @override
  int get hashCode =>
    (decision == null ? 0 : decision!.hashCode);

  @override
  String toString() => 'DecisionBody[decision=$decision]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.decision != null) {
      json[r'decision'] = this.decision;
    } else {
      json[r'decision'] = null;
    }
    return json;
  }

  /// Returns a new [DecisionBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static DecisionBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'decision'), 'Required key "DecisionBody[decision]" is missing from JSON.');
        return true;
      }());

      return DecisionBody(
        decision: mapValueOfType<String>(json, r'decision'),
      );
    }
    return null;
  }

  static List<DecisionBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DecisionBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DecisionBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DecisionBody> mapFromJson(dynamic json) {
    final map = <String, DecisionBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = DecisionBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DecisionBody-objects as value to a dart map
  static Map<String, List<DecisionBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DecisionBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DecisionBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'decision',
  };
}

