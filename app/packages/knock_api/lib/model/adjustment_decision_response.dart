//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AdjustmentDecisionResponse {
  /// Returns a new [AdjustmentDecisionResponse] instance.
  AdjustmentDecisionResponse({
    required this.id,
    required this.estado,
    required this.topeNuevo,
  });

  String id;

  String estado;

  int? topeNuevo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdjustmentDecisionResponse &&
    other.id == id &&
    other.estado == estado &&
    other.topeNuevo == topeNuevo;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (topeNuevo == null ? 0 : topeNuevo!.hashCode);

  @override
  String toString() => 'AdjustmentDecisionResponse[id=$id, estado=$estado, topeNuevo=$topeNuevo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
    if (this.topeNuevo != null) {
      json[r'topeNuevo'] = this.topeNuevo;
    } else {
      json[r'topeNuevo'] = null;
    }
    return json;
  }

  /// Returns a new [AdjustmentDecisionResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AdjustmentDecisionResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AdjustmentDecisionResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AdjustmentDecisionResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "AdjustmentDecisionResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "AdjustmentDecisionResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'topeNuevo'), 'Required key "AdjustmentDecisionResponse[topeNuevo]" is missing from JSON.');
        return true;
      }());

      return AdjustmentDecisionResponse(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        topeNuevo: mapValueOfType<int>(json, r'topeNuevo'),
      );
    }
    return null;
  }

  static List<AdjustmentDecisionResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdjustmentDecisionResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdjustmentDecisionResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdjustmentDecisionResponse> mapFromJson(dynamic json) {
    final map = <String, AdjustmentDecisionResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AdjustmentDecisionResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdjustmentDecisionResponse-objects as value to a dart map
  static Map<String, List<AdjustmentDecisionResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdjustmentDecisionResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdjustmentDecisionResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'topeNuevo',
  };
}

