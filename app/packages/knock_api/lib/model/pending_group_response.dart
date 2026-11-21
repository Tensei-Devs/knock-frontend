//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PendingGroupResponse {
  /// Returns a new [PendingGroupResponse] instance.
  PendingGroupResponse({
    required this.total,
    this.ids = const [],
  });

  int total;

  List<String> ids;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PendingGroupResponse &&
    other.total == total &&
    _deepEquality.equals(other.ids, ids);

  @override
  int get hashCode =>
    (total.hashCode) +
    (ids.hashCode);

  @override
  String toString() => 'PendingGroupResponse[total=$total, ids=$ids]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'total'] = this.total;
      json[r'ids'] = this.ids;
    return json;
  }

  /// Returns a new [PendingGroupResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PendingGroupResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'total'), 'Required key "PendingGroupResponse[total]" is missing from JSON.');
        assert(json[r'total'] != null, 'Required key "PendingGroupResponse[total]" has a null value in JSON.');
        assert(json.containsKey(r'ids'), 'Required key "PendingGroupResponse[ids]" is missing from JSON.');
        assert(json[r'ids'] != null, 'Required key "PendingGroupResponse[ids]" has a null value in JSON.');
        return true;
      }());

      return PendingGroupResponse(
        total: mapValueOfType<int>(json, r'total')!,
        ids: json[r'ids'] is Iterable
            ? (json[r'ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<PendingGroupResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PendingGroupResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PendingGroupResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PendingGroupResponse> mapFromJson(dynamic json) {
    final map = <String, PendingGroupResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PendingGroupResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PendingGroupResponse-objects as value to a dart map
  static Map<String, List<PendingGroupResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PendingGroupResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PendingGroupResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'total',
    'ids',
  };
}

