//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ConversacionBody {
  /// Returns a new [ConversacionBody] instance.
  ConversacionBody({
    required this.conversacionId,
  });

  String? conversacionId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversacionBody &&
    other.conversacionId == conversacionId;

  @override
  int get hashCode =>
    (conversacionId == null ? 0 : conversacionId!.hashCode);

  @override
  String toString() => 'ConversacionBody[conversacionId=$conversacionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.conversacionId != null) {
      json[r'conversacionId'] = this.conversacionId;
    } else {
      json[r'conversacionId'] = null;
    }
    return json;
  }

  /// Returns a new [ConversacionBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ConversacionBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'conversacionId'), 'Required key "ConversacionBody[conversacionId]" is missing from JSON.');
        return true;
      }());

      return ConversacionBody(
        conversacionId: mapValueOfType<String>(json, r'conversacionId'),
      );
    }
    return null;
  }

  static List<ConversacionBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversacionBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversacionBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversacionBody> mapFromJson(dynamic json) {
    final map = <String, ConversacionBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ConversacionBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversacionBody-objects as value to a dart map
  static Map<String, List<ConversacionBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversacionBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversacionBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'conversacionId',
  };
}

