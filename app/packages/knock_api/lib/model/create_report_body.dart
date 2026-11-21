//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CreateReportBody {
  /// Returns a new [CreateReportBody] instance.
  CreateReportBody({
    this.reportadoId,
    this.referencia,
    this.motivo,
    this.descripcion,
    this.evidencia = const [],
  });

  String? reportadoId;

  ReportReferenceBody? referencia;

  String? motivo;

  String? descripcion;

  List<String>? evidencia;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateReportBody &&
    other.reportadoId == reportadoId &&
    other.referencia == referencia &&
    other.motivo == motivo &&
    other.descripcion == descripcion &&
    _deepEquality.equals(other.evidencia, evidencia);

  @override
  int get hashCode =>
    (reportadoId == null ? 0 : reportadoId!.hashCode) +
    (referencia == null ? 0 : referencia!.hashCode) +
    (motivo == null ? 0 : motivo!.hashCode) +
    (descripcion == null ? 0 : descripcion!.hashCode) +
    (evidencia == null ? 0 : evidencia!.hashCode);

  @override
  String toString() => 'CreateReportBody[reportadoId=$reportadoId, referencia=$referencia, motivo=$motivo, descripcion=$descripcion, evidencia=$evidencia]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.reportadoId != null) {
      json[r'reportadoId'] = this.reportadoId;
    } else {
      json[r'reportadoId'] = null;
    }
    if (this.referencia != null) {
      json[r'referencia'] = this.referencia;
    } else {
      json[r'referencia'] = null;
    }
    if (this.motivo != null) {
      json[r'motivo'] = this.motivo;
    } else {
      json[r'motivo'] = null;
    }
    if (this.descripcion != null) {
      json[r'descripcion'] = this.descripcion;
    } else {
      json[r'descripcion'] = null;
    }
    if (this.evidencia != null) {
      json[r'evidencia'] = this.evidencia;
    } else {
      json[r'evidencia'] = null;
    }
    return json;
  }

  /// Returns a new [CreateReportBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CreateReportBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return CreateReportBody(
        reportadoId: mapValueOfType<String>(json, r'reportadoId'),
        referencia: ReportReferenceBody.fromJson(json[r'referencia']),
        motivo: mapValueOfType<String>(json, r'motivo'),
        descripcion: mapValueOfType<String>(json, r'descripcion'),
        evidencia: json[r'evidencia'] is Iterable
            ? (json[r'evidencia'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<CreateReportBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateReportBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateReportBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateReportBody> mapFromJson(dynamic json) {
    final map = <String, CreateReportBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CreateReportBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateReportBody-objects as value to a dart map
  static Map<String, List<CreateReportBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateReportBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateReportBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

