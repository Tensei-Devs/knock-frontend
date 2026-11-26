//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReportDecisionResult {
  /// Returns a new [ReportDecisionResult] instance.
  ReportDecisionResult({
    required this.id,
    required this.estado,
    required this.gravedad,
    required this.respuesta,
    required this.prioridad,
  });

  String id;

  String estado;

  String gravedad;

  String respuesta;

  String prioridad;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportDecisionResult &&
    other.id == id &&
    other.estado == estado &&
    other.gravedad == gravedad &&
    other.respuesta == respuesta &&
    other.prioridad == prioridad;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (gravedad.hashCode) +
    (respuesta.hashCode) +
    (prioridad.hashCode);

  @override
  String toString() => 'ReportDecisionResult[id=$id, estado=$estado, gravedad=$gravedad, respuesta=$respuesta, prioridad=$prioridad]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
      json[r'gravedad'] = this.gravedad;
      json[r'respuesta'] = this.respuesta;
      json[r'prioridad'] = this.prioridad;
    return json;
  }

  /// Returns a new [ReportDecisionResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReportDecisionResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ReportDecisionResult[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ReportDecisionResult[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "ReportDecisionResult[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "ReportDecisionResult[estado]" has a null value in JSON.');
        assert(json.containsKey(r'gravedad'), 'Required key "ReportDecisionResult[gravedad]" is missing from JSON.');
        assert(json[r'gravedad'] != null, 'Required key "ReportDecisionResult[gravedad]" has a null value in JSON.');
        assert(json.containsKey(r'respuesta'), 'Required key "ReportDecisionResult[respuesta]" is missing from JSON.');
        assert(json[r'respuesta'] != null, 'Required key "ReportDecisionResult[respuesta]" has a null value in JSON.');
        assert(json.containsKey(r'prioridad'), 'Required key "ReportDecisionResult[prioridad]" is missing from JSON.');
        assert(json[r'prioridad'] != null, 'Required key "ReportDecisionResult[prioridad]" has a null value in JSON.');
        return true;
      }());

      return ReportDecisionResult(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        gravedad: mapValueOfType<String>(json, r'gravedad')!,
        respuesta: mapValueOfType<String>(json, r'respuesta')!,
        prioridad: mapValueOfType<String>(json, r'prioridad')!,
      );
    }
    return null;
  }

  static List<ReportDecisionResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportDecisionResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportDecisionResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportDecisionResult> mapFromJson(dynamic json) {
    final map = <String, ReportDecisionResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReportDecisionResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportDecisionResult-objects as value to a dart map
  static Map<String, List<ReportDecisionResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportDecisionResult>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportDecisionResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'gravedad',
    'respuesta',
    'prioridad',
  };
}

