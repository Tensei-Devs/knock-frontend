//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NotFinishedReportResponse {
  /// Returns a new [NotFinishedReportResponse] instance.
  NotFinishedReportResponse({
    required this.visitaId,
    required this.clienteId,
    required this.tecnicoUsuarioId,
    required this.texto,
    required this.creadoEn,
  });

  String visitaId;

  String clienteId;

  String tecnicoUsuarioId;

  String texto;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotFinishedReportResponse &&
    other.visitaId == visitaId &&
    other.clienteId == clienteId &&
    other.tecnicoUsuarioId == tecnicoUsuarioId &&
    other.texto == texto &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (clienteId.hashCode) +
    (tecnicoUsuarioId.hashCode) +
    (texto.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'NotFinishedReportResponse[visitaId=$visitaId, clienteId=$clienteId, tecnicoUsuarioId=$tecnicoUsuarioId, texto=$texto, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'clienteId'] = this.clienteId;
      json[r'tecnicoUsuarioId'] = this.tecnicoUsuarioId;
      json[r'texto'] = this.texto;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [NotFinishedReportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NotFinishedReportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "NotFinishedReportResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "NotFinishedReportResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'clienteId'), 'Required key "NotFinishedReportResponse[clienteId]" is missing from JSON.');
        assert(json[r'clienteId'] != null, 'Required key "NotFinishedReportResponse[clienteId]" has a null value in JSON.');
        assert(json.containsKey(r'tecnicoUsuarioId'), 'Required key "NotFinishedReportResponse[tecnicoUsuarioId]" is missing from JSON.');
        assert(json[r'tecnicoUsuarioId'] != null, 'Required key "NotFinishedReportResponse[tecnicoUsuarioId]" has a null value in JSON.');
        assert(json.containsKey(r'texto'), 'Required key "NotFinishedReportResponse[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "NotFinishedReportResponse[texto]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "NotFinishedReportResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "NotFinishedReportResponse[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return NotFinishedReportResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        clienteId: mapValueOfType<String>(json, r'clienteId')!,
        tecnicoUsuarioId: mapValueOfType<String>(json, r'tecnicoUsuarioId')!,
        texto: mapValueOfType<String>(json, r'texto')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<NotFinishedReportResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotFinishedReportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotFinishedReportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotFinishedReportResponse> mapFromJson(dynamic json) {
    final map = <String, NotFinishedReportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NotFinishedReportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotFinishedReportResponse-objects as value to a dart map
  static Map<String, List<NotFinishedReportResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotFinishedReportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotFinishedReportResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'clienteId',
    'tecnicoUsuarioId',
    'texto',
    'creadoEn',
  };
}

