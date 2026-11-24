//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PendingAdjustmentItem {
  /// Returns a new [PendingAdjustmentItem] instance.
  PendingAdjustmentItem({
    required this.id,
    required this.cotizacionId,
    required this.montoNuevo,
    required this.motivo,
    required this.estado,
    required this.venceEn,
  });

  String id;

  String cotizacionId;

  int montoNuevo;

  String motivo;

  String estado;

  DateTime venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PendingAdjustmentItem &&
    other.id == id &&
    other.cotizacionId == cotizacionId &&
    other.montoNuevo == montoNuevo &&
    other.motivo == motivo &&
    other.estado == estado &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (cotizacionId.hashCode) +
    (montoNuevo.hashCode) +
    (motivo.hashCode) +
    (estado.hashCode) +
    (venceEn.hashCode);

  @override
  String toString() => 'PendingAdjustmentItem[id=$id, cotizacionId=$cotizacionId, montoNuevo=$montoNuevo, motivo=$motivo, estado=$estado, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'cotizacionId'] = this.cotizacionId;
      json[r'montoNuevo'] = this.montoNuevo;
      json[r'motivo'] = this.motivo;
      json[r'estado'] = this.estado;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [PendingAdjustmentItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PendingAdjustmentItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "PendingAdjustmentItem[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "PendingAdjustmentItem[id]" has a null value in JSON.');
        assert(json.containsKey(r'cotizacionId'), 'Required key "PendingAdjustmentItem[cotizacionId]" is missing from JSON.');
        assert(json[r'cotizacionId'] != null, 'Required key "PendingAdjustmentItem[cotizacionId]" has a null value in JSON.');
        assert(json.containsKey(r'montoNuevo'), 'Required key "PendingAdjustmentItem[montoNuevo]" is missing from JSON.');
        assert(json[r'montoNuevo'] != null, 'Required key "PendingAdjustmentItem[montoNuevo]" has a null value in JSON.');
        assert(json.containsKey(r'motivo'), 'Required key "PendingAdjustmentItem[motivo]" is missing from JSON.');
        assert(json[r'motivo'] != null, 'Required key "PendingAdjustmentItem[motivo]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "PendingAdjustmentItem[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "PendingAdjustmentItem[estado]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "PendingAdjustmentItem[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "PendingAdjustmentItem[venceEn]" has a null value in JSON.');
        return true;
      }());

      return PendingAdjustmentItem(
        id: mapValueOfType<String>(json, r'id')!,
        cotizacionId: mapValueOfType<String>(json, r'cotizacionId')!,
        montoNuevo: mapValueOfType<int>(json, r'montoNuevo')!,
        motivo: mapValueOfType<String>(json, r'motivo')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
      );
    }
    return null;
  }

  static List<PendingAdjustmentItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PendingAdjustmentItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PendingAdjustmentItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PendingAdjustmentItem> mapFromJson(dynamic json) {
    final map = <String, PendingAdjustmentItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PendingAdjustmentItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PendingAdjustmentItem-objects as value to a dart map
  static Map<String, List<PendingAdjustmentItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PendingAdjustmentItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PendingAdjustmentItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'cotizacionId',
    'montoNuevo',
    'motivo',
    'estado',
    'venceEn',
  };
}

