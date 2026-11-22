//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReportReferenceBody {
  /// Returns a new [ReportReferenceBody] instance.
  ReportReferenceBody({
    this.tipo,
    this.id,
  });

  String? tipo;

  String? id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReportReferenceBody &&
    other.tipo == tipo &&
    other.id == id;

  @override
  int get hashCode =>
    (tipo == null ? 0 : tipo!.hashCode) +
    (id == null ? 0 : id!.hashCode);

  @override
  String toString() => 'ReportReferenceBody[tipo=$tipo, id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.tipo != null) {
      json[r'tipo'] = this.tipo;
    } else {
      json[r'tipo'] = null;
    }
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    return json;
  }

  /// Returns a new [ReportReferenceBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReportReferenceBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ReportReferenceBody(
        tipo: mapValueOfType<String>(json, r'tipo'),
        id: mapValueOfType<String>(json, r'id'),
      );
    }
    return null;
  }

  static List<ReportReferenceBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReportReferenceBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportReferenceBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportReferenceBody> mapFromJson(dynamic json) {
    final map = <String, ReportReferenceBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReportReferenceBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportReferenceBody-objects as value to a dart map
  static Map<String, List<ReportReferenceBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReportReferenceBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportReferenceBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

