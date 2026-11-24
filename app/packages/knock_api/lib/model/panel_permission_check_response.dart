//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PanelPermissionCheckResponse {
  /// Returns a new [PanelPermissionCheckResponse] instance.
  PanelPermissionCheckResponse({
    required this.permitido,
  });

  bool permitido;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PanelPermissionCheckResponse &&
    other.permitido == permitido;

  @override
  int get hashCode =>
    (permitido.hashCode);

  @override
  String toString() => 'PanelPermissionCheckResponse[permitido=$permitido]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'permitido'] = this.permitido;
    return json;
  }

  /// Returns a new [PanelPermissionCheckResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PanelPermissionCheckResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'permitido'), 'Required key "PanelPermissionCheckResponse[permitido]" is missing from JSON.');
        assert(json[r'permitido'] != null, 'Required key "PanelPermissionCheckResponse[permitido]" has a null value in JSON.');
        return true;
      }());

      return PanelPermissionCheckResponse(
        permitido: mapValueOfType<bool>(json, r'permitido')!,
      );
    }
    return null;
  }

  static List<PanelPermissionCheckResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PanelPermissionCheckResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PanelPermissionCheckResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PanelPermissionCheckResponse> mapFromJson(dynamic json) {
    final map = <String, PanelPermissionCheckResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PanelPermissionCheckResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PanelPermissionCheckResponse-objects as value to a dart map
  static Map<String, List<PanelPermissionCheckResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PanelPermissionCheckResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PanelPermissionCheckResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'permitido',
  };
}

