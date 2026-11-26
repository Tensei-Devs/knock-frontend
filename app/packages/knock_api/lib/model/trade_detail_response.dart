//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TradeDetailResponse {
  /// Returns a new [TradeDetailResponse] instance.
  TradeDetailResponse({
    required this.clave,
    required this.nombre,
    required this.modalidad,
    this.frasesSugeridas = const [],
  });

  /// Clave estable del catálogo.
  String clave;

  /// Nombre para mostrar.
  String nombre;

  /// `domicilio`, `taller` o `ambos`: decide si la app pide dirección y código de visita.
  String modalidad;

  /// Frases de ejemplo para describir el problema; vacía si el oficio no tiene.
  List<String> frasesSugeridas;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TradeDetailResponse &&
    other.clave == clave &&
    other.nombre == nombre &&
    other.modalidad == modalidad &&
    _deepEquality.equals(other.frasesSugeridas, frasesSugeridas);

  @override
  int get hashCode =>
    (clave.hashCode) +
    (nombre.hashCode) +
    (modalidad.hashCode) +
    (frasesSugeridas.hashCode);

  @override
  String toString() => 'TradeDetailResponse[clave=$clave, nombre=$nombre, modalidad=$modalidad, frasesSugeridas=$frasesSugeridas]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'clave'] = this.clave;
      json[r'nombre'] = this.nombre;
      json[r'modalidad'] = this.modalidad;
      json[r'frasesSugeridas'] = this.frasesSugeridas;
    return json;
  }

  /// Returns a new [TradeDetailResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TradeDetailResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'clave'), 'Required key "TradeDetailResponse[clave]" is missing from JSON.');
        assert(json[r'clave'] != null, 'Required key "TradeDetailResponse[clave]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "TradeDetailResponse[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "TradeDetailResponse[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "TradeDetailResponse[modalidad]" is missing from JSON.');
        assert(json[r'modalidad'] != null, 'Required key "TradeDetailResponse[modalidad]" has a null value in JSON.');
        assert(json.containsKey(r'frasesSugeridas'), 'Required key "TradeDetailResponse[frasesSugeridas]" is missing from JSON.');
        assert(json[r'frasesSugeridas'] != null, 'Required key "TradeDetailResponse[frasesSugeridas]" has a null value in JSON.');
        return true;
      }());

      return TradeDetailResponse(
        clave: mapValueOfType<String>(json, r'clave')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        modalidad: mapValueOfType<String>(json, r'modalidad')!,
        frasesSugeridas: json[r'frasesSugeridas'] is Iterable
            ? (json[r'frasesSugeridas'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<TradeDetailResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TradeDetailResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TradeDetailResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TradeDetailResponse> mapFromJson(dynamic json) {
    final map = <String, TradeDetailResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TradeDetailResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TradeDetailResponse-objects as value to a dart map
  static Map<String, List<TradeDetailResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TradeDetailResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TradeDetailResponse.listFromJson(entry.value, growable: growable,);
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
  };
}

