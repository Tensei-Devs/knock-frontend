//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class BusquedaItem {
  /// Returns a new [BusquedaItem] instance.
  BusquedaItem({
    required this.id,
    required this.nombre,
    this.oficios = const [],
    required this.calificacion,
    required this.totalResenas,
    required this.verificado,
    required this.nivelVerificacion,
    required this.coloniaBase,
    required this.distanciaKm,
    required this.atiendeTuColonia,
    required this.fotoUrl,
  });

  String id;

  String nombre;

  List<BusquedaOficio> oficios;

  double calificacion;

  int totalResenas;

  bool verificado;

  String nivelVerificacion;

  String? coloniaBase;

  int? distanciaKm;

  bool atiendeTuColonia;

  String? fotoUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusquedaItem &&
    other.id == id &&
    other.nombre == nombre &&
    _deepEquality.equals(other.oficios, oficios) &&
    other.calificacion == calificacion &&
    other.totalResenas == totalResenas &&
    other.verificado == verificado &&
    other.nivelVerificacion == nivelVerificacion &&
    other.coloniaBase == coloniaBase &&
    other.distanciaKm == distanciaKm &&
    other.atiendeTuColonia == atiendeTuColonia &&
    other.fotoUrl == fotoUrl;

  @override
  int get hashCode =>
    (id.hashCode) +
    (nombre.hashCode) +
    (oficios.hashCode) +
    (calificacion.hashCode) +
    (totalResenas.hashCode) +
    (verificado.hashCode) +
    (nivelVerificacion.hashCode) +
    (coloniaBase == null ? 0 : coloniaBase!.hashCode) +
    (distanciaKm == null ? 0 : distanciaKm!.hashCode) +
    (atiendeTuColonia.hashCode) +
    (fotoUrl == null ? 0 : fotoUrl!.hashCode);

  @override
  String toString() => 'BusquedaItem[id=$id, nombre=$nombre, oficios=$oficios, calificacion=$calificacion, totalResenas=$totalResenas, verificado=$verificado, nivelVerificacion=$nivelVerificacion, coloniaBase=$coloniaBase, distanciaKm=$distanciaKm, atiendeTuColonia=$atiendeTuColonia, fotoUrl=$fotoUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'nombre'] = this.nombre;
      json[r'oficios'] = this.oficios;
      json[r'calificacion'] = this.calificacion;
      json[r'totalResenas'] = this.totalResenas;
      json[r'verificado'] = this.verificado;
      json[r'nivelVerificacion'] = this.nivelVerificacion;
    if (this.coloniaBase != null) {
      json[r'coloniaBase'] = this.coloniaBase;
    } else {
      json[r'coloniaBase'] = null;
    }
    if (this.distanciaKm != null) {
      json[r'distanciaKm'] = this.distanciaKm;
    } else {
      json[r'distanciaKm'] = null;
    }
      json[r'atiendeTuColonia'] = this.atiendeTuColonia;
    if (this.fotoUrl != null) {
      json[r'fotoUrl'] = this.fotoUrl;
    } else {
      json[r'fotoUrl'] = null;
    }
    return json;
  }

  /// Returns a new [BusquedaItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static BusquedaItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "BusquedaItem[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "BusquedaItem[id]" has a null value in JSON.');
        assert(json.containsKey(r'nombre'), 'Required key "BusquedaItem[nombre]" is missing from JSON.');
        assert(json[r'nombre'] != null, 'Required key "BusquedaItem[nombre]" has a null value in JSON.');
        assert(json.containsKey(r'oficios'), 'Required key "BusquedaItem[oficios]" is missing from JSON.');
        assert(json[r'oficios'] != null, 'Required key "BusquedaItem[oficios]" has a null value in JSON.');
        assert(json.containsKey(r'calificacion'), 'Required key "BusquedaItem[calificacion]" is missing from JSON.');
        assert(json[r'calificacion'] != null, 'Required key "BusquedaItem[calificacion]" has a null value in JSON.');
        assert(json.containsKey(r'totalResenas'), 'Required key "BusquedaItem[totalResenas]" is missing from JSON.');
        assert(json[r'totalResenas'] != null, 'Required key "BusquedaItem[totalResenas]" has a null value in JSON.');
        assert(json.containsKey(r'verificado'), 'Required key "BusquedaItem[verificado]" is missing from JSON.');
        assert(json[r'verificado'] != null, 'Required key "BusquedaItem[verificado]" has a null value in JSON.');
        assert(json.containsKey(r'nivelVerificacion'), 'Required key "BusquedaItem[nivelVerificacion]" is missing from JSON.');
        assert(json[r'nivelVerificacion'] != null, 'Required key "BusquedaItem[nivelVerificacion]" has a null value in JSON.');
        assert(json.containsKey(r'coloniaBase'), 'Required key "BusquedaItem[coloniaBase]" is missing from JSON.');
        assert(json.containsKey(r'distanciaKm'), 'Required key "BusquedaItem[distanciaKm]" is missing from JSON.');
        assert(json.containsKey(r'atiendeTuColonia'), 'Required key "BusquedaItem[atiendeTuColonia]" is missing from JSON.');
        assert(json[r'atiendeTuColonia'] != null, 'Required key "BusquedaItem[atiendeTuColonia]" has a null value in JSON.');
        assert(json.containsKey(r'fotoUrl'), 'Required key "BusquedaItem[fotoUrl]" is missing from JSON.');
        return true;
      }());

      return BusquedaItem(
        id: mapValueOfType<String>(json, r'id')!,
        nombre: mapValueOfType<String>(json, r'nombre')!,
        oficios: BusquedaOficio.listFromJson(json[r'oficios']),
        calificacion: mapValueOfType<double>(json, r'calificacion')!,
        totalResenas: mapValueOfType<int>(json, r'totalResenas')!,
        verificado: mapValueOfType<bool>(json, r'verificado')!,
        nivelVerificacion: mapValueOfType<String>(json, r'nivelVerificacion')!,
        coloniaBase: mapValueOfType<String>(json, r'coloniaBase'),
        distanciaKm: mapValueOfType<int>(json, r'distanciaKm'),
        atiendeTuColonia: mapValueOfType<bool>(json, r'atiendeTuColonia')!,
        fotoUrl: mapValueOfType<String>(json, r'fotoUrl'),
      );
    }
    return null;
  }

  static List<BusquedaItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BusquedaItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BusquedaItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BusquedaItem> mapFromJson(dynamic json) {
    final map = <String, BusquedaItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = BusquedaItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BusquedaItem-objects as value to a dart map
  static Map<String, List<BusquedaItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BusquedaItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BusquedaItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'nombre',
    'oficios',
    'calificacion',
    'totalResenas',
    'verificado',
    'nivelVerificacion',
    'coloniaBase',
    'distanciaKm',
    'atiendeTuColonia',
    'fotoUrl',
  };
}

