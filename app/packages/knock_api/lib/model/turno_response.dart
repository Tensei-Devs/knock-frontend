//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TurnoResponse {
  /// Returns a new [TurnoResponse] instance.
  TurnoResponse({
    required this.categoria,
    required this.mensaje,
    required this.pideFoto,
    required this.seguridad,
    required this.origen,
    required this.generadoPorIa,
  });

  String categoria;

  String mensaje;

  bool pideFoto;

  String? seguridad;

  String origen;

  bool generadoPorIa;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TurnoResponse &&
    other.categoria == categoria &&
    other.mensaje == mensaje &&
    other.pideFoto == pideFoto &&
    other.seguridad == seguridad &&
    other.origen == origen &&
    other.generadoPorIa == generadoPorIa;

  @override
  int get hashCode =>
    (categoria.hashCode) +
    (mensaje.hashCode) +
    (pideFoto.hashCode) +
    (seguridad == null ? 0 : seguridad!.hashCode) +
    (origen.hashCode) +
    (generadoPorIa.hashCode);

  @override
  String toString() => 'TurnoResponse[categoria=$categoria, mensaje=$mensaje, pideFoto=$pideFoto, seguridad=$seguridad, origen=$origen, generadoPorIa=$generadoPorIa]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'categoria'] = this.categoria;
      json[r'mensaje'] = this.mensaje;
      json[r'pideFoto'] = this.pideFoto;
    if (this.seguridad != null) {
      json[r'seguridad'] = this.seguridad;
    } else {
      json[r'seguridad'] = null;
    }
      json[r'origen'] = this.origen;
      json[r'generadoPorIa'] = this.generadoPorIa;
    return json;
  }

  /// Returns a new [TurnoResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TurnoResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'categoria'), 'Required key "TurnoResponse[categoria]" is missing from JSON.');
        assert(json[r'categoria'] != null, 'Required key "TurnoResponse[categoria]" has a null value in JSON.');
        assert(json.containsKey(r'mensaje'), 'Required key "TurnoResponse[mensaje]" is missing from JSON.');
        assert(json[r'mensaje'] != null, 'Required key "TurnoResponse[mensaje]" has a null value in JSON.');
        assert(json.containsKey(r'pideFoto'), 'Required key "TurnoResponse[pideFoto]" is missing from JSON.');
        assert(json[r'pideFoto'] != null, 'Required key "TurnoResponse[pideFoto]" has a null value in JSON.');
        assert(json.containsKey(r'seguridad'), 'Required key "TurnoResponse[seguridad]" is missing from JSON.');
        assert(json.containsKey(r'origen'), 'Required key "TurnoResponse[origen]" is missing from JSON.');
        assert(json[r'origen'] != null, 'Required key "TurnoResponse[origen]" has a null value in JSON.');
        assert(json.containsKey(r'generadoPorIa'), 'Required key "TurnoResponse[generadoPorIa]" is missing from JSON.');
        assert(json[r'generadoPorIa'] != null, 'Required key "TurnoResponse[generadoPorIa]" has a null value in JSON.');
        return true;
      }());

      return TurnoResponse(
        categoria: mapValueOfType<String>(json, r'categoria')!,
        mensaje: mapValueOfType<String>(json, r'mensaje')!,
        pideFoto: mapValueOfType<bool>(json, r'pideFoto')!,
        seguridad: mapValueOfType<String>(json, r'seguridad'),
        origen: mapValueOfType<String>(json, r'origen')!,
        generadoPorIa: mapValueOfType<bool>(json, r'generadoPorIa')!,
      );
    }
    return null;
  }

  static List<TurnoResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TurnoResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TurnoResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TurnoResponse> mapFromJson(dynamic json) {
    final map = <String, TurnoResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TurnoResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TurnoResponse-objects as value to a dart map
  static Map<String, List<TurnoResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TurnoResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TurnoResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'categoria',
    'mensaje',
    'pideFoto',
    'seguridad',
    'origen',
    'generadoPorIa',
  };
}

