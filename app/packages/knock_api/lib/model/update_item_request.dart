//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UpdateItemRequest {
  /// Returns a new [UpdateItemRequest] instance.
  UpdateItemRequest({
    this.tipo,
    this.nombre,
    this.anio,
  });

  String? tipo;

  String? nombre;

  int? anio;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateItemRequest &&
    other.tipo == tipo &&
    other.nombre == nombre &&
    other.anio == anio;

  @override
  int get hashCode =>
    (tipo == null ? 0 : tipo!.hashCode) +
    (nombre == null ? 0 : nombre!.hashCode) +
    (anio == null ? 0 : anio!.hashCode);

  @override
  String toString() => 'UpdateItemRequest[tipo=$tipo, nombre=$nombre, anio=$anio]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.tipo != null) {
      json[r'tipo'] = this.tipo;
    } else {
      json[r'tipo'] = null;
    }
    if (this.nombre != null) {
      json[r'nombre'] = this.nombre;
    } else {
      json[r'nombre'] = null;
    }
    if (this.anio != null) {
      json[r'anio'] = this.anio;
    } else {
      json[r'anio'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateItemRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UpdateItemRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return UpdateItemRequest(
        tipo: mapValueOfType<String>(json, r'tipo'),
        nombre: mapValueOfType<String>(json, r'nombre'),
        anio: mapValueOfType<int>(json, r'anio'),
      );
    }
    return null;
  }

  static List<UpdateItemRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateItemRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateItemRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateItemRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateItemRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UpdateItemRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateItemRequest-objects as value to a dart map
  static Map<String, List<UpdateItemRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateItemRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateItemRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

