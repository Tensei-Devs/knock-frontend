//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class QuoteResponse {
  /// Returns a new [QuoteResponse] instance.
  QuoteResponse({
    required this.id,
    required this.solicitudId,
    required this.estado,
    required this.tipoPrecio,
    required this.precio,
    required this.precioMin,
    required this.precioMax,
    required this.tope,
    required this.requiereAprobacion,
    required this.dia,
    required this.hora,
    required this.nota,
    required this.creadoEn,
  });

  String id;

  String solicitudId;

  String estado;

  String tipoPrecio;

  double? precio;

  double? precioMin;

  double? precioMax;

  int tope;

  bool requiereAprobacion;

  DateTime dia;

  String hora;

  String? nota;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuoteResponse &&
    other.id == id &&
    other.solicitudId == solicitudId &&
    other.estado == estado &&
    other.tipoPrecio == tipoPrecio &&
    other.precio == precio &&
    other.precioMin == precioMin &&
    other.precioMax == precioMax &&
    other.tope == tope &&
    other.requiereAprobacion == requiereAprobacion &&
    other.dia == dia &&
    other.hora == hora &&
    other.nota == nota &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (solicitudId.hashCode) +
    (estado.hashCode) +
    (tipoPrecio.hashCode) +
    (precio == null ? 0 : precio!.hashCode) +
    (precioMin == null ? 0 : precioMin!.hashCode) +
    (precioMax == null ? 0 : precioMax!.hashCode) +
    (tope.hashCode) +
    (requiereAprobacion.hashCode) +
    (dia.hashCode) +
    (hora.hashCode) +
    (nota == null ? 0 : nota!.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'QuoteResponse[id=$id, solicitudId=$solicitudId, estado=$estado, tipoPrecio=$tipoPrecio, precio=$precio, precioMin=$precioMin, precioMax=$precioMax, tope=$tope, requiereAprobacion=$requiereAprobacion, dia=$dia, hora=$hora, nota=$nota, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'solicitudId'] = this.solicitudId;
      json[r'estado'] = this.estado;
      json[r'tipoPrecio'] = this.tipoPrecio;
    if (this.precio != null) {
      json[r'precio'] = this.precio;
    } else {
      json[r'precio'] = null;
    }
    if (this.precioMin != null) {
      json[r'precioMin'] = this.precioMin;
    } else {
      json[r'precioMin'] = null;
    }
    if (this.precioMax != null) {
      json[r'precioMax'] = this.precioMax;
    } else {
      json[r'precioMax'] = null;
    }
      json[r'tope'] = this.tope;
      json[r'requiereAprobacion'] = this.requiereAprobacion;
      json[r'dia'] = _dateFormatter.format(this.dia);
      json[r'hora'] = this.hora;
    if (this.nota != null) {
      json[r'nota'] = this.nota;
    } else {
      json[r'nota'] = null;
    }
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [QuoteResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static QuoteResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "QuoteResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "QuoteResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'solicitudId'), 'Required key "QuoteResponse[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "QuoteResponse[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "QuoteResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "QuoteResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'tipoPrecio'), 'Required key "QuoteResponse[tipoPrecio]" is missing from JSON.');
        assert(json[r'tipoPrecio'] != null, 'Required key "QuoteResponse[tipoPrecio]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "QuoteResponse[precio]" is missing from JSON.');
        assert(json.containsKey(r'precioMin'), 'Required key "QuoteResponse[precioMin]" is missing from JSON.');
        assert(json.containsKey(r'precioMax'), 'Required key "QuoteResponse[precioMax]" is missing from JSON.');
        assert(json.containsKey(r'tope'), 'Required key "QuoteResponse[tope]" is missing from JSON.');
        assert(json[r'tope'] != null, 'Required key "QuoteResponse[tope]" has a null value in JSON.');
        assert(json.containsKey(r'requiereAprobacion'), 'Required key "QuoteResponse[requiereAprobacion]" is missing from JSON.');
        assert(json[r'requiereAprobacion'] != null, 'Required key "QuoteResponse[requiereAprobacion]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "QuoteResponse[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "QuoteResponse[dia]" has a null value in JSON.');
        assert(json.containsKey(r'hora'), 'Required key "QuoteResponse[hora]" is missing from JSON.');
        assert(json[r'hora'] != null, 'Required key "QuoteResponse[hora]" has a null value in JSON.');
        assert(json.containsKey(r'nota'), 'Required key "QuoteResponse[nota]" is missing from JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "QuoteResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "QuoteResponse[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return QuoteResponse(
        id: mapValueOfType<String>(json, r'id')!,
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        tipoPrecio: mapValueOfType<String>(json, r'tipoPrecio')!,
        precio: mapValueOfType<double>(json, r'precio'),
        precioMin: mapValueOfType<double>(json, r'precioMin'),
        precioMax: mapValueOfType<double>(json, r'precioMax'),
        tope: mapValueOfType<int>(json, r'tope')!,
        requiereAprobacion: mapValueOfType<bool>(json, r'requiereAprobacion')!,
        dia: mapDateTime(json, r'dia', r'')!,
        hora: mapValueOfType<String>(json, r'hora')!,
        nota: mapValueOfType<String>(json, r'nota'),
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<QuoteResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuoteResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuoteResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuoteResponse> mapFromJson(dynamic json) {
    final map = <String, QuoteResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = QuoteResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuoteResponse-objects as value to a dart map
  static Map<String, List<QuoteResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuoteResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuoteResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'solicitudId',
    'estado',
    'tipoPrecio',
    'precio',
    'precioMin',
    'precioMax',
    'tope',
    'requiereAprobacion',
    'dia',
    'hora',
    'nota',
    'creadoEn',
  };
}

