//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RegistroDispositivo {
  /// Returns a new [RegistroDispositivo] instance.
  RegistroDispositivo({
    required this.identificador,
    required this.plataforma,
  });

  String? identificador;

  String? plataforma;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegistroDispositivo &&
    other.identificador == identificador &&
    other.plataforma == plataforma;

  @override
  int get hashCode =>
    (identificador == null ? 0 : identificador!.hashCode) +
    (plataforma == null ? 0 : plataforma!.hashCode);

  @override
  String toString() => 'RegistroDispositivo[identificador=$identificador, plataforma=$plataforma]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.identificador != null) {
      json[r'identificador'] = this.identificador;
    } else {
      json[r'identificador'] = null;
    }
    if (this.plataforma != null) {
      json[r'plataforma'] = this.plataforma;
    } else {
      json[r'plataforma'] = null;
    }
    return json;
  }

  /// Returns a new [RegistroDispositivo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RegistroDispositivo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'identificador'), 'Required key "RegistroDispositivo[identificador]" is missing from JSON.');
        assert(json.containsKey(r'plataforma'), 'Required key "RegistroDispositivo[plataforma]" is missing from JSON.');
        return true;
      }());

      return RegistroDispositivo(
        identificador: mapValueOfType<String>(json, r'identificador'),
        plataforma: mapValueOfType<String>(json, r'plataforma'),
      );
    }
    return null;
  }

  static List<RegistroDispositivo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegistroDispositivo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegistroDispositivo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegistroDispositivo> mapFromJson(dynamic json) {
    final map = <String, RegistroDispositivo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RegistroDispositivo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegistroDispositivo-objects as value to a dart map
  static Map<String, List<RegistroDispositivo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegistroDispositivo>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegistroDispositivo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'identificador',
    'plataforma',
  };
}

