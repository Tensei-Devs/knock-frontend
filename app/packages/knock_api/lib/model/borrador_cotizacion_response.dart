//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class BorradorCotizacionResponse {
  /// Returns a new [BorradorCotizacionResponse] instance.
  BorradorCotizacionResponse({
    required this.precioSugerido,
    required this.tiempoEstimado,
    required this.dia,
    required this.nota,
    required this.explicacion,
    required this.origen,
    required this.generadoPorIa,
  });

  double precioSugerido;

  String tiempoEstimado;

  String dia;

  String nota;

  String explicacion;

  String origen;

  bool generadoPorIa;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BorradorCotizacionResponse &&
    other.precioSugerido == precioSugerido &&
    other.tiempoEstimado == tiempoEstimado &&
    other.dia == dia &&
    other.nota == nota &&
    other.explicacion == explicacion &&
    other.origen == origen &&
    other.generadoPorIa == generadoPorIa;

  @override
  int get hashCode =>
    (precioSugerido.hashCode) +
    (tiempoEstimado.hashCode) +
    (dia.hashCode) +
    (nota.hashCode) +
    (explicacion.hashCode) +
    (origen.hashCode) +
    (generadoPorIa.hashCode);

  @override
  String toString() => 'BorradorCotizacionResponse[precioSugerido=$precioSugerido, tiempoEstimado=$tiempoEstimado, dia=$dia, nota=$nota, explicacion=$explicacion, origen=$origen, generadoPorIa=$generadoPorIa]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'precioSugerido'] = this.precioSugerido;
      json[r'tiempoEstimado'] = this.tiempoEstimado;
      json[r'dia'] = this.dia;
      json[r'nota'] = this.nota;
      json[r'explicacion'] = this.explicacion;
      json[r'origen'] = this.origen;
      json[r'generadoPorIa'] = this.generadoPorIa;
    return json;
  }

  /// Returns a new [BorradorCotizacionResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static BorradorCotizacionResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'precioSugerido'), 'Required key "BorradorCotizacionResponse[precioSugerido]" is missing from JSON.');
        assert(json[r'precioSugerido'] != null, 'Required key "BorradorCotizacionResponse[precioSugerido]" has a null value in JSON.');
        assert(json.containsKey(r'tiempoEstimado'), 'Required key "BorradorCotizacionResponse[tiempoEstimado]" is missing from JSON.');
        assert(json[r'tiempoEstimado'] != null, 'Required key "BorradorCotizacionResponse[tiempoEstimado]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "BorradorCotizacionResponse[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "BorradorCotizacionResponse[dia]" has a null value in JSON.');
        assert(json.containsKey(r'nota'), 'Required key "BorradorCotizacionResponse[nota]" is missing from JSON.');
        assert(json[r'nota'] != null, 'Required key "BorradorCotizacionResponse[nota]" has a null value in JSON.');
        assert(json.containsKey(r'explicacion'), 'Required key "BorradorCotizacionResponse[explicacion]" is missing from JSON.');
        assert(json[r'explicacion'] != null, 'Required key "BorradorCotizacionResponse[explicacion]" has a null value in JSON.');
        assert(json.containsKey(r'origen'), 'Required key "BorradorCotizacionResponse[origen]" is missing from JSON.');
        assert(json[r'origen'] != null, 'Required key "BorradorCotizacionResponse[origen]" has a null value in JSON.');
        assert(json.containsKey(r'generadoPorIa'), 'Required key "BorradorCotizacionResponse[generadoPorIa]" is missing from JSON.');
        assert(json[r'generadoPorIa'] != null, 'Required key "BorradorCotizacionResponse[generadoPorIa]" has a null value in JSON.');
        return true;
      }());

      return BorradorCotizacionResponse(
        precioSugerido: mapValueOfType<double>(json, r'precioSugerido')!,
        tiempoEstimado: mapValueOfType<String>(json, r'tiempoEstimado')!,
        dia: mapValueOfType<String>(json, r'dia')!,
        nota: mapValueOfType<String>(json, r'nota')!,
        explicacion: mapValueOfType<String>(json, r'explicacion')!,
        origen: mapValueOfType<String>(json, r'origen')!,
        generadoPorIa: mapValueOfType<bool>(json, r'generadoPorIa')!,
      );
    }
    return null;
  }

  static List<BorradorCotizacionResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BorradorCotizacionResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BorradorCotizacionResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BorradorCotizacionResponse> mapFromJson(dynamic json) {
    final map = <String, BorradorCotizacionResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = BorradorCotizacionResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BorradorCotizacionResponse-objects as value to a dart map
  static Map<String, List<BorradorCotizacionResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BorradorCotizacionResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BorradorCotizacionResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'precioSugerido',
    'tiempoEstimado',
    'dia',
    'nota',
    'explicacion',
    'origen',
    'generadoPorIa',
  };
}

