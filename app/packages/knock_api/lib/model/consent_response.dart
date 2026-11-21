//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ConsentResponse {
  /// Returns a new [ConsentResponse] instance.
  ConsentResponse({
    required this.tipo,
    required this.vigente,
    required this.obligatorio,
    required this.version,
    required this.fecha,
  });

  String tipo;

  bool vigente;

  bool obligatorio;

  String? version;

  DateTime? fecha;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConsentResponse &&
    other.tipo == tipo &&
    other.vigente == vigente &&
    other.obligatorio == obligatorio &&
    other.version == version &&
    other.fecha == fecha;

  @override
  int get hashCode =>
    (tipo.hashCode) +
    (vigente.hashCode) +
    (obligatorio.hashCode) +
    (version == null ? 0 : version!.hashCode) +
    (fecha == null ? 0 : fecha!.hashCode);

  @override
  String toString() => 'ConsentResponse[tipo=$tipo, vigente=$vigente, obligatorio=$obligatorio, version=$version, fecha=$fecha]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tipo'] = this.tipo;
      json[r'vigente'] = this.vigente;
      json[r'obligatorio'] = this.obligatorio;
    if (this.version != null) {
      json[r'version'] = this.version;
    } else {
      json[r'version'] = null;
    }
    if (this.fecha != null) {
      json[r'fecha'] = this.fecha!.toUtc().toIso8601String();
    } else {
      json[r'fecha'] = null;
    }
    return json;
  }

  /// Returns a new [ConsentResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ConsentResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipo'), 'Required key "ConsentResponse[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "ConsentResponse[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'vigente'), 'Required key "ConsentResponse[vigente]" is missing from JSON.');
        assert(json[r'vigente'] != null, 'Required key "ConsentResponse[vigente]" has a null value in JSON.');
        assert(json.containsKey(r'obligatorio'), 'Required key "ConsentResponse[obligatorio]" is missing from JSON.');
        assert(json[r'obligatorio'] != null, 'Required key "ConsentResponse[obligatorio]" has a null value in JSON.');
        assert(json.containsKey(r'version'), 'Required key "ConsentResponse[version]" is missing from JSON.');
        assert(json.containsKey(r'fecha'), 'Required key "ConsentResponse[fecha]" is missing from JSON.');
        return true;
      }());

      return ConsentResponse(
        tipo: mapValueOfType<String>(json, r'tipo')!,
        vigente: mapValueOfType<bool>(json, r'vigente')!,
        obligatorio: mapValueOfType<bool>(json, r'obligatorio')!,
        version: mapValueOfType<String>(json, r'version'),
        fecha: mapDateTime(json, r'fecha', r''),
      );
    }
    return null;
  }

  static List<ConsentResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConsentResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConsentResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConsentResponse> mapFromJson(dynamic json) {
    final map = <String, ConsentResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ConsentResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConsentResponse-objects as value to a dart map
  static Map<String, List<ConsentResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConsentResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConsentResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipo',
    'vigente',
    'obligatorio',
    'version',
    'fecha',
  };
}

