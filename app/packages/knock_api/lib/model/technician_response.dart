//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TechnicianResponse {
  /// Returns a new [TechnicianResponse] instance.
  TechnicianResponse({
    required this.id,
    required this.nombre,
    this.oficios = const [],
    required this.otroOficio,
    required this.atencion,
    required this.radioKm,
    required this.coloniaId,
    required this.nombreNegocio,
    required this.descripcion,
    required this.anios,
    required this.estado,
    required this.verificacion,
    required this.disponibleHoy,
    required this.creadoEn,
  });

  String id;

  String nombre;

  List<String> oficios;

  String? otroOficio;

  String atencion;

  int? radioKm;

  String coloniaId;

  String? nombreNegocio;

  String? descripcion;

  int? anios;

  String estado;

  String verificacion;

  bool disponibleHoy;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TechnicianResponse &&
    other.id == id &&
    other.nombre == nombre &&
    _deepEquality.equals(other.oficios, oficios) &&
    other.otroOficio == otroOficio &&
    other.atencion == atencion &&
    other.radioKm == radioKm &&
    other.coloniaId == coloniaId &&
    other.nombreNegocio == nombreNegocio &&
    other.descripcion == descripcion &&
    other.anios == anios &&
    other.estado == estado &&
    other.verificacion == verificacion &&
    other.disponibleHoy == disponibleHoy &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (nombre.hashCode) +
    (oficios.hashCode) +
    (otroOficio == null ? 0 : otroOficio!.hashCode) +
    (atencion.hashCode) +
    (radioKm == null ? 0 : radioKm!.hashCode) +
    (coloniaId.hashCode) +
    (nombreNegocio == null ? 0 : nombreNegocio!.hashCode) +
    (descripcion == null ? 0 : descripcion!.hashCode) +
    (anios == null ? 0 : anios!.hashCode) +
    (estado.hashCode) +
    (verificacion.hashCode) +
    (disponibleHoy.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'TechnicianResponse[id=$id, nombre=$nombre, oficios=$oficios, otroOficio=$otroOficio, atencion=$atencion, radioKm=$radioKm, coloniaId=$coloniaId, nombreNegocio=$nombreNegocio, descripcion=$descripcion, anios=$anios, estado=$estado, verificacion=$verificacion, disponibleHoy=$disponibleHoy, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'nombre'] = this.nombre;
      json[r'oficios'] = this.oficios;
    if (this.otroOficio != null) {
      json[r'otroOficio'] = this.otroOficio;
    } else {
      json[r'otroOficio'] = null;
    }
      json[r'atencion'] = this.atencion;
    if (this.radioKm != null) {
      json[r'radioKm'] = this.radioKm;
    } else {
      json[r'radioKm'] = null;
    }
      json[r'coloniaId'] = this.coloniaId;
    if (this.nombreNegocio != null) {
      json[r'nombreNegocio'] = this.nombreNegocio;
    } else {
      json[r'nombreNegocio'] = null;
    }
    if (this.descripcion != null) {
      json[r'descripcion'] = this.descripcion;
    } else {
      json[r'descripcion'] = null;
    }
    if (this.anios != null) {
      json[r'anios'] = this.anios;
    } else {
      json[r'anios'] = null;
    }
      json[r'estado'] = this.estado;
      json[r'verificacion'] = this.verificacion;
      json[r'disponibleHoy'] = this.disponibleHoy;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [TechnicianResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TechnicianResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "TechnicianResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "TechnicianResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "TechnicianResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "TechnicianResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'oficios'), 'Required key "TechnicianResponse[oficios]" is missing from JSON.');
        assert(json[r'oficios'] != null, 'Required key "TechnicianResponse[oficios]" has a null value in JSON.');
        assert(json.containsKey(r'otroOficio'), 'Required key "TechnicianResponse[otroOficio]" is missing from JSON.');
        assert(json.containsKey(r'atencion'), 'Required key "TechnicianResponse[atencion]" is missing from JSON.');
        assert(json[r'atencion'] != null, 'Required key "TechnicianResponse[atencion]" has a null value in JSON.');
        assert(json.containsKey(r'radioKm'), 'Required key "TechnicianResponse[radioKm]" is missing from JSON.');
        assert(json.containsKey(r'coloniaId'), 'Required key "TechnicianResponse[coloniaId]" is missing from JSON.');
        assert(json[r'coloniaId'] != null, 'Required key "TechnicianResponse[coloniaId]" has a null value in JSON.');
        assert(json.containsKey(r'nombreNegocio'), 'Required key "TechnicianResponse[nombreNegocio]" is missing from JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "TechnicianResponse[descripcion]" is missing from JSON.');
        assert(json.containsKey(r'anios'), 'Required key "TechnicianResponse[anios]" is missing from JSON.');
        assert(json.containsKey(r'estado'), 'Required key "TechnicianResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "TechnicianResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'verificacion'), 'Required key "TechnicianResponse[verificacion]" is missing from JSON.');
        assert(json[r'verificacion'] != null, 'Required key "TechnicianResponse[verificacion]" has a null value in JSON.');
        assert(json.containsKey(r'disponibleHoy'), 'Required key "TechnicianResponse[disponibleHoy]" is missing from JSON.');
        assert(json[r'disponibleHoy'] != null, 'Required key "TechnicianResponse[disponibleHoy]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "TechnicianResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "TechnicianResponse[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return TechnicianResponse(
        id: mapValueOfType<String>(json, r'id')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        oficios: json[r'oficios'] is Iterable
            ? (json[r'oficios'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        otroOficio: mapValueOfType<String>(json, r'otroOficio'),
        atencion: mapValueOfType<String>(json, r'atencion')!,
        radioKm: mapValueOfType<int>(json, r'radioKm'),
        coloniaId: mapValueOfType<String>(json, r'coloniaId')!,
        nombreNegocio: mapValueOfType<String>(json, r'nombreNegocio'),
        descripcion: mapValueOfType<String>(json, r'descripcion'),
        anios: mapValueOfType<int>(json, r'anios'),
        estado: mapValueOfType<String>(json, r'estado')!,
        verificacion: mapValueOfType<String>(json, r'verificacion')!,
        disponibleHoy: mapValueOfType<bool>(json, r'disponibleHoy')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<TechnicianResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TechnicianResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TechnicianResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TechnicianResponse> mapFromJson(dynamic json) {
    final map = <String, TechnicianResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TechnicianResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TechnicianResponse-objects as value to a dart map
  static Map<String, List<TechnicianResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TechnicianResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TechnicianResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'nombre',
    'oficios',
    'otroOficio',
    'atencion',
    'radioKm',
    'coloniaId',
    'nombreNegocio',
    'descripcion',
    'anios',
    'estado',
    'verificacion',
    'disponibleHoy',
    'creadoEn',
  };
}

