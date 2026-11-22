//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TechnicianProfileResponse {
  /// Returns a new [TechnicianProfileResponse] instance.
  TechnicianProfileResponse({
    required this.id,
    required this.nombre,
    required this.nombreNegocio,
    required this.fotoUrl,
    required this.verificacion,
    required this.calificacion,
    required this.anios,
    required this.descripcionCorta,
    this.oficios = const [],
    required this.detalle,
  });

  String id;

  String nombre;

  String? nombreNegocio;

  String? fotoUrl;

  String verificacion;

  double? calificacion;

  int? anios;

  String? descripcionCorta;

  List<String> oficios;

  TechnicianProfileDetail? detalle;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TechnicianProfileResponse &&
    other.id == id &&
    other.nombre == nombre &&
    other.nombreNegocio == nombreNegocio &&
    other.fotoUrl == fotoUrl &&
    other.verificacion == verificacion &&
    other.calificacion == calificacion &&
    other.anios == anios &&
    other.descripcionCorta == descripcionCorta &&
    _deepEquality.equals(other.oficios, oficios) &&
    other.detalle == detalle;

  @override
  int get hashCode =>
    (id.hashCode) +
    (nombre.hashCode) +
    (nombreNegocio == null ? 0 : nombreNegocio!.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode) +
    (verificacion.hashCode) +
    (calificacion == null ? 0 : calificacion!.hashCode) +
    (anios == null ? 0 : anios!.hashCode) +
    (descripcionCorta == null ? 0 : descripcionCorta!.hashCode) +
    (oficios.hashCode) +
    (detalle == null ? 0 : detalle!.hashCode);

  @override
  String toString() => 'TechnicianProfileResponse[id=$id, nombre=$nombre, nombreNegocio=$nombreNegocio, fotoUrl=$fotoUrl, verificacion=$verificacion, calificacion=$calificacion, anios=$anios, descripcionCorta=$descripcionCorta, oficios=$oficios, detalle=$detalle]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'nombre'] = this.nombre;
    if (this.nombreNegocio != null) {
      json[r'nombreNegocio'] = this.nombreNegocio;
    } else {
      json[r'nombreNegocio'] = null;
    }
    if (this.fotoUrl != null) {
      json[r'fotoUrl'] = this.fotoUrl;
    } else {
      json[r'fotoUrl'] = null;
    }
      json[r'verificacion'] = this.verificacion;
    if (this.calificacion != null) {
      json[r'calificacion'] = this.calificacion;
    } else {
      json[r'calificacion'] = null;
    }
    if (this.anios != null) {
      json[r'anios'] = this.anios;
    } else {
      json[r'anios'] = null;
    }
    if (this.descripcionCorta != null) {
      json[r'descripcionCorta'] = this.descripcionCorta;
    } else {
      json[r'descripcionCorta'] = null;
    }
      json[r'oficios'] = this.oficios;
    if (this.detalle != null) {
      json[r'detalle'] = this.detalle;
    } else {
      json[r'detalle'] = null;
    }
    return json;
  }

  /// Returns a new [TechnicianProfileResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TechnicianProfileResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "TechnicianProfileResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "TechnicianProfileResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "TechnicianProfileResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "TechnicianProfileResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'nombreNegocio'), 'Required key "TechnicianProfileResponse[nombreNegocio]" is missing from JSON.');
        assert(json.containsKey(r'fotoUrl'), 'Required key "TechnicianProfileResponse[fotoUrl]" is missing from JSON.');
        assert(json.containsKey(r'verificacion'), 'Required key "TechnicianProfileResponse[verificacion]" is missing from JSON.');
        assert(json[r'verificacion'] != null, 'Required key "TechnicianProfileResponse[verificacion]" has a null value in JSON.');
        assert(json.containsKey(r'calificacion'), 'Required key "TechnicianProfileResponse[calificacion]" is missing from JSON.');
        assert(json.containsKey(r'anios'), 'Required key "TechnicianProfileResponse[anios]" is missing from JSON.');
        assert(json.containsKey(r'descripcionCorta'), 'Required key "TechnicianProfileResponse[descripcionCorta]" is missing from JSON.');
        assert(json.containsKey(r'oficios'), 'Required key "TechnicianProfileResponse[oficios]" is missing from JSON.');
        assert(json[r'oficios'] != null, 'Required key "TechnicianProfileResponse[oficios]" has a null value in JSON.');
        assert(json.containsKey(r'detalle'), 'Required key "TechnicianProfileResponse[detalle]" is missing from JSON.');
        return true;
      }());

      return TechnicianProfileResponse(
        id: mapValueOfType<String>(json, r'id')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        nombreNegocio: mapValueOfType<String>(json, r'nombreNegocio'),
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
        verificacion: mapValueOfType<String>(json, r'verificacion')!,
        calificacion: mapValueOfType<double>(json, r'calificacion'),
        anios: mapValueOfType<int>(json, r'anios'),
        descripcionCorta: mapValueOfType<String>(json, r'descripcionCorta'),
        oficios: json[r'oficios'] is Iterable
            ? (json[r'oficios'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        detalle: TechnicianProfileDetail.fromJson(json[r'detalle']),
      );
    }
    return null;
  }

  static List<TechnicianProfileResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TechnicianProfileResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TechnicianProfileResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TechnicianProfileResponse> mapFromJson(dynamic json) {
    final map = <String, TechnicianProfileResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TechnicianProfileResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TechnicianProfileResponse-objects as value to a dart map
  static Map<String, List<TechnicianProfileResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TechnicianProfileResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TechnicianProfileResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'nombre',
    'nombreNegocio',
    'fotoUrl',
    'verificacion',
    'calificacion',
    'anios',
    'descripcionCorta',
    'oficios',
    'detalle',
  };
}

