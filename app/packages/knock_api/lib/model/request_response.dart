//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RequestResponse {
  /// Returns a new [RequestResponse] instance.
  RequestResponse({
    required this.id,
    required this.estado,
    required this.modalidad,
    required this.oficio,
    required this.colonia,
    required this.descripcion,
    this.fotos = const [],
    required this.dia,
    required this.franja,
    required this.direccion,
    required this.totalCotizaciones,
    required this.venceEn,
    required this.creadoEn,
    this.puedeVolverAPedir,
  });

  String id;

  String estado;

  String modalidad;

  RequestTrade oficio;

  RequestNeighborhood colonia;

  String descripcion;

  List<RequestPhoto> fotos;

  String dia;

  String franja;

  String? direccion;

  int? totalCotizaciones;

  DateTime venceEn;

  DateTime creadoEn;

  bool? puedeVolverAPedir;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RequestResponse &&
    other.id == id &&
    other.estado == estado &&
    other.modalidad == modalidad &&
    other.oficio == oficio &&
    other.colonia == colonia &&
    other.descripcion == descripcion &&
    _deepEquality.equals(other.fotos, fotos) &&
    other.dia == dia &&
    other.franja == franja &&
    other.direccion == direccion &&
    other.totalCotizaciones == totalCotizaciones &&
    other.venceEn == venceEn &&
    other.creadoEn == creadoEn &&
    other.puedeVolverAPedir == puedeVolverAPedir;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (modalidad.hashCode) +
    (oficio.hashCode) +
    (colonia.hashCode) +
    (descripcion.hashCode) +
    (fotos.hashCode) +
    (dia.hashCode) +
    (franja.hashCode) +
    (direccion == null ? 0 : direccion!.hashCode) +
    (totalCotizaciones == null ? 0 : totalCotizaciones!.hashCode) +
    (venceEn.hashCode) +
    (creadoEn.hashCode) +
    (puedeVolverAPedir == null ? 0 : puedeVolverAPedir!.hashCode);

  @override
  String toString() => 'RequestResponse[id=$id, estado=$estado, modalidad=$modalidad, oficio=$oficio, colonia=$colonia, descripcion=$descripcion, fotos=$fotos, dia=$dia, franja=$franja, direccion=$direccion, totalCotizaciones=$totalCotizaciones, venceEn=$venceEn, creadoEn=$creadoEn, puedeVolverAPedir=$puedeVolverAPedir]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
      json[r'modalidad'] = this.modalidad;
      json[r'oficio'] = this.oficio;
      json[r'colonia'] = this.colonia;
      json[r'descripcion'] = this.descripcion;
      json[r'fotos'] = this.fotos;
      json[r'dia'] = this.dia;
      json[r'franja'] = this.franja;
    if (this.direccion != null) {
      json[r'direccion'] = this.direccion;
    } else {
      json[r'direccion'] = null;
    }
    if (this.totalCotizaciones != null) {
      json[r'totalCotizaciones'] = this.totalCotizaciones;
    } else {
      json[r'totalCotizaciones'] = null;
    }
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    if (this.puedeVolverAPedir != null) {
      json[r'puedeVolverAPedir'] = this.puedeVolverAPedir;
    } else {
      json[r'puedeVolverAPedir'] = null;
    }
    return json;
  }

  /// Returns a new [RequestResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RequestResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "RequestResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "RequestResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "RequestResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "RequestResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "RequestResponse[modalidad]" is missing from JSON.');
        assert(json[r'modalidad'] != null, 'Required key "RequestResponse[modalidad]" has a null value in JSON.');
        assert(json.containsKey(r'oficio'), 'Required key "RequestResponse[oficio]" is missing from JSON.');
        assert(json[r'oficio'] != null, 'Required key "RequestResponse[oficio]" has a null value in JSON.');
        assert(json.containsKey(r'colonia'), 'Required key "RequestResponse[colonia]" is missing from JSON.');
        assert(json[r'colonia'] != null, 'Required key "RequestResponse[colonia]" has a null value in JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "RequestResponse[descripcion]" is missing from JSON.');
        assert(json[r'descripcion'] != null, 'Required key "RequestResponse[descripcion]" has a null value in JSON.');
        assert(json.containsKey(r'fotos'), 'Required key "RequestResponse[fotos]" is missing from JSON.');
        assert(json[r'fotos'] != null, 'Required key "RequestResponse[fotos]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "RequestResponse[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "RequestResponse[dia]" has a null value in JSON.');
        assert(json.containsKey(r'franja'), 'Required key "RequestResponse[franja]" is missing from JSON.');
        assert(json[r'franja'] != null, 'Required key "RequestResponse[franja]" has a null value in JSON.');
        assert(json.containsKey(r'direccion'), 'Required key "RequestResponse[direccion]" is missing from JSON.');
        assert(json.containsKey(r'totalCotizaciones'), 'Required key "RequestResponse[totalCotizaciones]" is missing from JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "RequestResponse[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "RequestResponse[venceEn]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "RequestResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "RequestResponse[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return RequestResponse(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        modalidad: mapValueOfType<String>(json, r'modalidad')!,
        oficio: RequestTrade.fromJson(json[r'oficio'])!,
        colonia: RequestNeighborhood.fromJson(json[r'colonia'])!,
        descripcion: mapValueOfType<String>(json, r'descripcion')!,
        fotos: RequestPhoto.listFromJson(json[r'fotos']),
        dia: mapValueOfType<String>(json, r'dia')!,
        franja: mapValueOfType<String>(json, r'franja')!,
        direccion: mapValueOfType<String>(json, r'direccion'),
        totalCotizaciones: mapValueOfType<int>(json, r'totalCotizaciones'),
        venceEn: mapDateTime(json, r'venceEn', r'')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
        puedeVolverAPedir: mapValueOfType<bool>(json, r'puedeVolverAPedir'),
      );
    }
    return null;
  }

  static List<RequestResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RequestResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RequestResponse> mapFromJson(dynamic json) {
    final map = <String, RequestResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RequestResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RequestResponse-objects as value to a dart map
  static Map<String, List<RequestResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RequestResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RequestResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'modalidad',
    'oficio',
    'colonia',
    'descripcion',
    'fotos',
    'dia',
    'franja',
    'direccion',
    'totalCotizaciones',
    'venceEn',
    'creadoEn',
  };
}

