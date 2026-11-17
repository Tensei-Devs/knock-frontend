//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UpdateProfileRequest {
  /// Returns a new [UpdateProfileRequest] instance.
  UpdateProfileRequest({
    this.nombre,
    this.fotoUrl,
    this.colonia,
    this.codigoPostal,
  });

  String? nombre;

  String? fotoUrl;

  String? colonia;

  String? codigoPostal;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateProfileRequest &&
    other.nombre == nombre &&
    other.fotoUrl == fotoUrl &&
    other.colonia == colonia &&
    other.codigoPostal == codigoPostal;

  @override
  int get hashCode =>
    (nombre == null ? 0 : nombre!.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode) +
    (colonia == null ? 0 : colonia!.hashCode) +
    (codigoPostal == null ? 0 : codigoPostal!.hashCode);

  @override
  String toString() => 'UpdateProfileRequest[nombre=$nombre, fotoUrl=$fotoUrl, colonia=$colonia, codigoPostal=$codigoPostal]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.nombre != null) {
      json[r'nombre'] = this.nombre;
    } else {
      json[r'nombre'] = null;
    }
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
    return json;
  }

  /// Returns a new [UpdateProfileRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UpdateProfileRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return UpdateProfileRequest(
        nombre: mapValueOfType<String>(json, r'nombre'),
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
        colonia: mapValueOfType<String>(json, r'colonia'),
        codigoPostal: mapValueOfType<String>(json, r'codigoPostal'),
      );
    }
    return null;
  }

  static List<UpdateProfileRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateProfileRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateProfileRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateProfileRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateProfileRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UpdateProfileRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateProfileRequest-objects as value to a dart map
  static Map<String, List<UpdateProfileRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateProfileRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateProfileRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

