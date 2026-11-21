//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReportCreated {
  /// Returns a new [ReportCreated] instance.
  ReportCreated({
    required this.reporteId,
    required this.estado,
    required this.creadoEn,
    required this.avisoEmergencia,
  });

  String reporteId;

  String estado;

  DateTime creadoEn;

  String? avisoEmergencia;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportCreated &&
    other.reporteId == reporteId &&
    other.estado == estado &&
    other.creadoEn == creadoEn &&
    other.avisoEmergencia == avisoEmergencia;

  @override
  int get hashCode =>
    (reporteId.hashCode) +
    (estado.hashCode) +
    (creadoEn.hashCode) +
    (avisoEmergencia == null ? 0 : avisoEmergencia!.hashCode);

  @override
  String toString() => 'ReportCreated[reporteId=$reporteId, estado=$estado, creadoEn=$creadoEn, avisoEmergencia=$avisoEmergencia]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'reporteId'] = this.reporteId;
      json[r'estado'] = this.estado;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    if (this.avisoEmergencia != null) {
      json[r'avisoEmergencia'] = this.avisoEmergencia;
    } else {
      json[r'avisoEmergencia'] = null;
    }
    return json;
  }

  /// Returns a new [ReportCreated] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReportCreated? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'reporteId'), 'Required key "ReportCreated[reporteId]" is missing from JSON.');
        assert(json[r'reporteId'] != null, 'Required key "ReportCreated[reporteId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "ReportCreated[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "ReportCreated[estado]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "ReportCreated[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "ReportCreated[creadoEn]" has a null value in JSON.');
        assert(json.containsKey(r'avisoEmergencia'), 'Required key "ReportCreated[avisoEmergencia]" is missing from JSON.');
        return true;
      }());

      return ReportCreated(
        reporteId: mapValueOfType<String>(json, r'reporteId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
        avisoEmergencia: mapValueOfType<String>(json, r'avisoEmergencia'),
      );
    }
    return null;
  }

  static List<ReportCreated> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportCreated>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportCreated.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportCreated> mapFromJson(dynamic json) {
    final map = <String, ReportCreated>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReportCreated.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportCreated-objects as value to a dart map
  static Map<String, List<ReportCreated>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportCreated>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportCreated.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reporteId',
    'estado',
    'creadoEn',
    'avisoEmergencia',
  };
}

