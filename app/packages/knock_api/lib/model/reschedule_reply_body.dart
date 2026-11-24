//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RescheduleReplyBody {
  /// Returns a new [RescheduleReplyBody] instance.
  RescheduleReplyBody({
    required this.acepta,
  });

  bool? acepta;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RescheduleReplyBody &&
    other.acepta == acepta;

  @override
  int get hashCode =>
    (acepta == null ? 0 : acepta!.hashCode);

  @override
  String toString() => 'RescheduleReplyBody[acepta=$acepta]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.acepta != null) {
      json[r'acepta'] = this.acepta;
    } else {
      json[r'acepta'] = null;
    }
    return json;
  }

  /// Returns a new [RescheduleReplyBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RescheduleReplyBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'acepta'), 'Required key "RescheduleReplyBody[acepta]" is missing from JSON.');
        return true;
      }());

      return RescheduleReplyBody(
        acepta: mapValueOfType<bool>(json, r'acepta'),
      );
    }
    return null;
  }

  static List<RescheduleReplyBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RescheduleReplyBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RescheduleReplyBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RescheduleReplyBody> mapFromJson(dynamic json) {
    final map = <String, RescheduleReplyBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RescheduleReplyBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RescheduleReplyBody-objects as value to a dart map
  static Map<String, List<RescheduleReplyBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RescheduleReplyBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RescheduleReplyBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'acepta',
  };
}

