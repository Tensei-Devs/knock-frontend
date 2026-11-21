//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrabajoFinishedItem {
  /// Returns a new [TrabajoFinishedItem] instance.
  TrabajoFinishedItem({
    required this.solicitudId,
    required this.oficioNombre,
    required this.terminadaEn,
    required this.precio,
    required this.calificacion,
  });

  String solicitudId;

  String oficioNombre;

  DateTime terminadaEn;

  int? precio;

  Object? calificacion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrabajoFinishedItem &&
    other.solicitudId == solicitudId &&
    other.oficioNombre == oficioNombre &&
    other.terminadaEn == terminadaEn &&
    other.precio == precio &&
    other.calificacion == calificacion;

  @override
  int get hashCode =>
    (solicitudId.hashCode) +
    (oficioNombre.hashCode) +
    (terminadaEn.hashCode) +
    (precio == null ? 0 : precio!.hashCode) +
    (calificacion == null ? 0 : calificacion!.hashCode);

  @override
  String toString() => 'TrabajoFinishedItem[solicitudId=$solicitudId, oficioNombre=$oficioNombre, terminadaEn=$terminadaEn, precio=$precio, calificacion=$calificacion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'solicitudId'] = this.solicitudId;
      json[r'oficioNombre'] = this.oficioNombre;
      json[r'terminadaEn'] = this.terminadaEn.toUtc().toIso8601String();
    if (this.precio != null) {
      json[r'precio'] = this.precio;
    } else {
      json[r'precio'] = null;
    }
    if (this.calificacion != null) {
      json[r'calificacion'] = this.calificacion;
    } else {
      json[r'calificacion'] = null;
    }
    return json;
  }

  /// Returns a new [TrabajoFinishedItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrabajoFinishedItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'solicitudId'), 'Required key "TrabajoFinishedItem[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "TrabajoFinishedItem[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'oficioNombre'), 'Required key "TrabajoFinishedItem[oficioNombre]" is missing from JSON.');
        assert(json[r'oficioNombre'] != null, 'Required key "TrabajoFinishedItem[oficioNombre]" has a null value in JSON.');
        assert(json.containsKey(r'terminadaEn'), 'Required key "TrabajoFinishedItem[terminadaEn]" is missing from JSON.');
        assert(json[r'terminadaEn'] != null, 'Required key "TrabajoFinishedItem[terminadaEn]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "TrabajoFinishedItem[precio]" is missing from JSON.');
        assert(json.containsKey(r'calificacion'), 'Required key "TrabajoFinishedItem[calificacion]" is missing from JSON.');
        return true;
      }());

      return TrabajoFinishedItem(
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        oficioNombre: mapValueOfType<String>(json, r'oficioNombre')!,
        terminadaEn: mapDateTime(json, r'terminadaEn', r'')!,
        precio: mapValueOfType<int>(json, r'precio'),
        calificacion: mapValueOfType<Object>(json, r'calificacion'),
      );
    }
    return null;
  }

  static List<TrabajoFinishedItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrabajoFinishedItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrabajoFinishedItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrabajoFinishedItem> mapFromJson(dynamic json) {
    final map = <String, TrabajoFinishedItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrabajoFinishedItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrabajoFinishedItem-objects as value to a dart map
  static Map<String, List<TrabajoFinishedItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrabajoFinishedItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrabajoFinishedItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'solicitudId',
    'oficioNombre',
    'terminadaEn',
    'precio',
    'calificacion',
  };
}

