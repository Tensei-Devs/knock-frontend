//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VisitRescheduleProposal {
  /// Returns a new [VisitRescheduleProposal] instance.
  VisitRescheduleProposal({
    required this.fechaHora,
    required this.propuestaPor,
    required this.venceEn,
  });

  DateTime fechaHora;

  String propuestaPor;

  DateTime venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VisitRescheduleProposal &&
    other.fechaHora == fechaHora &&
    other.propuestaPor == propuestaPor &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (fechaHora.hashCode) +
    (propuestaPor.hashCode) +
    (venceEn.hashCode);

  @override
  String toString() => 'VisitRescheduleProposal[fechaHora=$fechaHora, propuestaPor=$propuestaPor, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fechaHora'] = this.fechaHora.toUtc().toIso8601String();
      json[r'propuestaPor'] = this.propuestaPor;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [VisitRescheduleProposal] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VisitRescheduleProposal? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'fechaHora'), 'Required key "VisitRescheduleProposal[fechaHora]" is missing from JSON.');
        assert(json[r'fechaHora'] != null, 'Required key "VisitRescheduleProposal[fechaHora]" has a null value in JSON.');
        assert(json.containsKey(r'propuestaPor'), 'Required key "VisitRescheduleProposal[propuestaPor]" is missing from JSON.');
        assert(json[r'propuestaPor'] != null, 'Required key "VisitRescheduleProposal[propuestaPor]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "VisitRescheduleProposal[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "VisitRescheduleProposal[venceEn]" has a null value in JSON.');
        return true;
      }());

      return VisitRescheduleProposal(
        fechaHora: mapDateTime(json, r'fechaHora', r'')!,
        propuestaPor: mapValueOfType<String>(json, r'propuestaPor')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
      );
    }
    return null;
  }

  static List<VisitRescheduleProposal> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VisitRescheduleProposal>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VisitRescheduleProposal.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VisitRescheduleProposal> mapFromJson(dynamic json) {
    final map = <String, VisitRescheduleProposal>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VisitRescheduleProposal.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VisitRescheduleProposal-objects as value to a dart map
  static Map<String, List<VisitRescheduleProposal>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VisitRescheduleProposal>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VisitRescheduleProposal.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fechaHora',
    'propuestaPor',
    'venceEn',
  };
}

