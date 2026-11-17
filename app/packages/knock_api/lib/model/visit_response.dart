//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VisitResponse {
  /// Returns a new [VisitResponse] instance.
  VisitResponse({
    required this.id,
    required this.rol,
    required this.estado,
    required this.modalidad,
    required this.dia,
    required this.hora,
    required this.precio,
    required this.tope,
    required this.tecnico,
    required this.cliente,
    required this.lugar,
    required this.codigo,
    required this.codigoVenceEn,
    required this.motivoCodigo,
    required this.reglaSeguridad,
    required this.puedeAvisar,
    required this.puedeLlegar,
    required this.llegadaEn,
  });

  String id;

  String rol;

  String estado;

  String modalidad;

  String dia;

  String hora;

  int? precio;

  int tope;

  VisitTechnician? tecnico;

  VisitCustomer? cliente;

  VisitPlace lugar;

  String? codigo;

  DateTime? codigoVenceEn;

  String? motivoCodigo;

  String? reglaSeguridad;

  bool? puedeAvisar;

  bool puedeLlegar;

  DateTime? llegadaEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VisitResponse &&
    other.id == id &&
    other.rol == rol &&
    other.estado == estado &&
    other.modalidad == modalidad &&
    other.dia == dia &&
    other.hora == hora &&
    other.precio == precio &&
    other.tope == tope &&
    other.tecnico == tecnico &&
    other.cliente == cliente &&
    other.lugar == lugar &&
    other.codigo == codigo &&
    other.codigoVenceEn == codigoVenceEn &&
    other.motivoCodigo == motivoCodigo &&
    other.reglaSeguridad == reglaSeguridad &&
    other.puedeAvisar == puedeAvisar &&
    other.puedeLlegar == puedeLlegar &&
    other.llegadaEn == llegadaEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (rol.hashCode) +
    (estado.hashCode) +
    (modalidad.hashCode) +
    (dia.hashCode) +
    (hora.hashCode) +
    (precio == null ? 0 : precio!.hashCode) +
    (tope.hashCode) +
    (tecnico == null ? 0 : tecnico!.hashCode) +
    (cliente == null ? 0 : cliente!.hashCode) +
    (lugar.hashCode) +
    (codigo == null ? 0 : codigo!.hashCode) +
    (codigoVenceEn == null ? 0 : codigoVenceEn!.hashCode) +
    (motivoCodigo == null ? 0 : motivoCodigo!.hashCode) +
    (reglaSeguridad == null ? 0 : reglaSeguridad!.hashCode) +
    (puedeAvisar == null ? 0 : puedeAvisar!.hashCode) +
    (puedeLlegar.hashCode) +
    (llegadaEn == null ? 0 : llegadaEn!.hashCode);

  @override
  String toString() => 'VisitResponse[id=$id, rol=$rol, estado=$estado, modalidad=$modalidad, dia=$dia, hora=$hora, precio=$precio, tope=$tope, tecnico=$tecnico, cliente=$cliente, lugar=$lugar, codigo=$codigo, codigoVenceEn=$codigoVenceEn, motivoCodigo=$motivoCodigo, reglaSeguridad=$reglaSeguridad, puedeAvisar=$puedeAvisar, puedeLlegar=$puedeLlegar, llegadaEn=$llegadaEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'rol'] = this.rol;
      json[r'estado'] = this.estado;
      json[r'modalidad'] = this.modalidad;
      json[r'dia'] = this.dia;
      json[r'hora'] = this.hora;
    if (this.precio != null) {
      json[r'precio'] = this.precio;
    } else {
      json[r'precio'] = null;
    }
      json[r'tope'] = this.tope;
    if (this.tecnico != null) {
      json[r'tecnico'] = this.tecnico;
    } else {
      json[r'tecnico'] = null;
    }
    if (this.cliente != null) {
      json[r'cliente'] = this.cliente;
    } else {
      json[r'cliente'] = null;
    }
      json[r'lugar'] = this.lugar;
    if (this.codigo != null) {
      json[r'codigo'] = this.codigo;
    } else {
      json[r'codigo'] = null;
    }
    if (this.codigoVenceEn != null) {
      json[r'codigoVenceEn'] = this.codigoVenceEn!.toUtc().toIso8601String();
    } else {
      json[r'codigoVenceEn'] = null;
    }
    if (this.motivoCodigo != null) {
      json[r'motivoCodigo'] = this.motivoCodigo;
    } else {
      json[r'motivoCodigo'] = null;
    }
    if (this.reglaSeguridad != null) {
      json[r'reglaSeguridad'] = this.reglaSeguridad;
    } else {
      json[r'reglaSeguridad'] = null;
    }
    if (this.puedeAvisar != null) {
      json[r'puedeAvisar'] = this.puedeAvisar;
    } else {
      json[r'puedeAvisar'] = null;
    }
      json[r'puedeLlegar'] = this.puedeLlegar;
    if (this.llegadaEn != null) {
      json[r'llegadaEn'] = this.llegadaEn!.toUtc().toIso8601String();
    } else {
      json[r'llegadaEn'] = null;
    }
    return json;
  }

  /// Returns a new [VisitResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VisitResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "VisitResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "VisitResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'rol'), 'Required key "VisitResponse[rol]" is missing from JSON.');
        assert(json[r'rol'] != null, 'Required key "VisitResponse[rol]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "VisitResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "VisitResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "VisitResponse[modalidad]" is missing from JSON.');
        assert(json[r'modalidad'] != null, 'Required key "VisitResponse[modalidad]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "VisitResponse[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "VisitResponse[dia]" has a null value in JSON.');
        assert(json.containsKey(r'hora'), 'Required key "VisitResponse[hora]" is missing from JSON.');
        assert(json[r'hora'] != null, 'Required key "VisitResponse[hora]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "VisitResponse[precio]" is missing from JSON.');
        assert(json.containsKey(r'tope'), 'Required key "VisitResponse[tope]" is missing from JSON.');
        assert(json[r'tope'] != null, 'Required key "VisitResponse[tope]" has a null value in JSON.');
        assert(json.containsKey(r'tecnico'), 'Required key "VisitResponse[tecnico]" is missing from JSON.');
        assert(json.containsKey(r'cliente'), 'Required key "VisitResponse[cliente]" is missing from JSON.');
        assert(json.containsKey(r'lugar'), 'Required key "VisitResponse[lugar]" is missing from JSON.');
        assert(json[r'lugar'] != null, 'Required key "VisitResponse[lugar]" has a null value in JSON.');
        assert(json.containsKey(r'codigo'), 'Required key "VisitResponse[codigo]" is missing from JSON.');
        assert(json.containsKey(r'codigoVenceEn'), 'Required key "VisitResponse[codigoVenceEn]" is missing from JSON.');
        assert(json.containsKey(r'motivoCodigo'), 'Required key "VisitResponse[motivoCodigo]" is missing from JSON.');
        assert(json.containsKey(r'reglaSeguridad'), 'Required key "VisitResponse[reglaSeguridad]" is missing from JSON.');
        assert(json.containsKey(r'puedeAvisar'), 'Required key "VisitResponse[puedeAvisar]" is missing from JSON.');
        assert(json.containsKey(r'puedeLlegar'), 'Required key "VisitResponse[puedeLlegar]" is missing from JSON.');
        assert(json[r'puedeLlegar'] != null, 'Required key "VisitResponse[puedeLlegar]" has a null value in JSON.');
        assert(json.containsKey(r'llegadaEn'), 'Required key "VisitResponse[llegadaEn]" is missing from JSON.');
        return true;
      }());

      return VisitResponse(
        id: mapValueOfType<String>(json, r'id')!,
        rol: mapValueOfType<String>(json, r'rol')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        modalidad: mapValueOfType<String>(json, r'modalidad')!,
        dia: mapValueOfType<String>(json, r'dia')!,
        hora: mapValueOfType<String>(json, r'hora')!,
        precio: mapValueOfType<int>(json, r'precio'),
        tope: mapValueOfType<int>(json, r'tope')!,
        tecnico: VisitTechnician.fromJson(json[r'tecnico']),
        cliente: VisitCustomer.fromJson(json[r'cliente']),
        lugar: VisitPlace.fromJson(json[r'lugar'])!,
        codigo: mapValueOfType<String>(json, r'codigo'),
        codigoVenceEn: mapDateTime(json, r'codigoVenceEn', r''),
        motivoCodigo: mapValueOfType<String>(json, r'motivoCodigo'),
        reglaSeguridad: mapValueOfType<String>(json, r'reglaSeguridad'),
        puedeAvisar: mapValueOfType<bool>(json, r'puedeAvisar'),
        puedeLlegar: mapValueOfType<bool>(json, r'puedeLlegar')!,
        llegadaEn: mapDateTime(json, r'llegadaEn', r''),
      );
    }
    return null;
  }

  static List<VisitResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VisitResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VisitResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VisitResponse> mapFromJson(dynamic json) {
    final map = <String, VisitResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VisitResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VisitResponse-objects as value to a dart map
  static Map<String, List<VisitResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VisitResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VisitResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'rol',
    'estado',
    'modalidad',
    'dia',
    'hora',
    'precio',
    'tope',
    'tecnico',
    'cliente',
    'lugar',
    'codigo',
    'codigoVenceEn',
    'motivoCodigo',
    'reglaSeguridad',
    'puedeAvisar',
    'puedeLlegar',
    'llegadaEn',
  };
}

