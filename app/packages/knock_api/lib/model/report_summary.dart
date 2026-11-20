//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReportSummary {
  /// Returns a new [ReportSummary] instance.
  ReportSummary({
    required this.reporteId,
    required this.motivo,
    required this.estado,
    required this.creadoEn,
    required this.puedeApelar,
  });

  String reporteId;

  String motivo;

  String estado;

  DateTime creadoEn;

  bool puedeApelar;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportSummary &&
    other.reporteId == reporteId &&
    other.motivo == motivo &&
    other.estado == estado &&
    other.creadoEn == creadoEn &&
    other.puedeApelar == puedeApelar;

  @override
  int get hashCode =>
    (reporteId.hashCode) +
    (motivo.hashCode) +
    (estado.hashCode) +
    (creadoEn.hashCode) +
    (puedeApelar.hashCode);

  @override
  String toString() => 'ReportSummary[reporteId=$reporteId, motivo=$motivo, estado=$estado, creadoEn=$creadoEn, puedeApelar=$puedeApelar]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'reporteId'] = this.reporteId;
      json[r'motivo'] = this.motivo;
      json[r'estado'] = this.estado;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
      json[r'puedeApelar'] = this.puedeApelar;
    return json;
  }

  /// Returns a new [ReportSummary] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReportSummary? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'reporteId'), 'Required key "ReportSummary[reporteId]" is missing from JSON.');
        assert(json[r'reporteId'] != null, 'Required key "ReportSummary[reporteId]" has a null value in JSON.');
        assert(json.containsKey(r'motivo'), 'Required key "ReportSummary[motivo]" is missing from JSON.');
        assert(json[r'motivo'] != null, 'Required key "ReportSummary[motivo]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "ReportSummary[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "ReportSummary[estado]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "ReportSummary[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "ReportSummary[creadoEn]" has a null value in JSON.');
        assert(json.containsKey(r'puedeApelar'), 'Required key "ReportSummary[puedeApelar]" is missing from JSON.');
        assert(json[r'puedeApelar'] != null, 'Required key "ReportSummary[puedeApelar]" has a null value in JSON.');
        return true;
      }());

      return ReportSummary(
        reporteId: mapValueOfType<String>(json, r'reporteId')!,
        motivo: mapValueOfType<String>(json, r'motivo')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
        puedeApelar: mapValueOfType<bool>(json, r'puedeApelar')!,
      );
    }
    return null;
  }

  static List<ReportSummary> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportSummary>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportSummary.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportSummary> mapFromJson(dynamic json) {
    final map = <String, ReportSummary>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReportSummary.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportSummary-objects as value to a dart map
  static Map<String, List<ReportSummary>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportSummary>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportSummary.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reporteId',
    'motivo',
    'estado',
    'creadoEn',
    'puedeApelar',
  };
}

