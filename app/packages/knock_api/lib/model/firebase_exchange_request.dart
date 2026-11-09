//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class FirebaseExchangeRequest {
  /// Returns a new [FirebaseExchangeRequest] instance.
  FirebaseExchangeRequest({
    this.firebaseIdToken,
    this.deviceId,
    this.aceptaAviso,
    this.dispositivo,
  });

  String? firebaseIdToken;

  String? deviceId;

  bool? aceptaAviso;

  String? dispositivo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FirebaseExchangeRequest &&
    other.firebaseIdToken == firebaseIdToken &&
    other.deviceId == deviceId &&
    other.aceptaAviso == aceptaAviso &&
    other.dispositivo == dispositivo;

  @override
  int get hashCode =>
    (firebaseIdToken == null ? 0 : firebaseIdToken!.hashCode) +
    (deviceId == null ? 0 : deviceId!.hashCode) +
    (aceptaAviso == null ? 0 : aceptaAviso!.hashCode) +
    (dispositivo == null ? 0 : dispositivo!.hashCode);

  @override
  String toString() => 'FirebaseExchangeRequest[firebaseIdToken=$firebaseIdToken, deviceId=$deviceId, aceptaAviso=$aceptaAviso, dispositivo=$dispositivo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.firebaseIdToken != null) {
      json[r'firebaseIdToken'] = this.firebaseIdToken;
    } else {
      json[r'firebaseIdToken'] = null;
    }
    if (this.deviceId != null) {
      json[r'deviceId'] = this.deviceId;
    } else {
      json[r'deviceId'] = null;
    }
    if (this.aceptaAviso != null) {
      json[r'aceptaAviso'] = this.aceptaAviso;
    } else {
      json[r'aceptaAviso'] = null;
    }
    if (this.dispositivo != null) {
      json[r'dispositivo'] = this.dispositivo;
    } else {
      json[r'dispositivo'] = null;
    }
    return json;
  }

  /// Returns a new [FirebaseExchangeRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static FirebaseExchangeRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return FirebaseExchangeRequest(
        firebaseIdToken: mapValueOfType<String>(json, r'firebaseIdToken'),
        deviceId: mapValueOfType<String>(json, r'deviceId'),
        aceptaAviso: mapValueOfType<bool>(json, r'aceptaAviso'),
        dispositivo: mapValueOfType<String>(json, r'dispositivo'),
      );
    }
    return null;
  }

  static List<FirebaseExchangeRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FirebaseExchangeRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FirebaseExchangeRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FirebaseExchangeRequest> mapFromJson(dynamic json) {
    final map = <String, FirebaseExchangeRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = FirebaseExchangeRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FirebaseExchangeRequest-objects as value to a dart map
  static Map<String, List<FirebaseExchangeRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FirebaseExchangeRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FirebaseExchangeRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

