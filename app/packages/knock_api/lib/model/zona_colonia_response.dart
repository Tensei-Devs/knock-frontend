//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ZonaColoniaResponse {
  /// Returns a new [ZonaColoniaResponse] instance.
  ZonaColoniaResponse({
    required this.id,
    required this.nombre,
    required this.cp,
    required this.municipio,
  });

  String id;

  String nombre;

  String cp;

  String municipio;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ZonaColoniaResponse &&
    other.id == id &&
    other.nombre == nombre &&
    other.cp == cp &&
    other.municipio == municipio;

  @override
  int get hashCode =>
    (id.hashCode) +
    (nombre.hashCode) +
    (cp.hashCode) +
    (municipio.hashCode);

  @override
  String toString() => 'ZonaColoniaResponse[id=$id, nombre=$nombre, cp=$cp, municipio=$municipio]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'nombre'] = this.nombre;
      json[r'cp'] = this.cp;
      json[r'municipio'] = this.municipio;
    return json;
  }

  /// Returns a new [ZonaColoniaResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ZonaColoniaResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ZonaColoniaResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ZonaColoniaResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "ZonaColoniaResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "ZonaColoniaResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'cp'), 'Required key "ZonaColoniaResponse[cp]" is missing from JSON.');
        assert(json[r'cp'] != null, 'Required key "ZonaColoniaResponse[cp]" has a null value in JSON.');
        assert(json.containsKey(r'municipio'), 'Required key "ZonaColoniaResponse[municipio]" is missing from JSON.');
        assert(json[r'municipio'] != null, 'Required key "ZonaColoniaResponse[municipio]" has a null value in JSON.');
        return true;
      }());

      return ZonaColoniaResponse(
        id: mapValueOfType<String>(json, r'id')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        cp: mapValueOfType<String>(json, r'cp')!,
        municipio: mapValueOfType<String>(json, r'municipio')!,
      );
    }
    return null;
  }

  static List<ZonaColoniaResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ZonaColoniaResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ZonaColoniaResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ZonaColoniaResponse> mapFromJson(dynamic json) {
    final map = <String, ZonaColoniaResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ZonaColoniaResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ZonaColoniaResponse-objects as value to a dart map
  static Map<String, List<ZonaColoniaResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ZonaColoniaResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ZonaColoniaResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'nombre',
    'cp',
    'municipio',
  };
}

