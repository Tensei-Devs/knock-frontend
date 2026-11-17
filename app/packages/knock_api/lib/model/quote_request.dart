//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class QuoteRequest {
  /// Returns a new [QuoteRequest] instance.
  QuoteRequest({
    required this.tipoPrecio,
    required this.precio,
    required this.precioMin,
    required this.precioMax,
    required this.dia,
    required this.hora,
    required this.nota,
  });

  String? tipoPrecio;

  double? precio;

  double? precioMin;

  double? precioMax;

  DateTime? dia;

  String? hora;

  String? nota;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuoteRequest &&
    other.tipoPrecio == tipoPrecio &&
    other.precio == precio &&
    other.precioMin == precioMin &&
    other.precioMax == precioMax &&
    other.dia == dia &&
    other.hora == hora &&
    other.nota == nota;

  @override
  int get hashCode =>
    (tipoPrecio == null ? 0 : tipoPrecio!.hashCode) +
    (precio == null ? 0 : precio!.hashCode) +
    (precioMin == null ? 0 : precioMin!.hashCode) +
    (precioMax == null ? 0 : precioMax!.hashCode) +
    (dia == null ? 0 : dia!.hashCode) +
    (hora == null ? 0 : hora!.hashCode) +
    (nota == null ? 0 : nota!.hashCode);

  @override
  String toString() => 'QuoteRequest[tipoPrecio=$tipoPrecio, precio=$precio, precioMin=$precioMin, precioMax=$precioMax, dia=$dia, hora=$hora, nota=$nota]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.tipoPrecio != null) {
      json[r'tipoPrecio'] = this.tipoPrecio;
    } else {
      json[r'tipoPrecio'] = null;
    }
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
    if (this.dia != null) {
      json[r'dia'] = _dateFormatter.format(this.dia!);
    } else {
      json[r'dia'] = null;
    }
    if (this.hora != null) {
      json[r'hora'] = this.hora;
    } else {
      json[r'hora'] = null;
    }
    if (this.nota != null) {
      json[r'nota'] = this.nota;
    } else {
      json[r'nota'] = null;
    }
    return json;
  }

  /// Returns a new [QuoteRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static QuoteRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tipoPrecio'), 'Required key "QuoteRequest[tipoPrecio]" is missing from JSON.');
        assert(json.containsKey(r'precio'), 'Required key "QuoteRequest[precio]" is missing from JSON.');
        assert(json.containsKey(r'precioMin'), 'Required key "QuoteRequest[precioMin]" is missing from JSON.');
        assert(json.containsKey(r'precioMax'), 'Required key "QuoteRequest[precioMax]" is missing from JSON.');
        assert(json.containsKey(r'dia'), 'Required key "QuoteRequest[dia]" is missing from JSON.');
        assert(json.containsKey(r'hora'), 'Required key "QuoteRequest[hora]" is missing from JSON.');
        assert(json.containsKey(r'nota'), 'Required key "QuoteRequest[nota]" is missing from JSON.');
        return true;
      }());

      return QuoteRequest(
        tipoPrecio: mapValueOfType<String>(json, r'tipoPrecio'),
        precio: mapValueOfType<double>(json, r'precio'),
        precioMin: mapValueOfType<double>(json, r'precioMin'),
        precioMax: mapValueOfType<double>(json, r'precioMax'),
        dia: mapDateTime(json, r'dia', r''),
        hora: mapValueOfType<String>(json, r'hora'),
        nota: mapValueOfType<String>(json, r'nota'),
      );
    }
    return null;
  }

  static List<QuoteRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuoteRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuoteRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuoteRequest> mapFromJson(dynamic json) {
    final map = <String, QuoteRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = QuoteRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuoteRequest-objects as value to a dart map
  static Map<String, List<QuoteRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuoteRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuoteRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tipoPrecio',
    'precio',
    'precioMin',
    'precioMax',
    'dia',
    'hora',
    'nota',
  };
}

