//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ScheduleBody {
  /// Returns a new [ScheduleBody] instance.
  ScheduleBody({
    this.horarios = const [],
  });

  List<DayScheduleDto>? horarios;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ScheduleBody &&
    _deepEquality.equals(other.horarios, horarios);

  @override
  int get hashCode =>
    (horarios == null ? 0 : horarios!.hashCode);

  @override
  String toString() => 'ScheduleBody[horarios=$horarios]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.horarios != null) {
      json[r'horarios'] = this.horarios;
    } else {
      json[r'horarios'] = null;
    }
    return json;
  }

  /// Returns a new [ScheduleBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ScheduleBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'horarios'), 'Required key "ScheduleBody[horarios]" is missing from JSON.');
        return true;
      }());

      return ScheduleBody(
        horarios: DayScheduleDto.listFromJson(json[r'horarios']),
      );
    }
    return null;
  }

  static List<ScheduleBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ScheduleBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ScheduleBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ScheduleBody> mapFromJson(dynamic json) {
    final map = <String, ScheduleBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ScheduleBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ScheduleBody-objects as value to a dart map
  static Map<String, List<ScheduleBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ScheduleBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ScheduleBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'horarios',
  };
}

