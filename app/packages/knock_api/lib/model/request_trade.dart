//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RequestTrade {
  /// Returns a new [RequestTrade] instance.
  RequestTrade({
    required this.clave,
    required this.nombre,
  });

  String clave;

  String nombre;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RequestTrade &&
    other.clave == clave &&
    other.nombre == nombre;

  @override
  int get hashCode =>
    (clave.hashCode) +
    (nombre.hashCode);

  @override
  String toString() => 'RequestTrade[clave=$clave, nombre=$nombre]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'clave'] = this.clave;
      json[r'nombre'] = this.nombre;
    return json;
  }

  /// Returns a new [RequestTrade] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RequestTrade? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'clave'), 'Required key "RequestTrade[clave]" is missing from JSON.');
        assert(json[r'clave'] != null, 'Required key "RequestTrade[clave]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "RequestTrade[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "RequestTrade[nombre]" has a null value in JSON.');
        return true;
      }());

      return RequestTrade(
        clave: mapValueOfType<String>(json, r'clave')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
      );
    }
    return null;
  }

  static List<RequestTrade> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RequestTrade>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestTrade.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RequestTrade> mapFromJson(dynamic json) {
    final map = <String, RequestTrade>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RequestTrade.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RequestTrade-objects as value to a dart map
  static Map<String, List<RequestTrade>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RequestTrade>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RequestTrade.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'clave',
    'nombre',
  };
}

