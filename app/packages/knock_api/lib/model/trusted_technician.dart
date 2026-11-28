//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrustedTechnician {
  /// Returns a new [TrustedTechnician] instance.
  TrustedTechnician({
    required this.tecnicoId,
    required this.nombre,
    required this.fotoUrl,
    required this.nivelVerificacion,
    required this.guardadoEn,
    this.tecnicoUsuarioId,
  });

  String tecnicoId;

  String nombre;

  String? fotoUrl;

  String nivelVerificacion;

  DateTime guardadoEn;

  String? tecnicoUsuarioId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrustedTechnician &&
    other.tecnicoId == tecnicoId &&
    other.nombre == nombre &&
    other.fotoUrl == fotoUrl &&
    other.nivelVerificacion == nivelVerificacion &&
    other.guardadoEn == guardadoEn &&
    other.tecnicoUsuarioId == tecnicoUsuarioId;

  @override
  int get hashCode =>
    (tecnicoId.hashCode) +
    (nombre.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode) +
    (nivelVerificacion.hashCode) +
    (guardadoEn.hashCode) +
    (tecnicoUsuarioId == null ? 0 : tecnicoUsuarioId!.hashCode);

  @override
  String toString() => 'TrustedTechnician[tecnicoId=$tecnicoId, nombre=$nombre, fotoUrl=$fotoUrl, nivelVerificacion=$nivelVerificacion, guardadoEn=$guardadoEn, tecnicoUsuarioId=$tecnicoUsuarioId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tecnicoId'] = this.tecnicoId;
      json[r'nombre'] = this.nombre;
    if (this.fotoUrl != null) {
      json[r'fotoUrl'] = this.fotoUrl;
    } else {
      json[r'fotoUrl'] = null;
    }
      json[r'nivelVerificacion'] = this.nivelVerificacion;
      json[r'guardadoEn'] = this.guardadoEn.toUtc().toIso8601String();
    if (this.tecnicoUsuarioId != null) {
      json[r'tecnicoUsuarioId'] = this.tecnicoUsuarioId;
    } else {
      json[r'tecnicoUsuarioId'] = null;
    }
    return json;
  }

  /// Returns a new [TrustedTechnician] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrustedTechnician? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tecnicoId'), 'Required key "TrustedTechnician[tecnicoId]" is missing from JSON.');
        assert(json[r'tecnicoId'] != null, 'Required key "TrustedTechnician[tecnicoId]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "TrustedTechnician[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "TrustedTechnician[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'fotoUrl'), 'Required key "TrustedTechnician[fotoUrl]" is missing from JSON.');
        assert(json.containsKey(r'nivelVerificacion'), 'Required key "TrustedTechnician[nivelVerificacion]" is missing from JSON.');
        assert(json[r'nivelVerificacion'] != null, 'Required key "TrustedTechnician[nivelVerificacion]" has a null value in JSON.');
        assert(json.containsKey(r'guardadoEn'), 'Required key "TrustedTechnician[guardadoEn]" is missing from JSON.');
        assert(json[r'guardadoEn'] != null, 'Required key "TrustedTechnician[guardadoEn]" has a null value in JSON.');
        return true;
      }());

      return TrustedTechnician(
        tecnicoId: mapValueOfType<String>(json, r'tecnicoId')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
        nivelVerificacion: mapValueOfType<String>(json, r'nivelVerificacion')!,
        guardadoEn: mapDateTime(json, r'guardadoEn', r'')!,
        tecnicoUsuarioId: mapValueOfType<String>(json, r'tecnicoUsuarioId'),
      );
    }
    return null;
  }

  static List<TrustedTechnician> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrustedTechnician>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrustedTechnician.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrustedTechnician> mapFromJson(dynamic json) {
    final map = <String, TrustedTechnician>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrustedTechnician.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrustedTechnician-objects as value to a dart map
  static Map<String, List<TrustedTechnician>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrustedTechnician>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrustedTechnician.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tecnicoId',
    'nombre',
    'fotoUrl',
    'nivelVerificacion',
    'guardadoEn',
  };
}

