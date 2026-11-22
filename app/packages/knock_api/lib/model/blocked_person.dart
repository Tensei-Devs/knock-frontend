//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class BlockedPerson {
  /// Returns a new [BlockedPerson] instance.
  BlockedPerson({
    required this.usuarioId,
    required this.nombre,
    required this.bloqueadoEn,
  });

  String usuarioId;

  String nombre;

  DateTime bloqueadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BlockedPerson &&
    other.usuarioId == usuarioId &&
    other.nombre == nombre &&
    other.bloqueadoEn == bloqueadoEn;

  @override
  int get hashCode =>
    (usuarioId.hashCode) +
    (nombre.hashCode) +
    (bloqueadoEn.hashCode);

  @override
  String toString() => 'BlockedPerson[usuarioId=$usuarioId, nombre=$nombre, bloqueadoEn=$bloqueadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'usuarioId'] = this.usuarioId;
      json[r'nombre'] = this.nombre;
      json[r'bloqueadoEn'] = this.bloqueadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [BlockedPerson] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static BlockedPerson? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'usuarioId'), 'Required key "BlockedPerson[usuarioId]" is missing from JSON.');
        assert(json[r'usuarioId'] != null, 'Required key "BlockedPerson[usuarioId]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "BlockedPerson[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "BlockedPerson[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'bloqueadoEn'), 'Required key "BlockedPerson[bloqueadoEn]" is missing from JSON.');
        assert(json[r'bloqueadoEn'] != null, 'Required key "BlockedPerson[bloqueadoEn]" has a null value in JSON.');
        return true;
      }());

      return BlockedPerson(
        usuarioId: mapValueOfType<String>(json, r'usuarioId')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        bloqueadoEn: mapDateTime(json, r'bloqueadoEn', r'')!,
      );
    }
    return null;
  }

  static List<BlockedPerson> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BlockedPerson>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BlockedPerson.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BlockedPerson> mapFromJson(dynamic json) {
    final map = <String, BlockedPerson>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = BlockedPerson.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BlockedPerson-objects as value to a dart map
  static Map<String, List<BlockedPerson>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BlockedPerson>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BlockedPerson.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'usuarioId',
    'nombre',
    'bloqueadoEn',
  };
}

