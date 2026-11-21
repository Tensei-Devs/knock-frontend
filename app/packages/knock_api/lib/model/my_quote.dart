//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class MyQuote {
  /// Returns a new [MyQuote] instance.
  MyQuote({
    required this.id,
    required this.solicitudId,
    required this.estado,
    required this.tipoPrecio,
    required this.precio,
    required this.precioMin,
    required this.precioMax,
    required this.tope,
    required this.dia,
    required this.hora,
    required this.creadoEn,
  });

  String id;

  String solicitudId;

  String estado;

  String tipoPrecio;

  int? precio;

  int? precioMin;

  int? precioMax;

  int tope;

  String dia;

  String hora;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MyQuote &&
    other.id == id &&
    other.solicitudId == solicitudId &&
    other.estado == estado &&
    other.tipoPrecio == tipoPrecio &&
    other.precio == precio &&
    other.precioMin == precioMin &&
    other.precioMax == precioMax &&
    other.tope == tope &&
    other.dia == dia &&
    other.hora == hora &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (solicitudId.hashCode) +
    (estado.hashCode) +
    (tipoPrecio.hashCode) +
    (precio == null ? 0 : precio!.hashCode) +
    (precioMin == null ? 0 : precioMin!.hashCode) +
    (precioMax == null ? 0 : precioMax!.hashCode) +
    (tope.hashCode) +
    (dia.hashCode) +
    (hora.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'MyQuote[id=$id, solicitudId=$solicitudId, estado=$estado, tipoPrecio=$tipoPrecio, precio=$precio, precioMin=$precioMin, precioMax=$precioMax, tope=$tope, dia=$dia, hora=$hora, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'solicitudId'] = this.solicitudId;
      json[r'estado'] = this.estado;
      json[r'tipoPrecio'] = this.tipoPrecio;
    if (this.precio != null) {
      json[r'precio'] = this.precio;
    } else {
      json[r'precio'] = null;
    }
    if (this.precioMin != null) {
      json[r'precioMin'] = this.precioMin;
    } else {
      json[r'precioMin'] = null;
    }
    if (this.precioMax != null) {
      json[r'precioMax'] = this.precioMax;
    } else {
      json[r'precioMax'] = null;
    }
      json[r'tope'] = this.tope;
      json[r'dia'] = this.dia;
      json[r'hora'] = this.hora;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [MyQuote] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static MyQuote? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "MyQuote[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "MyQuote[id]" has a null value in JSON.');
        assert(json.containsKey(r'solicitudId'), 'Required key "MyQuote[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "MyQuote[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "MyQuote[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "MyQuote[estado]" has a null value in JSON.');
        assert(json.containsKey(r'tipoPrecio'), 'Required key "MyQuote[tipoPrecio]" is missing from JSON.');
        assert(json[r'tipoPrecio'] != null, 'Required key "MyQuote[tipoPrecio]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "MyQuote[precio]" is missing from JSON.');
        assert(json.containsKey(r'precioMin'), 'Required key "MyQuote[precioMin]" is missing from JSON.');
        assert(json.containsKey(r'precioMax'), 'Required key "MyQuote[precioMax]" is missing from JSON.');
        assert(json.containsKey(r'tope'), 'Required key "MyQuote[tope]" is missing from JSON.');
        assert(json[r'tope'] != null, 'Required key "MyQuote[tope]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "MyQuote[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "MyQuote[dia]" has a null value in JSON.');
        assert(json.containsKey(r'hora'), 'Required key "MyQuote[hora]" is missing from JSON.');
        assert(json[r'hora'] != null, 'Required key "MyQuote[hora]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "MyQuote[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "MyQuote[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return MyQuote(
        id: mapValueOfType<String>(json, r'id')!,
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        tipoPrecio: mapValueOfType<String>(json, r'tipoPrecio')!,
        precio: mapValueOfType<int>(json, r'precio'),
        precioMin: mapValueOfType<int>(json, r'precioMin'),
        precioMax: mapValueOfType<int>(json, r'precioMax'),
        tope: mapValueOfType<int>(json, r'tope')!,
        dia: mapValueOfType<String>(json, r'dia')!,
        hora: mapValueOfType<String>(json, r'hora')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<MyQuote> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MyQuote>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MyQuote.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MyQuote> mapFromJson(dynamic json) {
    final map = <String, MyQuote>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = MyQuote.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MyQuote-objects as value to a dart map
  static Map<String, List<MyQuote>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MyQuote>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MyQuote.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'solicitudId',
    'estado',
    'tipoPrecio',
    'precio',
    'precioMin',
    'precioMax',
    'tope',
    'dia',
    'hora',
    'creadoEn',
  };
}

