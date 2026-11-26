//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TurnoBody {
  /// Returns a new [TurnoBody] instance.
  TurnoBody({
    required this.mensaje,
    required this.foto,
    required this.contexto,
  });

  String? mensaje;

  String? foto;

  String? contexto;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TurnoBody &&
    other.mensaje == mensaje &&
    other.foto == foto &&
    other.contexto == contexto;

  @override
  int get hashCode =>
    (mensaje == null ? 0 : mensaje!.hashCode) +
    (foto == null ? 0 : foto!.hashCode) +
    (contexto == null ? 0 : contexto!.hashCode);

  @override
  String toString() => 'TurnoBody[mensaje=$mensaje, foto=$foto, contexto=$contexto]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.mensaje != null) {
      json[r'mensaje'] = this.mensaje;
    } else {
      json[r'mensaje'] = null;
    }
    if (this.foto != null) {
      json[r'foto'] = this.foto;
    } else {
      json[r'foto'] = null;
    }
    if (this.contexto != null) {
      json[r'contexto'] = this.contexto;
    } else {
      json[r'contexto'] = null;
    }
    return json;
  }

  /// Returns a new [TurnoBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TurnoBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'mensaje'), 'Required key "TurnoBody[mensaje]" is missing from JSON.');
        assert(json.containsKey(r'foto'), 'Required key "TurnoBody[foto]" is missing from JSON.');
        assert(json.containsKey(r'contexto'), 'Required key "TurnoBody[contexto]" is missing from JSON.');
        return true;
      }());

      return TurnoBody(
        mensaje: mapValueOfType<String>(json, r'mensaje'),
        foto: mapValueOfType<String>(json, r'foto'),
        contexto: mapValueOfType<String>(json, r'contexto'),
      );
    }
    return null;
  }

  static List<TurnoBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TurnoBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TurnoBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TurnoBody> mapFromJson(dynamic json) {
    final map = <String, TurnoBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TurnoBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TurnoBody-objects as value to a dart map
  static Map<String, List<TurnoBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TurnoBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TurnoBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'mensaje',
    'foto',
    'contexto',
  };
}

