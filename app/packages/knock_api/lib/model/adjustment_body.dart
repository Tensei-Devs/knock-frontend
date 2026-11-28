//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AdjustmentBody {
  /// Returns a new [AdjustmentBody] instance.
  AdjustmentBody({
    required this.montoNuevo,
    required this.motivo,
  });

  int? montoNuevo;

  String? motivo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdjustmentBody &&
    other.montoNuevo == montoNuevo &&
    other.motivo == motivo;

  @override
  int get hashCode =>
    (montoNuevo == null ? 0 : montoNuevo!.hashCode) +
    (motivo == null ? 0 : motivo!.hashCode);

  @override
  String toString() => 'AdjustmentBody[montoNuevo=$montoNuevo, motivo=$motivo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.montoNuevo != null) {
      json[r'montoNuevo'] = this.montoNuevo;
    } else {
      json[r'montoNuevo'] = null;
    }
    if (this.motivo != null) {
      json[r'motivo'] = this.motivo;
    } else {
      json[r'motivo'] = null;
    }
    return json;
  }

  /// Returns a new [AdjustmentBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AdjustmentBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'montoNuevo'), 'Required key "AdjustmentBody[montoNuevo]" is missing from JSON.');
        assert(json.containsKey(r'motivo'), 'Required key "AdjustmentBody[motivo]" is missing from JSON.');
        return true;
      }());

      return AdjustmentBody(
        montoNuevo: mapValueOfType<int>(json, r'montoNuevo'),
        motivo: mapValueOfType<String>(json, r'motivo'),
      );
    }
    return null;
  }

  static List<AdjustmentBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdjustmentBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdjustmentBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdjustmentBody> mapFromJson(dynamic json) {
    final map = <String, AdjustmentBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AdjustmentBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdjustmentBody-objects as value to a dart map
  static Map<String, List<AdjustmentBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdjustmentBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdjustmentBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'montoNuevo',
    'motivo',
  };
}

