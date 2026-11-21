//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AccessRecoveryRequest {
  /// Returns a new [AccessRecoveryRequest] instance.
  AccessRecoveryRequest({
    this.firebaseIdToken,
    this.celularAnterior,
    this.tipo,
  });

  String? firebaseIdToken;

  String? celularAnterior;

  String? tipo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AccessRecoveryRequest &&
    other.firebaseIdToken == firebaseIdToken &&
    other.celularAnterior == celularAnterior &&
    other.tipo == tipo;

  @override
  int get hashCode =>
    (firebaseIdToken == null ? 0 : firebaseIdToken!.hashCode) +
    (celularAnterior == null ? 0 : celularAnterior!.hashCode) +
    (tipo == null ? 0 : tipo!.hashCode);

  @override
  String toString() => 'AccessRecoveryRequest[firebaseIdToken=$firebaseIdToken, celularAnterior=$celularAnterior, tipo=$tipo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.firebaseIdToken != null) {
      json[r'firebaseIdToken'] = this.firebaseIdToken;
    } else {
      json[r'firebaseIdToken'] = null;
    }
    if (this.celularAnterior != null) {
      json[r'celularAnterior'] = this.celularAnterior;
    } else {
      json[r'celularAnterior'] = null;
    }
    if (this.tipo != null) {
      json[r'tipo'] = this.tipo;
    } else {
      json[r'tipo'] = null;
    }
    return json;
  }

  /// Returns a new [AccessRecoveryRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AccessRecoveryRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return AccessRecoveryRequest(
        firebaseIdToken: mapValueOfType<String>(json, r'firebaseIdToken'),
        celularAnterior: mapValueOfType<String>(json, r'celularAnterior'),
        tipo: mapValueOfType<String>(json, r'tipo'),
      );
    }
    return null;
  }

  static List<AccessRecoveryRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AccessRecoveryRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AccessRecoveryRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AccessRecoveryRequest> mapFromJson(dynamic json) {
    final map = <String, AccessRecoveryRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AccessRecoveryRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AccessRecoveryRequest-objects as value to a dart map
  static Map<String, List<AccessRecoveryRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AccessRecoveryRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AccessRecoveryRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

