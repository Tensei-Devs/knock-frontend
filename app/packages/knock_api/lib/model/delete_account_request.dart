//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class DeleteAccountRequest {
  /// Returns a new [DeleteAccountRequest] instance.
  DeleteAccountRequest({
    this.confirmacion,
    this.firebaseIdToken,
    this.motivo,
  });

  String? confirmacion;

  String? firebaseIdToken;

  String? motivo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeleteAccountRequest &&
    other.confirmacion == confirmacion &&
    other.firebaseIdToken == firebaseIdToken &&
    other.motivo == motivo;

  @override
  int get hashCode =>
    (confirmacion == null ? 0 : confirmacion!.hashCode) +
    (firebaseIdToken == null ? 0 : firebaseIdToken!.hashCode) +
    (motivo == null ? 0 : motivo!.hashCode);

  @override
  String toString() => 'DeleteAccountRequest[confirmacion=$confirmacion, firebaseIdToken=$firebaseIdToken, motivo=$motivo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.confirmacion != null) {
      json[r'confirmacion'] = this.confirmacion;
    } else {
      json[r'confirmacion'] = null;
    }
    if (this.firebaseIdToken != null) {
      json[r'firebaseIdToken'] = this.firebaseIdToken;
    } else {
      json[r'firebaseIdToken'] = null;
    }
    if (this.motivo != null) {
      json[r'motivo'] = this.motivo;
    } else {
      json[r'motivo'] = null;
    }
    return json;
  }

  /// Returns a new [DeleteAccountRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static DeleteAccountRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return DeleteAccountRequest(
        confirmacion: mapValueOfType<String>(json, r'confirmacion'),
        firebaseIdToken: mapValueOfType<String>(json, r'firebaseIdToken'),
        motivo: mapValueOfType<String>(json, r'motivo'),
      );
    }
    return null;
  }

  static List<DeleteAccountRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DeleteAccountRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DeleteAccountRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DeleteAccountRequest> mapFromJson(dynamic json) {
    final map = <String, DeleteAccountRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = DeleteAccountRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DeleteAccountRequest-objects as value to a dart map
  static Map<String, List<DeleteAccountRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DeleteAccountRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DeleteAccountRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

