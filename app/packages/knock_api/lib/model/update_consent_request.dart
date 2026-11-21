//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UpdateConsentRequest {
  /// Returns a new [UpdateConsentRequest] instance.
  UpdateConsentRequest({
    this.tipo,
    this.vigente,
  });

  String? tipo;

  bool? vigente;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateConsentRequest &&
    other.tipo == tipo &&
    other.vigente == vigente;

  @override
  int get hashCode =>
    (tipo == null ? 0 : tipo!.hashCode) +
    (vigente == null ? 0 : vigente!.hashCode);

  @override
  String toString() => 'UpdateConsentRequest[tipo=$tipo, vigente=$vigente]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.tipo != null) {
      json[r'tipo'] = this.tipo;
    } else {
      json[r'tipo'] = null;
    }
    if (this.vigente != null) {
      json[r'vigente'] = this.vigente;
    } else {
      json[r'vigente'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateConsentRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UpdateConsentRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return UpdateConsentRequest(
        tipo: mapValueOfType<String>(json, r'tipo'),
        vigente: mapValueOfType<bool>(json, r'vigente'),
      );
    }
    return null;
  }

  static List<UpdateConsentRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateConsentRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateConsentRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateConsentRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateConsentRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UpdateConsentRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateConsentRequest-objects as value to a dart map
  static Map<String, List<UpdateConsentRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateConsentRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateConsentRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

