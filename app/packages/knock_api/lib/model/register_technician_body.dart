//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RegisterTechnicianBody {
  /// Returns a new [RegisterTechnicianBody] instance.
  RegisterTechnicianBody({
    required this.nombre,
    this.oficios = const [],
    required this.otroOficio,
    required this.atencion,
    required this.direccionTaller,
    required this.radioKm,
    required this.coloniaId,
    required this.perfil,
    required this.aceptaTerminos,
  });

  /// Nombre y apellido que ven los clientes: de 2 a 80 letras, espacios, punto, apóstrofo o guion.
  String? nombre;

  /// Una o más claves de oficios activos del catálogo, sin repetir y sin máximo propio (D-07).
  List<String>? oficios;

  /// Texto libre opcional («Otro oficio»), de hasta 60 caracteres; no recibe solicitudes.
  String? otroOficio;

  /// Una de `taller`, `domicilio` o `ambos`.
  String? atencion;

  /// De 8 a 200 caracteres; obligatoria con taller o ambos y no admitida a domicilio. Se guarda cifrada.
  String? direccionTaller;

  /// 3, 5, 8 o 12; obligatorio a domicilio o ambos y no admitido solo en taller.
  int? radioKm;

  /// Colonia base del técnico (24 hexadecimales); de ella sale la ubicación aproximada.
  String? coloniaId;

  /// Datos opcionales del perfil público.
  TechnicianProfileBody? perfil;

  /// Debe ser `true`.
  bool? aceptaTerminos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegisterTechnicianBody &&
    other.nombre == nombre &&
    _deepEquality.equals(other.oficios, oficios) &&
    other.otroOficio == otroOficio &&
    other.atencion == atencion &&
    other.direccionTaller == direccionTaller &&
    other.radioKm == radioKm &&
    other.coloniaId == coloniaId &&
    other.perfil == perfil &&
    other.aceptaTerminos == aceptaTerminos;

  @override
  int get hashCode =>
    (nombre == null ? 0 : nombre!.hashCode) +
    (oficios == null ? 0 : oficios!.hashCode) +
    (otroOficio == null ? 0 : otroOficio!.hashCode) +
    (atencion == null ? 0 : atencion!.hashCode) +
    (direccionTaller == null ? 0 : direccionTaller!.hashCode) +
    (radioKm == null ? 0 : radioKm!.hashCode) +
    (coloniaId == null ? 0 : coloniaId!.hashCode) +
    (perfil == null ? 0 : perfil!.hashCode) +
    (aceptaTerminos == null ? 0 : aceptaTerminos!.hashCode);

  @override
  String toString() => 'RegisterTechnicianBody[nombre=$nombre, oficios=$oficios, otroOficio=$otroOficio, atencion=$atencion, direccionTaller=$direccionTaller, radioKm=$radioKm, coloniaId=$coloniaId, perfil=$perfil, aceptaTerminos=$aceptaTerminos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.nombre != null) {
      json[r'nombre'] = this.nombre;
    } else {
      json[r'nombre'] = null;
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
    if (this.coloniaId != null) {
      json[r'coloniaId'] = this.coloniaId;
    } else {
      json[r'coloniaId'] = null;
    }
    if (this.perfil != null) {
      json[r'perfil'] = this.perfil;
    } else {
      json[r'perfil'] = null;
    }
    if (this.aceptaTerminos != null) {
      json[r'aceptaTerminos'] = this.aceptaTerminos;
    } else {
      json[r'aceptaTerminos'] = null;
    }
    return json;
  }

  /// Returns a new [RegisterTechnicianBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RegisterTechnicianBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'nombre'), 'Required key "RegisterTechnicianBody[nombre]" is missing from JSON.');
        assert(json.containsKey(r'oficios'), 'Required key "RegisterTechnicianBody[oficios]" is missing from JSON.');
        assert(json.containsKey(r'otroOficio'), 'Required key "RegisterTechnicianBody[otroOficio]" is missing from JSON.');
        assert(json.containsKey(r'atencion'), 'Required key "RegisterTechnicianBody[atencion]" is missing from JSON.');
        assert(json.containsKey(r'direccionTaller'), 'Required key "RegisterTechnicianBody[direccionTaller]" is missing from JSON.');
        assert(json.containsKey(r'radioKm'), 'Required key "RegisterTechnicianBody[radioKm]" is missing from JSON.');
        assert(json.containsKey(r'coloniaId'), 'Required key "RegisterTechnicianBody[coloniaId]" is missing from JSON.');
        assert(json.containsKey(r'perfil'), 'Required key "RegisterTechnicianBody[perfil]" is missing from JSON.');
        assert(json.containsKey(r'aceptaTerminos'), 'Required key "RegisterTechnicianBody[aceptaTerminos]" is missing from JSON.');
        return true;
      }());

      return RegisterTechnicianBody(
        nombre: mapValueOfType<String>(json, r'nombre'),
        oficios: json[r'oficios'] is Iterable
            ? (json[r'oficios'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        otroOficio: mapValueOfType<String>(json, r'otroOficio'),
        atencion: mapValueOfType<String>(json, r'atencion'),
        direccionTaller: mapValueOfType<String>(json, r'direccionTaller'),
        radioKm: mapValueOfType<int>(json, r'radioKm'),
        coloniaId: mapValueOfType<String>(json, r'coloniaId'),
        perfil: TechnicianProfileBody.fromJson(json[r'perfil']),
        aceptaTerminos: mapValueOfType<bool>(json, r'aceptaTerminos'),
      );
    }
    return null;
  }

  static List<RegisterTechnicianBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegisterTechnicianBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegisterTechnicianBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegisterTechnicianBody> mapFromJson(dynamic json) {
    final map = <String, RegisterTechnicianBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RegisterTechnicianBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegisterTechnicianBody-objects as value to a dart map
  static Map<String, List<RegisterTechnicianBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegisterTechnicianBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegisterTechnicianBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'nombre',
    'oficios',
    'otroOficio',
    'atencion',
    'direccionTaller',
    'radioKm',
    'coloniaId',
    'perfil',
    'aceptaTerminos',
  };
}

