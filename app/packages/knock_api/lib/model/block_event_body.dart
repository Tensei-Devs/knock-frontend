//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class BlockEventBody {
  /// Returns a new [BlockEventBody] instance.
  BlockEventBody({
    required this.eventoId,
    required this.tipo,
    required this.bloqueaId,
    required this.bloqueadoId,
    required this.ocurridoEn,
  });

  String? eventoId;

  String? tipo;

  String? bloqueaId;

  String? bloqueadoId;

  DateTime? ocurridoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BlockEventBody &&
    other.eventoId == eventoId &&
    other.tipo == tipo &&
    other.bloqueaId == bloqueaId &&
    other.bloqueadoId == bloqueadoId &&
    other.ocurridoEn == ocurridoEn;

  @override
  int get hashCode =>
    (eventoId == null ? 0 : eventoId!.hashCode) +
    (tipo == null ? 0 : tipo!.hashCode) +
    (bloqueaId == null ? 0 : bloqueaId!.hashCode) +
    (bloqueadoId == null ? 0 : bloqueadoId!.hashCode) +
    (ocurridoEn == null ? 0 : ocurridoEn!.hashCode);

  @override
  String toString() => 'BlockEventBody[eventoId=$eventoId, tipo=$tipo, bloqueaId=$bloqueaId, bloqueadoId=$bloqueadoId, ocurridoEn=$ocurridoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.eventoId != null) {
      json[r'eventoId'] = this.eventoId;
    } else {
      json[r'eventoId'] = null;
    }
    if (this.tipo != null) {
      json[r'tipo'] = this.tipo;
    } else {
      json[r'tipo'] = null;
    }
    if (this.bloqueaId != null) {
      json[r'bloqueaId'] = this.bloqueaId;
    } else {
      json[r'bloqueaId'] = null;
    }
    if (this.bloqueadoId != null) {
      json[r'bloqueadoId'] = this.bloqueadoId;
    } else {
      json[r'bloqueadoId'] = null;
    }
    if (this.ocurridoEn != null) {
      json[r'ocurridoEn'] = this.ocurridoEn!.toUtc().toIso8601String();
    } else {
      json[r'ocurridoEn'] = null;
    }
    return json;
  }

  /// Returns a new [BlockEventBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static BlockEventBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'eventoId'), 'Required key "BlockEventBody[eventoId]" is missing from JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "BlockEventBody[tipo]" is missing from JSON.');
        assert(json.containsKey(r'bloqueaId'), 'Required key "BlockEventBody[bloqueaId]" is missing from JSON.');
        assert(json.containsKey(r'bloqueadoId'), 'Required key "BlockEventBody[bloqueadoId]" is missing from JSON.');
        assert(json.containsKey(r'ocurridoEn'), 'Required key "BlockEventBody[ocurridoEn]" is missing from JSON.');
        return true;
      }());

      return BlockEventBody(
        eventoId: mapValueOfType<String>(json, r'eventoId'),
        tipo: mapValueOfType<String>(json, r'tipo'),
        bloqueaId: mapValueOfType<String>(json, r'bloqueaId'),
        bloqueadoId: mapValueOfType<String>(json, r'bloqueadoId'),
        ocurridoEn: mapDateTime(json, r'ocurridoEn', r''),
      );
    }
    return null;
  }

  static List<BlockEventBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BlockEventBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BlockEventBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BlockEventBody> mapFromJson(dynamic json) {
    final map = <String, BlockEventBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = BlockEventBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BlockEventBody-objects as value to a dart map
  static Map<String, List<BlockEventBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BlockEventBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BlockEventBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'eventoId',
    'tipo',
    'bloqueaId',
    'bloqueadoId',
    'ocurridoEn',
  };
}

