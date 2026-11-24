//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class UpdateTradeBody {
  /// Returns a new [UpdateTradeBody] instance.
  UpdateTradeBody({
    required this.clave,
    required this.nombre,
    required this.modalidad,
    this.frasesSugeridas = const [],
    required this.topePorcentaje,
    required this.topeFijoPorcentaje,
    required this.pisoAprobacion,
    required this.visitaMaxima,
    required this.activo,
    this.changedFields = const [],
  });

  String? clave;

  String? nombre;

  String? modalidad;

  List<String>? frasesSugeridas;

  double? topePorcentaje;

  double? topeFijoPorcentaje;

  int? pisoAprobacion;

  int? visitaMaxima;

  bool? activo;

  /// Nombres (camelCase) de los campos que la edición cambia.
  List<String> changedFields;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateTradeBody &&
    other.clave == clave &&
    other.nombre == nombre &&
    other.modalidad == modalidad &&
    _deepEquality.equals(other.frasesSugeridas, frasesSugeridas) &&
    other.topePorcentaje == topePorcentaje &&
    other.topeFijoPorcentaje == topeFijoPorcentaje &&
    other.pisoAprobacion == pisoAprobacion &&
    other.visitaMaxima == visitaMaxima &&
    other.activo == activo &&
    _deepEquality.equals(other.changedFields, changedFields);

  @override
  int get hashCode =>
    (clave == null ? 0 : clave!.hashCode) +
    (nombre == null ? 0 : nombre!.hashCode) +
    (modalidad == null ? 0 : modalidad!.hashCode) +
    (frasesSugeridas == null ? 0 : frasesSugeridas!.hashCode) +
    (topePorcentaje == null ? 0 : topePorcentaje!.hashCode) +
    (topeFijoPorcentaje == null ? 0 : topeFijoPorcentaje!.hashCode) +
    (pisoAprobacion == null ? 0 : pisoAprobacion!.hashCode) +
    (visitaMaxima == null ? 0 : visitaMaxima!.hashCode) +
    (activo == null ? 0 : activo!.hashCode) +
    (changedFields.hashCode);

  @override
  String toString() => 'UpdateTradeBody[clave=$clave, nombre=$nombre, modalidad=$modalidad, frasesSugeridas=$frasesSugeridas, topePorcentaje=$topePorcentaje, topeFijoPorcentaje=$topeFijoPorcentaje, pisoAprobacion=$pisoAprobacion, visitaMaxima=$visitaMaxima, activo=$activo, changedFields=$changedFields]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.clave != null) {
      json[r'clave'] = this.clave;
    } else {
      json[r'clave'] = null;
    }
    if (this.nombre != null) {
      json[r'nombre'] = this.nombre;
    } else {
      json[r'nombre'] = null;
    }
    if (this.modalidad != null) {
      json[r'modalidad'] = this.modalidad;
    } else {
      json[r'modalidad'] = null;
    }
    if (this.frasesSugeridas != null) {
      json[r'frasesSugeridas'] = this.frasesSugeridas;
    } else {
      json[r'frasesSugeridas'] = null;
    }
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
    if (this.activo != null) {
      json[r'activo'] = this.activo;
    } else {
      json[r'activo'] = null;
    }
      json[r'changedFields'] = this.changedFields;
    return json;
  }

  /// Returns a new [UpdateTradeBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static UpdateTradeBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'clave'), 'Required key "UpdateTradeBody[clave]" is missing from JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "UpdateTradeBody[nombre]" is missing from JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "UpdateTradeBody[modalidad]" is missing from JSON.');
        assert(json.containsKey(r'frasesSugeridas'), 'Required key "UpdateTradeBody[frasesSugeridas]" is missing from JSON.');
        assert(json.containsKey(r'topePorcentaje'), 'Required key "UpdateTradeBody[topePorcentaje]" is missing from JSON.');
        assert(json.containsKey(r'topeFijoPorcentaje'), 'Required key "UpdateTradeBody[topeFijoPorcentaje]" is missing from JSON.');
        assert(json.containsKey(r'pisoAprobacion'), 'Required key "UpdateTradeBody[pisoAprobacion]" is missing from JSON.');
        assert(json.containsKey(r'visitaMaxima'), 'Required key "UpdateTradeBody[visitaMaxima]" is missing from JSON.');
        assert(json.containsKey(r'activo'), 'Required key "UpdateTradeBody[activo]" is missing from JSON.');
        return true;
      }());

      return UpdateTradeBody(
        clave: mapValueOfType<String>(json, r'clave'),
        nombre: mapValueOfType<String>(json, r'nombre'),
        modalidad: mapValueOfType<String>(json, r'modalidad'),
        frasesSugeridas: json[r'frasesSugeridas'] is Iterable
            ? (json[r'frasesSugeridas'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        topePorcentaje: mapValueOfType<double>(json, r'topePorcentaje'),
        topeFijoPorcentaje: mapValueOfType<double>(json, r'topeFijoPorcentaje'),
        pisoAprobacion: mapValueOfType<int>(json, r'pisoAprobacion'),
        visitaMaxima: mapValueOfType<int>(json, r'visitaMaxima'),
        activo: mapValueOfType<bool>(json, r'activo'),
        changedFields: json[r'changedFields'] is Iterable
            ? (json[r'changedFields'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<UpdateTradeBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateTradeBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateTradeBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateTradeBody> mapFromJson(dynamic json) {
    final map = <String, UpdateTradeBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = UpdateTradeBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateTradeBody-objects as value to a dart map
  static Map<String, List<UpdateTradeBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateTradeBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateTradeBody.listFromJson(entry.value, growable: growable,);
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

