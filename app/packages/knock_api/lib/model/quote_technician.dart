//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class QuoteTechnician {
  /// Returns a new [QuoteTechnician] instance.
  QuoteTechnician({
    required this.id,
    required this.nombre,
    required this.fotoUrl,
    required this.calificacion,
    required this.verificado,
    required this.nivelVerificacion,
  });

  String id;

  String nombre;

  String? fotoUrl;

  double? calificacion;

  bool verificado;

  String nivelVerificacion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuoteTechnician &&
    other.id == id &&
    other.nombre == nombre &&
    other.fotoUrl == fotoUrl &&
    other.calificacion == calificacion &&
    other.verificado == verificado &&
    other.nivelVerificacion == nivelVerificacion;

  @override
  int get hashCode =>
    (id.hashCode) +
    (nombre.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode) +
    (calificacion == null ? 0 : calificacion!.hashCode) +
    (verificado.hashCode) +
    (nivelVerificacion.hashCode);

  @override
  String toString() => 'QuoteTechnician[id=$id, nombre=$nombre, fotoUrl=$fotoUrl, calificacion=$calificacion, verificado=$verificado, nivelVerificacion=$nivelVerificacion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'nombre'] = this.nombre;
    if (this.fotoUrl != null) {
      json[r'fotoUrl'] = this.fotoUrl;
    } else {
      json[r'fotoUrl'] = null;
    }
    if (this.calificacion != null) {
      json[r'calificacion'] = this.calificacion;
    } else {
      json[r'calificacion'] = null;
    }
      json[r'verificado'] = this.verificado;
      json[r'nivelVerificacion'] = this.nivelVerificacion;
    return json;
  }

  /// Returns a new [QuoteTechnician] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static QuoteTechnician? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "QuoteTechnician[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "QuoteTechnician[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "QuoteTechnician[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "QuoteTechnician[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'fotoUrl'), 'Required key "QuoteTechnician[fotoUrl]" is missing from JSON.');
        assert(json.containsKey(r'calificacion'), 'Required key "QuoteTechnician[calificacion]" is missing from JSON.');
        assert(json.containsKey(r'verificado'), 'Required key "QuoteTechnician[verificado]" is missing from JSON.');
        assert(json[r'verificado'] != null, 'Required key "QuoteTechnician[verificado]" has a null value in JSON.');
        assert(json.containsKey(r'nivelVerificacion'), 'Required key "QuoteTechnician[nivelVerificacion]" is missing from JSON.');
        assert(json[r'nivelVerificacion'] != null, 'Required key "QuoteTechnician[nivelVerificacion]" has a null value in JSON.');
        return true;
      }());

      return QuoteTechnician(
        id: mapValueOfType<String>(json, r'id')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
        calificacion: mapValueOfType<double>(json, r'calificacion'),
        verificado: mapValueOfType<bool>(json, r'verificado')!,
        nivelVerificacion: mapValueOfType<String>(json, r'nivelVerificacion')!,
      );
    }
    return null;
  }

  static List<QuoteTechnician> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuoteTechnician>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuoteTechnician.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuoteTechnician> mapFromJson(dynamic json) {
    final map = <String, QuoteTechnician>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = QuoteTechnician.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuoteTechnician-objects as value to a dart map
  static Map<String, List<QuoteTechnician>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuoteTechnician>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuoteTechnician.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'nombre',
    'fotoUrl',
    'calificacion',
    'verificado',
    'nivelVerificacion',
  };
}

