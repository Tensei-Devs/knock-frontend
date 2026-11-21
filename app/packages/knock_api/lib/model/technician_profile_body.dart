//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TechnicianProfileBody {
  /// Returns a new [TechnicianProfileBody] instance.
  TechnicianProfileBody({
    required this.nombreNegocio,
    required this.descripcion,
    required this.anios,
  });

  /// Hasta 60 caracteres.
  String? nombreNegocio;

  /// Hasta 300 caracteres.
  String? descripcion;

  /// Años de experiencia, de 0 a 60.
  int? anios;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TechnicianProfileBody &&
    other.nombreNegocio == nombreNegocio &&
    other.descripcion == descripcion &&
    other.anios == anios;

  @override
  int get hashCode =>
    (nombreNegocio == null ? 0 : nombreNegocio!.hashCode) +
    (descripcion == null ? 0 : descripcion!.hashCode) +
    (anios == null ? 0 : anios!.hashCode);

  @override
  String toString() => 'TechnicianProfileBody[nombreNegocio=$nombreNegocio, descripcion=$descripcion, anios=$anios]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.nombreNegocio != null) {
      json[r'nombreNegocio'] = this.nombreNegocio;
    } else {
      json[r'nombreNegocio'] = null;
    }
    if (this.descripcion != null) {
      json[r'descripcion'] = this.descripcion;
    } else {
      json[r'descripcion'] = null;
    }
    if (this.anios != null) {
      json[r'anios'] = this.anios;
    } else {
      json[r'anios'] = null;
    }
    return json;
  }

  /// Returns a new [TechnicianProfileBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TechnicianProfileBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'nombreNegocio'), 'Required key "TechnicianProfileBody[nombreNegocio]" is missing from JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "TechnicianProfileBody[descripcion]" is missing from JSON.');
        assert(json.containsKey(r'anios'), 'Required key "TechnicianProfileBody[anios]" is missing from JSON.');
        return true;
      }());

      return TechnicianProfileBody(
        nombreNegocio: mapValueOfType<String>(json, r'nombreNegocio'),
        descripcion: mapValueOfType<String>(json, r'descripcion'),
        anios: mapValueOfType<int>(json, r'anios'),
      );
    }
    return null;
  }

  static List<TechnicianProfileBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TechnicianProfileBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TechnicianProfileBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TechnicianProfileBody> mapFromJson(dynamic json) {
    final map = <String, TechnicianProfileBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TechnicianProfileBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TechnicianProfileBody-objects as value to a dart map
  static Map<String, List<TechnicianProfileBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TechnicianProfileBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TechnicianProfileBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'nombreNegocio',
    'descripcion',
    'anios',
  };
}

