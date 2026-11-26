//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AgendaItem {
  /// Returns a new [AgendaItem] instance.
  AgendaItem({
    required this.id,
    required this.estado,
    required this.modalidad,
    required this.fechaHora,
    required this.dia,
    required this.hora,
    required this.precio,
  });

  String id;

  String estado;

  String modalidad;

  DateTime fechaHora;

  String dia;

  String hora;

  int? precio;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AgendaItem &&
    other.id == id &&
    other.estado == estado &&
    other.modalidad == modalidad &&
    other.fechaHora == fechaHora &&
    other.dia == dia &&
    other.hora == hora &&
    other.precio == precio;

  @override
  int get hashCode =>
    (id.hashCode) +
    (estado.hashCode) +
    (modalidad.hashCode) +
    (fechaHora.hashCode) +
    (dia.hashCode) +
    (hora.hashCode) +
    (precio == null ? 0 : precio!.hashCode);

  @override
  String toString() => 'AgendaItem[id=$id, estado=$estado, modalidad=$modalidad, fechaHora=$fechaHora, dia=$dia, hora=$hora, precio=$precio]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'estado'] = this.estado;
      json[r'modalidad'] = this.modalidad;
      json[r'fechaHora'] = this.fechaHora.toUtc().toIso8601String();
      json[r'dia'] = this.dia;
      json[r'hora'] = this.hora;
    if (this.precio != null) {
      json[r'precio'] = this.precio;
    } else {
      json[r'precio'] = null;
    }
    return json;
  }

  /// Returns a new [AgendaItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AgendaItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "AgendaItem[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "AgendaItem[id]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "AgendaItem[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "AgendaItem[estado]" has a null value in JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "AgendaItem[modalidad]" is missing from JSON.');
        assert(json[r'modalidad'] != null, 'Required key "AgendaItem[modalidad]" has a null value in JSON.');
        assert(json.containsKey(r'fechaHora'), 'Required key "AgendaItem[fechaHora]" is missing from JSON.');
        assert(json[r'fechaHora'] != null, 'Required key "AgendaItem[fechaHora]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "AgendaItem[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "AgendaItem[dia]" has a null value in JSON.');
        assert(json.containsKey(r'hora'), 'Required key "AgendaItem[hora]" is missing from JSON.');
        assert(json[r'hora'] != null, 'Required key "AgendaItem[hora]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "AgendaItem[precio]" is missing from JSON.');
        return true;
      }());

      return AgendaItem(
        id: mapValueOfType<String>(json, r'id')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        modalidad: mapValueOfType<String>(json, r'modalidad')!,
        fechaHora: mapDateTime(json, r'fechaHora', r'')!,
        dia: mapValueOfType<String>(json, r'dia')!,
        hora: mapValueOfType<String>(json, r'hora')!,
        precio: mapValueOfType<int>(json, r'precio'),
      );
    }
    return null;
  }

  static List<AgendaItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AgendaItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AgendaItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AgendaItem> mapFromJson(dynamic json) {
    final map = <String, AgendaItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AgendaItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AgendaItem-objects as value to a dart map
  static Map<String, List<AgendaItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AgendaItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AgendaItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'estado',
    'modalidad',
    'fechaHora',
    'dia',
    'hora',
    'precio',
  };
}

