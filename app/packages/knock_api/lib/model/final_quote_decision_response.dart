//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class FinalQuoteDecisionResponse {
  /// Returns a new [FinalQuoteDecisionResponse] instance.
  FinalQuoteDecisionResponse({
    required this.visitaId,
    required this.estado,
    required this.resultado,
  });

  String visitaId;

  String estado;

  String? resultado;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FinalQuoteDecisionResponse &&
    other.visitaId == visitaId &&
    other.estado == estado &&
    other.resultado == resultado;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (estado.hashCode) +
    (resultado == null ? 0 : resultado!.hashCode);

  @override
  String toString() => 'FinalQuoteDecisionResponse[visitaId=$visitaId, estado=$estado, resultado=$resultado]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'estado'] = this.estado;
    if (this.resultado != null) {
      json[r'resultado'] = this.resultado;
    } else {
      json[r'resultado'] = null;
    }
    return json;
  }

  /// Returns a new [FinalQuoteDecisionResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static FinalQuoteDecisionResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "FinalQuoteDecisionResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "FinalQuoteDecisionResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "FinalQuoteDecisionResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "FinalQuoteDecisionResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'resultado'), 'Required key "FinalQuoteDecisionResponse[resultado]" is missing from JSON.');
        return true;
      }());

      return FinalQuoteDecisionResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        resultado: mapValueOfType<String>(json, r'resultado'),
      );
    }
    return null;
  }

  static List<FinalQuoteDecisionResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FinalQuoteDecisionResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FinalQuoteDecisionResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FinalQuoteDecisionResponse> mapFromJson(dynamic json) {
    final map = <String, FinalQuoteDecisionResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = FinalQuoteDecisionResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FinalQuoteDecisionResponse-objects as value to a dart map
  static Map<String, List<FinalQuoteDecisionResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FinalQuoteDecisionResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FinalQuoteDecisionResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'estado',
    'resultado',
  };
}

