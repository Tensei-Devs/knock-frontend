//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ItemResponse {
  /// Returns a new [ItemResponse] instance.
  ItemResponse({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.anio,
    required this.creadoEn,
  });

  String id;

  String tipo;

  String nombre;

  int? anio;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ItemResponse &&
    other.id == id &&
    other.tipo == tipo &&
    other.nombre == nombre &&
    other.anio == anio &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (tipo.hashCode) +
    (nombre.hashCode) +
    (anio == null ? 0 : anio!.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'ItemResponse[id=$id, tipo=$tipo, nombre=$nombre, anio=$anio, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'tipo'] = this.tipo;
      json[r'nombre'] = this.nombre;
    if (this.anio != null) {
      json[r'anio'] = this.anio;
    } else {
      json[r'anio'] = null;
    }
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ItemResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ItemResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ItemResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ItemResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "ItemResponse[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "ItemResponse[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "ItemResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "ItemResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'anio'), 'Required key "ItemResponse[anio]" is missing from JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "ItemResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "ItemResponse[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return ItemResponse(
        id: mapValueOfType<String>(json, r'id')!,
        tipo: mapValueOfType<String>(json, r'tipo')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        anio: mapValueOfType<int>(json, r'anio'),
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<ItemResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ItemResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ItemResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ItemResponse> mapFromJson(dynamic json) {
    final map = <String, ItemResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ItemResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ItemResponse-objects as value to a dart map
  static Map<String, List<ItemResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ItemResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ItemResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'tipo',
    'nombre',
    'anio',
    'creadoEn',
  };
}

