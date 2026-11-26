//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class SuspensionAppealView {
  /// Returns a new [SuspensionAppealView] instance.
  SuspensionAppealView({
    required this.estado,
    required this.presentadaEn,
    required this.resueltaEn,
  });

  String estado;

  DateTime presentadaEn;

  DateTime? resueltaEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SuspensionAppealView &&
    other.estado == estado &&
    other.presentadaEn == presentadaEn &&
    other.resueltaEn == resueltaEn;

  @override
  int get hashCode =>
    (estado.hashCode) +
    (presentadaEn.hashCode) +
    (resueltaEn == null ? 0 : resueltaEn!.hashCode);

  @override
  String toString() => 'SuspensionAppealView[estado=$estado, presentadaEn=$presentadaEn, resueltaEn=$resueltaEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'estado'] = this.estado;
      json[r'presentadaEn'] = this.presentadaEn.toUtc().toIso8601String();
    if (this.resueltaEn != null) {
      json[r'resueltaEn'] = this.resueltaEn!.toUtc().toIso8601String();
    } else {
      json[r'resueltaEn'] = null;
    }
    return json;
  }

  /// Returns a new [SuspensionAppealView] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static SuspensionAppealView? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'estado'), 'Required key "SuspensionAppealView[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "SuspensionAppealView[estado]" has a null value in JSON.');
        assert(json.containsKey(r'presentadaEn'), 'Required key "SuspensionAppealView[presentadaEn]" is missing from JSON.');
        assert(json[r'presentadaEn'] != null, 'Required key "SuspensionAppealView[presentadaEn]" has a null value in JSON.');
        assert(json.containsKey(r'resueltaEn'), 'Required key "SuspensionAppealView[resueltaEn]" is missing from JSON.');
        return true;
      }());

      return SuspensionAppealView(
        estado: mapValueOfType<String>(json, r'estado')!,
        presentadaEn: mapDateTime(json, r'presentadaEn', r'')!,
        resueltaEn: mapDateTime(json, r'resueltaEn', r''),
      );
    }
    return null;
  }

  static List<SuspensionAppealView> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SuspensionAppealView>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SuspensionAppealView.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SuspensionAppealView> mapFromJson(dynamic json) {
    final map = <String, SuspensionAppealView>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = SuspensionAppealView.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SuspensionAppealView-objects as value to a dart map
  static Map<String, List<SuspensionAppealView>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SuspensionAppealView>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SuspensionAppealView.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'estado',
    'presentadaEn',
    'resueltaEn',
  };
}

