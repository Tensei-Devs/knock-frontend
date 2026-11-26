//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RescheduleBody {
  /// Returns a new [RescheduleBody] instance.
  RescheduleBody({
    required this.fechaHora,
  });

  DateTime? fechaHora;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RescheduleBody &&
    other.fechaHora == fechaHora;

  @override
  int get hashCode =>
    (fechaHora == null ? 0 : fechaHora!.hashCode);

  @override
  String toString() => 'RescheduleBody[fechaHora=$fechaHora]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.fechaHora != null) {
      json[r'fechaHora'] = this.fechaHora!.toUtc().toIso8601String();
    } else {
      json[r'fechaHora'] = null;
    }
    return json;
  }

  /// Returns a new [RescheduleBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RescheduleBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'fechaHora'), 'Required key "RescheduleBody[fechaHora]" is missing from JSON.');
        return true;
      }());

      return RescheduleBody(
        fechaHora: mapDateTime(json, r'fechaHora', r''),
      );
    }
    return null;
  }

  static List<RescheduleBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RescheduleBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RescheduleBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RescheduleBody> mapFromJson(dynamic json) {
    final map = <String, RescheduleBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RescheduleBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RescheduleBody-objects as value to a dart map
  static Map<String, List<RescheduleBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RescheduleBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RescheduleBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fechaHora',
  };
}

