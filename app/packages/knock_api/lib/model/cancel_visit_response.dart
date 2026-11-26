//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CancelVisitResponse {
  /// Returns a new [CancelVisitResponse] instance.
  CancelVisitResponse({
    required this.visitaId,
    required this.estado,
    required this.tardia,
  });

  String visitaId;

  String estado;

  bool tardia;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CancelVisitResponse &&
    other.visitaId == visitaId &&
    other.estado == estado &&
    other.tardia == tardia;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (estado.hashCode) +
    (tardia.hashCode);

  @override
  String toString() => 'CancelVisitResponse[visitaId=$visitaId, estado=$estado, tardia=$tardia]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'estado'] = this.estado;
      json[r'tardia'] = this.tardia;
    return json;
  }

  /// Returns a new [CancelVisitResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CancelVisitResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "CancelVisitResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "CancelVisitResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "CancelVisitResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "CancelVisitResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'tardia'), 'Required key "CancelVisitResponse[tardia]" is missing from JSON.');
        assert(json[r'tardia'] != null, 'Required key "CancelVisitResponse[tardia]" has a null value in JSON.');
        return true;
      }());

      return CancelVisitResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        tardia: mapValueOfType<bool>(json, r'tardia')!,
      );
    }
    return null;
  }

  static List<CancelVisitResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CancelVisitResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CancelVisitResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CancelVisitResponse> mapFromJson(dynamic json) {
    final map = <String, CancelVisitResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CancelVisitResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CancelVisitResponse-objects as value to a dart map
  static Map<String, List<CancelVisitResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CancelVisitResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CancelVisitResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'estado',
    'tardia',
  };
}

