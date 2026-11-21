//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AutocompleteResponse {
  /// Returns a new [AutocompleteResponse] instance.
  AutocompleteResponse({
    this.sugerencias = const [],
  });

  List<Suggestion> sugerencias;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AutocompleteResponse &&
    _deepEquality.equals(other.sugerencias, sugerencias);

  @override
  int get hashCode =>
    (sugerencias.hashCode);

  @override
  String toString() => 'AutocompleteResponse[sugerencias=$sugerencias]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'sugerencias'] = this.sugerencias;
    return json;
  }

  /// Returns a new [AutocompleteResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AutocompleteResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'sugerencias'), 'Required key "AutocompleteResponse[sugerencias]" is missing from JSON.');
        assert(json[r'sugerencias'] != null, 'Required key "AutocompleteResponse[sugerencias]" has a null value in JSON.');
        return true;
      }());

      return AutocompleteResponse(
        sugerencias: Suggestion.listFromJson(json[r'sugerencias']),
      );
    }
    return null;
  }

  static List<AutocompleteResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AutocompleteResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AutocompleteResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AutocompleteResponse> mapFromJson(dynamic json) {
    final map = <String, AutocompleteResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AutocompleteResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AutocompleteResponse-objects as value to a dart map
  static Map<String, List<AutocompleteResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AutocompleteResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AutocompleteResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sugerencias',
  };
}

