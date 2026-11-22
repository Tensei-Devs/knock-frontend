//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class DayScheduleDto {
  /// Returns a new [DayScheduleDto] instance.
  DayScheduleDto({
    required this.dia,
    required this.abierto,
    this.franjas = const [],
  });

  String? dia;

  bool? abierto;

  List<TimeRangeDto>? franjas;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DayScheduleDto &&
    other.dia == dia &&
    other.abierto == abierto &&
    _deepEquality.equals(other.franjas, franjas);

  @override
  int get hashCode =>
    (dia == null ? 0 : dia!.hashCode) +
    (abierto == null ? 0 : abierto!.hashCode) +
    (franjas == null ? 0 : franjas!.hashCode);

  @override
  String toString() => 'DayScheduleDto[dia=$dia, abierto=$abierto, franjas=$franjas]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dia != null) {
      json[r'dia'] = this.dia;
    } else {
      json[r'dia'] = null;
    }
    if (this.abierto != null) {
      json[r'abierto'] = this.abierto;
    } else {
      json[r'abierto'] = null;
    }
    if (this.franjas != null) {
      json[r'franjas'] = this.franjas;
    } else {
      json[r'franjas'] = null;
    }
    return json;
  }

  /// Returns a new [DayScheduleDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static DayScheduleDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'dia'), 'Required key "DayScheduleDto[dia]" is missing from JSON.');
        assert(json.containsKey(r'abierto'), 'Required key "DayScheduleDto[abierto]" is missing from JSON.');
        assert(json.containsKey(r'franjas'), 'Required key "DayScheduleDto[franjas]" is missing from JSON.');
        return true;
      }());

      return DayScheduleDto(
        dia: mapValueOfType<String>(json, r'dia'),
        abierto: mapValueOfType<bool>(json, r'abierto'),
        franjas: TimeRangeDto.listFromJson(json[r'franjas']),
      );
    }
    return null;
  }

  static List<DayScheduleDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DayScheduleDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DayScheduleDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DayScheduleDto> mapFromJson(dynamic json) {
    final map = <String, DayScheduleDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = DayScheduleDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DayScheduleDto-objects as value to a dart map
  static Map<String, List<DayScheduleDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DayScheduleDto>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DayScheduleDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'dia',
    'abierto',
    'franjas',
  };
}

