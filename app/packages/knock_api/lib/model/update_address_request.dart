//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UpdateAddressRequest {
  /// Returns a new [UpdateAddressRequest] instance.
  UpdateAddressRequest({
    this.calleNumero,
    this.colonia,
    this.referencias,
    this.principal,
  });

  String? calleNumero;

  String? colonia;

  String? referencias;

  bool? principal;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateAddressRequest &&
    other.calleNumero == calleNumero &&
    other.colonia == colonia &&
    other.referencias == referencias &&
    other.principal == principal;

  @override
  int get hashCode =>
    (calleNumero == null ? 0 : calleNumero!.hashCode) +
    (colonia == null ? 0 : colonia!.hashCode) +
    (referencias == null ? 0 : referencias!.hashCode) +
    (principal == null ? 0 : principal!.hashCode);

  @override
  String toString() => 'UpdateAddressRequest[calleNumero=$calleNumero, colonia=$colonia, referencias=$referencias, principal=$principal]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.calleNumero != null) {
      json[r'calleNumero'] = this.calleNumero;
    } else {
      json[r'calleNumero'] = null;
    }
    if (this.colonia != null) {
      json[r'colonia'] = this.colonia;
    } else {
      json[r'colonia'] = null;
    }
    if (this.referencias != null) {
      json[r'referencias'] = this.referencias;
    } else {
      json[r'referencias'] = null;
    }
    if (this.principal != null) {
      json[r'principal'] = this.principal;
    } else {
      json[r'principal'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateAddressRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UpdateAddressRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return UpdateAddressRequest(
        calleNumero: mapValueOfType<String>(json, r'calleNumero'),
        colonia: mapValueOfType<String>(json, r'colonia'),
        referencias: mapValueOfType<String>(json, r'referencias'),
        principal: mapValueOfType<bool>(json, r'principal'),
      );
    }
    return null;
  }

  static List<UpdateAddressRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateAddressRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateAddressRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateAddressRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateAddressRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UpdateAddressRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateAddressRequest-objects as value to a dart map
  static Map<String, List<UpdateAddressRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateAddressRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateAddressRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

