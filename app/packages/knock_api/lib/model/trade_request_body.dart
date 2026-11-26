//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TradeRequestBody {
  /// Returns a new [TradeRequestBody] instance.
  TradeRequestBody({
    required this.texto,
  });

  String? texto;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TradeRequestBody &&
    other.texto == texto;

  @override
  int get hashCode =>
    (texto == null ? 0 : texto!.hashCode);

  @override
  String toString() => 'TradeRequestBody[texto=$texto]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.texto != null) {
      json[r'texto'] = this.texto;
    } else {
      json[r'texto'] = null;
    }
    return json;
  }

  /// Returns a new [TradeRequestBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TradeRequestBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'texto'), 'Required key "TradeRequestBody[texto]" is missing from JSON.');
        return true;
      }());

      return TradeRequestBody(
        texto: mapValueOfType<String>(json, r'texto'),
      );
    }
    return null;
  }

  static List<TradeRequestBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TradeRequestBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TradeRequestBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TradeRequestBody> mapFromJson(dynamic json) {
    final map = <String, TradeRequestBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TradeRequestBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TradeRequestBody-objects as value to a dart map
  static Map<String, List<TradeRequestBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TradeRequestBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TradeRequestBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'texto',
  };
}

