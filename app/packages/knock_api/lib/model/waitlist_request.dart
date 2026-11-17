//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class WaitlistRequest {
  /// Returns a new [WaitlistRequest] instance.
  WaitlistRequest({
    required this.cp,
    required this.municipio,
  });

  String? cp;

  String? municipio;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WaitlistRequest &&
    other.cp == cp &&
    other.municipio == municipio;

  @override
  int get hashCode =>
    (cp == null ? 0 : cp!.hashCode) +
    (municipio == null ? 0 : municipio!.hashCode);

  @override
  String toString() => 'WaitlistRequest[cp=$cp, municipio=$municipio]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.cp != null) {
      json[r'cp'] = this.cp;
    } else {
      json[r'cp'] = null;
    }
    if (this.municipio != null) {
      json[r'municipio'] = this.municipio;
    } else {
      json[r'municipio'] = null;
    }
    return json;
  }

  /// Returns a new [WaitlistRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static WaitlistRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'cp'), 'Required key "WaitlistRequest[cp]" is missing from JSON.');
        assert(json.containsKey(r'municipio'), 'Required key "WaitlistRequest[municipio]" is missing from JSON.');
        return true;
      }());

      return WaitlistRequest(
        cp: mapValueOfType<String>(json, r'cp'),
        municipio: mapValueOfType<String>(json, r'municipio'),
      );
    }
    return null;
  }

  static List<WaitlistRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WaitlistRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WaitlistRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WaitlistRequest> mapFromJson(dynamic json) {
    final map = <String, WaitlistRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = WaitlistRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WaitlistRequest-objects as value to a dart map
  static Map<String, List<WaitlistRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WaitlistRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WaitlistRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'cp',
    'municipio',
  };
}

