//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class FinalQuoteReadResponse {
  /// Returns a new [FinalQuoteReadResponse] instance.
  FinalQuoteReadResponse({
    required this.visitaId,
    required this.precio,
    required this.descripcion,
    required this.estado,
    required this.venceEn,
    required this.decididaEn,
  });

  String visitaId;

  int precio;

  String descripcion;

  String estado;

  DateTime venceEn;

  DateTime? decididaEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FinalQuoteReadResponse &&
    other.visitaId == visitaId &&
    other.precio == precio &&
    other.descripcion == descripcion &&
    other.estado == estado &&
    other.venceEn == venceEn &&
    other.decididaEn == decididaEn;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (precio.hashCode) +
    (descripcion.hashCode) +
    (estado.hashCode) +
    (venceEn.hashCode) +
    (decididaEn == null ? 0 : decididaEn!.hashCode);

  @override
  String toString() => 'FinalQuoteReadResponse[visitaId=$visitaId, precio=$precio, descripcion=$descripcion, estado=$estado, venceEn=$venceEn, decididaEn=$decididaEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'precio'] = this.precio;
      json[r'descripcion'] = this.descripcion;
      json[r'estado'] = this.estado;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
    if (this.decididaEn != null) {
      json[r'decididaEn'] = this.decididaEn!.toUtc().toIso8601String();
    } else {
      json[r'decididaEn'] = null;
    }
    return json;
  }

  /// Returns a new [FinalQuoteReadResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static FinalQuoteReadResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "FinalQuoteReadResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "FinalQuoteReadResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "FinalQuoteReadResponse[precio]" is missing from JSON.');
        assert(json[r'precio'] != null, 'Required key "FinalQuoteReadResponse[precio]" has a null value in JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "FinalQuoteReadResponse[descripcion]" is missing from JSON.');
        assert(json[r'descripcion'] != null, 'Required key "FinalQuoteReadResponse[descripcion]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "FinalQuoteReadResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "FinalQuoteReadResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "FinalQuoteReadResponse[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "FinalQuoteReadResponse[venceEn]" has a null value in JSON.');
        assert(json.containsKey(r'decididaEn'), 'Required key "FinalQuoteReadResponse[decididaEn]" is missing from JSON.');
        return true;
      }());

      return FinalQuoteReadResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        precio: mapValueOfType<int>(json, r'precio')!,
        descripcion: mapValueOfType<String>(json, r'descripcion')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
        decididaEn: mapDateTime(json, r'decididaEn', r''),
      );
    }
    return null;
  }

  static List<FinalQuoteReadResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FinalQuoteReadResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FinalQuoteReadResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FinalQuoteReadResponse> mapFromJson(dynamic json) {
    final map = <String, FinalQuoteReadResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = FinalQuoteReadResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FinalQuoteReadResponse-objects as value to a dart map
  static Map<String, List<FinalQuoteReadResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FinalQuoteReadResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FinalQuoteReadResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'precio',
    'descripcion',
    'estado',
    'venceEn',
    'decididaEn',
  };
}

