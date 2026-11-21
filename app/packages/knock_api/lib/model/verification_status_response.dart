//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationStatusResponse {
  /// Returns a new [VerificationStatusResponse] instance.
  VerificationStatusResponse({
    required this.id,
    required this.nivel,
    required this.estado,
    required this.motivo,
    this.consejos = const [],
    required this.nivelOtorgado,
    this.fotos = const [],
    required this.creadoEn,
    required this.enviadoEn,
    required this.decididoEn,
    required this.expiraEn,
    required this.puedeReintentar,
  });

  String? id;

  String? nivel;

  String estado;

  String? motivo;

  List<String> consejos;

  String? nivelOtorgado;

  List<VerificationPhotoStateResponse> fotos;

  DateTime? creadoEn;

  DateTime? enviadoEn;

  DateTime? decididoEn;

  DateTime? expiraEn;

  bool puedeReintentar;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationStatusResponse &&
    other.id == id &&
    other.nivel == nivel &&
    other.estado == estado &&
    other.motivo == motivo &&
    _deepEquality.equals(other.consejos, consejos) &&
    other.nivelOtorgado == nivelOtorgado &&
    _deepEquality.equals(other.fotos, fotos) &&
    other.creadoEn == creadoEn &&
    other.enviadoEn == enviadoEn &&
    other.decididoEn == decididoEn &&
    other.expiraEn == expiraEn &&
    other.puedeReintentar == puedeReintentar;

  @override
  int get hashCode =>
    (id == null ? 0 : id!.hashCode) +
    (nivel == null ? 0 : nivel!.hashCode) +
    (estado.hashCode) +
    (motivo == null ? 0 : motivo!.hashCode) +
    (consejos.hashCode) +
    (nivelOtorgado == null ? 0 : nivelOtorgado!.hashCode) +
    (fotos.hashCode) +
    (creadoEn == null ? 0 : creadoEn!.hashCode) +
    (enviadoEn == null ? 0 : enviadoEn!.hashCode) +
    (decididoEn == null ? 0 : decididoEn!.hashCode) +
    (expiraEn == null ? 0 : expiraEn!.hashCode) +
    (puedeReintentar.hashCode);

  @override
  String toString() => 'VerificationStatusResponse[id=$id, nivel=$nivel, estado=$estado, motivo=$motivo, consejos=$consejos, nivelOtorgado=$nivelOtorgado, fotos=$fotos, creadoEn=$creadoEn, enviadoEn=$enviadoEn, decididoEn=$decididoEn, expiraEn=$expiraEn, puedeReintentar=$puedeReintentar]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.nivel != null) {
      json[r'nivel'] = this.nivel;
    } else {
      json[r'nivel'] = null;
    }
      json[r'estado'] = this.estado;
    if (this.motivo != null) {
      json[r'motivo'] = this.motivo;
    } else {
      json[r'motivo'] = null;
    }
      json[r'consejos'] = this.consejos;
    if (this.nivelOtorgado != null) {
      json[r'nivelOtorgado'] = this.nivelOtorgado;
    } else {
      json[r'nivelOtorgado'] = null;
    }
      json[r'fotos'] = this.fotos;
    if (this.creadoEn != null) {
      json[r'creadoEn'] = this.creadoEn!.toUtc().toIso8601String();
    } else {
      json[r'creadoEn'] = null;
    }
    if (this.enviadoEn != null) {
      json[r'enviadoEn'] = this.enviadoEn!.toUtc().toIso8601String();
    } else {
      json[r'enviadoEn'] = null;
    }
    if (this.decididoEn != null) {
      json[r'decididoEn'] = this.decididoEn!.toUtc().toIso8601String();
    } else {
      json[r'decididoEn'] = null;
    }
    if (this.expiraEn != null) {
      json[r'expiraEn'] = this.expiraEn!.toUtc().toIso8601String();
    } else {
      json[r'expiraEn'] = null;
    }
      json[r'puedeReintentar'] = this.puedeReintentar;
    return json;
  }

  /// Returns a new [VerificationStatusResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationStatusResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "VerificationStatusResponse[id]" is missing from JSON.');
        assert(json.containsKey(r'nivel'), 'Required key "VerificationStatusResponse[nivel]" is missing from JSON.');
        assert(json.containsKey(r'estado'), 'Required key "VerificationStatusResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "VerificationStatusResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'motivo'), 'Required key "VerificationStatusResponse[motivo]" is missing from JSON.');
        assert(json.containsKey(r'consejos'), 'Required key "VerificationStatusResponse[consejos]" is missing from JSON.');
        assert(json[r'consejos'] != null, 'Required key "VerificationStatusResponse[consejos]" has a null value in JSON.');
        assert(json.containsKey(r'nivelOtorgado'), 'Required key "VerificationStatusResponse[nivelOtorgado]" is missing from JSON.');
        assert(json.containsKey(r'fotos'), 'Required key "VerificationStatusResponse[fotos]" is missing from JSON.');
        assert(json[r'fotos'] != null, 'Required key "VerificationStatusResponse[fotos]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "VerificationStatusResponse[creadoEn]" is missing from JSON.');
        assert(json.containsKey(r'enviadoEn'), 'Required key "VerificationStatusResponse[enviadoEn]" is missing from JSON.');
        assert(json.containsKey(r'decididoEn'), 'Required key "VerificationStatusResponse[decididoEn]" is missing from JSON.');
        assert(json.containsKey(r'expiraEn'), 'Required key "VerificationStatusResponse[expiraEn]" is missing from JSON.');
        assert(json.containsKey(r'puedeReintentar'), 'Required key "VerificationStatusResponse[puedeReintentar]" is missing from JSON.');
        assert(json[r'puedeReintentar'] != null, 'Required key "VerificationStatusResponse[puedeReintentar]" has a null value in JSON.');
        return true;
      }());

      return VerificationStatusResponse(
        id: mapValueOfType<String>(json, r'id'),
        nivel: mapValueOfType<String>(json, r'nivel'),
        estado: mapValueOfType<String>(json, r'estado')!,
        motivo: mapValueOfType<String>(json, r'motivo'),
        consejos: json[r'consejos'] is Iterable
            ? (json[r'consejos'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        nivelOtorgado: mapValueOfType<String>(json, r'nivelOtorgado'),
        fotos: VerificationPhotoStateResponse.listFromJson(json[r'fotos']),
        creadoEn: mapDateTime(json, r'creadoEn', r''),
        enviadoEn: mapDateTime(json, r'enviadoEn', r''),
        decididoEn: mapDateTime(json, r'decididoEn', r''),
        expiraEn: mapDateTime(json, r'expiraEn', r''),
        puedeReintentar: mapValueOfType<bool>(json, r'puedeReintentar')!,
      );
    }
    return null;
  }

  static List<VerificationStatusResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationStatusResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationStatusResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationStatusResponse> mapFromJson(dynamic json) {
    final map = <String, VerificationStatusResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationStatusResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationStatusResponse-objects as value to a dart map
  static Map<String, List<VerificationStatusResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationStatusResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationStatusResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'nivel',
    'estado',
    'motivo',
    'consejos',
    'nivelOtorgado',
    'fotos',
    'creadoEn',
    'enviadoEn',
    'decididoEn',
    'expiraEn',
    'puedeReintentar',
  };
}

