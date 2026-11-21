//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrabajoQuoteResponse {
  /// Returns a new [TrabajoQuoteResponse] instance.
  TrabajoQuoteResponse({
    required this.cotizacionId,
    required this.solicitudId,
    required this.oficioNombre,
    required this.tipoPrecio,
    required this.precio,
    required this.precioMin,
    required this.precioMax,
    required this.tope,
    required this.estado,
    required this.motivoRechazo,
    required this.enviadaEn,
  });

  String cotizacionId;

  String solicitudId;

  String oficioNombre;

  String tipoPrecio;

  int? precio;

  int? precioMin;

  int? precioMax;

  int tope;

  String estado;

  String? motivoRechazo;

  DateTime enviadaEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrabajoQuoteResponse &&
    other.cotizacionId == cotizacionId &&
    other.solicitudId == solicitudId &&
    other.oficioNombre == oficioNombre &&
    other.tipoPrecio == tipoPrecio &&
    other.precio == precio &&
    other.precioMin == precioMin &&
    other.precioMax == precioMax &&
    other.tope == tope &&
    other.estado == estado &&
    other.motivoRechazo == motivoRechazo &&
    other.enviadaEn == enviadaEn;

  @override
  int get hashCode =>
    (cotizacionId.hashCode) +
    (solicitudId.hashCode) +
    (oficioNombre.hashCode) +
    (tipoPrecio.hashCode) +
    (precio == null ? 0 : precio!.hashCode) +
    (precioMin == null ? 0 : precioMin!.hashCode) +
    (precioMax == null ? 0 : precioMax!.hashCode) +
    (tope.hashCode) +
    (estado.hashCode) +
    (motivoRechazo == null ? 0 : motivoRechazo!.hashCode) +
    (enviadaEn.hashCode);

  @override
  String toString() => 'TrabajoQuoteResponse[cotizacionId=$cotizacionId, solicitudId=$solicitudId, oficioNombre=$oficioNombre, tipoPrecio=$tipoPrecio, precio=$precio, precioMin=$precioMin, precioMax=$precioMax, tope=$tope, estado=$estado, motivoRechazo=$motivoRechazo, enviadaEn=$enviadaEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'cotizacionId'] = this.cotizacionId;
      json[r'solicitudId'] = this.solicitudId;
      json[r'oficioNombre'] = this.oficioNombre;
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
      json[r'estado'] = this.estado;
    if (this.motivoRechazo != null) {
      json[r'motivoRechazo'] = this.motivoRechazo;
    } else {
      json[r'motivoRechazo'] = null;
    }
      json[r'enviadaEn'] = this.enviadaEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [TrabajoQuoteResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrabajoQuoteResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'cotizacionId'), 'Required key "TrabajoQuoteResponse[cotizacionId]" is missing from JSON.');
        assert(json[r'cotizacionId'] != null, 'Required key "TrabajoQuoteResponse[cotizacionId]" has a null value in JSON.');
        assert(json.containsKey(r'solicitudId'), 'Required key "TrabajoQuoteResponse[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "TrabajoQuoteResponse[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'oficioNombre'), 'Required key "TrabajoQuoteResponse[oficioNombre]" is missing from JSON.');
        assert(json[r'oficioNombre'] != null, 'Required key "TrabajoQuoteResponse[oficioNombre]" has a null value in JSON.');
        assert(json.containsKey(r'tipoPrecio'), 'Required key "TrabajoQuoteResponse[tipoPrecio]" is missing from JSON.');
        assert(json[r'tipoPrecio'] != null, 'Required key "TrabajoQuoteResponse[tipoPrecio]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "TrabajoQuoteResponse[precio]" is missing from JSON.');
        assert(json.containsKey(r'precioMin'), 'Required key "TrabajoQuoteResponse[precioMin]" is missing from JSON.');
        assert(json.containsKey(r'precioMax'), 'Required key "TrabajoQuoteResponse[precioMax]" is missing from JSON.');
        assert(json.containsKey(r'tope'), 'Required key "TrabajoQuoteResponse[tope]" is missing from JSON.');
        assert(json[r'tope'] != null, 'Required key "TrabajoQuoteResponse[tope]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "TrabajoQuoteResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "TrabajoQuoteResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'motivoRechazo'), 'Required key "TrabajoQuoteResponse[motivoRechazo]" is missing from JSON.');
        assert(json.containsKey(r'enviadaEn'), 'Required key "TrabajoQuoteResponse[enviadaEn]" is missing from JSON.');
        assert(json[r'enviadaEn'] != null, 'Required key "TrabajoQuoteResponse[enviadaEn]" has a null value in JSON.');
        return true;
      }());

      return TrabajoQuoteResponse(
        cotizacionId: mapValueOfType<String>(json, r'cotizacionId')!,
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        oficioNombre: mapValueOfType<String>(json, r'oficioNombre')!,
        tipoPrecio: mapValueOfType<String>(json, r'tipoPrecio')!,
        precio: mapValueOfType<int>(json, r'precio'),
        precioMin: mapValueOfType<int>(json, r'precioMin'),
        precioMax: mapValueOfType<int>(json, r'precioMax'),
        tope: mapValueOfType<int>(json, r'tope')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        motivoRechazo: mapValueOfType<String>(json, r'motivoRechazo'),
        enviadaEn: mapDateTime(json, r'enviadaEn', r'')!,
      );
    }
    return null;
  }

  static List<TrabajoQuoteResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrabajoQuoteResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrabajoQuoteResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrabajoQuoteResponse> mapFromJson(dynamic json) {
    final map = <String, TrabajoQuoteResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrabajoQuoteResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrabajoQuoteResponse-objects as value to a dart map
  static Map<String, List<TrabajoQuoteResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrabajoQuoteResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrabajoQuoteResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'cotizacionId',
    'solicitudId',
    'oficioNombre',
    'tipoPrecio',
    'precio',
    'precioMin',
    'precioMax',
    'tope',
    'estado',
    'motivoRechazo',
    'enviadaEn',
  };
}

