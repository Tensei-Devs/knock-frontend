//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NeighborhoodAtPointColoniaResponse {
  /// Returns a new [NeighborhoodAtPointColoniaResponse] instance.
  NeighborhoodAtPointColoniaResponse({
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
  bool operator ==(Object other) => identical(this, other) || other is NeighborhoodAtPointColoniaResponse &&
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
  String toString() => 'NeighborhoodAtPointColoniaResponse[id=$id, nombre=$nombre, cp=$cp, municipio=$municipio]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'nombre'] = this.nombre;
      json[r'cp'] = this.cp;
      json[r'municipio'] = this.municipio;
    return json;
  }

  /// Returns a new [NeighborhoodAtPointColoniaResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NeighborhoodAtPointColoniaResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "NeighborhoodAtPointColoniaResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "NeighborhoodAtPointColoniaResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "NeighborhoodAtPointColoniaResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "NeighborhoodAtPointColoniaResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'cp'), 'Required key "NeighborhoodAtPointColoniaResponse[cp]" is missing from JSON.');
        assert(json[r'cp'] != null, 'Required key "NeighborhoodAtPointColoniaResponse[cp]" has a null value in JSON.');
        assert(json.containsKey(r'municipio'), 'Required key "NeighborhoodAtPointColoniaResponse[municipio]" is missing from JSON.');
        assert(json[r'municipio'] != null, 'Required key "NeighborhoodAtPointColoniaResponse[municipio]" has a null value in JSON.');
        return true;
      }());

      return NeighborhoodAtPointColoniaResponse(
        id: mapValueOfType<String>(json, r'id')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        cp: mapValueOfType<String>(json, r'cp')!,
        municipio: mapValueOfType<String>(json, r'municipio')!,
      );
    }
    return null;
  }

  static List<NeighborhoodAtPointColoniaResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NeighborhoodAtPointColoniaResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NeighborhoodAtPointColoniaResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NeighborhoodAtPointColoniaResponse> mapFromJson(dynamic json) {
    final map = <String, NeighborhoodAtPointColoniaResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NeighborhoodAtPointColoniaResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NeighborhoodAtPointColoniaResponse-objects as value to a dart map
  static Map<String, List<NeighborhoodAtPointColoniaResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NeighborhoodAtPointColoniaResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NeighborhoodAtPointColoniaResponse.listFromJson(entry.value, growable: growable,);
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

