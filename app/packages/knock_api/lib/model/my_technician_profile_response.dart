//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class MyTechnicianProfileResponse {
  /// Returns a new [MyTechnicianProfileResponse] instance.
  MyTechnicianProfileResponse({
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
    required this.fotoUrl,
    required this.direccionTaller,
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

  String? fotoUrl;

  String? direccionTaller;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MyTechnicianProfileResponse &&
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
    other.creadoEn == creadoEn &&
    other.fotoUrl == fotoUrl &&
    other.direccionTaller == direccionTaller;

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
    (creadoEn.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode) +
    (direccionTaller == null ? 0 : direccionTaller!.hashCode);

  @override
  String toString() => 'MyTechnicianProfileResponse[id=$id, nombre=$nombre, oficios=$oficios, otroOficio=$otroOficio, atencion=$atencion, radioKm=$radioKm, coloniaId=$coloniaId, nombreNegocio=$nombreNegocio, descripcion=$descripcion, anios=$anios, estado=$estado, verificacion=$verificacion, disponibleHoy=$disponibleHoy, creadoEn=$creadoEn, fotoUrl=$fotoUrl, direccionTaller=$direccionTaller]';

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
    if (this.fotoUrl != null) {
      json[r'fotoUrl'] = this.fotoUrl;
    } else {
      json[r'fotoUrl'] = null;
    }
    if (this.direccionTaller != null) {
      json[r'direccionTaller'] = this.direccionTaller;
    } else {
      json[r'direccionTaller'] = null;
    }
    return json;
  }

  /// Returns a new [MyTechnicianProfileResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static MyTechnicianProfileResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "MyTechnicianProfileResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "MyTechnicianProfileResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "MyTechnicianProfileResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "MyTechnicianProfileResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'oficios'), 'Required key "MyTechnicianProfileResponse[oficios]" is missing from JSON.');
        assert(json[r'oficios'] != null, 'Required key "MyTechnicianProfileResponse[oficios]" has a null value in JSON.');
        assert(json.containsKey(r'otroOficio'), 'Required key "MyTechnicianProfileResponse[otroOficio]" is missing from JSON.');
        assert(json.containsKey(r'atencion'), 'Required key "MyTechnicianProfileResponse[atencion]" is missing from JSON.');
        assert(json[r'atencion'] != null, 'Required key "MyTechnicianProfileResponse[atencion]" has a null value in JSON.');
        assert(json.containsKey(r'radioKm'), 'Required key "MyTechnicianProfileResponse[radioKm]" is missing from JSON.');
        assert(json.containsKey(r'coloniaId'), 'Required key "MyTechnicianProfileResponse[coloniaId]" is missing from JSON.');
        assert(json[r'coloniaId'] != null, 'Required key "MyTechnicianProfileResponse[coloniaId]" has a null value in JSON.');
        assert(json.containsKey(r'nombreNegocio'), 'Required key "MyTechnicianProfileResponse[nombreNegocio]" is missing from JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "MyTechnicianProfileResponse[descripcion]" is missing from JSON.');
        assert(json.containsKey(r'anios'), 'Required key "MyTechnicianProfileResponse[anios]" is missing from JSON.');
        assert(json.containsKey(r'estado'), 'Required key "MyTechnicianProfileResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "MyTechnicianProfileResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'verificacion'), 'Required key "MyTechnicianProfileResponse[verificacion]" is missing from JSON.');
        assert(json[r'verificacion'] != null, 'Required key "MyTechnicianProfileResponse[verificacion]" has a null value in JSON.');
        assert(json.containsKey(r'disponibleHoy'), 'Required key "MyTechnicianProfileResponse[disponibleHoy]" is missing from JSON.');
        assert(json[r'disponibleHoy'] != null, 'Required key "MyTechnicianProfileResponse[disponibleHoy]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "MyTechnicianProfileResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "MyTechnicianProfileResponse[creadoEn]" has a null value in JSON.');
        assert(json.containsKey(r'fotoUrl'), 'Required key "MyTechnicianProfileResponse[fotoUrl]" is missing from JSON.');
        assert(json.containsKey(r'direccionTaller'), 'Required key "MyTechnicianProfileResponse[direccionTaller]" is missing from JSON.');
        return true;
      }());

      return MyTechnicianProfileResponse(
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
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
        direccionTaller: mapValueOfType<String>(json, r'direccionTaller'),
      );
    }
    return null;
  }

  static List<MyTechnicianProfileResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MyTechnicianProfileResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MyTechnicianProfileResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MyTechnicianProfileResponse> mapFromJson(dynamic json) {
    final map = <String, MyTechnicianProfileResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = MyTechnicianProfileResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MyTechnicianProfileResponse-objects as value to a dart map
  static Map<String, List<MyTechnicianProfileResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MyTechnicianProfileResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MyTechnicianProfileResponse.listFromJson(entry.value, growable: growable,);
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
    'fotoUrl',
    'direccionTaller',
  };
}

