//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationDecisionResult {
  /// Returns a new [VerificationDecisionResult] instance.
  VerificationDecisionResult({
    required this.id,
    required this.estado,
    required this.decididaEn,
  });

  String id;

  String estado;

  DateTime decididaEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationDecisionResult &&
    other.id == id &&
    other.estado == estado &&
    other.decididaEn == decididaEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (decididaEn.hashCode);

  @override
  String toString() => 'VerificationDecisionResult[id=$id, estado=$estado, decididaEn=$decididaEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
      json[r'decididaEn'] = this.decididaEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [VerificationDecisionResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationDecisionResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "VerificationDecisionResult[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "VerificationDecisionResult[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "VerificationDecisionResult[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "VerificationDecisionResult[estado]" has a null value in JSON.');
        assert(json.containsKey(r'decididaEn'), 'Required key "VerificationDecisionResult[decididaEn]" is missing from JSON.');
        assert(json[r'decididaEn'] != null, 'Required key "VerificationDecisionResult[decididaEn]" has a null value in JSON.');
        return true;
      }());

      return VerificationDecisionResult(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        decididaEn: mapDateTime(json, r'decididaEn', r'')!,
      );
    }
    return null;
  }

  static List<VerificationDecisionResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationDecisionResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationDecisionResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationDecisionResult> mapFromJson(dynamic json) {
    final map = <String, VerificationDecisionResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationDecisionResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationDecisionResult-objects as value to a dart map
  static Map<String, List<VerificationDecisionResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationDecisionResult>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationDecisionResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'decididaEn',
  };
}

