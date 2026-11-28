//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ConversacionExportada {
  /// Returns a new [ConversacionExportada] instance.
  ConversacionExportada({
    required this.conversacionId,
    required this.rol,
    this.mensajes = const [],
  });

  String conversacionId;

  String rol;

  List<MensajePropioExportado> mensajes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversacionExportada &&
    other.conversacionId == conversacionId &&
    other.rol == rol &&
    _deepEquality.equals(other.mensajes, mensajes);

  @override
  int get hashCode =>
    (conversacionId.hashCode) +
    (rol.hashCode) +
    (mensajes.hashCode);

  @override
  String toString() => 'ConversacionExportada[conversacionId=$conversacionId, rol=$rol, mensajes=$mensajes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'conversacionId'] = this.conversacionId;
      json[r'rol'] = this.rol;
      json[r'mensajes'] = this.mensajes;
    return json;
  }

  /// Returns a new [ConversacionExportada] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ConversacionExportada? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'conversacionId'), 'Required key "ConversacionExportada[conversacionId]" is missing from JSON.');
        assert(json[r'conversacionId'] != null, 'Required key "ConversacionExportada[conversacionId]" has a null value in JSON.');
        assert(json.containsKey(r'rol'), 'Required key "ConversacionExportada[rol]" is missing from JSON.');
        assert(json[r'rol'] != null, 'Required key "ConversacionExportada[rol]" has a null value in JSON.');
        assert(json.containsKey(r'mensajes'), 'Required key "ConversacionExportada[mensajes]" is missing from JSON.');
        assert(json[r'mensajes'] != null, 'Required key "ConversacionExportada[mensajes]" has a null value in JSON.');
        return true;
      }());

      return ConversacionExportada(
        conversacionId: mapValueOfType<String>(json, r'conversacionId')!,
        rol: mapValueOfType<String>(json, r'rol')!,
        mensajes: MensajePropioExportado.listFromJson(json[r'mensajes']),
      );
    }
    return null;
  }

  static List<ConversacionExportada> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversacionExportada>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversacionExportada.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversacionExportada> mapFromJson(dynamic json) {
    final map = <String, ConversacionExportada>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ConversacionExportada.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversacionExportada-objects as value to a dart map
  static Map<String, List<ConversacionExportada>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversacionExportada>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversacionExportada.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'conversacionId',
    'rol',
    'mensajes',
  };
}

