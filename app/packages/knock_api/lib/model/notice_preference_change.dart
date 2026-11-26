//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NoticePreferenceChange {
  /// Returns a new [NoticePreferenceChange] instance.
  NoticePreferenceChange({
    required this.tipo,
    required this.activo,
  });

  String? tipo;

  bool? activo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NoticePreferenceChange &&
    other.tipo == tipo &&
    other.activo == activo;

  @override
  int get hashCode =>
    (tipo == null ? 0 : tipo!.hashCode) +
    (activo == null ? 0 : activo!.hashCode);

  @override
  String toString() => 'NoticePreferenceChange[tipo=$tipo, activo=$activo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.tipo != null) {
      json[r'tipo'] = this.tipo;
    } else {
      json[r'tipo'] = null;
    }
    if (this.activo != null) {
      json[r'activo'] = this.activo;
    } else {
      json[r'activo'] = null;
    }
    return json;
  }

  /// Returns a new [NoticePreferenceChange] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NoticePreferenceChange? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipo'), 'Required key "NoticePreferenceChange[tipo]" is missing from JSON.');
        assert(json.containsKey(r'activo'), 'Required key "NoticePreferenceChange[activo]" is missing from JSON.');
        return true;
      }());

      return NoticePreferenceChange(
        tipo: mapValueOfType<String>(json, r'tipo'),
        activo: mapValueOfType<bool>(json, r'activo'),
      );
    }
    return null;
  }

  static List<NoticePreferenceChange> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NoticePreferenceChange>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NoticePreferenceChange.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NoticePreferenceChange> mapFromJson(dynamic json) {
    final map = <String, NoticePreferenceChange>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NoticePreferenceChange.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NoticePreferenceChange-objects as value to a dart map
  static Map<String, List<NoticePreferenceChange>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NoticePreferenceChange>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NoticePreferenceChange.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipo',
    'activo',
  };
}

