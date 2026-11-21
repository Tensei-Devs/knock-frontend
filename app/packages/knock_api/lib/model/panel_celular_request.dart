//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PanelCelularRequest {
  /// Returns a new [PanelCelularRequest] instance.
  PanelCelularRequest({
    this.idToken,
  });

  String? idToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PanelCelularRequest &&
    other.idToken == idToken;

  @override
  int get hashCode =>
    (idToken == null ? 0 : idToken!.hashCode);

  @override
  String toString() => 'PanelCelularRequest[idToken=$idToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.idToken != null) {
      json[r'idToken'] = this.idToken;
    } else {
      json[r'idToken'] = null;
    }
    return json;
  }

  /// Returns a new [PanelCelularRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PanelCelularRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return PanelCelularRequest(
        idToken: mapValueOfType<String>(json, r'idToken'),
      );
    }
    return null;
  }

  static List<PanelCelularRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PanelCelularRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PanelCelularRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PanelCelularRequest> mapFromJson(dynamic json) {
    final map = <String, PanelCelularRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PanelCelularRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PanelCelularRequest-objects as value to a dart map
  static Map<String, List<PanelCelularRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PanelCelularRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PanelCelularRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

