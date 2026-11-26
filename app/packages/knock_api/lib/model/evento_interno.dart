//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class EventoInterno {
  /// Returns a new [EventoInterno] instance.
  EventoInterno({
    required this.eventoId,
    required this.tipo,
    required this.solicitudId,
    required this.tecnicoUsuarioId,
  });

  String? eventoId;

  String? tipo;

  String? solicitudId;

  String? tecnicoUsuarioId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EventoInterno &&
    other.eventoId == eventoId &&
    other.tipo == tipo &&
    other.solicitudId == solicitudId &&
    other.tecnicoUsuarioId == tecnicoUsuarioId;

  @override
  int get hashCode =>
    (eventoId == null ? 0 : eventoId!.hashCode) +
    (tipo == null ? 0 : tipo!.hashCode) +
    (solicitudId == null ? 0 : solicitudId!.hashCode) +
    (tecnicoUsuarioId == null ? 0 : tecnicoUsuarioId!.hashCode);

  @override
  String toString() => 'EventoInterno[eventoId=$eventoId, tipo=$tipo, solicitudId=$solicitudId, tecnicoUsuarioId=$tecnicoUsuarioId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.eventoId != null) {
      json[r'eventoId'] = this.eventoId;
    } else {
      json[r'eventoId'] = null;
    }
    if (this.tipo != null) {
      json[r'tipo'] = this.tipo;
    } else {
      json[r'tipo'] = null;
    }
    if (this.solicitudId != null) {
      json[r'solicitudId'] = this.solicitudId;
    } else {
      json[r'solicitudId'] = null;
    }
    if (this.tecnicoUsuarioId != null) {
      json[r'tecnicoUsuarioId'] = this.tecnicoUsuarioId;
    } else {
      json[r'tecnicoUsuarioId'] = null;
    }
    return json;
  }

  /// Returns a new [EventoInterno] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static EventoInterno? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'eventoId'), 'Required key "EventoInterno[eventoId]" is missing from JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "EventoInterno[tipo]" is missing from JSON.');
        assert(json.containsKey(r'solicitudId'), 'Required key "EventoInterno[solicitudId]" is missing from JSON.');
        assert(json.containsKey(r'tecnicoUsuarioId'), 'Required key "EventoInterno[tecnicoUsuarioId]" is missing from JSON.');
        return true;
      }());

      return EventoInterno(
        eventoId: mapValueOfType<String>(json, r'eventoId'),
        tipo: mapValueOfType<String>(json, r'tipo'),
        solicitudId: mapValueOfType<String>(json, r'solicitudId'),
        tecnicoUsuarioId: mapValueOfType<String>(json, r'tecnicoUsuarioId'),
      );
    }
    return null;
  }

  static List<EventoInterno> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EventoInterno>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EventoInterno.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EventoInterno> mapFromJson(dynamic json) {
    final map = <String, EventoInterno>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = EventoInterno.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EventoInterno-objects as value to a dart map
  static Map<String, List<EventoInterno>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EventoInterno>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EventoInterno.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'eventoId',
    'tipo',
    'solicitudId',
    'tecnicoUsuarioId',
  };
}

