//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ProfileResponse {
  /// Returns a new [ProfileResponse] instance.
  ProfileResponse({
    required this.id,
    required this.nombre,
    required this.fotoUrl,
    required this.colonia,
    required this.codigoPostal,
    required this.esTecnico,
    required this.estado,
    required this.perfilCompleto,
    required this.creadoEn,
  });

  String id;

  String nombre;

  String? fotoUrl;

  String? colonia;

  String? codigoPostal;

  bool esTecnico;

  String estado;

  bool perfilCompleto;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProfileResponse &&
    other.id == id &&
    other.nombre == nombre &&
    other.fotoUrl == fotoUrl &&
    other.colonia == colonia &&
    other.codigoPostal == codigoPostal &&
    other.esTecnico == esTecnico &&
    other.estado == estado &&
    other.perfilCompleto == perfilCompleto &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (nombre.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode) +
    (colonia == null ? 0 : colonia!.hashCode) +
    (codigoPostal == null ? 0 : codigoPostal!.hashCode) +
    (esTecnico.hashCode) +
    (estado.hashCode) +
    (perfilCompleto.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'ProfileResponse[id=$id, nombre=$nombre, fotoUrl=$fotoUrl, colonia=$colonia, codigoPostal=$codigoPostal, esTecnico=$esTecnico, estado=$estado, perfilCompleto=$perfilCompleto, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'nombre'] = this.nombre;
    if (this.fotoUrl != null) {
      json[r'fotoUrl'] = this.fotoUrl;
    } else {
      json[r'fotoUrl'] = null;
    }
    if (this.colonia != null) {
      json[r'colonia'] = this.colonia;
    } else {
      json[r'colonia'] = null;
    }
    if (this.codigoPostal != null) {
      json[r'codigoPostal'] = this.codigoPostal;
    } else {
      json[r'codigoPostal'] = null;
    }
      json[r'esTecnico'] = this.esTecnico;
      json[r'estado'] = this.estado;
      json[r'perfilCompleto'] = this.perfilCompleto;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ProfileResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ProfileResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ProfileResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ProfileResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "ProfileResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "ProfileResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'fotoUrl'), 'Required key "ProfileResponse[fotoUrl]" is missing from JSON.');
        assert(json.containsKey(r'colonia'), 'Required key "ProfileResponse[colonia]" is missing from JSON.');
        assert(json.containsKey(r'codigoPostal'), 'Required key "ProfileResponse[codigoPostal]" is missing from JSON.');
        assert(json.containsKey(r'esTecnico'), 'Required key "ProfileResponse[esTecnico]" is missing from JSON.');
        assert(json[r'esTecnico'] != null, 'Required key "ProfileResponse[esTecnico]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "ProfileResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "ProfileResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'perfilCompleto'), 'Required key "ProfileResponse[perfilCompleto]" is missing from JSON.');
        assert(json[r'perfilCompleto'] != null, 'Required key "ProfileResponse[perfilCompleto]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "ProfileResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "ProfileResponse[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return ProfileResponse(
        id: mapValueOfType<String>(json, r'id')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
        colonia: mapValueOfType<String>(json, r'colonia'),
        codigoPostal: mapValueOfType<String>(json, r'codigoPostal'),
        esTecnico: mapValueOfType<bool>(json, r'esTecnico')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        perfilCompleto: mapValueOfType<bool>(json, r'perfilCompleto')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<ProfileResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProfileResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProfileResponse> mapFromJson(dynamic json) {
    final map = <String, ProfileResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ProfileResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProfileResponse-objects as value to a dart map
  static Map<String, List<ProfileResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProfileResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProfileResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'nombre',
    'fotoUrl',
    'colonia',
    'codigoPostal',
    'esTecnico',
    'estado',
    'perfilCompleto',
    'creadoEn',
  };
}

