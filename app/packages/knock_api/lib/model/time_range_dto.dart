//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TimeRangeDto {
  /// Returns a new [TimeRangeDto] instance.
  TimeRangeDto({
    required this.inicio,
    required this.fin,
  });

  String? inicio;

  String? fin;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TimeRangeDto &&
    other.inicio == inicio &&
    other.fin == fin;

  @override
  int get hashCode =>
    (inicio == null ? 0 : inicio!.hashCode) +
    (fin == null ? 0 : fin!.hashCode);

  @override
  String toString() => 'TimeRangeDto[inicio=$inicio, fin=$fin]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.inicio != null) {
      json[r'inicio'] = this.inicio;
    } else {
      json[r'inicio'] = null;
    }
    if (this.fin != null) {
      json[r'fin'] = this.fin;
    } else {
      json[r'fin'] = null;
    }
    return json;
  }

  /// Returns a new [TimeRangeDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TimeRangeDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'inicio'), 'Required key "TimeRangeDto[inicio]" is missing from JSON.');
        assert(json.containsKey(r'fin'), 'Required key "TimeRangeDto[fin]" is missing from JSON.');
        return true;
      }());

      return TimeRangeDto(
        inicio: mapValueOfType<String>(json, r'inicio'),
        fin: mapValueOfType<String>(json, r'fin'),
      );
    }
    return null;
  }

  static List<TimeRangeDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TimeRangeDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TimeRangeDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TimeRangeDto> mapFromJson(dynamic json) {
    final map = <String, TimeRangeDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TimeRangeDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TimeRangeDto-objects as value to a dart map
  static Map<String, List<TimeRangeDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TimeRangeDto>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TimeRangeDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'inicio',
    'fin',
  };
}

