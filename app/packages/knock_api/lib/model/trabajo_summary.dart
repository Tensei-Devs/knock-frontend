//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrabajoSummary {
  /// Returns a new [TrabajoSummary] instance.
  TrabajoSummary({
    required this.trabajosTerminados,
    required this.calificacion,
  });

  int trabajosTerminados;

  Object? calificacion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrabajoSummary &&
    other.trabajosTerminados == trabajosTerminados &&
    other.calificacion == calificacion;

  @override
  int get hashCode =>
    (trabajosTerminados.hashCode) +
    (calificacion == null ? 0 : calificacion!.hashCode);

  @override
  String toString() => 'TrabajoSummary[trabajosTerminados=$trabajosTerminados, calificacion=$calificacion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'trabajosTerminados'] = this.trabajosTerminados;
    if (this.calificacion != null) {
      json[r'calificacion'] = this.calificacion;
    } else {
      json[r'calificacion'] = null;
    }
    return json;
  }

  /// Returns a new [TrabajoSummary] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrabajoSummary? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'trabajosTerminados'), 'Required key "TrabajoSummary[trabajosTerminados]" is missing from JSON.');
        assert(json[r'trabajosTerminados'] != null, 'Required key "TrabajoSummary[trabajosTerminados]" has a null value in JSON.');
        assert(json.containsKey(r'calificacion'), 'Required key "TrabajoSummary[calificacion]" is missing from JSON.');
        return true;
      }());

      return TrabajoSummary(
        trabajosTerminados: mapValueOfType<int>(json, r'trabajosTerminados')!,
        calificacion: mapValueOfType<Object>(json, r'calificacion'),
      );
    }
    return null;
  }

  static List<TrabajoSummary> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrabajoSummary>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrabajoSummary.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrabajoSummary> mapFromJson(dynamic json) {
    final map = <String, TrabajoSummary>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrabajoSummary.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrabajoSummary-objects as value to a dart map
  static Map<String, List<TrabajoSummary>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrabajoSummary>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrabajoSummary.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'trabajosTerminados',
    'calificacion',
  };
}

