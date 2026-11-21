//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ConfirmPhoneChangeRequest {
  /// Returns a new [ConfirmPhoneChangeRequest] instance.
  ConfirmPhoneChangeRequest({
    this.firebaseIdToken,
  });

  String? firebaseIdToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConfirmPhoneChangeRequest &&
    other.firebaseIdToken == firebaseIdToken;

  @override
  int get hashCode =>
    (firebaseIdToken == null ? 0 : firebaseIdToken!.hashCode);

  @override
  String toString() => 'ConfirmPhoneChangeRequest[firebaseIdToken=$firebaseIdToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.firebaseIdToken != null) {
      json[r'firebaseIdToken'] = this.firebaseIdToken;
    } else {
      json[r'firebaseIdToken'] = null;
    }
    return json;
  }

  /// Returns a new [ConfirmPhoneChangeRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ConfirmPhoneChangeRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ConfirmPhoneChangeRequest(
        firebaseIdToken: mapValueOfType<String>(json, r'firebaseIdToken'),
      );
    }
    return null;
  }

  static List<ConfirmPhoneChangeRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConfirmPhoneChangeRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConfirmPhoneChangeRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConfirmPhoneChangeRequest> mapFromJson(dynamic json) {
    final map = <String, ConfirmPhoneChangeRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ConfirmPhoneChangeRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConfirmPhoneChangeRequest-objects as value to a dart map
  static Map<String, List<ConfirmPhoneChangeRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConfirmPhoneChangeRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConfirmPhoneChangeRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

