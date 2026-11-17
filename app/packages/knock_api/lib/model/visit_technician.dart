//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VisitTechnician {
  /// Returns a new [VisitTechnician] instance.
  VisitTechnician({
    required this.nombre,
    required this.fotoUrl,
    required this.verificado,
    required this.nivelVerificacion,
    required this.telefono,
    required this.whatsapp,
  });

  String nombre;

  String? fotoUrl;

  bool verificado;

  String nivelVerificacion;

  String? telefono;

  String? whatsapp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VisitTechnician &&
    other.nombre == nombre &&
    other.fotoUrl == fotoUrl &&
    other.verificado == verificado &&
    other.nivelVerificacion == nivelVerificacion &&
    other.telefono == telefono &&
    other.whatsapp == whatsapp;

  @override
  int get hashCode =>
    (nombre.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode) +
    (verificado.hashCode) +
    (nivelVerificacion.hashCode) +
    (telefono == null ? 0 : telefono!.hashCode) +
    (whatsapp == null ? 0 : whatsapp!.hashCode);

  @override
  String toString() => 'VisitTechnician[nombre=$nombre, fotoUrl=$fotoUrl, verificado=$verificado, nivelVerificacion=$nivelVerificacion, telefono=$telefono, whatsapp=$whatsapp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'nombre'] = this.nombre;
    if (this.fotoUrl != null) {
      json[r'fotoUrl'] = this.fotoUrl;
    } else {
      json[r'fotoUrl'] = null;
    }
      json[r'verificado'] = this.verificado;
      json[r'nivelVerificacion'] = this.nivelVerificacion;
    if (this.telefono != null) {
      json[r'telefono'] = this.telefono;
    } else {
      json[r'telefono'] = null;
    }
    if (this.whatsapp != null) {
      json[r'whatsapp'] = this.whatsapp;
    } else {
      json[r'whatsapp'] = null;
    }
    return json;
  }

  /// Returns a new [VisitTechnician] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VisitTechnician? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'nombre'), 'Required key "VisitTechnician[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "VisitTechnician[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'fotoUrl'), 'Required key "VisitTechnician[fotoUrl]" is missing from JSON.');
        assert(json.containsKey(r'verificado'), 'Required key "VisitTechnician[verificado]" is missing from JSON.');
        assert(json[r'verificado'] != null, 'Required key "VisitTechnician[verificado]" has a null value in JSON.');
        assert(json.containsKey(r'nivelVerificacion'), 'Required key "VisitTechnician[nivelVerificacion]" is missing from JSON.');
        assert(json[r'nivelVerificacion'] != null, 'Required key "VisitTechnician[nivelVerificacion]" has a null value in JSON.');
        assert(json.containsKey(r'telefono'), 'Required key "VisitTechnician[telefono]" is missing from JSON.');
        assert(json.containsKey(r'whatsapp'), 'Required key "VisitTechnician[whatsapp]" is missing from JSON.');
        return true;
      }());

      return VisitTechnician(
        nombre: mapValueOfType<String>(json, r'nombre')!,
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
        verificado: mapValueOfType<bool>(json, r'verificado')!,
        nivelVerificacion: mapValueOfType<String>(json, r'nivelVerificacion')!,
        telefono: mapValueOfType<String>(json, r'telefono'),
        whatsapp: mapValueOfType<String>(json, r'whatsapp'),
      );
    }
    return null;
  }

  static List<VisitTechnician> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VisitTechnician>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VisitTechnician.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VisitTechnician> mapFromJson(dynamic json) {
    final map = <String, VisitTechnician>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VisitTechnician.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VisitTechnician-objects as value to a dart map
  static Map<String, List<VisitTechnician>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VisitTechnician>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VisitTechnician.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'nombre',
    'fotoUrl',
    'verificado',
    'nivelVerificacion',
    'telefono',
    'whatsapp',
  };
}

