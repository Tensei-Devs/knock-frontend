//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CrearConversacionBody {
  /// Returns a new [CrearConversacionBody] instance.
  CrearConversacionBody({
    required this.solicitudId,
    required this.tecnicoId,
  });

  String? solicitudId;

  String? tecnicoId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CrearConversacionBody &&
    other.solicitudId == solicitudId &&
    other.tecnicoId == tecnicoId;

  @override
  int get hashCode =>
    (solicitudId == null ? 0 : solicitudId!.hashCode) +
    (tecnicoId == null ? 0 : tecnicoId!.hashCode);

  @override
  String toString() => 'CrearConversacionBody[solicitudId=$solicitudId, tecnicoId=$tecnicoId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.solicitudId != null) {
      json[r'solicitudId'] = this.solicitudId;
    } else {
      json[r'solicitudId'] = null;
    }
    if (this.tecnicoId != null) {
      json[r'tecnicoId'] = this.tecnicoId;
    } else {
      json[r'tecnicoId'] = null;
    }
    return json;
  }

  /// Returns a new [CrearConversacionBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CrearConversacionBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'solicitudId'), 'Required key "CrearConversacionBody[solicitudId]" is missing from JSON.');
        assert(json.containsKey(r'tecnicoId'), 'Required key "CrearConversacionBody[tecnicoId]" is missing from JSON.');
        return true;
      }());

      return CrearConversacionBody(
        solicitudId: mapValueOfType<String>(json, r'solicitudId'),
        tecnicoId: mapValueOfType<String>(json, r'tecnicoId'),
      );
    }
    return null;
  }

  static List<CrearConversacionBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CrearConversacionBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CrearConversacionBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CrearConversacionBody> mapFromJson(dynamic json) {
    final map = <String, CrearConversacionBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CrearConversacionBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CrearConversacionBody-objects as value to a dart map
  static Map<String, List<CrearConversacionBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CrearConversacionBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CrearConversacionBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'solicitudId',
    'tecnicoId',
  };
}

