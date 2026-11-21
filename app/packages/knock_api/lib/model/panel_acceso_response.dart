//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PanelAccesoResponse {
  /// Returns a new [PanelAccesoResponse] instance.
  PanelAccesoResponse({
    required this.accessToken,
    required this.expiraEn,
    this.permisos = const [],
    required this.nombre,
  });

  String accessToken;

  DateTime expiraEn;

  List<String> permisos;

  String nombre;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PanelAccesoResponse &&
    other.accessToken == accessToken &&
    other.expiraEn == expiraEn &&
    _deepEquality.equals(other.permisos, permisos) &&
    other.nombre == nombre;

  @override
  int get hashCode =>
    (accessToken.hashCode) +
    (expiraEn.hashCode) +
    (permisos.hashCode) +
    (nombre.hashCode);

  @override
  String toString() => 'PanelAccesoResponse[accessToken=$accessToken, expiraEn=$expiraEn, permisos=$permisos, nombre=$nombre]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'accessToken'] = this.accessToken;
      json[r'expiraEn'] = this.expiraEn.toUtc().toIso8601String();
      json[r'permisos'] = this.permisos;
      json[r'nombre'] = this.nombre;
    return json;
  }

  /// Returns a new [PanelAccesoResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PanelAccesoResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'accessToken'), 'Required key "PanelAccesoResponse[accessToken]" is missing from JSON.');
        assert(json[r'accessToken'] != null, 'Required key "PanelAccesoResponse[accessToken]" has a null value in JSON.');
        assert(json.containsKey(r'expiraEn'), 'Required key "PanelAccesoResponse[expiraEn]" is missing from JSON.');
        assert(json[r'expiraEn'] != null, 'Required key "PanelAccesoResponse[expiraEn]" has a null value in JSON.');
        assert(json.containsKey(r'permisos'), 'Required key "PanelAccesoResponse[permisos]" is missing from JSON.');
        assert(json[r'permisos'] != null, 'Required key "PanelAccesoResponse[permisos]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "PanelAccesoResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "PanelAccesoResponse[nombre]" has a null value in JSON.');
        return true;
      }());

      return PanelAccesoResponse(
        accessToken: mapValueOfType<String>(json, r'accessToken')!,
        expiraEn: mapDateTime(json, r'expiraEn', r'')!,
        permisos: json[r'permisos'] is Iterable
            ? (json[r'permisos'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        nombre: mapValueOfType<String>(json, r'nombre')!,
      );
    }
    return null;
  }

  static List<PanelAccesoResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PanelAccesoResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PanelAccesoResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PanelAccesoResponse> mapFromJson(dynamic json) {
    final map = <String, PanelAccesoResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PanelAccesoResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PanelAccesoResponse-objects as value to a dart map
  static Map<String, List<PanelAccesoResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PanelAccesoResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PanelAccesoResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'accessToken',
    'expiraEn',
    'permisos',
    'nombre',
  };
}

