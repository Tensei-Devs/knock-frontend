//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class Suggestion {
  /// Returns a new [Suggestion] instance.
  Suggestion({
    required this.tipo,
    required this.texto,
    required this.clave,
    required this.id,
  });

  String tipo;

  String texto;

  String? clave;

  String? id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Suggestion &&
    other.tipo == tipo &&
    other.texto == texto &&
    other.clave == clave &&
    other.id == id;

  @override
  int get hashCode =>
    (tipo.hashCode) +
    (texto.hashCode) +
    (clave == null ? 0 : clave!.hashCode) +
    (id == null ? 0 : id!.hashCode);

  @override
  String toString() => 'Suggestion[tipo=$tipo, texto=$texto, clave=$clave, id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tipo'] = this.tipo;
      json[r'texto'] = this.texto;
    if (this.clave != null) {
      json[r'clave'] = this.clave;
    } else {
      json[r'clave'] = null;
    }
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    return json;
  }

  /// Returns a new [Suggestion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static Suggestion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipo'), 'Required key "Suggestion[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "Suggestion[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'texto'), 'Required key "Suggestion[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "Suggestion[texto]" has a null value in JSON.');
        assert(json.containsKey(r'clave'), 'Required key "Suggestion[clave]" is missing from JSON.');
        assert(json.containsKey(r'id'), 'Required key "Suggestion[id]" is missing from JSON.');
        return true;
      }());

      return Suggestion(
        tipo: mapValueOfType<String>(json, r'tipo')!,
        texto: mapValueOfType<String>(json, r'texto')!,
        clave: mapValueOfType<String>(json, r'clave'),
        id: mapValueOfType<String>(json, r'id'),
      );
    }
    return null;
  }

  static List<Suggestion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Suggestion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Suggestion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Suggestion> mapFromJson(dynamic json) {
    final map = <String, Suggestion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = Suggestion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Suggestion-objects as value to a dart map
  static Map<String, List<Suggestion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Suggestion>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Suggestion.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipo',
    'texto',
    'clave',
    'id',
  };
}

