//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PhoneAvailabilityRequest {
  /// Returns a new [PhoneAvailabilityRequest] instance.
  PhoneAvailabilityRequest({
    this.celularNuevo,
  });

  String? celularNuevo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PhoneAvailabilityRequest &&
    other.celularNuevo == celularNuevo;

  @override
  int get hashCode =>
    (celularNuevo == null ? 0 : celularNuevo!.hashCode);

  @override
  String toString() => 'PhoneAvailabilityRequest[celularNuevo=$celularNuevo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.celularNuevo != null) {
      json[r'celularNuevo'] = this.celularNuevo;
    } else {
      json[r'celularNuevo'] = null;
    }
    return json;
  }

  /// Returns a new [PhoneAvailabilityRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PhoneAvailabilityRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return PhoneAvailabilityRequest(
        celularNuevo: mapValueOfType<String>(json, r'celularNuevo'),
      );
    }
    return null;
  }

  static List<PhoneAvailabilityRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PhoneAvailabilityRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PhoneAvailabilityRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PhoneAvailabilityRequest> mapFromJson(dynamic json) {
    final map = <String, PhoneAvailabilityRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PhoneAvailabilityRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PhoneAvailabilityRequest-objects as value to a dart map
  static Map<String, List<PhoneAvailabilityRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PhoneAvailabilityRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PhoneAvailabilityRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

