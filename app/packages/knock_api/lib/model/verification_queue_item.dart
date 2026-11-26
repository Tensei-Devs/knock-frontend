//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationQueueItem {
  /// Returns a new [VerificationQueueItem] instance.
  VerificationQueueItem({
    required this.id,
    required this.tipo,
    required this.nivel,
    required this.estado,
    required this.enviadaEn,
  });

  String id;

  String tipo;

  String nivel;

  String estado;

  DateTime enviadaEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationQueueItem &&
    other.id == id &&
    other.tipo == tipo &&
    other.nivel == nivel &&
    other.estado == estado &&
    other.enviadaEn == enviadaEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (tipo.hashCode) +
    (nivel.hashCode) +
    (estado.hashCode) +
    (enviadaEn.hashCode);

  @override
  String toString() => 'VerificationQueueItem[id=$id, tipo=$tipo, nivel=$nivel, estado=$estado, enviadaEn=$enviadaEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'tipo'] = this.tipo;
      json[r'nivel'] = this.nivel;
      json[r'estado'] = this.estado;
      json[r'enviadaEn'] = this.enviadaEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [VerificationQueueItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationQueueItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "VerificationQueueItem[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "VerificationQueueItem[id]" has a null value in JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "VerificationQueueItem[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "VerificationQueueItem[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'nivel'), 'Required key "VerificationQueueItem[nivel]" is missing from JSON.');
        assert(json[r'nivel'] != null, 'Required key "VerificationQueueItem[nivel]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "VerificationQueueItem[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "VerificationQueueItem[estado]" has a null value in JSON.');
        assert(json.containsKey(r'enviadaEn'), 'Required key "VerificationQueueItem[enviadaEn]" is missing from JSON.');
        assert(json[r'enviadaEn'] != null, 'Required key "VerificationQueueItem[enviadaEn]" has a null value in JSON.');
        return true;
      }());

      return VerificationQueueItem(
        id: mapValueOfType<String>(json, r'id')!,
        tipo: mapValueOfType<String>(json, r'tipo')!,
        nivel: mapValueOfType<String>(json, r'nivel')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        enviadaEn: mapDateTime(json, r'enviadaEn', r'')!,
      );
    }
    return null;
  }

  static List<VerificationQueueItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationQueueItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationQueueItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationQueueItem> mapFromJson(dynamic json) {
    final map = <String, VerificationQueueItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationQueueItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationQueueItem-objects as value to a dart map
  static Map<String, List<VerificationQueueItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationQueueItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationQueueItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'tipo',
    'nivel',
    'estado',
    'enviadaEn',
  };
}

