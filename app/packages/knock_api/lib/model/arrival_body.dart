//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ArrivalBody {
  /// Returns a new [ArrivalBody] instance.
  ArrivalBody({
    required this.codigo,
  });

  String? codigo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ArrivalBody &&
    other.codigo == codigo;

  @override
  int get hashCode =>
    (codigo == null ? 0 : codigo!.hashCode);

  @override
  String toString() => 'ArrivalBody[codigo=$codigo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.codigo != null) {
      json[r'codigo'] = this.codigo;
    } else {
      json[r'codigo'] = null;
    }
    return json;
  }

  /// Returns a new [ArrivalBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ArrivalBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'codigo'), 'Required key "ArrivalBody[codigo]" is missing from JSON.');
        return true;
      }());

      return ArrivalBody(
        codigo: mapValueOfType<String>(json, r'codigo'),
      );
    }
    return null;
  }

  static List<ArrivalBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ArrivalBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ArrivalBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ArrivalBody> mapFromJson(dynamic json) {
    final map = <String, ArrivalBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ArrivalBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ArrivalBody-objects as value to a dart map
  static Map<String, List<ArrivalBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ArrivalBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ArrivalBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'codigo',
  };
}

