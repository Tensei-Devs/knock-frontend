//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class FinishVisitResponse {
  /// Returns a new [FinishVisitResponse] instance.
  FinishVisitResponse({
    required this.visitaId,
    required this.estado,
    required this.terminadaEn,
  });

  String visitaId;

  String estado;

  DateTime terminadaEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FinishVisitResponse &&
    other.visitaId == visitaId &&
    other.estado == estado &&
    other.terminadaEn == terminadaEn;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (estado.hashCode) +
    (terminadaEn.hashCode);

  @override
  String toString() => 'FinishVisitResponse[visitaId=$visitaId, estado=$estado, terminadaEn=$terminadaEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'estado'] = this.estado;
      json[r'terminadaEn'] = this.terminadaEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [FinishVisitResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static FinishVisitResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "FinishVisitResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "FinishVisitResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "FinishVisitResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "FinishVisitResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'terminadaEn'), 'Required key "FinishVisitResponse[terminadaEn]" is missing from JSON.');
        assert(json[r'terminadaEn'] != null, 'Required key "FinishVisitResponse[terminadaEn]" has a null value in JSON.');
        return true;
      }());

      return FinishVisitResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        terminadaEn: mapDateTime(json, r'terminadaEn', r'')!,
      );
    }
    return null;
  }

  static List<FinishVisitResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FinishVisitResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FinishVisitResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FinishVisitResponse> mapFromJson(dynamic json) {
    final map = <String, FinishVisitResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = FinishVisitResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FinishVisitResponse-objects as value to a dart map
  static Map<String, List<FinishVisitResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FinishVisitResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FinishVisitResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'estado',
    'terminadaEn',
  };
}

