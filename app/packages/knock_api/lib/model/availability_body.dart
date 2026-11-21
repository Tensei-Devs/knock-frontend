//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AvailabilityBody {
  /// Returns a new [AvailabilityBody] instance.
  AvailabilityBody({
    required this.disponibleHoy,
  });

  bool? disponibleHoy;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AvailabilityBody &&
    other.disponibleHoy == disponibleHoy;

  @override
  int get hashCode =>
    (disponibleHoy == null ? 0 : disponibleHoy!.hashCode);

  @override
  String toString() => 'AvailabilityBody[disponibleHoy=$disponibleHoy]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.disponibleHoy != null) {
      json[r'disponibleHoy'] = this.disponibleHoy;
    } else {
      json[r'disponibleHoy'] = null;
    }
    return json;
  }

  /// Returns a new [AvailabilityBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AvailabilityBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'disponibleHoy'), 'Required key "AvailabilityBody[disponibleHoy]" is missing from JSON.');
        return true;
      }());

      return AvailabilityBody(
        disponibleHoy: mapValueOfType<bool>(json, r'disponibleHoy'),
      );
    }
    return null;
  }

  static List<AvailabilityBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AvailabilityBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AvailabilityBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AvailabilityBody> mapFromJson(dynamic json) {
    final map = <String, AvailabilityBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AvailabilityBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AvailabilityBody-objects as value to a dart map
  static Map<String, List<AvailabilityBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AvailabilityBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AvailabilityBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'disponibleHoy',
  };
}

