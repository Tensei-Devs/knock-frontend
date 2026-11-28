//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationPhotoLink {
  /// Returns a new [VerificationPhotoLink] instance.
  VerificationPhotoLink({
    required this.tipo,
    required this.url,
    required this.venceEn,
  });

  String tipo;

  String url;

  DateTime venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationPhotoLink &&
    other.tipo == tipo &&
    other.url == url &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (tipo.hashCode) +
    (url.hashCode) +
    (venceEn.hashCode);

  @override
  String toString() => 'VerificationPhotoLink[tipo=$tipo, url=$url, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tipo'] = this.tipo;
      json[r'url'] = this.url;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [VerificationPhotoLink] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationPhotoLink? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipo'), 'Required key "VerificationPhotoLink[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "VerificationPhotoLink[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'url'), 'Required key "VerificationPhotoLink[url]" is missing from JSON.');
        assert(json[r'url'] != null, 'Required key "VerificationPhotoLink[url]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "VerificationPhotoLink[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "VerificationPhotoLink[venceEn]" has a null value in JSON.');
        return true;
      }());

      return VerificationPhotoLink(
        tipo: mapValueOfType<String>(json, r'tipo')!,
        url: mapValueOfType<String>(json, r'url')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
      );
    }
    return null;
  }

  static List<VerificationPhotoLink> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationPhotoLink>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationPhotoLink.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationPhotoLink> mapFromJson(dynamic json) {
    final map = <String, VerificationPhotoLink>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationPhotoLink.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationPhotoLink-objects as value to a dart map
  static Map<String, List<VerificationPhotoLink>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationPhotoLink>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationPhotoLink.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipo',
    'url',
    'venceEn',
  };
}

