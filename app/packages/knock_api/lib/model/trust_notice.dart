//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrustNotice {
  /// Returns a new [TrustNotice] instance.
  TrustNotice({
    required this.texto,
    required this.incluyeCodigo,
    required this.incluyeDireccion,
  });

  String texto;

  bool incluyeCodigo;

  bool incluyeDireccion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrustNotice &&
    other.texto == texto &&
    other.incluyeCodigo == incluyeCodigo &&
    other.incluyeDireccion == incluyeDireccion;

  @override
  int get hashCode =>
    (texto.hashCode) +
    (incluyeCodigo.hashCode) +
    (incluyeDireccion.hashCode);

  @override
  String toString() => 'TrustNotice[texto=$texto, incluyeCodigo=$incluyeCodigo, incluyeDireccion=$incluyeDireccion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'texto'] = this.texto;
      json[r'incluyeCodigo'] = this.incluyeCodigo;
      json[r'incluyeDireccion'] = this.incluyeDireccion;
    return json;
  }

  /// Returns a new [TrustNotice] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrustNotice? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'texto'), 'Required key "TrustNotice[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "TrustNotice[texto]" has a null value in JSON.');
        assert(json.containsKey(r'incluyeCodigo'), 'Required key "TrustNotice[incluyeCodigo]" is missing from JSON.');
        assert(json[r'incluyeCodigo'] != null, 'Required key "TrustNotice[incluyeCodigo]" has a null value in JSON.');
        assert(json.containsKey(r'incluyeDireccion'), 'Required key "TrustNotice[incluyeDireccion]" is missing from JSON.');
        assert(json[r'incluyeDireccion'] != null, 'Required key "TrustNotice[incluyeDireccion]" has a null value in JSON.');
        return true;
      }());

      return TrustNotice(
        texto: mapValueOfType<String>(json, r'texto')!,
        incluyeCodigo: mapValueOfType<bool>(json, r'incluyeCodigo')!,
        incluyeDireccion: mapValueOfType<bool>(json, r'incluyeDireccion')!,
      );
    }
    return null;
  }

  static List<TrustNotice> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrustNotice>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrustNotice.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrustNotice> mapFromJson(dynamic json) {
    final map = <String, TrustNotice>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrustNotice.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrustNotice-objects as value to a dart map
  static Map<String, List<TrustNotice>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrustNotice>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrustNotice.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'texto',
    'incluyeCodigo',
    'incluyeDireccion',
  };
}

