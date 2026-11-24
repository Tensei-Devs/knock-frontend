//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AdminTradeListResponse {
  /// Returns a new [AdminTradeListResponse] instance.
  AdminTradeListResponse({
    this.items = const [],
  });

  List<AdminTradeResponse> items;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminTradeListResponse &&
    _deepEquality.equals(other.items, items);

  @override
  int get hashCode =>
    (items.hashCode);

  @override
  String toString() => 'AdminTradeListResponse[items=$items]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
    return json;
  }

  /// Returns a new [AdminTradeListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AdminTradeListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "AdminTradeListResponse[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "AdminTradeListResponse[items]" has a null value in JSON.');
        return true;
      }());

      return AdminTradeListResponse(
        items: AdminTradeResponse.listFromJson(json[r'items']),
      );
    }
    return null;
  }

  static List<AdminTradeListResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminTradeListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminTradeListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminTradeListResponse> mapFromJson(dynamic json) {
    final map = <String, AdminTradeListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AdminTradeListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminTradeListResponse-objects as value to a dart map
  static Map<String, List<AdminTradeListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminTradeListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminTradeListResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
  };
}

