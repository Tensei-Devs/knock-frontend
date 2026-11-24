//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PendingAdjustmentsResponse {
  /// Returns a new [PendingAdjustmentsResponse] instance.
  PendingAdjustmentsResponse({
    this.items = const [],
  });

  List<PendingAdjustmentItem> items;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PendingAdjustmentsResponse &&
    _deepEquality.equals(other.items, items);

  @override
  int get hashCode =>
    (items.hashCode);

  @override
  String toString() => 'PendingAdjustmentsResponse[items=$items]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
    return json;
  }

  /// Returns a new [PendingAdjustmentsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PendingAdjustmentsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "PendingAdjustmentsResponse[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "PendingAdjustmentsResponse[items]" has a null value in JSON.');
        return true;
      }());

      return PendingAdjustmentsResponse(
        items: PendingAdjustmentItem.listFromJson(json[r'items']),
      );
    }
    return null;
  }

  static List<PendingAdjustmentsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PendingAdjustmentsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PendingAdjustmentsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PendingAdjustmentsResponse> mapFromJson(dynamic json) {
    final map = <String, PendingAdjustmentsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PendingAdjustmentsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PendingAdjustmentsResponse-objects as value to a dart map
  static Map<String, List<PendingAdjustmentsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PendingAdjustmentsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PendingAdjustmentsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
  };
}

