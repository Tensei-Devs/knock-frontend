//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ZonaResponse {
  /// Returns a new [ZonaResponse] instance.
  ZonaResponse({
    required this.enCobertura,
    required this.ciudadPiloto,
    this.colonias = const [],
  });

  bool enCobertura;

  String ciudadPiloto;

  List<ZonaColoniaResponse> colonias;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ZonaResponse &&
    other.enCobertura == enCobertura &&
    other.ciudadPiloto == ciudadPiloto &&
    _deepEquality.equals(other.colonias, colonias);

  @override
  int get hashCode =>
    (enCobertura.hashCode) +
    (ciudadPiloto.hashCode) +
    (colonias.hashCode);

  @override
  String toString() => 'ZonaResponse[enCobertura=$enCobertura, ciudadPiloto=$ciudadPiloto, colonias=$colonias]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'enCobertura'] = this.enCobertura;
      json[r'ciudadPiloto'] = this.ciudadPiloto;
      json[r'colonias'] = this.colonias;
    return json;
  }

  /// Returns a new [ZonaResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ZonaResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'enCobertura'), 'Required key "ZonaResponse[enCobertura]" is missing from JSON.');
        assert(json[r'enCobertura'] != null, 'Required key "ZonaResponse[enCobertura]" has a null value in JSON.');
        assert(json.containsKey(r'ciudadPiloto'), 'Required key "ZonaResponse[ciudadPiloto]" is missing from JSON.');
        assert(json[r'ciudadPiloto'] != null, 'Required key "ZonaResponse[ciudadPiloto]" has a null value in JSON.');
        assert(json.containsKey(r'colonias'), 'Required key "ZonaResponse[colonias]" is missing from JSON.');
        assert(json[r'colonias'] != null, 'Required key "ZonaResponse[colonias]" has a null value in JSON.');
        return true;
      }());

      return ZonaResponse(
        enCobertura: mapValueOfType<bool>(json, r'enCobertura')!,
        ciudadPiloto: mapValueOfType<String>(json, r'ciudadPiloto')!,
        colonias: ZonaColoniaResponse.listFromJson(json[r'colonias']),
      );
    }
    return null;
  }

  static List<ZonaResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ZonaResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ZonaResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ZonaResponse> mapFromJson(dynamic json) {
    final map = <String, ZonaResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ZonaResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ZonaResponse-objects as value to a dart map
  static Map<String, List<ZonaResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ZonaResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ZonaResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'enCobertura',
    'ciudadPiloto',
    'colonias',
  };
}

