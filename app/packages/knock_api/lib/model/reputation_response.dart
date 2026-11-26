//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReputationResponse {
  /// Returns a new [ReputationResponse] instance.
  ReputationResponse({
    required this.promedio,
    required this.total,
    this.distribucion = const {},
    required this.nivel,
  });

  double? promedio;

  int total;

  Map<String, int> distribucion;

  String nivel;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReputationResponse &&
    other.promedio == promedio &&
    other.total == total &&
    _deepEquality.equals(other.distribucion, distribucion) &&
    other.nivel == nivel;

  @override
  int get hashCode =>
    (promedio == null ? 0 : promedio!.hashCode) +
    (total.hashCode) +
    (distribucion.hashCode) +
    (nivel.hashCode);

  @override
  String toString() => 'ReputationResponse[promedio=$promedio, total=$total, distribucion=$distribucion, nivel=$nivel]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.promedio != null) {
      json[r'promedio'] = this.promedio;
    } else {
      json[r'promedio'] = null;
    }
      json[r'total'] = this.total;
      json[r'distribucion'] = this.distribucion;
      json[r'nivel'] = this.nivel;
    return json;
  }

  /// Returns a new [ReputationResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReputationResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'promedio'), 'Required key "ReputationResponse[promedio]" is missing from JSON.');
        assert(json.containsKey(r'total'), 'Required key "ReputationResponse[total]" is missing from JSON.');
        assert(json[r'total'] != null, 'Required key "ReputationResponse[total]" has a null value in JSON.');
        assert(json.containsKey(r'distribucion'), 'Required key "ReputationResponse[distribucion]" is missing from JSON.');
        assert(json[r'distribucion'] != null, 'Required key "ReputationResponse[distribucion]" has a null value in JSON.');
        assert(json.containsKey(r'nivel'), 'Required key "ReputationResponse[nivel]" is missing from JSON.');
        assert(json[r'nivel'] != null, 'Required key "ReputationResponse[nivel]" has a null value in JSON.');
        return true;
      }());

      return ReputationResponse(
        promedio: mapValueOfType<double>(json, r'promedio'),
        total: mapValueOfType<int>(json, r'total')!,
        distribucion: mapCastOfType<String, int>(json, r'distribucion')!,
        nivel: mapValueOfType<String>(json, r'nivel')!,
      );
    }
    return null;
  }

  static List<ReputationResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReputationResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReputationResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReputationResponse> mapFromJson(dynamic json) {
    final map = <String, ReputationResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReputationResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReputationResponse-objects as value to a dart map
  static Map<String, List<ReputationResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReputationResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReputationResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'promedio',
    'total',
    'distribucion',
    'nivel',
  };
}

