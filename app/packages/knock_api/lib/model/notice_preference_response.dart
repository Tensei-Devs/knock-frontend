//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NoticePreferenceResponse {
  /// Returns a new [NoticePreferenceResponse] instance.
  NoticePreferenceResponse({
    required this.tipo,
    required this.activo,
    required this.apagable,
  });

  String tipo;

  bool activo;

  bool apagable;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NoticePreferenceResponse &&
    other.tipo == tipo &&
    other.activo == activo &&
    other.apagable == apagable;

  @override
  int get hashCode =>
    (tipo.hashCode) +
    (activo.hashCode) +
    (apagable.hashCode);

  @override
  String toString() => 'NoticePreferenceResponse[tipo=$tipo, activo=$activo, apagable=$apagable]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tipo'] = this.tipo;
      json[r'activo'] = this.activo;
      json[r'apagable'] = this.apagable;
    return json;
  }

  /// Returns a new [NoticePreferenceResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NoticePreferenceResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipo'), 'Required key "NoticePreferenceResponse[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "NoticePreferenceResponse[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'activo'), 'Required key "NoticePreferenceResponse[activo]" is missing from JSON.');
        assert(json[r'activo'] != null, 'Required key "NoticePreferenceResponse[activo]" has a null value in JSON.');
        assert(json.containsKey(r'apagable'), 'Required key "NoticePreferenceResponse[apagable]" is missing from JSON.');
        assert(json[r'apagable'] != null, 'Required key "NoticePreferenceResponse[apagable]" has a null value in JSON.');
        return true;
      }());

      return NoticePreferenceResponse(
        tipo: mapValueOfType<String>(json, r'tipo')!,
        activo: mapValueOfType<bool>(json, r'activo')!,
        apagable: mapValueOfType<bool>(json, r'apagable')!,
      );
    }
    return null;
  }

  static List<NoticePreferenceResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NoticePreferenceResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NoticePreferenceResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NoticePreferenceResponse> mapFromJson(dynamic json) {
    final map = <String, NoticePreferenceResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NoticePreferenceResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NoticePreferenceResponse-objects as value to a dart map
  static Map<String, List<NoticePreferenceResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NoticePreferenceResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NoticePreferenceResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipo',
    'activo',
    'apagable',
  };
}

