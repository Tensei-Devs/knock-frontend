//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class WaitlistResponse {
  /// Returns a new [WaitlistResponse] instance.
  WaitlistResponse({
    required this.id,
    required this.cp,
    required this.municipio,
    required this.creadoEn,
    required this.yaRegistrado,
  });

  String id;

  String cp;

  String? municipio;

  DateTime creadoEn;

  bool yaRegistrado;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WaitlistResponse &&
    other.id == id &&
    other.cp == cp &&
    other.municipio == municipio &&
    other.creadoEn == creadoEn &&
    other.yaRegistrado == yaRegistrado;

  @override
  int get hashCode =>
    (id.hashCode) +
    (cp.hashCode) +
    (municipio == null ? 0 : municipio!.hashCode) +
    (creadoEn.hashCode) +
    (yaRegistrado.hashCode);

  @override
  String toString() => 'WaitlistResponse[id=$id, cp=$cp, municipio=$municipio, creadoEn=$creadoEn, yaRegistrado=$yaRegistrado]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'cp'] = this.cp;
    if (this.municipio != null) {
      json[r'municipio'] = this.municipio;
    } else {
      json[r'municipio'] = null;
    }
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
      json[r'yaRegistrado'] = this.yaRegistrado;
    return json;
  }

  /// Returns a new [WaitlistResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static WaitlistResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "WaitlistResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "WaitlistResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'cp'), 'Required key "WaitlistResponse[cp]" is missing from JSON.');
        assert(json[r'cp'] != null, 'Required key "WaitlistResponse[cp]" has a null value in JSON.');
        assert(json.containsKey(r'municipio'), 'Required key "WaitlistResponse[municipio]" is missing from JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "WaitlistResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "WaitlistResponse[creadoEn]" has a null value in JSON.');
        assert(json.containsKey(r'yaRegistrado'), 'Required key "WaitlistResponse[yaRegistrado]" is missing from JSON.');
        assert(json[r'yaRegistrado'] != null, 'Required key "WaitlistResponse[yaRegistrado]" has a null value in JSON.');
        return true;
      }());

      return WaitlistResponse(
        id: mapValueOfType<String>(json, r'id')!,
        cp: mapValueOfType<String>(json, r'cp')!,
        municipio: mapValueOfType<String>(json, r'municipio'),
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
        yaRegistrado: mapValueOfType<bool>(json, r'yaRegistrado')!,
      );
    }
    return null;
  }

  static List<WaitlistResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WaitlistResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WaitlistResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WaitlistResponse> mapFromJson(dynamic json) {
    final map = <String, WaitlistResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = WaitlistResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WaitlistResponse-objects as value to a dart map
  static Map<String, List<WaitlistResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WaitlistResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WaitlistResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'cp',
    'municipio',
    'creadoEn',
    'yaRegistrado',
  };
}

