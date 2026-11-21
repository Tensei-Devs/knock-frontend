//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PanelActivacionResponse {
  /// Returns a new [PanelActivacionResponse] instance.
  PanelActivacionResponse({
    required this.otpauthUri,
    required this.qrSvg,
  });

  String otpauthUri;

  String qrSvg;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PanelActivacionResponse &&
    other.otpauthUri == otpauthUri &&
    other.qrSvg == qrSvg;

  @override
  int get hashCode =>
    (otpauthUri.hashCode) +
    (qrSvg.hashCode);

  @override
  String toString() => 'PanelActivacionResponse[otpauthUri=$otpauthUri, qrSvg=$qrSvg]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'otpauthUri'] = this.otpauthUri;
      json[r'qrSvg'] = this.qrSvg;
    return json;
  }

  /// Returns a new [PanelActivacionResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PanelActivacionResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'otpauthUri'), 'Required key "PanelActivacionResponse[otpauthUri]" is missing from JSON.');
        assert(json[r'otpauthUri'] != null, 'Required key "PanelActivacionResponse[otpauthUri]" has a null value in JSON.');
        assert(json.containsKey(r'qrSvg'), 'Required key "PanelActivacionResponse[qrSvg]" is missing from JSON.');
        assert(json[r'qrSvg'] != null, 'Required key "PanelActivacionResponse[qrSvg]" has a null value in JSON.');
        return true;
      }());

      return PanelActivacionResponse(
        otpauthUri: mapValueOfType<String>(json, r'otpauthUri')!,
        qrSvg: mapValueOfType<String>(json, r'qrSvg')!,
      );
    }
    return null;
  }

  static List<PanelActivacionResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PanelActivacionResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PanelActivacionResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PanelActivacionResponse> mapFromJson(dynamic json) {
    final map = <String, PanelActivacionResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PanelActivacionResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PanelActivacionResponse-objects as value to a dart map
  static Map<String, List<PanelActivacionResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PanelActivacionResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PanelActivacionResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'otpauthUri',
    'qrSvg',
  };
}

