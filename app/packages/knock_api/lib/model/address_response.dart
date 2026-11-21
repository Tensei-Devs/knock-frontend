//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AddressResponse {
  /// Returns a new [AddressResponse] instance.
  AddressResponse({
    required this.id,
    required this.calleNumero,
    required this.colonia,
    required this.referencias,
    required this.principal,
    required this.creadoEn,
  });

  String id;

  String calleNumero;

  String colonia;

  String? referencias;

  bool principal;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AddressResponse &&
    other.id == id &&
    other.calleNumero == calleNumero &&
    other.colonia == colonia &&
    other.referencias == referencias &&
    other.principal == principal &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (calleNumero.hashCode) +
    (colonia.hashCode) +
    (referencias == null ? 0 : referencias!.hashCode) +
    (principal.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'AddressResponse[id=$id, calleNumero=$calleNumero, colonia=$colonia, referencias=$referencias, principal=$principal, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'calleNumero'] = this.calleNumero;
      json[r'colonia'] = this.colonia;
    if (this.referencias != null) {
      json[r'referencias'] = this.referencias;
    } else {
      json[r'referencias'] = null;
    }
      json[r'principal'] = this.principal;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [AddressResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AddressResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AddressResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AddressResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'calleNumero'), 'Required key "AddressResponse[calleNumero]" is missing from JSON.');
        assert(json[r'calleNumero'] != null, 'Required key "AddressResponse[calleNumero]" has a null value in JSON.');
        assert(json.containsKey(r'colonia'), 'Required key "AddressResponse[colonia]" is missing from JSON.');
        assert(json[r'colonia'] != null, 'Required key "AddressResponse[colonia]" has a null value in JSON.');
        assert(json.containsKey(r'referencias'), 'Required key "AddressResponse[referencias]" is missing from JSON.');
        assert(json.containsKey(r'principal'), 'Required key "AddressResponse[principal]" is missing from JSON.');
        assert(json[r'principal'] != null, 'Required key "AddressResponse[principal]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "AddressResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "AddressResponse[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return AddressResponse(
        id: mapValueOfType<String>(json, r'id')!,
        calleNumero: mapValueOfType<String>(json, r'calleNumero')!,
        colonia: mapValueOfType<String>(json, r'colonia')!,
        referencias: mapValueOfType<String>(json, r'referencias'),
        principal: mapValueOfType<bool>(json, r'principal')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<AddressResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AddressResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AddressResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AddressResponse> mapFromJson(dynamic json) {
    final map = <String, AddressResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AddressResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AddressResponse-objects as value to a dart map
  static Map<String, List<AddressResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AddressResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AddressResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'calleNumero',
    'colonia',
    'referencias',
    'principal',
    'creadoEn',
  };
}

