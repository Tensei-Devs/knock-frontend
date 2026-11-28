//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CreateReviewBody {
  /// Returns a new [CreateReviewBody] instance.
  CreateReviewBody({
    required this.calificacion,
    required this.partes,
    required this.comentario,
    this.fotos = const [],
    required this.guardarTecnicoConfianza,
  });

  /// Entero de 1 a 5.
  int? calificacion;

  /// Cada parte de 1 a 5.
  ReviewParts? partes;

  /// Hasta 500 caracteres.
  String? comentario;

  /// De 0 a 3 identificadores de archivo (`archivoId`, 32 hexadecimales), sin repetidos, moderadas; más de 3 responde 422 `errors.fotos`.
  List<String>? fotos;

  /// Opcional: suma al técnico a los de confianza.
  bool? guardarTecnicoConfianza;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateReviewBody &&
    other.calificacion == calificacion &&
    other.partes == partes &&
    other.comentario == comentario &&
    _deepEquality.equals(other.fotos, fotos) &&
    other.guardarTecnicoConfianza == guardarTecnicoConfianza;

  @override
  int get hashCode =>
    (calificacion == null ? 0 : calificacion!.hashCode) +
    (partes == null ? 0 : partes!.hashCode) +
    (comentario == null ? 0 : comentario!.hashCode) +
    (fotos == null ? 0 : fotos!.hashCode) +
    (guardarTecnicoConfianza == null ? 0 : guardarTecnicoConfianza!.hashCode);

  @override
  String toString() => 'CreateReviewBody[calificacion=$calificacion, partes=$partes, comentario=$comentario, fotos=$fotos, guardarTecnicoConfianza=$guardarTecnicoConfianza]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.calificacion != null) {
      json[r'calificacion'] = this.calificacion;
    } else {
      json[r'calificacion'] = null;
    }
    if (this.partes != null) {
      json[r'partes'] = this.partes;
    } else {
      json[r'partes'] = null;
    }
    if (this.comentario != null) {
      json[r'comentario'] = this.comentario;
    } else {
      json[r'comentario'] = null;
    }
    if (this.fotos != null) {
      json[r'fotos'] = this.fotos;
    } else {
      json[r'fotos'] = null;
    }
    if (this.guardarTecnicoConfianza != null) {
      json[r'guardarTecnicoConfianza'] = this.guardarTecnicoConfianza;
    } else {
      json[r'guardarTecnicoConfianza'] = null;
    }
    return json;
  }

  /// Returns a new [CreateReviewBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CreateReviewBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'calificacion'), 'Required key "CreateReviewBody[calificacion]" is missing from JSON.');
        assert(json.containsKey(r'partes'), 'Required key "CreateReviewBody[partes]" is missing from JSON.');
        assert(json.containsKey(r'comentario'), 'Required key "CreateReviewBody[comentario]" is missing from JSON.');
        assert(json.containsKey(r'fotos'), 'Required key "CreateReviewBody[fotos]" is missing from JSON.');
        assert(json.containsKey(r'guardarTecnicoConfianza'), 'Required key "CreateReviewBody[guardarTecnicoConfianza]" is missing from JSON.');
        return true;
      }());

      return CreateReviewBody(
        calificacion: mapValueOfType<int>(json, r'calificacion'),
        partes: ReviewParts.fromJson(json[r'partes']),
        comentario: mapValueOfType<String>(json, r'comentario'),
        fotos: json[r'fotos'] is Iterable
            ? (json[r'fotos'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        guardarTecnicoConfianza: mapValueOfType<bool>(json, r'guardarTecnicoConfianza'),
      );
    }
    return null;
  }

  static List<CreateReviewBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateReviewBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateReviewBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateReviewBody> mapFromJson(dynamic json) {
    final map = <String, CreateReviewBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CreateReviewBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateReviewBody-objects as value to a dart map
  static Map<String, List<CreateReviewBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateReviewBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateReviewBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'calificacion',
    'partes',
    'comentario',
    'fotos',
    'guardarTecnicoConfianza',
  };
}

