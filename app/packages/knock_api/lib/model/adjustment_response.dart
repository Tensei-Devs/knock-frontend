//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AdjustmentResponse {
  /// Returns a new [AdjustmentResponse] instance.
  AdjustmentResponse({
    required this.id,
    required this.cotizacionId,
    required this.visitaId,
    required this.montoNuevo,
    required this.estado,
    required this.venceEn,
  });

  String id;

  String cotizacionId;

  String visitaId;

  int montoNuevo;

  String estado;

  DateTime venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdjustmentResponse &&
    other.id == id &&
    other.cotizacionId == cotizacionId &&
    other.visitaId == visitaId &&
    other.montoNuevo == montoNuevo &&
    other.estado == estado &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (cotizacionId.hashCode) +
    (visitaId.hashCode) +
    (montoNuevo.hashCode) +
    (estado.hashCode) +
    (venceEn.hashCode);

  @override
  String toString() => 'AdjustmentResponse[id=$id, cotizacionId=$cotizacionId, visitaId=$visitaId, montoNuevo=$montoNuevo, estado=$estado, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'cotizacionId'] = this.cotizacionId;
      json[r'visitaId'] = this.visitaId;
      json[r'montoNuevo'] = this.montoNuevo;
      json[r'estado'] = this.estado;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [AdjustmentResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AdjustmentResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdjustmentResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdjustmentResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'cotizacionId'), 'Required key "AdjustmentResponse[cotizacionId]" is missing from JSON.');
        assert(json[r'cotizacionId'] != null, 'Required key "AdjustmentResponse[cotizacionId]" has a null value in JSON.');
        assert(json.containsKey(r'visitaId'), 'Required key "AdjustmentResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "AdjustmentResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'montoNuevo'), 'Required key "AdjustmentResponse[montoNuevo]" is missing from JSON.');
        assert(json[r'montoNuevo'] != null, 'Required key "AdjustmentResponse[montoNuevo]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "AdjustmentResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "AdjustmentResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "AdjustmentResponse[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "AdjustmentResponse[venceEn]" has a null value in JSON.');
        return true;
      }());

      return AdjustmentResponse(
        id: mapValueOfType<String>(json, r'id')!,
        cotizacionId: mapValueOfType<String>(json, r'cotizacionId')!,
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        montoNuevo: mapValueOfType<int>(json, r'montoNuevo')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
      );
    }
    return null;
  }

  static List<AdjustmentResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdjustmentResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdjustmentResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdjustmentResponse> mapFromJson(dynamic json) {
    final map = <String, AdjustmentResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AdjustmentResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdjustmentResponse-objects as value to a dart map
  static Map<String, List<AdjustmentResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdjustmentResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdjustmentResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'cotizacionId',
    'visitaId',
    'montoNuevo',
    'estado',
    'venceEn',
  };
}

