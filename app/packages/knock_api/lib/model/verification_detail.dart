//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationDetail {
  /// Returns a new [VerificationDetail] instance.
  VerificationDetail({
    required this.id,
    required this.tipo,
    required this.nivel,
    required this.estado,
    required this.enviadaEn,
    this.fotos = const [],
  });

  String id;

  String tipo;

  String nivel;

  String estado;

  DateTime enviadaEn;

  List<VerificationPhotoLink> fotos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationDetail &&
    other.id == id &&
    other.tipo == tipo &&
    other.nivel == nivel &&
    other.estado == estado &&
    other.enviadaEn == enviadaEn &&
    _deepEquality.equals(other.fotos, fotos);

  @override
  int get hashCode =>
    (id.hashCode) +
    (tipo.hashCode) +
    (nivel.hashCode) +
    (estado.hashCode) +
    (enviadaEn.hashCode) +
    (fotos.hashCode);

  @override
  String toString() => 'VerificationDetail[id=$id, tipo=$tipo, nivel=$nivel, estado=$estado, enviadaEn=$enviadaEn, fotos=$fotos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'tipo'] = this.tipo;
      json[r'nivel'] = this.nivel;
      json[r'estado'] = this.estado;
      json[r'enviadaEn'] = this.enviadaEn.toUtc().toIso8601String();
      json[r'fotos'] = this.fotos;
    return json;
  }

  /// Returns a new [VerificationDetail] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationDetail? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "VerificationDetail[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "VerificationDetail[id]" has a null value in JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "VerificationDetail[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "VerificationDetail[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'nivel'), 'Required key "VerificationDetail[nivel]" is missing from JSON.');
        assert(json[r'nivel'] != null, 'Required key "VerificationDetail[nivel]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "VerificationDetail[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "VerificationDetail[estado]" has a null value in JSON.');
        assert(json.containsKey(r'enviadaEn'), 'Required key "VerificationDetail[enviadaEn]" is missing from JSON.');
        assert(json[r'enviadaEn'] != null, 'Required key "VerificationDetail[enviadaEn]" has a null value in JSON.');
        assert(json.containsKey(r'fotos'), 'Required key "VerificationDetail[fotos]" is missing from JSON.');
        assert(json[r'fotos'] != null, 'Required key "VerificationDetail[fotos]" has a null value in JSON.');
        return true;
      }());

      return VerificationDetail(
        id: mapValueOfType<String>(json, r'id')!,
        tipo: mapValueOfType<String>(json, r'tipo')!,
        nivel: mapValueOfType<String>(json, r'nivel')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        enviadaEn: mapDateTime(json, r'enviadaEn', r'')!,
        fotos: VerificationPhotoLink.listFromJson(json[r'fotos']),
      );
    }
    return null;
  }

  static List<VerificationDetail> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationDetail>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationDetail.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationDetail> mapFromJson(dynamic json) {
    final map = <String, VerificationDetail>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationDetail.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationDetail-objects as value to a dart map
  static Map<String, List<VerificationDetail>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationDetail>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationDetail.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'tipo',
    'nivel',
    'estado',
    'enviadaEn',
    'fotos',
  };
}

