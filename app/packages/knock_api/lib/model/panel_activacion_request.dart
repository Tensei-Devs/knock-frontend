//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PanelActivacionRequest {
  /// Returns a new [PanelActivacionRequest] instance.
  PanelActivacionRequest({
    this.token,
  });

  String? token;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PanelActivacionRequest &&
    other.token == token;

  @override
  int get hashCode =>
    (token == null ? 0 : token!.hashCode);

  @override
  String toString() => 'PanelActivacionRequest[token=$token]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.token != null) {
      json[r'token'] = this.token;
    } else {
      json[r'token'] = null;
    }
    return json;
  }

  /// Returns a new [PanelActivacionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PanelActivacionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return PanelActivacionRequest(
        token: mapValueOfType<String>(json, r'token'),
      );
    }
    return null;
  }

  static List<PanelActivacionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PanelActivacionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PanelActivacionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PanelActivacionRequest> mapFromJson(dynamic json) {
    final map = <String, PanelActivacionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PanelActivacionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PanelActivacionRequest-objects as value to a dart map
  static Map<String, List<PanelActivacionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PanelActivacionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PanelActivacionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

