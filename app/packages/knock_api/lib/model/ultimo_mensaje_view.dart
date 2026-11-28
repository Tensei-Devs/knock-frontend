//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UltimoMensajeView {
  /// Returns a new [UltimoMensajeView] instance.
  UltimoMensajeView({
    required this.texto,
    required this.enviadoEn,
    required this.autorRol,
  });

  String texto;

  DateTime enviadoEn;

  String autorRol;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UltimoMensajeView &&
    other.texto == texto &&
    other.enviadoEn == enviadoEn &&
    other.autorRol == autorRol;

  @override
  int get hashCode =>
    (texto.hashCode) +
    (enviadoEn.hashCode) +
    (autorRol.hashCode);

  @override
  String toString() => 'UltimoMensajeView[texto=$texto, enviadoEn=$enviadoEn, autorRol=$autorRol]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'texto'] = this.texto;
      json[r'enviadoEn'] = this.enviadoEn.toUtc().toIso8601String();
      json[r'autorRol'] = this.autorRol;
    return json;
  }

  /// Returns a new [UltimoMensajeView] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UltimoMensajeView? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'texto'), 'Required key "UltimoMensajeView[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "UltimoMensajeView[texto]" has a null value in JSON.');
        assert(json.containsKey(r'enviadoEn'), 'Required key "UltimoMensajeView[enviadoEn]" is missing from JSON.');
        assert(json[r'enviadoEn'] != null, 'Required key "UltimoMensajeView[enviadoEn]" has a null value in JSON.');
        assert(json.containsKey(r'autorRol'), 'Required key "UltimoMensajeView[autorRol]" is missing from JSON.');
        assert(json[r'autorRol'] != null, 'Required key "UltimoMensajeView[autorRol]" has a null value in JSON.');
        return true;
      }());

      return UltimoMensajeView(
        texto: mapValueOfType<String>(json, r'texto')!,
        enviadoEn: mapDateTime(json, r'enviadoEn', r'')!,
        autorRol: mapValueOfType<String>(json, r'autorRol')!,
      );
    }
    return null;
  }

  static List<UltimoMensajeView> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UltimoMensajeView>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UltimoMensajeView.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UltimoMensajeView> mapFromJson(dynamic json) {
    final map = <String, UltimoMensajeView>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UltimoMensajeView.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UltimoMensajeView-objects as value to a dart map
  static Map<String, List<UltimoMensajeView>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UltimoMensajeView>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UltimoMensajeView.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'texto',
    'enviadoEn',
    'autorRol',
  };
}

