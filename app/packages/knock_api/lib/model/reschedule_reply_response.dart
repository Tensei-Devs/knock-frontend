//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RescheduleReplyResponse {
  /// Returns a new [RescheduleReplyResponse] instance.
  RescheduleReplyResponse({
    required this.visitaId,
    required this.aceptada,
    required this.fechaHora,
    required this.reprogramaciones,
  });

  String visitaId;

  bool aceptada;

  DateTime fechaHora;

  int reprogramaciones;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RescheduleReplyResponse &&
    other.visitaId == visitaId &&
    other.aceptada == aceptada &&
    other.fechaHora == fechaHora &&
    other.reprogramaciones == reprogramaciones;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (aceptada.hashCode) +
    (fechaHora.hashCode) +
    (reprogramaciones.hashCode);

  @override
  String toString() => 'RescheduleReplyResponse[visitaId=$visitaId, aceptada=$aceptada, fechaHora=$fechaHora, reprogramaciones=$reprogramaciones]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'aceptada'] = this.aceptada;
      json[r'fechaHora'] = this.fechaHora.toUtc().toIso8601String();
      json[r'reprogramaciones'] = this.reprogramaciones;
    return json;
  }

  /// Returns a new [RescheduleReplyResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RescheduleReplyResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "RescheduleReplyResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "RescheduleReplyResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'aceptada'), 'Required key "RescheduleReplyResponse[aceptada]" is missing from JSON.');
        assert(json[r'aceptada'] != null, 'Required key "RescheduleReplyResponse[aceptada]" has a null value in JSON.');
        assert(json.containsKey(r'fechaHora'), 'Required key "RescheduleReplyResponse[fechaHora]" is missing from JSON.');
        assert(json[r'fechaHora'] != null, 'Required key "RescheduleReplyResponse[fechaHora]" has a null value in JSON.');
        assert(json.containsKey(r'reprogramaciones'), 'Required key "RescheduleReplyResponse[reprogramaciones]" is missing from JSON.');
        assert(json[r'reprogramaciones'] != null, 'Required key "RescheduleReplyResponse[reprogramaciones]" has a null value in JSON.');
        return true;
      }());

      return RescheduleReplyResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        aceptada: mapValueOfType<bool>(json, r'aceptada')!,
        fechaHora: mapDateTime(json, r'fechaHora', r'')!,
        reprogramaciones: mapValueOfType<int>(json, r'reprogramaciones')!,
      );
    }
    return null;
  }

  static List<RescheduleReplyResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RescheduleReplyResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RescheduleReplyResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RescheduleReplyResponse> mapFromJson(dynamic json) {
    final map = <String, RescheduleReplyResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RescheduleReplyResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RescheduleReplyResponse-objects as value to a dart map
  static Map<String, List<RescheduleReplyResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RescheduleReplyResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RescheduleReplyResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'aceptada',
    'fechaHora',
    'reprogramaciones',
  };
}

