//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReportQueueItem {
  /// Returns a new [ReportQueueItem] instance.
  ReportQueueItem({
    required this.id,
    required this.motivo,
    required this.descripcion,
    required this.gravedad,
    required this.estado,
    required this.creadoEn,
    this.prioridad,
  });

  String id;

  String motivo;

  String descripcion;

  String? gravedad;

  String estado;

  DateTime creadoEn;

  String? prioridad;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportQueueItem &&
    other.id == id &&
    other.motivo == motivo &&
    other.descripcion == descripcion &&
    other.gravedad == gravedad &&
    other.estado == estado &&
    other.creadoEn == creadoEn &&
    other.prioridad == prioridad;

  @override
  int get hashCode =>
    (id.hashCode) +
    (motivo.hashCode) +
    (descripcion.hashCode) +
    (gravedad == null ? 0 : gravedad!.hashCode) +
    (estado.hashCode) +
    (creadoEn.hashCode) +
    (prioridad == null ? 0 : prioridad!.hashCode);

  @override
  String toString() => 'ReportQueueItem[id=$id, motivo=$motivo, descripcion=$descripcion, gravedad=$gravedad, estado=$estado, creadoEn=$creadoEn, prioridad=$prioridad]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'motivo'] = this.motivo;
      json[r'descripcion'] = this.descripcion;
    if (this.gravedad != null) {
      json[r'gravedad'] = this.gravedad;
    } else {
      json[r'gravedad'] = null;
    }
      json[r'estado'] = this.estado;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    if (this.prioridad != null) {
      json[r'prioridad'] = this.prioridad;
    } else {
      json[r'prioridad'] = null;
    }
    return json;
  }

  /// Returns a new [ReportQueueItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReportQueueItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ReportQueueItem[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ReportQueueItem[id]" has a null value in JSON.');
        assert(json.containsKey(r'motivo'), 'Required key "ReportQueueItem[motivo]" is missing from JSON.');
        assert(json[r'motivo'] != null, 'Required key "ReportQueueItem[motivo]" has a null value in JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "ReportQueueItem[descripcion]" is missing from JSON.');
        assert(json[r'descripcion'] != null, 'Required key "ReportQueueItem[descripcion]" has a null value in JSON.');
        assert(json.containsKey(r'gravedad'), 'Required key "ReportQueueItem[gravedad]" is missing from JSON.');
        assert(json.containsKey(r'estado'), 'Required key "ReportQueueItem[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "ReportQueueItem[estado]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "ReportQueueItem[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "ReportQueueItem[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return ReportQueueItem(
        id: mapValueOfType<String>(json, r'id')!,
        motivo: mapValueOfType<String>(json, r'motivo')!,
        descripcion: mapValueOfType<String>(json, r'descripcion')!,
        gravedad: mapValueOfType<String>(json, r'gravedad'),
        estado: mapValueOfType<String>(json, r'estado')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
        prioridad: mapValueOfType<String>(json, r'prioridad'),
      );
    }
    return null;
  }

  static List<ReportQueueItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportQueueItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportQueueItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportQueueItem> mapFromJson(dynamic json) {
    final map = <String, ReportQueueItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReportQueueItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportQueueItem-objects as value to a dart map
  static Map<String, List<ReportQueueItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportQueueItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportQueueItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'motivo',
    'descripcion',
    'gravedad',
    'estado',
    'creadoEn',
  };
}

