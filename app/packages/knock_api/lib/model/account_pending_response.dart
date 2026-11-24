//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AccountPendingResponse {
  /// Returns a new [AccountPendingResponse] instance.
  AccountPendingResponse({
    required this.appointmentTotal,
    this.appointmentIds = const [],
    required this.quoteTotal,
    this.quoteIds = const [],
    required this.visitInProgress,
  });

  int appointmentTotal;

  List<String> appointmentIds;

  int quoteTotal;

  List<String> quoteIds;

  bool visitInProgress;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AccountPendingResponse &&
    other.appointmentTotal == appointmentTotal &&
    _deepEquality.equals(other.appointmentIds, appointmentIds) &&
    other.quoteTotal == quoteTotal &&
    _deepEquality.equals(other.quoteIds, quoteIds) &&
    other.visitInProgress == visitInProgress;

  @override
  int get hashCode =>
    (appointmentTotal.hashCode) +
    (appointmentIds.hashCode) +
    (quoteTotal.hashCode) +
    (quoteIds.hashCode) +
    (visitInProgress.hashCode);

  @override
  String toString() => 'AccountPendingResponse[appointmentTotal=$appointmentTotal, appointmentIds=$appointmentIds, quoteTotal=$quoteTotal, quoteIds=$quoteIds, visitInProgress=$visitInProgress]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'appointmentTotal'] = this.appointmentTotal;
      json[r'appointmentIds'] = this.appointmentIds;
      json[r'quoteTotal'] = this.quoteTotal;
      json[r'quoteIds'] = this.quoteIds;
      json[r'visitInProgress'] = this.visitInProgress;
    return json;
  }

  /// Returns a new [AccountPendingResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AccountPendingResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'appointmentTotal'), 'Required key "AccountPendingResponse[appointmentTotal]" is missing from JSON.');
        assert(json[r'appointmentTotal'] != null, 'Required key "AccountPendingResponse[appointmentTotal]" has a null value in JSON.');
        assert(json.containsKey(r'appointmentIds'), 'Required key "AccountPendingResponse[appointmentIds]" is missing from JSON.');
        assert(json[r'appointmentIds'] != null, 'Required key "AccountPendingResponse[appointmentIds]" has a null value in JSON.');
        assert(json.containsKey(r'quoteTotal'), 'Required key "AccountPendingResponse[quoteTotal]" is missing from JSON.');
        assert(json[r'quoteTotal'] != null, 'Required key "AccountPendingResponse[quoteTotal]" has a null value in JSON.');
        assert(json.containsKey(r'quoteIds'), 'Required key "AccountPendingResponse[quoteIds]" is missing from JSON.');
        assert(json[r'quoteIds'] != null, 'Required key "AccountPendingResponse[quoteIds]" has a null value in JSON.');
        assert(json.containsKey(r'visitInProgress'), 'Required key "AccountPendingResponse[visitInProgress]" is missing from JSON.');
        assert(json[r'visitInProgress'] != null, 'Required key "AccountPendingResponse[visitInProgress]" has a null value in JSON.');
        return true;
      }());

      return AccountPendingResponse(
        appointmentTotal: mapValueOfType<int>(json, r'appointmentTotal')!,
        appointmentIds: json[r'appointmentIds'] is Iterable
            ? (json[r'appointmentIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        quoteTotal: mapValueOfType<int>(json, r'quoteTotal')!,
        quoteIds: json[r'quoteIds'] is Iterable
            ? (json[r'quoteIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        visitInProgress: mapValueOfType<bool>(json, r'visitInProgress')!,
      );
    }
    return null;
  }

  static List<AccountPendingResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AccountPendingResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AccountPendingResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AccountPendingResponse> mapFromJson(dynamic json) {
    final map = <String, AccountPendingResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AccountPendingResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AccountPendingResponse-objects as value to a dart map
  static Map<String, List<AccountPendingResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AccountPendingResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AccountPendingResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'appointmentTotal',
    'appointmentIds',
    'quoteTotal',
    'quoteIds',
    'visitInProgress',
  };
}

