//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class MensajeResponse {
  /// Returns a new [MensajeResponse] instance.
  MensajeResponse({
    required this.mensajeId,
    required this.autorRol,
    required this.texto,
    required this.contactoOculto,
    required this.enviadoEn,
  });

  String mensajeId;

  String autorRol;

  String texto;

  bool contactoOculto;

  DateTime enviadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MensajeResponse &&
    other.mensajeId == mensajeId &&
    other.autorRol == autorRol &&
    other.texto == texto &&
    other.contactoOculto == contactoOculto &&
    other.enviadoEn == enviadoEn;

  @override
  int get hashCode =>
    (mensajeId.hashCode) +
    (autorRol.hashCode) +
    (texto.hashCode) +
    (contactoOculto.hashCode) +
    (enviadoEn.hashCode);

  @override
  String toString() => 'MensajeResponse[mensajeId=$mensajeId, autorRol=$autorRol, texto=$texto, contactoOculto=$contactoOculto, enviadoEn=$enviadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'mensajeId'] = this.mensajeId;
      json[r'autorRol'] = this.autorRol;
      json[r'texto'] = this.texto;
      json[r'contactoOculto'] = this.contactoOculto;
      json[r'enviadoEn'] = this.enviadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [MensajeResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static MensajeResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'mensajeId'), 'Required key "MensajeResponse[mensajeId]" is missing from JSON.');
        assert(json[r'mensajeId'] != null, 'Required key "MensajeResponse[mensajeId]" has a null value in JSON.');
        assert(json.containsKey(r'autorRol'), 'Required key "MensajeResponse[autorRol]" is missing from JSON.');
        assert(json[r'autorRol'] != null, 'Required key "MensajeResponse[autorRol]" has a null value in JSON.');
        assert(json.containsKey(r'texto'), 'Required key "MensajeResponse[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "MensajeResponse[texto]" has a null value in JSON.');
        assert(json.containsKey(r'contactoOculto'), 'Required key "MensajeResponse[contactoOculto]" is missing from JSON.');
        assert(json[r'contactoOculto'] != null, 'Required key "MensajeResponse[contactoOculto]" has a null value in JSON.');
        assert(json.containsKey(r'enviadoEn'), 'Required key "MensajeResponse[enviadoEn]" is missing from JSON.');
        assert(json[r'enviadoEn'] != null, 'Required key "MensajeResponse[enviadoEn]" has a null value in JSON.');
        return true;
      }());

      return MensajeResponse(
        mensajeId: mapValueOfType<String>(json, r'mensajeId')!,
        autorRol: mapValueOfType<String>(json, r'autorRol')!,
        texto: mapValueOfType<String>(json, r'texto')!,
        contactoOculto: mapValueOfType<bool>(json, r'contactoOculto')!,
        enviadoEn: mapDateTime(json, r'enviadoEn', r'')!,
      );
    }
    return null;
  }

  static List<MensajeResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MensajeResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MensajeResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MensajeResponse> mapFromJson(dynamic json) {
    final map = <String, MensajeResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = MensajeResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MensajeResponse-objects as value to a dart map
  static Map<String, List<MensajeResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MensajeResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MensajeResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'mensajeId',
    'autorRol',
    'texto',
    'contactoOculto',
    'enviadoEn',
  };
}

