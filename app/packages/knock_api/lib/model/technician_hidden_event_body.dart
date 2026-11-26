//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TechnicianHiddenEventBody {
  /// Returns a new [TechnicianHiddenEventBody] instance.
  TechnicianHiddenEventBody({
    this.eventoId,
    this.usuarioId,
    this.reporteId,
  });

  String? eventoId;

  String? usuarioId;

  String? reporteId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TechnicianHiddenEventBody &&
    other.eventoId == eventoId &&
    other.usuarioId == usuarioId &&
    other.reporteId == reporteId;

  @override
  int get hashCode =>
    (eventoId == null ? 0 : eventoId!.hashCode) +
    (usuarioId == null ? 0 : usuarioId!.hashCode) +
    (reporteId == null ? 0 : reporteId!.hashCode);

  @override
  String toString() => 'TechnicianHiddenEventBody[eventoId=$eventoId, usuarioId=$usuarioId, reporteId=$reporteId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.eventoId != null) {
      json[r'eventoId'] = this.eventoId;
    } else {
      json[r'eventoId'] = null;
    }
    if (this.usuarioId != null) {
      json[r'usuarioId'] = this.usuarioId;
    } else {
      json[r'usuarioId'] = null;
    }
    if (this.reporteId != null) {
      json[r'reporteId'] = this.reporteId;
    } else {
      json[r'reporteId'] = null;
    }
    return json;
  }

  /// Returns a new [TechnicianHiddenEventBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TechnicianHiddenEventBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return TechnicianHiddenEventBody(
        eventoId: mapValueOfType<String>(json, r'eventoId'),
        usuarioId: mapValueOfType<String>(json, r'usuarioId'),
        reporteId: mapValueOfType<String>(json, r'reporteId'),
      );
    }
    return null;
  }

  static List<TechnicianHiddenEventBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TechnicianHiddenEventBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TechnicianHiddenEventBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TechnicianHiddenEventBody> mapFromJson(dynamic json) {
    final map = <String, TechnicianHiddenEventBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TechnicianHiddenEventBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TechnicianHiddenEventBody-objects as value to a dart map
  static Map<String, List<TechnicianHiddenEventBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TechnicianHiddenEventBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TechnicianHiddenEventBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

