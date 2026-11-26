//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class MapGroup {
  /// Returns a new [MapGroup] instance.
  MapGroup({
    required this.latitud,
    required this.longitud,
    required this.cantidad,
    required this.tecnicoId,
  });

  double latitud;

  double longitud;

  int cantidad;

  String? tecnicoId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapGroup &&
    other.latitud == latitud &&
    other.longitud == longitud &&
    other.cantidad == cantidad &&
    other.tecnicoId == tecnicoId;

  @override
  int get hashCode =>
    (latitud.hashCode) +
    (longitud.hashCode) +
    (cantidad.hashCode) +
    (tecnicoId == null ? 0 : tecnicoId!.hashCode);

  @override
  String toString() => 'MapGroup[latitud=$latitud, longitud=$longitud, cantidad=$cantidad, tecnicoId=$tecnicoId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'latitud'] = this.latitud;
      json[r'longitud'] = this.longitud;
      json[r'cantidad'] = this.cantidad;
    if (this.tecnicoId != null) {
      json[r'tecnicoId'] = this.tecnicoId;
    } else {
      json[r'tecnicoId'] = null;
    }
    return json;
  }

  /// Returns a new [MapGroup] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static MapGroup? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'latitud'), 'Required key "MapGroup[latitud]" is missing from JSON.');
        assert(json[r'latitud'] != null, 'Required key "MapGroup[latitud]" has a null value in JSON.');
        assert(json.containsKey(r'longitud'), 'Required key "MapGroup[longitud]" is missing from JSON.');
        assert(json[r'longitud'] != null, 'Required key "MapGroup[longitud]" has a null value in JSON.');
        assert(json.containsKey(r'cantidad'), 'Required key "MapGroup[cantidad]" is missing from JSON.');
        assert(json[r'cantidad'] != null, 'Required key "MapGroup[cantidad]" has a null value in JSON.');
        assert(json.containsKey(r'tecnicoId'), 'Required key "MapGroup[tecnicoId]" is missing from JSON.');
        return true;
      }());

      return MapGroup(
        latitud: mapValueOfType<double>(json, r'latitud')!,
        longitud: mapValueOfType<double>(json, r'longitud')!,
        cantidad: mapValueOfType<int>(json, r'cantidad')!,
        tecnicoId: mapValueOfType<String>(json, r'tecnicoId'),
      );
    }
    return null;
  }

  static List<MapGroup> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapGroup>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapGroup.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapGroup> mapFromJson(dynamic json) {
    final map = <String, MapGroup>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = MapGroup.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapGroup-objects as value to a dart map
  static Map<String, List<MapGroup>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapGroup>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapGroup.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'latitud',
    'longitud',
    'cantidad',
    'tecnicoId',
  };
}

