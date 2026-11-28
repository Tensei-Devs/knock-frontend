//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TradeRequestGroup {
  /// Returns a new [TradeRequestGroup] instance.
  TradeRequestGroup({
    required this.texto,
    required this.cantidad,
  });

  String texto;

  int cantidad;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TradeRequestGroup &&
    other.texto == texto &&
    other.cantidad == cantidad;

  @override
  int get hashCode =>
    (texto.hashCode) +
    (cantidad.hashCode);

  @override
  String toString() => 'TradeRequestGroup[texto=$texto, cantidad=$cantidad]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'texto'] = this.texto;
      json[r'cantidad'] = this.cantidad;
    return json;
  }

  /// Returns a new [TradeRequestGroup] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TradeRequestGroup? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'texto'), 'Required key "TradeRequestGroup[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "TradeRequestGroup[texto]" has a null value in JSON.');
        assert(json.containsKey(r'cantidad'), 'Required key "TradeRequestGroup[cantidad]" is missing from JSON.');
        assert(json[r'cantidad'] != null, 'Required key "TradeRequestGroup[cantidad]" has a null value in JSON.');
        return true;
      }());

      return TradeRequestGroup(
        texto: mapValueOfType<String>(json, r'texto')!,
        cantidad: mapValueOfType<int>(json, r'cantidad')!,
      );
    }
    return null;
  }

  static List<TradeRequestGroup> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TradeRequestGroup>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TradeRequestGroup.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TradeRequestGroup> mapFromJson(dynamic json) {
    final map = <String, TradeRequestGroup>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TradeRequestGroup.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TradeRequestGroup-objects as value to a dart map
  static Map<String, List<TradeRequestGroup>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TradeRequestGroup>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TradeRequestGroup.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'texto',
    'cantidad',
  };
}

