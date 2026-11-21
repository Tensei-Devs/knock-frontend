//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class HistoryEntryResponse {
  /// Returns a new [HistoryEntryResponse] instance.
  HistoryEntryResponse({
    required this.fecha,
    required this.oficio,
    required this.tecnico,
  });

  String fecha;

  String oficio;

  String tecnico;

  @override
  bool operator ==(Object other) => identical(this, other) || other is HistoryEntryResponse &&
    other.fecha == fecha &&
    other.oficio == oficio &&
    other.tecnico == tecnico;

  @override
  int get hashCode =>
    (fecha.hashCode) +
    (oficio.hashCode) +
    (tecnico.hashCode);

  @override
  String toString() => 'HistoryEntryResponse[fecha=$fecha, oficio=$oficio, tecnico=$tecnico]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fecha'] = this.fecha;
      json[r'oficio'] = this.oficio;
      json[r'tecnico'] = this.tecnico;
    return json;
  }

  /// Returns a new [HistoryEntryResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static HistoryEntryResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'fecha'), 'Required key "HistoryEntryResponse[fecha]" is missing from JSON.');
        assert(json[r'fecha'] != null, 'Required key "HistoryEntryResponse[fecha]" has a null value in JSON.');
        assert(json.containsKey(r'oficio'), 'Required key "HistoryEntryResponse[oficio]" is missing from JSON.');
        assert(json[r'oficio'] != null, 'Required key "HistoryEntryResponse[oficio]" has a null value in JSON.');
        assert(json.containsKey(r'tecnico'), 'Required key "HistoryEntryResponse[tecnico]" is missing from JSON.');
        assert(json[r'tecnico'] != null, 'Required key "HistoryEntryResponse[tecnico]" has a null value in JSON.');
        return true;
      }());

      return HistoryEntryResponse(
        fecha: mapValueOfType<String>(json, r'fecha')!,
        oficio: mapValueOfType<String>(json, r'oficio')!,
        tecnico: mapValueOfType<String>(json, r'tecnico')!,
      );
    }
    return null;
  }

  static List<HistoryEntryResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <HistoryEntryResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HistoryEntryResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HistoryEntryResponse> mapFromJson(dynamic json) {
    final map = <String, HistoryEntryResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = HistoryEntryResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HistoryEntryResponse-objects as value to a dart map
  static Map<String, List<HistoryEntryResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<HistoryEntryResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HistoryEntryResponse.listFromJson(entry.value, growable: growable,);
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

