//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CancelVisitBody {
  /// Returns a new [CancelVisitBody] instance.
  CancelVisitBody({
    required this.motivo,
  });

  String? motivo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CancelVisitBody &&
    other.motivo == motivo;

  @override
  int get hashCode =>
    (motivo == null ? 0 : motivo!.hashCode);

  @override
  String toString() => 'CancelVisitBody[motivo=$motivo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.motivo != null) {
      json[r'motivo'] = this.motivo;
    } else {
      json[r'motivo'] = null;
    }
    return json;
  }

  /// Returns a new [CancelVisitBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CancelVisitBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'motivo'), 'Required key "CancelVisitBody[motivo]" is missing from JSON.');
        return true;
      }());

      return CancelVisitBody(
        motivo: mapValueOfType<String>(json, r'motivo'),
      );
    }
    return null;
  }

  static List<CancelVisitBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CancelVisitBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CancelVisitBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CancelVisitBody> mapFromJson(dynamic json) {
    final map = <String, CancelVisitBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CancelVisitBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CancelVisitBody-objects as value to a dart map
  static Map<String, List<CancelVisitBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CancelVisitBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CancelVisitBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'motivo',
  };
}

