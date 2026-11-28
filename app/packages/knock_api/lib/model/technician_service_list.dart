//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TechnicianServiceList {
  /// Returns a new [TechnicianServiceList] instance.
  TechnicianServiceList({
    this.items = const [],
  });

  List<TechnicianService> items;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TechnicianServiceList &&
    _deepEquality.equals(other.items, items);

  @override
  int get hashCode =>
    (items.hashCode);

  @override
  String toString() => 'TechnicianServiceList[items=$items]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
    return json;
  }

  /// Returns a new [TechnicianServiceList] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TechnicianServiceList? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "TechnicianServiceList[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "TechnicianServiceList[items]" has a null value in JSON.');
        return true;
      }());

      return TechnicianServiceList(
        items: TechnicianService.listFromJson(json[r'items']),
      );
    }
    return null;
  }

  static List<TechnicianServiceList> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TechnicianServiceList>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TechnicianServiceList.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TechnicianServiceList> mapFromJson(dynamic json) {
    final map = <String, TechnicianServiceList>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TechnicianServiceList.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TechnicianServiceList-objects as value to a dart map
  static Map<String, List<TechnicianServiceList>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TechnicianServiceList>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TechnicianServiceList.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
  };
}

