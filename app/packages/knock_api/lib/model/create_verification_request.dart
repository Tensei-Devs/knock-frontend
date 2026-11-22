//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CreateVerificationRequest {
  /// Returns a new [CreateVerificationRequest] instance.
  CreateVerificationRequest({
    required this.nivel,
    required this.aceptaBiometria,
    required this.versionAviso,
    required this.curp,
  });

  String? nivel;

  bool? aceptaBiometria;

  String? versionAviso;

  String? curp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateVerificationRequest &&
    other.nivel == nivel &&
    other.aceptaBiometria == aceptaBiometria &&
    other.versionAviso == versionAviso &&
    other.curp == curp;

  @override
  int get hashCode =>
    (nivel == null ? 0 : nivel!.hashCode) +
    (aceptaBiometria == null ? 0 : aceptaBiometria!.hashCode) +
    (versionAviso == null ? 0 : versionAviso!.hashCode) +
    (curp == null ? 0 : curp!.hashCode);

  @override
  String toString() => 'CreateVerificationRequest[nivel=$nivel, aceptaBiometria=$aceptaBiometria, versionAviso=$versionAviso, curp=$curp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.nivel != null) {
      json[r'nivel'] = this.nivel;
    } else {
      json[r'nivel'] = null;
    }
    if (this.aceptaBiometria != null) {
      json[r'aceptaBiometria'] = this.aceptaBiometria;
    } else {
      json[r'aceptaBiometria'] = null;
    }
    if (this.versionAviso != null) {
      json[r'versionAviso'] = this.versionAviso;
    } else {
      json[r'versionAviso'] = null;
    }
    if (this.curp != null) {
      json[r'curp'] = this.curp;
    } else {
      json[r'curp'] = null;
    }
    return json;
  }

  /// Returns a new [CreateVerificationRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CreateVerificationRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'nivel'), 'Required key "CreateVerificationRequest[nivel]" is missing from JSON.');
        assert(json.containsKey(r'aceptaBiometria'), 'Required key "CreateVerificationRequest[aceptaBiometria]" is missing from JSON.');
        assert(json.containsKey(r'versionAviso'), 'Required key "CreateVerificationRequest[versionAviso]" is missing from JSON.');
        assert(json.containsKey(r'curp'), 'Required key "CreateVerificationRequest[curp]" is missing from JSON.');
        return true;
      }());

      return CreateVerificationRequest(
        nivel: mapValueOfType<String>(json, r'nivel'),
        aceptaBiometria: mapValueOfType<bool>(json, r'aceptaBiometria'),
        versionAviso: mapValueOfType<String>(json, r'versionAviso'),
        curp: mapValueOfType<String>(json, r'curp'),
      );
    }
    return null;
  }

  static List<CreateVerificationRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateVerificationRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateVerificationRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateVerificationRequest> mapFromJson(dynamic json) {
    final map = <String, CreateVerificationRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CreateVerificationRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateVerificationRequest-objects as value to a dart map
  static Map<String, List<CreateVerificationRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateVerificationRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateVerificationRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'nivel',
    'aceptaBiometria',
    'versionAviso',
    'curp',
  };
}

