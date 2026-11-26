//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class FinishVisitBody {
  /// Returns a new [FinishVisitBody] instance.
  FinishVisitBody({
    required this.descripcion,
    required this.recomendacion,
    this.fotos = const [],
  });

  /// De 8 a 500 caracteres.
  String? descripcion;

  /// Opcional, hasta 300 caracteres.
  String? recomendacion;

  /// De 1 a 5 identificadores de archivo (`archivoId`, 32 hexadecimales), sin repetidos; sin foto o con más de 5 responde 422 `errors.fotos`.
  List<String>? fotos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FinishVisitBody &&
    other.descripcion == descripcion &&
    other.recomendacion == recomendacion &&
    _deepEquality.equals(other.fotos, fotos);

  @override
  int get hashCode =>
    (descripcion == null ? 0 : descripcion!.hashCode) +
    (recomendacion == null ? 0 : recomendacion!.hashCode) +
    (fotos == null ? 0 : fotos!.hashCode);

  @override
  String toString() => 'FinishVisitBody[descripcion=$descripcion, recomendacion=$recomendacion, fotos=$fotos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.descripcion != null) {
      json[r'descripcion'] = this.descripcion;
    } else {
      json[r'descripcion'] = null;
    }
    if (this.recomendacion != null) {
      json[r'recomendacion'] = this.recomendacion;
    } else {
      json[r'recomendacion'] = null;
    }
    if (this.fotos != null) {
      json[r'fotos'] = this.fotos;
    } else {
      json[r'fotos'] = null;
    }
    return json;
  }

  /// Returns a new [FinishVisitBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static FinishVisitBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'descripcion'), 'Required key "FinishVisitBody[descripcion]" is missing from JSON.');
        assert(json.containsKey(r'recomendacion'), 'Required key "FinishVisitBody[recomendacion]" is missing from JSON.');
        assert(json.containsKey(r'fotos'), 'Required key "FinishVisitBody[fotos]" is missing from JSON.');
        return true;
      }());

      return FinishVisitBody(
        descripcion: mapValueOfType<String>(json, r'descripcion'),
        recomendacion: mapValueOfType<String>(json, r'recomendacion'),
        fotos: json[r'fotos'] is Iterable
            ? (json[r'fotos'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<FinishVisitBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FinishVisitBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FinishVisitBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FinishVisitBody> mapFromJson(dynamic json) {
    final map = <String, FinishVisitBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = FinishVisitBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FinishVisitBody-objects as value to a dart map
  static Map<String, List<FinishVisitBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FinishVisitBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FinishVisitBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'descripcion',
    'recomendacion',
    'fotos',
  };
}

