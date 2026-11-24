//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NotFinishedReportEventBody {
  /// Returns a new [NotFinishedReportEventBody] instance.
  NotFinishedReportEventBody({
    required this.eventoId,
    required this.tipo,
    required this.visitaId,
    required this.clienteId,
    required this.tecnicoUsuarioId,
  });

  String? eventoId;

  String? tipo;

  String? visitaId;

  String? clienteId;

  String? tecnicoUsuarioId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotFinishedReportEventBody &&
    other.eventoId == eventoId &&
    other.tipo == tipo &&
    other.visitaId == visitaId &&
    other.clienteId == clienteId &&
    other.tecnicoUsuarioId == tecnicoUsuarioId;

  @override
  int get hashCode =>
    (eventoId == null ? 0 : eventoId!.hashCode) +
    (tipo == null ? 0 : tipo!.hashCode) +
    (visitaId == null ? 0 : visitaId!.hashCode) +
    (clienteId == null ? 0 : clienteId!.hashCode) +
    (tecnicoUsuarioId == null ? 0 : tecnicoUsuarioId!.hashCode);

  @override
  String toString() => 'NotFinishedReportEventBody[eventoId=$eventoId, tipo=$tipo, visitaId=$visitaId, clienteId=$clienteId, tecnicoUsuarioId=$tecnicoUsuarioId]';

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
    if (this.visitaId != null) {
      json[r'visitaId'] = this.visitaId;
    } else {
      json[r'visitaId'] = null;
    }
    if (this.clienteId != null) {
      json[r'clienteId'] = this.clienteId;
    } else {
      json[r'clienteId'] = null;
    }
    if (this.tecnicoUsuarioId != null) {
      json[r'tecnicoUsuarioId'] = this.tecnicoUsuarioId;
    } else {
      json[r'tecnicoUsuarioId'] = null;
    }
    return json;
  }

  /// Returns a new [NotFinishedReportEventBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NotFinishedReportEventBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'eventoId'), 'Required key "NotFinishedReportEventBody[eventoId]" is missing from JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "NotFinishedReportEventBody[tipo]" is missing from JSON.');
        assert(json.containsKey(r'visitaId'), 'Required key "NotFinishedReportEventBody[visitaId]" is missing from JSON.');
        assert(json.containsKey(r'clienteId'), 'Required key "NotFinishedReportEventBody[clienteId]" is missing from JSON.');
        assert(json.containsKey(r'tecnicoUsuarioId'), 'Required key "NotFinishedReportEventBody[tecnicoUsuarioId]" is missing from JSON.');
        return true;
      }());

      return NotFinishedReportEventBody(
        eventoId: mapValueOfType<String>(json, r'eventoId'),
        tipo: mapValueOfType<String>(json, r'tipo'),
        visitaId: mapValueOfType<String>(json, r'visitaId'),
        clienteId: mapValueOfType<String>(json, r'clienteId'),
        tecnicoUsuarioId: mapValueOfType<String>(json, r'tecnicoUsuarioId'),
      );
    }
    return null;
  }

  static List<NotFinishedReportEventBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotFinishedReportEventBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotFinishedReportEventBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotFinishedReportEventBody> mapFromJson(dynamic json) {
    final map = <String, NotFinishedReportEventBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NotFinishedReportEventBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotFinishedReportEventBody-objects as value to a dart map
  static Map<String, List<NotFinishedReportEventBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotFinishedReportEventBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotFinishedReportEventBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'eventoId',
    'tipo',
    'visitaId',
    'clienteId',
    'tecnicoUsuarioId',
  };
}

