//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrabajoResponse {
  /// Returns a new [TrabajoResponse] instance.
  TrabajoResponse({
    required this.disponibleHoy,
    required this.verificacion,
    required this.nivel,
    this.proximasVisitas = const [],
    this.cotizacionesEnviadas = const [],
    required this.terminadas,
    required this.resumen,
  });

  bool disponibleHoy;

  TrabajoVerificationResponse verificacion;

  Object? nivel;

  List<TrabajoVisitResponse> proximasVisitas;

  List<TrabajoQuoteResponse> cotizacionesEnviadas;

  TrabajoFinishedPage terminadas;

  TrabajoSummary resumen;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrabajoResponse &&
    other.disponibleHoy == disponibleHoy &&
    other.verificacion == verificacion &&
    other.nivel == nivel &&
    _deepEquality.equals(other.proximasVisitas, proximasVisitas) &&
    _deepEquality.equals(other.cotizacionesEnviadas, cotizacionesEnviadas) &&
    other.terminadas == terminadas &&
    other.resumen == resumen;

  @override
  int get hashCode =>
    (disponibleHoy.hashCode) +
    (verificacion.hashCode) +
    (nivel == null ? 0 : nivel!.hashCode) +
    (proximasVisitas.hashCode) +
    (cotizacionesEnviadas.hashCode) +
    (terminadas.hashCode) +
    (resumen.hashCode);

  @override
  String toString() => 'TrabajoResponse[disponibleHoy=$disponibleHoy, verificacion=$verificacion, nivel=$nivel, proximasVisitas=$proximasVisitas, cotizacionesEnviadas=$cotizacionesEnviadas, terminadas=$terminadas, resumen=$resumen]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'disponibleHoy'] = this.disponibleHoy;
      json[r'verificacion'] = this.verificacion;
    if (this.nivel != null) {
      json[r'nivel'] = this.nivel;
    } else {
      json[r'nivel'] = null;
    }
      json[r'proximasVisitas'] = this.proximasVisitas;
      json[r'cotizacionesEnviadas'] = this.cotizacionesEnviadas;
      json[r'terminadas'] = this.terminadas;
      json[r'resumen'] = this.resumen;
    return json;
  }

  /// Returns a new [TrabajoResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrabajoResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'disponibleHoy'), 'Required key "TrabajoResponse[disponibleHoy]" is missing from JSON.');
        assert(json[r'disponibleHoy'] != null, 'Required key "TrabajoResponse[disponibleHoy]" has a null value in JSON.');
        assert(json.containsKey(r'verificacion'), 'Required key "TrabajoResponse[verificacion]" is missing from JSON.');
        assert(json[r'verificacion'] != null, 'Required key "TrabajoResponse[verificacion]" has a null value in JSON.');
        assert(json.containsKey(r'nivel'), 'Required key "TrabajoResponse[nivel]" is missing from JSON.');
        assert(json.containsKey(r'proximasVisitas'), 'Required key "TrabajoResponse[proximasVisitas]" is missing from JSON.');
        assert(json[r'proximasVisitas'] != null, 'Required key "TrabajoResponse[proximasVisitas]" has a null value in JSON.');
        assert(json.containsKey(r'cotizacionesEnviadas'), 'Required key "TrabajoResponse[cotizacionesEnviadas]" is missing from JSON.');
        assert(json[r'cotizacionesEnviadas'] != null, 'Required key "TrabajoResponse[cotizacionesEnviadas]" has a null value in JSON.');
        assert(json.containsKey(r'terminadas'), 'Required key "TrabajoResponse[terminadas]" is missing from JSON.');
        assert(json[r'terminadas'] != null, 'Required key "TrabajoResponse[terminadas]" has a null value in JSON.');
        assert(json.containsKey(r'resumen'), 'Required key "TrabajoResponse[resumen]" is missing from JSON.');
        assert(json[r'resumen'] != null, 'Required key "TrabajoResponse[resumen]" has a null value in JSON.');
        return true;
      }());

      return TrabajoResponse(
        disponibleHoy: mapValueOfType<bool>(json, r'disponibleHoy')!,
        verificacion: TrabajoVerificationResponse.fromJson(json[r'verificacion'])!,
        nivel: mapValueOfType<Object>(json, r'nivel'),
        proximasVisitas: TrabajoVisitResponse.listFromJson(json[r'proximasVisitas']),
        cotizacionesEnviadas: TrabajoQuoteResponse.listFromJson(json[r'cotizacionesEnviadas']),
        terminadas: TrabajoFinishedPage.fromJson(json[r'terminadas'])!,
        resumen: TrabajoSummary.fromJson(json[r'resumen'])!,
      );
    }
    return null;
  }

  static List<TrabajoResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrabajoResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrabajoResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrabajoResponse> mapFromJson(dynamic json) {
    final map = <String, TrabajoResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrabajoResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrabajoResponse-objects as value to a dart map
  static Map<String, List<TrabajoResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrabajoResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrabajoResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'disponibleHoy',
    'verificacion',
    'nivel',
    'proximasVisitas',
    'cotizacionesEnviadas',
    'terminadas',
    'resumen',
  };
}

