//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ClientAbsentResponse {
  /// Returns a new [ClientAbsentResponse] instance.
  ClientAbsentResponse({
    required this.visitaId,
    required this.estado,
    required this.quienFalto,
  });

  String visitaId;

  String estado;

  String quienFalto;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClientAbsentResponse &&
    other.visitaId == visitaId &&
    other.estado == estado &&
    other.quienFalto == quienFalto;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (estado.hashCode) +
    (quienFalto.hashCode);

  @override
  String toString() => 'ClientAbsentResponse[visitaId=$visitaId, estado=$estado, quienFalto=$quienFalto]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'estado'] = this.estado;
      json[r'quienFalto'] = this.quienFalto;
    return json;
  }

  /// Returns a new [ClientAbsentResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ClientAbsentResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "ClientAbsentResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "ClientAbsentResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "ClientAbsentResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "ClientAbsentResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'quienFalto'), 'Required key "ClientAbsentResponse[quienFalto]" is missing from JSON.');
        assert(json[r'quienFalto'] != null, 'Required key "ClientAbsentResponse[quienFalto]" has a null value in JSON.');
        return true;
      }());

      return ClientAbsentResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        quienFalto: mapValueOfType<String>(json, r'quienFalto')!,
      );
    }
    return null;
  }

  static List<ClientAbsentResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClientAbsentResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClientAbsentResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClientAbsentResponse> mapFromJson(dynamic json) {
    final map = <String, ClientAbsentResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ClientAbsentResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClientAbsentResponse-objects as value to a dart map
  static Map<String, List<ClientAbsentResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClientAbsentResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClientAbsentResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'estado',
    'quienFalto',
  };
}

