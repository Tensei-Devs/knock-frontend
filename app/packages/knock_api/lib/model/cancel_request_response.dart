//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CancelRequestResponse {
  /// Returns a new [CancelRequestResponse] instance.
  CancelRequestResponse({
    required this.id,
    required this.estado,
    required this.canceladaEn,
    required this.motivo,
  });

  String id;

  String estado;

  DateTime canceladaEn;

  String? motivo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CancelRequestResponse &&
    other.id == id &&
    other.estado == estado &&
    other.canceladaEn == canceladaEn &&
    other.motivo == motivo;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (canceladaEn.hashCode) +
    (motivo == null ? 0 : motivo!.hashCode);

  @override
  String toString() => 'CancelRequestResponse[id=$id, estado=$estado, canceladaEn=$canceladaEn, motivo=$motivo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
      json[r'canceladaEn'] = this.canceladaEn.toUtc().toIso8601String();
    if (this.motivo != null) {
      json[r'motivo'] = this.motivo;
    } else {
      json[r'motivo'] = null;
    }
    return json;
  }

  /// Returns a new [CancelRequestResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CancelRequestResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CancelRequestResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CancelRequestResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "CancelRequestResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "CancelRequestResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'canceladaEn'), 'Required key "CancelRequestResponse[canceladaEn]" is missing from JSON.');
        assert(json[r'canceladaEn'] != null, 'Required key "CancelRequestResponse[canceladaEn]" has a null value in JSON.');
        assert(json.containsKey(r'motivo'), 'Required key "CancelRequestResponse[motivo]" is missing from JSON.');
        return true;
      }());

      return CancelRequestResponse(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        canceladaEn: mapDateTime(json, r'canceladaEn', r'')!,
        motivo: mapValueOfType<String>(json, r'motivo'),
      );
    }
    return null;
  }

  static List<CancelRequestResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CancelRequestResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CancelRequestResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CancelRequestResponse> mapFromJson(dynamic json) {
    final map = <String, CancelRequestResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CancelRequestResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CancelRequestResponse-objects as value to a dart map
  static Map<String, List<CancelRequestResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CancelRequestResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CancelRequestResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'canceladaEn',
    'motivo',
  };
}

