//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class HistoryItemResponse {
  /// Returns a new [HistoryItemResponse] instance.
  HistoryItemResponse({
    required this.fecha,
    required this.oficio,
    required this.tecnico,
  });

  String fecha;

  String oficio;

  String tecnico;

  @override
  bool operator ==(Object other) => identical(this, other) || other is HistoryItemResponse &&
    other.fecha == fecha &&
    other.oficio == oficio &&
    other.tecnico == tecnico;

  @override
  int get hashCode =>
    (fecha.hashCode) +
    (oficio.hashCode) +
    (tecnico.hashCode);

  @override
  String toString() => 'HistoryItemResponse[fecha=$fecha, oficio=$oficio, tecnico=$tecnico]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fecha'] = this.fecha;
      json[r'oficio'] = this.oficio;
      json[r'tecnico'] = this.tecnico;
    return json;
  }

  /// Returns a new [HistoryItemResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static HistoryItemResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'fecha'), 'Required key "HistoryItemResponse[fecha]" is missing from JSON.');
        assert(json[r'fecha'] != null, 'Required key "HistoryItemResponse[fecha]" has a null value in JSON.');
        assert(json.containsKey(r'oficio'), 'Required key "HistoryItemResponse[oficio]" is missing from JSON.');
        assert(json[r'oficio'] != null, 'Required key "HistoryItemResponse[oficio]" has a null value in JSON.');
        assert(json.containsKey(r'tecnico'), 'Required key "HistoryItemResponse[tecnico]" is missing from JSON.');
        assert(json[r'tecnico'] != null, 'Required key "HistoryItemResponse[tecnico]" has a null value in JSON.');
        return true;
      }());

      return HistoryItemResponse(
        fecha: mapValueOfType<String>(json, r'fecha')!,
        oficio: mapValueOfType<String>(json, r'oficio')!,
        tecnico: mapValueOfType<String>(json, r'tecnico')!,
      );
    }
    return null;
  }

  static List<HistoryItemResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <HistoryItemResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HistoryItemResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HistoryItemResponse> mapFromJson(dynamic json) {
    final map = <String, HistoryItemResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = HistoryItemResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HistoryItemResponse-objects as value to a dart map
  static Map<String, List<HistoryItemResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<HistoryItemResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HistoryItemResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fecha',
    'oficio',
    'tecnico',
  };
}

