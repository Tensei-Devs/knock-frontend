//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class BusquedaInterpretacion {
  /// Returns a new [BusquedaInterpretacion] instance.
  BusquedaInterpretacion({
    required this.estado,
    required this.oficioDetectado,
    this.oficiosSugeridos = const [],
  });

  String estado;

  BusquedaOficio? oficioDetectado;

  List<BusquedaOficio>? oficiosSugeridos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusquedaInterpretacion &&
    other.estado == estado &&
    other.oficioDetectado == oficioDetectado &&
    _deepEquality.equals(other.oficiosSugeridos, oficiosSugeridos);

  @override
  int get hashCode =>
    (estado.hashCode) +
    (oficioDetectado == null ? 0 : oficioDetectado!.hashCode) +
    (oficiosSugeridos == null ? 0 : oficiosSugeridos!.hashCode);

  @override
  String toString() => 'BusquedaInterpretacion[estado=$estado, oficioDetectado=$oficioDetectado, oficiosSugeridos=$oficiosSugeridos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'estado'] = this.estado;
    if (this.oficioDetectado != null) {
      json[r'oficioDetectado'] = this.oficioDetectado;
    } else {
      json[r'oficioDetectado'] = null;
    }
    if (this.oficiosSugeridos != null) {
      json[r'oficiosSugeridos'] = this.oficiosSugeridos;
    } else {
      json[r'oficiosSugeridos'] = null;
    }
    return json;
  }

  /// Returns a new [BusquedaInterpretacion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static BusquedaInterpretacion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'estado'), 'Required key "BusquedaInterpretacion[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "BusquedaInterpretacion[estado]" has a null value in JSON.');
        assert(json.containsKey(r'oficioDetectado'), 'Required key "BusquedaInterpretacion[oficioDetectado]" is missing from JSON.');
        assert(json.containsKey(r'oficiosSugeridos'), 'Required key "BusquedaInterpretacion[oficiosSugeridos]" is missing from JSON.');
        return true;
      }());

      return BusquedaInterpretacion(
        estado: mapValueOfType<String>(json, r'estado')!,
        oficioDetectado: BusquedaOficio.fromJson(json[r'oficioDetectado']),
        oficiosSugeridos: BusquedaOficio.listFromJson(json[r'oficiosSugeridos']),
      );
    }
    return null;
  }

  static List<BusquedaInterpretacion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BusquedaInterpretacion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BusquedaInterpretacion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BusquedaInterpretacion> mapFromJson(dynamic json) {
    final map = <String, BusquedaInterpretacion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = BusquedaInterpretacion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BusquedaInterpretacion-objects as value to a dart map
  static Map<String, List<BusquedaInterpretacion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BusquedaInterpretacion>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BusquedaInterpretacion.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'estado',
    'oficioDetectado',
    'oficiosSugeridos',
  };
}

