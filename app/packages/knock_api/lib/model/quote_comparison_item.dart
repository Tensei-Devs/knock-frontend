//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class QuoteComparisonItem {
  /// Returns a new [QuoteComparisonItem] instance.
  QuoteComparisonItem({
    required this.id,
    required this.estado,
    required this.tipoPrecio,
    required this.precio,
    required this.precioMin,
    required this.precioMax,
    required this.tope,
    required this.requiereAprobacion,
    required this.dia,
    required this.hora,
    required this.nota,
    required this.cubre,
    this.etiquetas = const [],
    required this.tecnico,
    required this.motivoRechazo,
  });

  String id;

  String estado;

  String tipoPrecio;

  int? precio;

  int? precioMin;

  int? precioMax;

  int tope;

  bool requiereAprobacion;

  String dia;

  String hora;

  String? nota;

  String cubre;

  List<String> etiquetas;

  QuoteTechnician tecnico;

  String? motivoRechazo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuoteComparisonItem &&
    other.id == id &&
    other.estado == estado &&
    other.tipoPrecio == tipoPrecio &&
    other.precio == precio &&
    other.precioMin == precioMin &&
    other.precioMax == precioMax &&
    other.tope == tope &&
    other.requiereAprobacion == requiereAprobacion &&
    other.dia == dia &&
    other.hora == hora &&
    other.nota == nota &&
    other.cubre == cubre &&
    _deepEquality.equals(other.etiquetas, etiquetas) &&
    other.tecnico == tecnico &&
    other.motivoRechazo == motivoRechazo;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (tipoPrecio.hashCode) +
    (precio == null ? 0 : precio!.hashCode) +
    (precioMin == null ? 0 : precioMin!.hashCode) +
    (precioMax == null ? 0 : precioMax!.hashCode) +
    (tope.hashCode) +
    (requiereAprobacion.hashCode) +
    (dia.hashCode) +
    (hora.hashCode) +
    (nota == null ? 0 : nota!.hashCode) +
    (cubre.hashCode) +
    (etiquetas.hashCode) +
    (tecnico.hashCode) +
    (motivoRechazo == null ? 0 : motivoRechazo!.hashCode);

  @override
  String toString() => 'QuoteComparisonItem[id=$id, estado=$estado, tipoPrecio=$tipoPrecio, precio=$precio, precioMin=$precioMin, precioMax=$precioMax, tope=$tope, requiereAprobacion=$requiereAprobacion, dia=$dia, hora=$hora, nota=$nota, cubre=$cubre, etiquetas=$etiquetas, tecnico=$tecnico, motivoRechazo=$motivoRechazo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
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
      json[r'requiereAprobacion'] = this.requiereAprobacion;
      json[r'dia'] = this.dia;
      json[r'hora'] = this.hora;
    if (this.nota != null) {
      json[r'nota'] = this.nota;
    } else {
      json[r'nota'] = null;
    }
      json[r'cubre'] = this.cubre;
      json[r'etiquetas'] = this.etiquetas;
      json[r'tecnico'] = this.tecnico;
    if (this.motivoRechazo != null) {
      json[r'motivoRechazo'] = this.motivoRechazo;
    } else {
      json[r'motivoRechazo'] = null;
    }
    return json;
  }

  /// Returns a new [QuoteComparisonItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static QuoteComparisonItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "QuoteComparisonItem[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "QuoteComparisonItem[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "QuoteComparisonItem[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "QuoteComparisonItem[estado]" has a null value in JSON.');
        assert(json.containsKey(r'tipoPrecio'), 'Required key "QuoteComparisonItem[tipoPrecio]" is missing from JSON.');
        assert(json[r'tipoPrecio'] != null, 'Required key "QuoteComparisonItem[tipoPrecio]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "QuoteComparisonItem[precio]" is missing from JSON.');
        assert(json.containsKey(r'precioMin'), 'Required key "QuoteComparisonItem[precioMin]" is missing from JSON.');
        assert(json.containsKey(r'precioMax'), 'Required key "QuoteComparisonItem[precioMax]" is missing from JSON.');
        assert(json.containsKey(r'tope'), 'Required key "QuoteComparisonItem[tope]" is missing from JSON.');
        assert(json[r'tope'] != null, 'Required key "QuoteComparisonItem[tope]" has a null value in JSON.');
        assert(json.containsKey(r'requiereAprobacion'), 'Required key "QuoteComparisonItem[requiereAprobacion]" is missing from JSON.');
        assert(json[r'requiereAprobacion'] != null, 'Required key "QuoteComparisonItem[requiereAprobacion]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "QuoteComparisonItem[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "QuoteComparisonItem[dia]" has a null value in JSON.');
        assert(json.containsKey(r'hora'), 'Required key "QuoteComparisonItem[hora]" is missing from JSON.');
        assert(json[r'hora'] != null, 'Required key "QuoteComparisonItem[hora]" has a null value in JSON.');
        assert(json.containsKey(r'nota'), 'Required key "QuoteComparisonItem[nota]" is missing from JSON.');
        assert(json.containsKey(r'cubre'), 'Required key "QuoteComparisonItem[cubre]" is missing from JSON.');
        assert(json[r'cubre'] != null, 'Required key "QuoteComparisonItem[cubre]" has a null value in JSON.');
        assert(json.containsKey(r'etiquetas'), 'Required key "QuoteComparisonItem[etiquetas]" is missing from JSON.');
        assert(json[r'etiquetas'] != null, 'Required key "QuoteComparisonItem[etiquetas]" has a null value in JSON.');
        assert(json.containsKey(r'tecnico'), 'Required key "QuoteComparisonItem[tecnico]" is missing from JSON.');
        assert(json[r'tecnico'] != null, 'Required key "QuoteComparisonItem[tecnico]" has a null value in JSON.');
        assert(json.containsKey(r'motivoRechazo'), 'Required key "QuoteComparisonItem[motivoRechazo]" is missing from JSON.');
        return true;
      }());

      return QuoteComparisonItem(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        tipoPrecio: mapValueOfType<String>(json, r'tipoPrecio')!,
        precio: mapValueOfType<int>(json, r'precio'),
        precioMin: mapValueOfType<int>(json, r'precioMin'),
        precioMax: mapValueOfType<int>(json, r'precioMax'),
        tope: mapValueOfType<int>(json, r'tope')!,
        requiereAprobacion: mapValueOfType<bool>(json, r'requiereAprobacion')!,
        dia: mapValueOfType<String>(json, r'dia')!,
        hora: mapValueOfType<String>(json, r'hora')!,
        nota: mapValueOfType<String>(json, r'nota'),
        cubre: mapValueOfType<String>(json, r'cubre')!,
        etiquetas: json[r'etiquetas'] is Iterable
            ? (json[r'etiquetas'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        tecnico: QuoteTechnician.fromJson(json[r'tecnico'])!,
        motivoRechazo: mapValueOfType<String>(json, r'motivoRechazo'),
      );
    }
    return null;
  }

  static List<QuoteComparisonItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuoteComparisonItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuoteComparisonItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuoteComparisonItem> mapFromJson(dynamic json) {
    final map = <String, QuoteComparisonItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = QuoteComparisonItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuoteComparisonItem-objects as value to a dart map
  static Map<String, List<QuoteComparisonItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuoteComparisonItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuoteComparisonItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'tipoPrecio',
    'precio',
    'precioMin',
    'precioMax',
    'tope',
    'requiereAprobacion',
    'dia',
    'hora',
    'nota',
    'cubre',
    'etiquetas',
    'tecnico',
    'motivoRechazo',
  };
}

