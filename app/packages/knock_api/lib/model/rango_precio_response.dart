//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RangoPrecioResponse {
  /// Returns a new [RangoPrecioResponse] instance.
  RangoPrecioResponse({
    required this.minimo,
    required this.maximo,
    required this.muestras,
    required this.fuente,
  });

  double minimo;

  double maximo;

  int muestras;

  String fuente;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RangoPrecioResponse &&
    other.minimo == minimo &&
    other.maximo == maximo &&
    other.muestras == muestras &&
    other.fuente == fuente;

  @override
  int get hashCode =>
    (minimo.hashCode) +
    (maximo.hashCode) +
    (muestras.hashCode) +
    (fuente.hashCode);

  @override
  String toString() => 'RangoPrecioResponse[minimo=$minimo, maximo=$maximo, muestras=$muestras, fuente=$fuente]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'minimo'] = this.minimo;
      json[r'maximo'] = this.maximo;
      json[r'muestras'] = this.muestras;
      json[r'fuente'] = this.fuente;
    return json;
  }

  /// Returns a new [RangoPrecioResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RangoPrecioResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'minimo'), 'Required key "RangoPrecioResponse[minimo]" is missing from JSON.');
        assert(json[r'minimo'] != null, 'Required key "RangoPrecioResponse[minimo]" has a null value in JSON.');
        assert(json.containsKey(r'maximo'), 'Required key "RangoPrecioResponse[maximo]" is missing from JSON.');
        assert(json[r'maximo'] != null, 'Required key "RangoPrecioResponse[maximo]" has a null value in JSON.');
        assert(json.containsKey(r'muestras'), 'Required key "RangoPrecioResponse[muestras]" is missing from JSON.');
        assert(json[r'muestras'] != null, 'Required key "RangoPrecioResponse[muestras]" has a null value in JSON.');
        assert(json.containsKey(r'fuente'), 'Required key "RangoPrecioResponse[fuente]" is missing from JSON.');
        assert(json[r'fuente'] != null, 'Required key "RangoPrecioResponse[fuente]" has a null value in JSON.');
        return true;
      }());

      return RangoPrecioResponse(
        minimo: mapValueOfType<double>(json, r'minimo')!,
        maximo: mapValueOfType<double>(json, r'maximo')!,
        muestras: mapValueOfType<int>(json, r'muestras')!,
        fuente: mapValueOfType<String>(json, r'fuente')!,
      );
    }
    return null;
  }

  static List<RangoPrecioResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RangoPrecioResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RangoPrecioResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RangoPrecioResponse> mapFromJson(dynamic json) {
    final map = <String, RangoPrecioResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RangoPrecioResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RangoPrecioResponse-objects as value to a dart map
  static Map<String, List<RangoPrecioResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RangoPrecioResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RangoPrecioResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'minimo',
    'maximo',
    'muestras',
    'fuente',
  };
}

