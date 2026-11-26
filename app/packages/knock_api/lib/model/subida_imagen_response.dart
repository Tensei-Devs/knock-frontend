//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class SubidaImagenResponse {
  /// Returns a new [SubidaImagenResponse] instance.
  SubidaImagenResponse({
    required this.id,
    required this.urlSubida,
    required this.metodo,
    this.encabezados = const {},
    required this.venceEn,
    required this.confirmarAntesDe,
  });

  String id;

  String urlSubida;

  String metodo;

  Map<String, String> encabezados;

  DateTime venceEn;

  DateTime confirmarAntesDe;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SubidaImagenResponse &&
    other.id == id &&
    other.urlSubida == urlSubida &&
    other.metodo == metodo &&
    _deepEquality.equals(other.encabezados, encabezados) &&
    other.venceEn == venceEn &&
    other.confirmarAntesDe == confirmarAntesDe;

  @override
  int get hashCode =>
    (id.hashCode) +
    (urlSubida.hashCode) +
    (metodo.hashCode) +
    (encabezados.hashCode) +
    (venceEn.hashCode) +
    (confirmarAntesDe.hashCode);

  @override
  String toString() => 'SubidaImagenResponse[id=$id, urlSubida=$urlSubida, metodo=$metodo, encabezados=$encabezados, venceEn=$venceEn, confirmarAntesDe=$confirmarAntesDe]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'urlSubida'] = this.urlSubida;
      json[r'metodo'] = this.metodo;
      json[r'encabezados'] = this.encabezados;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
      json[r'confirmarAntesDe'] = this.confirmarAntesDe.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [SubidaImagenResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static SubidaImagenResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "SubidaImagenResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "SubidaImagenResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'urlSubida'), 'Required key "SubidaImagenResponse[urlSubida]" is missing from JSON.');
        assert(json[r'urlSubida'] != null, 'Required key "SubidaImagenResponse[urlSubida]" has a null value in JSON.');
        assert(json.containsKey(r'metodo'), 'Required key "SubidaImagenResponse[metodo]" is missing from JSON.');
        assert(json[r'metodo'] != null, 'Required key "SubidaImagenResponse[metodo]" has a null value in JSON.');
        assert(json.containsKey(r'encabezados'), 'Required key "SubidaImagenResponse[encabezados]" is missing from JSON.');
        assert(json[r'encabezados'] != null, 'Required key "SubidaImagenResponse[encabezados]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "SubidaImagenResponse[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "SubidaImagenResponse[venceEn]" has a null value in JSON.');
        assert(json.containsKey(r'confirmarAntesDe'), 'Required key "SubidaImagenResponse[confirmarAntesDe]" is missing from JSON.');
        assert(json[r'confirmarAntesDe'] != null, 'Required key "SubidaImagenResponse[confirmarAntesDe]" has a null value in JSON.');
        return true;
      }());

      return SubidaImagenResponse(
        id: mapValueOfType<String>(json, r'id')!,
        urlSubida: mapValueOfType<String>(json, r'urlSubida')!,
        metodo: mapValueOfType<String>(json, r'metodo')!,
        encabezados: mapCastOfType<String, String>(json, r'encabezados')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
        confirmarAntesDe: mapDateTime(json, r'confirmarAntesDe', r'')!,
      );
    }
    return null;
  }

  static List<SubidaImagenResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SubidaImagenResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SubidaImagenResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SubidaImagenResponse> mapFromJson(dynamic json) {
    final map = <String, SubidaImagenResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = SubidaImagenResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SubidaImagenResponse-objects as value to a dart map
  static Map<String, List<SubidaImagenResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SubidaImagenResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SubidaImagenResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'urlSubida',
    'metodo',
    'encabezados',
    'venceEn',
    'confirmarAntesDe',
  };
}

