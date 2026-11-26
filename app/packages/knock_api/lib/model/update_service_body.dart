//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UpdateServiceBody {
  /// Returns a new [UpdateServiceBody] instance.
  UpdateServiceBody({
    required this.nombre,
    required this.detalle,
    required this.precioReferencia,
    required this.oficio,
  });

  String? nombre;

  String? detalle;

  int? precioReferencia;

  String? oficio;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateServiceBody &&
    other.nombre == nombre &&
    other.detalle == detalle &&
    other.precioReferencia == precioReferencia &&
    other.oficio == oficio;

  @override
  int get hashCode =>
    (nombre == null ? 0 : nombre!.hashCode) +
    (detalle == null ? 0 : detalle!.hashCode) +
    (precioReferencia == null ? 0 : precioReferencia!.hashCode) +
    (oficio == null ? 0 : oficio!.hashCode);

  @override
  String toString() => 'UpdateServiceBody[nombre=$nombre, detalle=$detalle, precioReferencia=$precioReferencia, oficio=$oficio]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.nombre != null) {
      json[r'nombre'] = this.nombre;
    } else {
      json[r'nombre'] = null;
    }
    if (this.detalle != null) {
      json[r'detalle'] = this.detalle;
    } else {
      json[r'detalle'] = null;
    }
    if (this.precioReferencia != null) {
      json[r'precioReferencia'] = this.precioReferencia;
    } else {
      json[r'precioReferencia'] = null;
    }
    if (this.oficio != null) {
      json[r'oficio'] = this.oficio;
    } else {
      json[r'oficio'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateServiceBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UpdateServiceBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'nombre'), 'Required key "UpdateServiceBody[nombre]" is missing from JSON.');
        assert(json.containsKey(r'detalle'), 'Required key "UpdateServiceBody[detalle]" is missing from JSON.');
        assert(json.containsKey(r'precioReferencia'), 'Required key "UpdateServiceBody[precioReferencia]" is missing from JSON.');
        assert(json.containsKey(r'oficio'), 'Required key "UpdateServiceBody[oficio]" is missing from JSON.');
        return true;
      }());

      return UpdateServiceBody(
        nombre: mapValueOfType<String>(json, r'nombre'),
        detalle: mapValueOfType<String>(json, r'detalle'),
        precioReferencia: mapValueOfType<int>(json, r'precioReferencia'),
        oficio: mapValueOfType<String>(json, r'oficio'),
      );
    }
    return null;
  }

  static List<UpdateServiceBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateServiceBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateServiceBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateServiceBody> mapFromJson(dynamic json) {
    final map = <String, UpdateServiceBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UpdateServiceBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateServiceBody-objects as value to a dart map
  static Map<String, List<UpdateServiceBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateServiceBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateServiceBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'nombre',
    'detalle',
    'precioReferencia',
    'oficio',
  };
}

