//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class MarketReference {
  /// Returns a new [MarketReference] instance.
  MarketReference({
    required this.origen,
    required this.p25,
    required this.mediana,
    required this.p75,
  });

  String origen;

  int? p25;

  int? mediana;

  int? p75;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MarketReference &&
    other.origen == origen &&
    other.p25 == p25 &&
    other.mediana == mediana &&
    other.p75 == p75;

  @override
  int get hashCode =>
    (origen.hashCode) +
    (p25 == null ? 0 : p25!.hashCode) +
    (mediana == null ? 0 : mediana!.hashCode) +
    (p75 == null ? 0 : p75!.hashCode);

  @override
  String toString() => 'MarketReference[origen=$origen, p25=$p25, mediana=$mediana, p75=$p75]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'origen'] = this.origen;
    if (this.p25 != null) {
      json[r'p25'] = this.p25;
    } else {
      json[r'p25'] = null;
    }
    if (this.mediana != null) {
      json[r'mediana'] = this.mediana;
    } else {
      json[r'mediana'] = null;
    }
    if (this.p75 != null) {
      json[r'p75'] = this.p75;
    } else {
      json[r'p75'] = null;
    }
    return json;
  }

  /// Returns a new [MarketReference] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static MarketReference? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'origen'), 'Required key "MarketReference[origen]" is missing from JSON.');
        assert(json[r'origen'] != null, 'Required key "MarketReference[origen]" has a null value in JSON.');
        assert(json.containsKey(r'p25'), 'Required key "MarketReference[p25]" is missing from JSON.');
        assert(json.containsKey(r'mediana'), 'Required key "MarketReference[mediana]" is missing from JSON.');
        assert(json.containsKey(r'p75'), 'Required key "MarketReference[p75]" is missing from JSON.');
        return true;
      }());

      return MarketReference(
        origen: mapValueOfType<String>(json, r'origen')!,
        p25: mapValueOfType<int>(json, r'p25'),
        mediana: mapValueOfType<int>(json, r'mediana'),
        p75: mapValueOfType<int>(json, r'p75'),
      );
    }
    return null;
  }

  static List<MarketReference> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MarketReference>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MarketReference.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MarketReference> mapFromJson(dynamic json) {
    final map = <String, MarketReference>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = MarketReference.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MarketReference-objects as value to a dart map
  static Map<String, List<MarketReference>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MarketReference>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MarketReference.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'origen',
    'p25',
    'mediana',
    'p75',
  };
}

