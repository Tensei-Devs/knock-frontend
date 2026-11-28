//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class MensajePropioExportado {
  /// Returns a new [MensajePropioExportado] instance.
  MensajePropioExportado({
    required this.mensajeId,
    required this.texto,
    required this.contactoOculto,
    required this.creadoEn,
  });

  String mensajeId;

  String texto;

  bool contactoOculto;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MensajePropioExportado &&
    other.mensajeId == mensajeId &&
    other.texto == texto &&
    other.contactoOculto == contactoOculto &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (mensajeId.hashCode) +
    (texto.hashCode) +
    (contactoOculto.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'MensajePropioExportado[mensajeId=$mensajeId, texto=$texto, contactoOculto=$contactoOculto, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'mensajeId'] = this.mensajeId;
      json[r'texto'] = this.texto;
      json[r'contactoOculto'] = this.contactoOculto;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [MensajePropioExportado] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static MensajePropioExportado? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'mensajeId'), 'Required key "MensajePropioExportado[mensajeId]" is missing from JSON.');
        assert(json[r'mensajeId'] != null, 'Required key "MensajePropioExportado[mensajeId]" has a null value in JSON.');
        assert(json.containsKey(r'texto'), 'Required key "MensajePropioExportado[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "MensajePropioExportado[texto]" has a null value in JSON.');
        assert(json.containsKey(r'contactoOculto'), 'Required key "MensajePropioExportado[contactoOculto]" is missing from JSON.');
        assert(json[r'contactoOculto'] != null, 'Required key "MensajePropioExportado[contactoOculto]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "MensajePropioExportado[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "MensajePropioExportado[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return MensajePropioExportado(
        mensajeId: mapValueOfType<String>(json, r'mensajeId')!,
        texto: mapValueOfType<String>(json, r'texto')!,
        contactoOculto: mapValueOfType<bool>(json, r'contactoOculto')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<MensajePropioExportado> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MensajePropioExportado>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MensajePropioExportado.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MensajePropioExportado> mapFromJson(dynamic json) {
    final map = <String, MensajePropioExportado>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = MensajePropioExportado.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MensajePropioExportado-objects as value to a dart map
  static Map<String, List<MensajePropioExportado>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MensajePropioExportado>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MensajePropioExportado.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'mensajeId',
    'texto',
    'contactoOculto',
    'creadoEn',
  };
}

