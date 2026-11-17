//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RequestSummary {
  /// Returns a new [RequestSummary] instance.
  RequestSummary({
    required this.id,
    required this.estado,
    required this.oficioNombre,
    required this.coloniaNombre,
    required this.dia,
    required this.franja,
    required this.totalFotos,
    required this.totalCotizaciones,
    required this.venceEn,
    required this.creadoEn,
    this.visitaId,
  });

  String id;

  String estado;

  String oficioNombre;

  String coloniaNombre;

  String dia;

  String franja;

  int totalFotos;

  int totalCotizaciones;

  DateTime venceEn;

  DateTime creadoEn;

  String? visitaId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RequestSummary &&
    other.id == id &&
    other.estado == estado &&
    other.oficioNombre == oficioNombre &&
    other.coloniaNombre == coloniaNombre &&
    other.dia == dia &&
    other.franja == franja &&
    other.totalFotos == totalFotos &&
    other.totalCotizaciones == totalCotizaciones &&
    other.venceEn == venceEn &&
    other.creadoEn == creadoEn &&
    other.visitaId == visitaId;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (oficioNombre.hashCode) +
    (coloniaNombre.hashCode) +
    (dia.hashCode) +
    (franja.hashCode) +
    (totalFotos.hashCode) +
    (totalCotizaciones.hashCode) +
    (venceEn.hashCode) +
    (creadoEn.hashCode) +
    (visitaId == null ? 0 : visitaId!.hashCode);

  @override
  String toString() => 'RequestSummary[id=$id, estado=$estado, oficioNombre=$oficioNombre, coloniaNombre=$coloniaNombre, dia=$dia, franja=$franja, totalFotos=$totalFotos, totalCotizaciones=$totalCotizaciones, venceEn=$venceEn, creadoEn=$creadoEn, visitaId=$visitaId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
      json[r'oficioNombre'] = this.oficioNombre;
      json[r'coloniaNombre'] = this.coloniaNombre;
      json[r'dia'] = this.dia;
      json[r'franja'] = this.franja;
      json[r'totalFotos'] = this.totalFotos;
      json[r'totalCotizaciones'] = this.totalCotizaciones;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    if (this.visitaId != null) {
      json[r'visitaId'] = this.visitaId;
    } else {
      json[r'visitaId'] = null;
    }
    return json;
  }

  /// Returns a new [RequestSummary] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RequestSummary? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RequestSummary[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RequestSummary[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "RequestSummary[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "RequestSummary[estado]" has a null value in JSON.');
        assert(json.containsKey(r'oficioNombre'), 'Required key "RequestSummary[oficioNombre]" is missing from JSON.');
        assert(json[r'oficioNombre'] != null, 'Required key "RequestSummary[oficioNombre]" has a null value in JSON.');
        assert(json.containsKey(r'coloniaNombre'), 'Required key "RequestSummary[coloniaNombre]" is missing from JSON.');
        assert(json[r'coloniaNombre'] != null, 'Required key "RequestSummary[coloniaNombre]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "RequestSummary[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "RequestSummary[dia]" has a null value in JSON.');
        assert(json.containsKey(r'franja'), 'Required key "RequestSummary[franja]" is missing from JSON.');
        assert(json[r'franja'] != null, 'Required key "RequestSummary[franja]" has a null value in JSON.');
        assert(json.containsKey(r'totalFotos'), 'Required key "RequestSummary[totalFotos]" is missing from JSON.');
        assert(json[r'totalFotos'] != null, 'Required key "RequestSummary[totalFotos]" has a null value in JSON.');
        assert(json.containsKey(r'totalCotizaciones'), 'Required key "RequestSummary[totalCotizaciones]" is missing from JSON.');
        assert(json[r'totalCotizaciones'] != null, 'Required key "RequestSummary[totalCotizaciones]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "RequestSummary[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "RequestSummary[venceEn]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "RequestSummary[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "RequestSummary[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return RequestSummary(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        oficioNombre: mapValueOfType<String>(json, r'oficioNombre')!,
        coloniaNombre: mapValueOfType<String>(json, r'coloniaNombre')!,
        dia: mapValueOfType<String>(json, r'dia')!,
        franja: mapValueOfType<String>(json, r'franja')!,
        totalFotos: mapValueOfType<int>(json, r'totalFotos')!,
        totalCotizaciones: mapValueOfType<int>(json, r'totalCotizaciones')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
        visitaId: mapValueOfType<String>(json, r'visitaId'),
      );
    }
    return null;
  }

  static List<RequestSummary> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RequestSummary>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestSummary.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RequestSummary> mapFromJson(dynamic json) {
    final map = <String, RequestSummary>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RequestSummary.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RequestSummary-objects as value to a dart map
  static Map<String, List<RequestSummary>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RequestSummary>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RequestSummary.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'oficioNombre',
    'coloniaNombre',
    'dia',
    'franja',
    'totalFotos',
    'totalCotizaciones',
    'venceEn',
    'creadoEn',
  };
}

