//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TechnicianService {
  /// Returns a new [TechnicianService] instance.
  TechnicianService({
    required this.id,
    required this.nombre,
    required this.detalle,
    required this.precioReferencia,
    required this.oficio,
  });

  String id;

  String nombre;

  String? detalle;

  int precioReferencia;

  String oficio;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TechnicianService &&
    other.id == id &&
    other.nombre == nombre &&
    other.detalle == detalle &&
    other.precioReferencia == precioReferencia &&
    other.oficio == oficio;

  @override
  int get hashCode =>
    (id.hashCode) +
    (nombre.hashCode) +
    (detalle == null ? 0 : detalle!.hashCode) +
    (precioReferencia.hashCode) +
    (oficio.hashCode);

  @override
  String toString() => 'TechnicianService[id=$id, nombre=$nombre, detalle=$detalle, precioReferencia=$precioReferencia, oficio=$oficio]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'nombre'] = this.nombre;
    if (this.detalle != null) {
      json[r'detalle'] = this.detalle;
    } else {
      json[r'detalle'] = null;
    }
      json[r'precioReferencia'] = this.precioReferencia;
      json[r'oficio'] = this.oficio;
    return json;
  }

  /// Returns a new [TechnicianService] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TechnicianService? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "TechnicianService[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "TechnicianService[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "TechnicianService[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "TechnicianService[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'detalle'), 'Required key "TechnicianService[detalle]" is missing from JSON.');
        assert(json.containsKey(r'precioReferencia'), 'Required key "TechnicianService[precioReferencia]" is missing from JSON.');
        assert(json[r'precioReferencia'] != null, 'Required key "TechnicianService[precioReferencia]" has a null value in JSON.');
        assert(json.containsKey(r'oficio'), 'Required key "TechnicianService[oficio]" is missing from JSON.');
        assert(json[r'oficio'] != null, 'Required key "TechnicianService[oficio]" has a null value in JSON.');
        return true;
      }());

      return TechnicianService(
        id: mapValueOfType<String>(json, r'id')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        detalle: mapValueOfType<String>(json, r'detalle'),
        precioReferencia: mapValueOfType<int>(json, r'precioReferencia')!,
        oficio: mapValueOfType<String>(json, r'oficio')!,
      );
    }
    return null;
  }

  static List<TechnicianService> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TechnicianService>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TechnicianService.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TechnicianService> mapFromJson(dynamic json) {
    final map = <String, TechnicianService>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TechnicianService.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TechnicianService-objects as value to a dart map
  static Map<String, List<TechnicianService>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TechnicianService>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TechnicianService.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'nombre',
    'detalle',
    'precioReferencia',
    'oficio',
  };
}

