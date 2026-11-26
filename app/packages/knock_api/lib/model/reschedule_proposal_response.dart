//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class RescheduleProposalResponse {
  /// Returns a new [RescheduleProposalResponse] instance.
  RescheduleProposalResponse({
    required this.visitaId,
    required this.fechaHora,
    required this.propuestaPor,
    required this.venceEn,
  });

  String visitaId;

  DateTime fechaHora;

  String propuestaPor;

  DateTime venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RescheduleProposalResponse &&
    other.visitaId == visitaId &&
    other.fechaHora == fechaHora &&
    other.propuestaPor == propuestaPor &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (fechaHora.hashCode) +
    (propuestaPor.hashCode) +
    (venceEn.hashCode);

  @override
  String toString() => 'RescheduleProposalResponse[visitaId=$visitaId, fechaHora=$fechaHora, propuestaPor=$propuestaPor, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'fechaHora'] = this.fechaHora.toUtc().toIso8601String();
      json[r'propuestaPor'] = this.propuestaPor;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [RescheduleProposalResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static RescheduleProposalResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "RescheduleProposalResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "RescheduleProposalResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'fechaHora'), 'Required key "RescheduleProposalResponse[fechaHora]" is missing from JSON.');
        assert(json[r'fechaHora'] != null, 'Required key "RescheduleProposalResponse[fechaHora]" has a null value in JSON.');
        assert(json.containsKey(r'propuestaPor'), 'Required key "RescheduleProposalResponse[propuestaPor]" is missing from JSON.');
        assert(json[r'propuestaPor'] != null, 'Required key "RescheduleProposalResponse[propuestaPor]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "RescheduleProposalResponse[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "RescheduleProposalResponse[venceEn]" has a null value in JSON.');
        return true;
      }());

      return RescheduleProposalResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        fechaHora: mapDateTime(json, r'fechaHora', r'')!,
        propuestaPor: mapValueOfType<String>(json, r'propuestaPor')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
      );
    }
    return null;
  }

  static List<RescheduleProposalResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RescheduleProposalResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RescheduleProposalResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RescheduleProposalResponse> mapFromJson(dynamic json) {
    final map = <String, RescheduleProposalResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = RescheduleProposalResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RescheduleProposalResponse-objects as value to a dart map
  static Map<String, List<RescheduleProposalResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RescheduleProposalResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RescheduleProposalResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'fechaHora',
    'propuestaPor',
    'venceEn',
  };
}

