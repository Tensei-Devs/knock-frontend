//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TechnicianAbsentResponse {
  /// Returns a new [TechnicianAbsentResponse] instance.
  TechnicianAbsentResponse({
    required this.visitaId,
    required this.estado,
    required this.quienFalto,
  });

  String visitaId;

  String estado;

  String quienFalto;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TechnicianAbsentResponse &&
    other.visitaId == visitaId &&
    other.estado == estado &&
    other.quienFalto == quienFalto;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (estado.hashCode) +
    (quienFalto.hashCode);

  @override
  String toString() => 'TechnicianAbsentResponse[visitaId=$visitaId, estado=$estado, quienFalto=$quienFalto]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'estado'] = this.estado;
      json[r'quienFalto'] = this.quienFalto;
    return json;
  }

  /// Returns a new [TechnicianAbsentResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TechnicianAbsentResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "TechnicianAbsentResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "TechnicianAbsentResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "TechnicianAbsentResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "TechnicianAbsentResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'quienFalto'), 'Required key "TechnicianAbsentResponse[quienFalto]" is missing from JSON.');
        assert(json[r'quienFalto'] != null, 'Required key "TechnicianAbsentResponse[quienFalto]" has a null value in JSON.');
        return true;
      }());

      return TechnicianAbsentResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        quienFalto: mapValueOfType<String>(json, r'quienFalto')!,
      );
    }
    return null;
  }

  static List<TechnicianAbsentResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TechnicianAbsentResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TechnicianAbsentResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TechnicianAbsentResponse> mapFromJson(dynamic json) {
    final map = <String, TechnicianAbsentResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TechnicianAbsentResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TechnicianAbsentResponse-objects as value to a dart map
  static Map<String, List<TechnicianAbsentResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TechnicianAbsentResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TechnicianAbsentResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'estado',
    'quienFalto',
  };
}

