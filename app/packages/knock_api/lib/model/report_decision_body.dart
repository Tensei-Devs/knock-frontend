//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReportDecisionBody {
  /// Returns a new [ReportDecisionBody] instance.
  ReportDecisionBody({
    this.gravedad,
    this.motivo,
  });

  String? gravedad;

  String? motivo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportDecisionBody &&
    other.gravedad == gravedad &&
    other.motivo == motivo;

  @override
  int get hashCode =>
    (gravedad == null ? 0 : gravedad!.hashCode) +
    (motivo == null ? 0 : motivo!.hashCode);

  @override
  String toString() => 'ReportDecisionBody[gravedad=$gravedad, motivo=$motivo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.gravedad != null) {
      json[r'gravedad'] = this.gravedad;
    } else {
      json[r'gravedad'] = null;
    }
    if (this.motivo != null) {
      json[r'motivo'] = this.motivo;
    } else {
      json[r'motivo'] = null;
    }
    return json;
  }

  /// Returns a new [ReportDecisionBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReportDecisionBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ReportDecisionBody(
        gravedad: mapValueOfType<String>(json, r'gravedad'),
        motivo: mapValueOfType<String>(json, r'motivo'),
      );
    }
    return null;
  }

  static List<ReportDecisionBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportDecisionBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportDecisionBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportDecisionBody> mapFromJson(dynamic json) {
    final map = <String, ReportDecisionBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReportDecisionBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportDecisionBody-objects as value to a dart map
  static Map<String, List<ReportDecisionBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportDecisionBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportDecisionBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

