//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NoLeidasView {
  /// Returns a new [NoLeidasView] instance.
  NoLeidasView({
    required this.total,
  });

  int total;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NoLeidasView &&
    other.total == total;

  @override
  int get hashCode =>
    (total.hashCode);

  @override
  String toString() => 'NoLeidasView[total=$total]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'total'] = this.total;
    return json;
  }

  /// Returns a new [NoLeidasView] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NoLeidasView? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'total'), 'Required key "NoLeidasView[total]" is missing from JSON.');
        assert(json[r'total'] != null, 'Required key "NoLeidasView[total]" has a null value in JSON.');
        return true;
      }());

      return NoLeidasView(
        total: mapValueOfType<int>(json, r'total')!,
      );
    }
    return null;
  }

  static List<NoLeidasView> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NoLeidasView>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NoLeidasView.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NoLeidasView> mapFromJson(dynamic json) {
    final map = <String, NoLeidasView>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NoLeidasView.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NoLeidasView-objects as value to a dart map
  static Map<String, List<NoLeidasView>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NoLeidasView>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NoLeidasView.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'total',
  };
}

