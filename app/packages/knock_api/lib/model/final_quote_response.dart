//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class FinalQuoteResponse {
  /// Returns a new [FinalQuoteResponse] instance.
  FinalQuoteResponse({
    required this.visitaId,
    required this.precio,
    required this.estado,
    required this.venceEn,
  });

  String visitaId;

  int precio;

  String estado;

  DateTime venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FinalQuoteResponse &&
    other.visitaId == visitaId &&
    other.precio == precio &&
    other.estado == estado &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (precio.hashCode) +
    (estado.hashCode) +
    (venceEn.hashCode);

  @override
  String toString() => 'FinalQuoteResponse[visitaId=$visitaId, precio=$precio, estado=$estado, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'precio'] = this.precio;
      json[r'estado'] = this.estado;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [FinalQuoteResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static FinalQuoteResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "FinalQuoteResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "FinalQuoteResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "FinalQuoteResponse[precio]" is missing from JSON.');
        assert(json[r'precio'] != null, 'Required key "FinalQuoteResponse[precio]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "FinalQuoteResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "FinalQuoteResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "FinalQuoteResponse[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "FinalQuoteResponse[venceEn]" has a null value in JSON.');
        return true;
      }());

      return FinalQuoteResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        precio: mapValueOfType<int>(json, r'precio')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
      );
    }
    return null;
  }

  static List<FinalQuoteResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FinalQuoteResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FinalQuoteResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FinalQuoteResponse> mapFromJson(dynamic json) {
    final map = <String, FinalQuoteResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = FinalQuoteResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FinalQuoteResponse-objects as value to a dart map
  static Map<String, List<FinalQuoteResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FinalQuoteResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FinalQuoteResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'precio',
    'estado',
    'venceEn',
  };
}

