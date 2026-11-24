//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AdminTradeResponse {
  /// Returns a new [AdminTradeResponse] instance.
  AdminTradeResponse({
    required this.clave,
    required this.nombre,
    required this.modalidad,
    this.frasesSugeridas = const [],
    required this.topePorcentaje,
    required this.topeFijoPorcentaje,
    required this.pisoAprobacion,
    required this.visitaMaxima,
    required this.activo,
  });

  String clave;

  String nombre;

  String modalidad;

  List<String> frasesSugeridas;

  double? topePorcentaje;

  double? topeFijoPorcentaje;

  int? pisoAprobacion;

  int? visitaMaxima;

  bool activo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminTradeResponse &&
    other.clave == clave &&
    other.nombre == nombre &&
    other.modalidad == modalidad &&
    _deepEquality.equals(other.frasesSugeridas, frasesSugeridas) &&
    other.topePorcentaje == topePorcentaje &&
    other.topeFijoPorcentaje == topeFijoPorcentaje &&
    other.pisoAprobacion == pisoAprobacion &&
    other.visitaMaxima == visitaMaxima &&
    other.activo == activo;

  @override
  int get hashCode =>
    (clave.hashCode) +
    (nombre.hashCode) +
    (modalidad.hashCode) +
    (frasesSugeridas.hashCode) +
    (topePorcentaje == null ? 0 : topePorcentaje!.hashCode) +
    (topeFijoPorcentaje == null ? 0 : topeFijoPorcentaje!.hashCode) +
    (pisoAprobacion == null ? 0 : pisoAprobacion!.hashCode) +
    (visitaMaxima == null ? 0 : visitaMaxima!.hashCode) +
    (activo.hashCode);

  @override
  String toString() => 'AdminTradeResponse[clave=$clave, nombre=$nombre, modalidad=$modalidad, frasesSugeridas=$frasesSugeridas, topePorcentaje=$topePorcentaje, topeFijoPorcentaje=$topeFijoPorcentaje, pisoAprobacion=$pisoAprobacion, visitaMaxima=$visitaMaxima, activo=$activo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'clave'] = this.clave;
      json[r'nombre'] = this.nombre;
      json[r'modalidad'] = this.modalidad;
      json[r'frasesSugeridas'] = this.frasesSugeridas;
    if (this.topePorcentaje != null) {
      json[r'topePorcentaje'] = this.topePorcentaje;
    } else {
      json[r'topePorcentaje'] = null;
    }
    if (this.topeFijoPorcentaje != null) {
      json[r'topeFijoPorcentaje'] = this.topeFijoPorcentaje;
    } else {
      json[r'topeFijoPorcentaje'] = null;
    }
    if (this.pisoAprobacion != null) {
      json[r'pisoAprobacion'] = this.pisoAprobacion;
    } else {
      json[r'pisoAprobacion'] = null;
    }
    if (this.visitaMaxima != null) {
      json[r'visitaMaxima'] = this.visitaMaxima;
    } else {
      json[r'visitaMaxima'] = null;
    }
      json[r'activo'] = this.activo;
    return json;
  }

  /// Returns a new [AdminTradeResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AdminTradeResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'clave'), 'Required key "AdminTradeResponse[clave]" is missing from JSON.');
        assert(json[r'clave'] != null, 'Required key "AdminTradeResponse[clave]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "AdminTradeResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "AdminTradeResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "AdminTradeResponse[modalidad]" is missing from JSON.');
        assert(json[r'modalidad'] != null, 'Required key "AdminTradeResponse[modalidad]" has a null value in JSON.');
        assert(json.containsKey(r'frasesSugeridas'), 'Required key "AdminTradeResponse[frasesSugeridas]" is missing from JSON.');
        assert(json[r'frasesSugeridas'] != null, 'Required key "AdminTradeResponse[frasesSugeridas]" has a null value in JSON.');
        assert(json.containsKey(r'topePorcentaje'), 'Required key "AdminTradeResponse[topePorcentaje]" is missing from JSON.');
        assert(json.containsKey(r'topeFijoPorcentaje'), 'Required key "AdminTradeResponse[topeFijoPorcentaje]" is missing from JSON.');
        assert(json.containsKey(r'pisoAprobacion'), 'Required key "AdminTradeResponse[pisoAprobacion]" is missing from JSON.');
        assert(json.containsKey(r'visitaMaxima'), 'Required key "AdminTradeResponse[visitaMaxima]" is missing from JSON.');
        assert(json.containsKey(r'activo'), 'Required key "AdminTradeResponse[activo]" is missing from JSON.');
        assert(json[r'activo'] != null, 'Required key "AdminTradeResponse[activo]" has a null value in JSON.');
        return true;
      }());

      return AdminTradeResponse(
        clave: mapValueOfType<String>(json, r'clave')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        modalidad: mapValueOfType<String>(json, r'modalidad')!,
        frasesSugeridas: json[r'frasesSugeridas'] is Iterable
            ? (json[r'frasesSugeridas'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        topePorcentaje: mapValueOfType<double>(json, r'topePorcentaje'),
        topeFijoPorcentaje: mapValueOfType<double>(json, r'topeFijoPorcentaje'),
        pisoAprobacion: mapValueOfType<int>(json, r'pisoAprobacion'),
        visitaMaxima: mapValueOfType<int>(json, r'visitaMaxima'),
        activo: mapValueOfType<bool>(json, r'activo')!,
      );
    }
    return null;
  }

  static List<AdminTradeResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminTradeResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminTradeResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminTradeResponse> mapFromJson(dynamic json) {
    final map = <String, AdminTradeResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AdminTradeResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminTradeResponse-objects as value to a dart map
  static Map<String, List<AdminTradeResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminTradeResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminTradeResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'clave',
    'nombre',
    'modalidad',
    'frasesSugeridas',
    'topePorcentaje',
    'topeFijoPorcentaje',
    'pisoAprobacion',
    'visitaMaxima',
    'activo',
  };
}

