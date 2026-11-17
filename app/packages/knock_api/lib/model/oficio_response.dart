//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class OficioResponse {
  /// Returns a new [OficioResponse] instance.
  OficioResponse({
    required this.clave,
    required this.nombre,
    required this.modalidad,
  });

  /// Clave estable del catálogo (≤ 16 caracteres).
  String clave;

  /// Nombre para mostrar, en español (≤ 100 caracteres).
  String nombre;

  /// Valores conocidos: `domicilio` o `taller`. Es texto, no enum cerrado, para admitir modalidades futuras.
  String modalidad;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OficioResponse &&
    other.clave == clave &&
    other.nombre == nombre &&
    other.modalidad == modalidad;

  @override
  int get hashCode =>
    (clave.hashCode) +
    (nombre.hashCode) +
    (modalidad.hashCode);

  @override
  String toString() => 'OficioResponse[clave=$clave, nombre=$nombre, modalidad=$modalidad]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'clave'] = this.clave;
      json[r'nombre'] = this.nombre;
      json[r'modalidad'] = this.modalidad;
    return json;
  }

  /// Returns a new [OficioResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static OficioResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'clave'), 'Required key "OficioResponse[clave]" is missing from JSON.');
        assert(json[r'clave'] != null, 'Required key "OficioResponse[clave]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "OficioResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "OficioResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "OficioResponse[modalidad]" is missing from JSON.');
        assert(json[r'modalidad'] != null, 'Required key "OficioResponse[modalidad]" has a null value in JSON.');
        return true;
      }());

      return OficioResponse(
        clave: mapValueOfType<String>(json, r'clave')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        modalidad: mapValueOfType<String>(json, r'modalidad')!,
      );
    }
    return null;
  }

  static List<OficioResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OficioResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OficioResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OficioResponse> mapFromJson(dynamic json) {
    final map = <String, OficioResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = OficioResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OficioResponse-objects as value to a dart map
  static Map<String, List<OficioResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OficioResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OficioResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'clave',
    'nombre',
    'modalidad',
  };
}

