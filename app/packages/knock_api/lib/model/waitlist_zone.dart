//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class WaitlistZone {
  /// Returns a new [WaitlistZone] instance.
  WaitlistZone({
    required this.codigoPostal,
    required this.cantidad,
  });

  String codigoPostal;

  int cantidad;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WaitlistZone &&
    other.codigoPostal == codigoPostal &&
    other.cantidad == cantidad;

  @override
  int get hashCode =>
    (codigoPostal.hashCode) +
    (cantidad.hashCode);

  @override
  String toString() => 'WaitlistZone[codigoPostal=$codigoPostal, cantidad=$cantidad]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'codigoPostal'] = this.codigoPostal;
      json[r'cantidad'] = this.cantidad;
    return json;
  }

  /// Returns a new [WaitlistZone] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static WaitlistZone? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'codigoPostal'), 'Required key "WaitlistZone[codigoPostal]" is missing from JSON.');
        assert(json[r'codigoPostal'] != null, 'Required key "WaitlistZone[codigoPostal]" has a null value in JSON.');
        assert(json.containsKey(r'cantidad'), 'Required key "WaitlistZone[cantidad]" is missing from JSON.');
        assert(json[r'cantidad'] != null, 'Required key "WaitlistZone[cantidad]" has a null value in JSON.');
        return true;
      }());

      return WaitlistZone(
        codigoPostal: mapValueOfType<String>(json, r'codigoPostal')!,
        cantidad: mapValueOfType<int>(json, r'cantidad')!,
      );
    }
    return null;
  }

  static List<WaitlistZone> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WaitlistZone>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WaitlistZone.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WaitlistZone> mapFromJson(dynamic json) {
    final map = <String, WaitlistZone>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = WaitlistZone.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WaitlistZone-objects as value to a dart map
  static Map<String, List<WaitlistZone>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WaitlistZone>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WaitlistZone.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'codigoPostal',
    'cantidad',
  };
}

