//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AppealResolutionResult {
  /// Returns a new [AppealResolutionResult] instance.
  AppealResolutionResult({
    required this.id,
    required this.estado,
    required this.decision,
  });

  String id;

  String estado;

  String decision;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AppealResolutionResult &&
    other.id == id &&
    other.estado == estado &&
    other.decision == decision;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (decision.hashCode);

  @override
  String toString() => 'AppealResolutionResult[id=$id, estado=$estado, decision=$decision]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
      json[r'decision'] = this.decision;
    return json;
  }

  /// Returns a new [AppealResolutionResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AppealResolutionResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AppealResolutionResult[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AppealResolutionResult[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "AppealResolutionResult[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "AppealResolutionResult[estado]" has a null value in JSON.');
        assert(json.containsKey(r'decision'), 'Required key "AppealResolutionResult[decision]" is missing from JSON.');
        assert(json[r'decision'] != null, 'Required key "AppealResolutionResult[decision]" has a null value in JSON.');
        return true;
      }());

      return AppealResolutionResult(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        decision: mapValueOfType<String>(json, r'decision')!,
      );
    }
    return null;
  }

  static List<AppealResolutionResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AppealResolutionResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AppealResolutionResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AppealResolutionResult> mapFromJson(dynamic json) {
    final map = <String, AppealResolutionResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AppealResolutionResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AppealResolutionResult-objects as value to a dart map
  static Map<String, List<AppealResolutionResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AppealResolutionResult>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AppealResolutionResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'decision',
  };
}

