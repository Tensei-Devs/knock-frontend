//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PedirSubidaImagenRequest {
  /// Returns a new [PedirSubidaImagenRequest] instance.
  PedirSubidaImagenRequest({
    required this.proposito,
    required this.tipoContenido,
    required this.tamanoBytes,
  });

  String? proposito;

  String? tipoContenido;

  int? tamanoBytes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PedirSubidaImagenRequest &&
    other.proposito == proposito &&
    other.tipoContenido == tipoContenido &&
    other.tamanoBytes == tamanoBytes;

  @override
  int get hashCode =>
    (proposito == null ? 0 : proposito!.hashCode) +
    (tipoContenido == null ? 0 : tipoContenido!.hashCode) +
    (tamanoBytes == null ? 0 : tamanoBytes!.hashCode);

  @override
  String toString() => 'PedirSubidaImagenRequest[proposito=$proposito, tipoContenido=$tipoContenido, tamanoBytes=$tamanoBytes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.proposito != null) {
      json[r'proposito'] = this.proposito;
    } else {
      json[r'proposito'] = null;
    }
    if (this.tipoContenido != null) {
      json[r'tipoContenido'] = this.tipoContenido;
    } else {
      json[r'tipoContenido'] = null;
    }
    if (this.tamanoBytes != null) {
      json[r'tamanoBytes'] = this.tamanoBytes;
    } else {
      json[r'tamanoBytes'] = null;
    }
    return json;
  }

  /// Returns a new [PedirSubidaImagenRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PedirSubidaImagenRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'proposito'), 'Required key "PedirSubidaImagenRequest[proposito]" is missing from JSON.');
        assert(json.containsKey(r'tipoContenido'), 'Required key "PedirSubidaImagenRequest[tipoContenido]" is missing from JSON.');
        assert(json.containsKey(r'tamanoBytes'), 'Required key "PedirSubidaImagenRequest[tamanoBytes]" is missing from JSON.');
        return true;
      }());

      return PedirSubidaImagenRequest(
        proposito: mapValueOfType<String>(json, r'proposito'),
        tipoContenido: mapValueOfType<String>(json, r'tipoContenido'),
        tamanoBytes: mapValueOfType<int>(json, r'tamanoBytes'),
      );
    }
    return null;
  }

  static List<PedirSubidaImagenRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PedirSubidaImagenRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PedirSubidaImagenRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PedirSubidaImagenRequest> mapFromJson(dynamic json) {
    final map = <String, PedirSubidaImagenRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PedirSubidaImagenRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PedirSubidaImagenRequest-objects as value to a dart map
  static Map<String, List<PedirSubidaImagenRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PedirSubidaImagenRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PedirSubidaImagenRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'proposito',
    'tipoContenido',
    'tamanoBytes',
  };
}

