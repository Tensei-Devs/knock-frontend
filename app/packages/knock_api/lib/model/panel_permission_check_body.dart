//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PanelPermissionCheckBody {
  /// Returns a new [PanelPermissionCheckBody] instance.
  PanelPermissionCheckBody({
    required this.sub,
    required this.sid,
    required this.pv,
    required this.permiso,
  });

  String? sub;

  String? sid;

  int? pv;

  String? permiso;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PanelPermissionCheckBody &&
    other.sub == sub &&
    other.sid == sid &&
    other.pv == pv &&
    other.permiso == permiso;

  @override
  int get hashCode =>
    (sub == null ? 0 : sub!.hashCode) +
    (sid == null ? 0 : sid!.hashCode) +
    (pv == null ? 0 : pv!.hashCode) +
    (permiso == null ? 0 : permiso!.hashCode);

  @override
  String toString() => 'PanelPermissionCheckBody[sub=$sub, sid=$sid, pv=$pv, permiso=$permiso]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.sub != null) {
      json[r'sub'] = this.sub;
    } else {
      json[r'sub'] = null;
    }
    if (this.sid != null) {
      json[r'sid'] = this.sid;
    } else {
      json[r'sid'] = null;
    }
    if (this.pv != null) {
      json[r'pv'] = this.pv;
    } else {
      json[r'pv'] = null;
    }
    if (this.permiso != null) {
      json[r'permiso'] = this.permiso;
    } else {
      json[r'permiso'] = null;
    }
    return json;
  }

  /// Returns a new [PanelPermissionCheckBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PanelPermissionCheckBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'sub'), 'Required key "PanelPermissionCheckBody[sub]" is missing from JSON.');
        assert(json.containsKey(r'sid'), 'Required key "PanelPermissionCheckBody[sid]" is missing from JSON.');
        assert(json.containsKey(r'pv'), 'Required key "PanelPermissionCheckBody[pv]" is missing from JSON.');
        assert(json.containsKey(r'permiso'), 'Required key "PanelPermissionCheckBody[permiso]" is missing from JSON.');
        return true;
      }());

      return PanelPermissionCheckBody(
        sub: mapValueOfType<String>(json, r'sub'),
        sid: mapValueOfType<String>(json, r'sid'),
        pv: mapValueOfType<int>(json, r'pv'),
        permiso: mapValueOfType<String>(json, r'permiso'),
      );
    }
    return null;
  }

  static List<PanelPermissionCheckBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PanelPermissionCheckBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PanelPermissionCheckBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PanelPermissionCheckBody> mapFromJson(dynamic json) {
    final map = <String, PanelPermissionCheckBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PanelPermissionCheckBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PanelPermissionCheckBody-objects as value to a dart map
  static Map<String, List<PanelPermissionCheckBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PanelPermissionCheckBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PanelPermissionCheckBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sub',
    'sid',
    'pv',
    'permiso',
  };
}

