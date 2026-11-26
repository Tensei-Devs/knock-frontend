//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class OpinionModeratedEventBody {
  /// Returns a new [OpinionModeratedEventBody] instance.
  OpinionModeratedEventBody({
    required this.eventoId,
    required this.tipo,
    required this.opinionId,
    required this.tecnicoId,
    required this.accion,
    required this.porId,
  });

  String? eventoId;

  String? tipo;

  String? opinionId;

  String? tecnicoId;

  String? accion;

  String? porId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OpinionModeratedEventBody &&
    other.eventoId == eventoId &&
    other.tipo == tipo &&
    other.opinionId == opinionId &&
    other.tecnicoId == tecnicoId &&
    other.accion == accion &&
    other.porId == porId;

  @override
  int get hashCode =>
    (eventoId == null ? 0 : eventoId!.hashCode) +
    (tipo == null ? 0 : tipo!.hashCode) +
    (opinionId == null ? 0 : opinionId!.hashCode) +
    (tecnicoId == null ? 0 : tecnicoId!.hashCode) +
    (accion == null ? 0 : accion!.hashCode) +
    (porId == null ? 0 : porId!.hashCode);

  @override
  String toString() => 'OpinionModeratedEventBody[eventoId=$eventoId, tipo=$tipo, opinionId=$opinionId, tecnicoId=$tecnicoId, accion=$accion, porId=$porId]';

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
    if (this.opinionId != null) {
      json[r'opinionId'] = this.opinionId;
    } else {
      json[r'opinionId'] = null;
    }
    if (this.tecnicoId != null) {
      json[r'tecnicoId'] = this.tecnicoId;
    } else {
      json[r'tecnicoId'] = null;
    }
    if (this.accion != null) {
      json[r'accion'] = this.accion;
    } else {
      json[r'accion'] = null;
    }
    if (this.porId != null) {
      json[r'porId'] = this.porId;
    } else {
      json[r'porId'] = null;
    }
    return json;
  }

  /// Returns a new [OpinionModeratedEventBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static OpinionModeratedEventBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'eventoId'), 'Required key "OpinionModeratedEventBody[eventoId]" is missing from JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "OpinionModeratedEventBody[tipo]" is missing from JSON.');
        assert(json.containsKey(r'opinionId'), 'Required key "OpinionModeratedEventBody[opinionId]" is missing from JSON.');
        assert(json.containsKey(r'tecnicoId'), 'Required key "OpinionModeratedEventBody[tecnicoId]" is missing from JSON.');
        assert(json.containsKey(r'accion'), 'Required key "OpinionModeratedEventBody[accion]" is missing from JSON.');
        assert(json.containsKey(r'porId'), 'Required key "OpinionModeratedEventBody[porId]" is missing from JSON.');
        return true;
      }());

      return OpinionModeratedEventBody(
        eventoId: mapValueOfType<String>(json, r'eventoId'),
        tipo: mapValueOfType<String>(json, r'tipo'),
        opinionId: mapValueOfType<String>(json, r'opinionId'),
        tecnicoId: mapValueOfType<String>(json, r'tecnicoId'),
        accion: mapValueOfType<String>(json, r'accion'),
        porId: mapValueOfType<String>(json, r'porId'),
      );
    }
    return null;
  }

  static List<OpinionModeratedEventBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OpinionModeratedEventBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OpinionModeratedEventBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OpinionModeratedEventBody> mapFromJson(dynamic json) {
    final map = <String, OpinionModeratedEventBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = OpinionModeratedEventBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OpinionModeratedEventBody-objects as value to a dart map
  static Map<String, List<OpinionModeratedEventBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OpinionModeratedEventBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OpinionModeratedEventBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'eventoId',
    'tipo',
    'opinionId',
    'tecnicoId',
    'accion',
    'porId',
  };
}

