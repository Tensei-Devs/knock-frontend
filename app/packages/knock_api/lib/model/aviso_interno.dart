//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AvisoInterno {
  /// Returns a new [AvisoInterno] instance.
  AvisoInterno({
    required this.eventoId,
    required this.tipo,
    required this.destinatarioId,
    required this.rol,
    required this.recurso,
    required this.sid,
  });

  String? eventoId;

  String? tipo;

  String? destinatarioId;

  String? rol;

  String? recurso;

  String? sid;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AvisoInterno &&
    other.eventoId == eventoId &&
    other.tipo == tipo &&
    other.destinatarioId == destinatarioId &&
    other.rol == rol &&
    other.recurso == recurso &&
    other.sid == sid;

  @override
  int get hashCode =>
    (eventoId == null ? 0 : eventoId!.hashCode) +
    (tipo == null ? 0 : tipo!.hashCode) +
    (destinatarioId == null ? 0 : destinatarioId!.hashCode) +
    (rol == null ? 0 : rol!.hashCode) +
    (recurso == null ? 0 : recurso!.hashCode) +
    (sid == null ? 0 : sid!.hashCode);

  @override
  String toString() => 'AvisoInterno[eventoId=$eventoId, tipo=$tipo, destinatarioId=$destinatarioId, rol=$rol, recurso=$recurso, sid=$sid]';

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
    if (this.destinatarioId != null) {
      json[r'destinatarioId'] = this.destinatarioId;
    } else {
      json[r'destinatarioId'] = null;
    }
    if (this.rol != null) {
      json[r'rol'] = this.rol;
    } else {
      json[r'rol'] = null;
    }
    if (this.recurso != null) {
      json[r'recurso'] = this.recurso;
    } else {
      json[r'recurso'] = null;
    }
    if (this.sid != null) {
      json[r'sid'] = this.sid;
    } else {
      json[r'sid'] = null;
    }
    return json;
  }

  /// Returns a new [AvisoInterno] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AvisoInterno? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'eventoId'), 'Required key "AvisoInterno[eventoId]" is missing from JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "AvisoInterno[tipo]" is missing from JSON.');
        assert(json.containsKey(r'destinatarioId'), 'Required key "AvisoInterno[destinatarioId]" is missing from JSON.');
        assert(json.containsKey(r'rol'), 'Required key "AvisoInterno[rol]" is missing from JSON.');
        assert(json.containsKey(r'recurso'), 'Required key "AvisoInterno[recurso]" is missing from JSON.');
        assert(json.containsKey(r'sid'), 'Required key "AvisoInterno[sid]" is missing from JSON.');
        return true;
      }());

      return AvisoInterno(
        eventoId: mapValueOfType<String>(json, r'eventoId'),
        tipo: mapValueOfType<String>(json, r'tipo'),
        destinatarioId: mapValueOfType<String>(json, r'destinatarioId'),
        rol: mapValueOfType<String>(json, r'rol'),
        recurso: mapValueOfType<String>(json, r'recurso'),
        sid: mapValueOfType<String>(json, r'sid'),
      );
    }
    return null;
  }

  static List<AvisoInterno> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AvisoInterno>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AvisoInterno.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AvisoInterno> mapFromJson(dynamic json) {
    final map = <String, AvisoInterno>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AvisoInterno.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AvisoInterno-objects as value to a dart map
  static Map<String, List<AvisoInterno>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AvisoInterno>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AvisoInterno.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'eventoId',
    'tipo',
    'destinatarioId',
    'rol',
    'recurso',
    'sid',
  };
}

