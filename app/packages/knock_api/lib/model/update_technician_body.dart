//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UpdateTechnicianBody {
  /// Returns a new [UpdateTechnicianBody] instance.
  UpdateTechnicianBody({
    required this.nombre,
    required this.nombreNegocio,
    required this.anios,
    this.oficios = const [],
    required this.otroOficio,
    required this.atencion,
    required this.direccionTaller,
    required this.radioKm,
    required this.descripcion,
    required this.fotoUrl,
  });

  String? nombre;

  String? nombreNegocio;

  int? anios;

  List<String>? oficios;

  String? otroOficio;

  String? atencion;

  String? direccionTaller;

  int? radioKm;

  String? descripcion;

  String? fotoUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateTechnicianBody &&
    other.nombre == nombre &&
    other.nombreNegocio == nombreNegocio &&
    other.anios == anios &&
    _deepEquality.equals(other.oficios, oficios) &&
    other.otroOficio == otroOficio &&
    other.atencion == atencion &&
    other.direccionTaller == direccionTaller &&
    other.radioKm == radioKm &&
    other.descripcion == descripcion &&
    other.fotoUrl == fotoUrl;

  @override
  int get hashCode =>
    (nombre == null ? 0 : nombre!.hashCode) +
    (nombreNegocio == null ? 0 : nombreNegocio!.hashCode) +
    (anios == null ? 0 : anios!.hashCode) +
    (oficios == null ? 0 : oficios!.hashCode) +
    (otroOficio == null ? 0 : otroOficio!.hashCode) +
    (atencion == null ? 0 : atencion!.hashCode) +
    (direccionTaller == null ? 0 : direccionTaller!.hashCode) +
    (radioKm == null ? 0 : radioKm!.hashCode) +
    (descripcion == null ? 0 : descripcion!.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode);

  @override
  String toString() => 'UpdateTechnicianBody[nombre=$nombre, nombreNegocio=$nombreNegocio, anios=$anios, oficios=$oficios, otroOficio=$otroOficio, atencion=$atencion, direccionTaller=$direccionTaller, radioKm=$radioKm, descripcion=$descripcion, fotoUrl=$fotoUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.nombre != null) {
      json[r'nombre'] = this.nombre;
    } else {
      json[r'nombre'] = null;
    }
    if (this.nombreNegocio != null) {
      json[r'nombreNegocio'] = this.nombreNegocio;
    } else {
      json[r'nombreNegocio'] = null;
    }
    if (this.anios != null) {
      json[r'anios'] = this.anios;
    } else {
      json[r'anios'] = null;
    }
    if (this.oficios != null) {
      json[r'oficios'] = this.oficios;
    } else {
      json[r'oficios'] = null;
    }
    if (this.otroOficio != null) {
      json[r'otroOficio'] = this.otroOficio;
    } else {
      json[r'otroOficio'] = null;
    }
    if (this.atencion != null) {
      json[r'atencion'] = this.atencion;
    } else {
      json[r'atencion'] = null;
    }
    if (this.direccionTaller != null) {
      json[r'direccionTaller'] = this.direccionTaller;
    } else {
      json[r'direccionTaller'] = null;
    }
    if (this.radioKm != null) {
      json[r'radioKm'] = this.radioKm;
    } else {
      json[r'radioKm'] = null;
    }
    if (this.descripcion != null) {
      json[r'descripcion'] = this.descripcion;
    } else {
      json[r'descripcion'] = null;
    }
    if (this.fotoUrl != null) {
      json[r'fotoUrl'] = this.fotoUrl;
    } else {
      json[r'fotoUrl'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateTechnicianBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UpdateTechnicianBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'nombre'), 'Required key "UpdateTechnicianBody[nombre]" is missing from JSON.');
        assert(json.containsKey(r'nombreNegocio'), 'Required key "UpdateTechnicianBody[nombreNegocio]" is missing from JSON.');
        assert(json.containsKey(r'anios'), 'Required key "UpdateTechnicianBody[anios]" is missing from JSON.');
        assert(json.containsKey(r'oficios'), 'Required key "UpdateTechnicianBody[oficios]" is missing from JSON.');
        assert(json.containsKey(r'otroOficio'), 'Required key "UpdateTechnicianBody[otroOficio]" is missing from JSON.');
        assert(json.containsKey(r'atencion'), 'Required key "UpdateTechnicianBody[atencion]" is missing from JSON.');
        assert(json.containsKey(r'direccionTaller'), 'Required key "UpdateTechnicianBody[direccionTaller]" is missing from JSON.');
        assert(json.containsKey(r'radioKm'), 'Required key "UpdateTechnicianBody[radioKm]" is missing from JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "UpdateTechnicianBody[descripcion]" is missing from JSON.');
        assert(json.containsKey(r'fotoUrl'), 'Required key "UpdateTechnicianBody[fotoUrl]" is missing from JSON.');
        return true;
      }());

      return UpdateTechnicianBody(
        nombre: mapValueOfType<String>(json, r'nombre'),
        nombreNegocio: mapValueOfType<String>(json, r'nombreNegocio'),
        anios: mapValueOfType<int>(json, r'anios'),
        oficios: json[r'oficios'] is Iterable
            ? (json[r'oficios'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        otroOficio: mapValueOfType<String>(json, r'otroOficio'),
        atencion: mapValueOfType<String>(json, r'atencion'),
        direccionTaller: mapValueOfType<String>(json, r'direccionTaller'),
        radioKm: mapValueOfType<int>(json, r'radioKm'),
        descripcion: mapValueOfType<String>(json, r'descripcion'),
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
      );
    }
    return null;
  }

  static List<UpdateTechnicianBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateTechnicianBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateTechnicianBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateTechnicianBody> mapFromJson(dynamic json) {
    final map = <String, UpdateTechnicianBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UpdateTechnicianBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateTechnicianBody-objects as value to a dart map
  static Map<String, List<UpdateTechnicianBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateTechnicianBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateTechnicianBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'nombre',
    'nombreNegocio',
    'anios',
    'oficios',
    'otroOficio',
    'atencion',
    'direccionTaller',
    'radioKm',
    'descripcion',
    'fotoUrl',
  };
}

