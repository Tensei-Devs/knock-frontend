//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TradeRequestResponse {
  /// Returns a new [TradeRequestResponse] instance.
  TradeRequestResponse({
    required this.id,
    required this.texto,
  });

  String id;

  String texto;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TradeRequestResponse &&
    other.id == id &&
    other.texto == texto;

  @override
  int get hashCode =>
    (id.hashCode) +
    (texto.hashCode);

  @override
  String toString() => 'TradeRequestResponse[id=$id, texto=$texto]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'texto'] = this.texto;
    return json;
  }

  /// Returns a new [TradeRequestResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TradeRequestResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "TradeRequestResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "TradeRequestResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'texto'), 'Required key "TradeRequestResponse[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "TradeRequestResponse[texto]" has a null value in JSON.');
        return true;
      }());

      return TradeRequestResponse(
        id: mapValueOfType<String>(json, r'id')!,
        texto: mapValueOfType<String>(json, r'texto')!,
      );
    }
    return null;
  }

  static List<TradeRequestResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TradeRequestResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TradeRequestResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TradeRequestResponse> mapFromJson(dynamic json) {
    final map = <String, TradeRequestResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TradeRequestResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TradeRequestResponse-objects as value to a dart map
  static Map<String, List<TradeRequestResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TradeRequestResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TradeRequestResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'texto',
  };
}

